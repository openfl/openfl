package openfl.net; #if !flash #if (display || openfl_next || js)


import haxe.io.Bytes;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.net.SharedObjectFlushStatus;
import openfl.Lib;

#if js
import js.html.Storage;
import js.Browser;
#end


class SharedObject extends EventDispatcher {
	
	
	public var data (default, null):Dynamic;
	public var size (get, never):Int;
	
	@:noCompletion private var __key:String;
	

	private function new () {
		
		super ();
		
	}
	
	
	public function clear ():Void {
		
		data = { };
		
		#if js
		try {
			
			__getLocalStorage ().removeItem (__key);
			
		} catch (e:Dynamic) {}
		#end
		
		flush ();
		
	}
	
	
	public function flush (minDiskSpace:Int = 0):SharedObjectFlushStatus {
		
		#if js
		var data = Serializer.run (data);
		
		try {
			
			__getLocalStorage ().removeItem (__key);
			__getLocalStorage ().setItem (__key, data);
			
		} catch (e:Dynamic) {
			
			// user may have privacy settings which prevent writing
			return SharedObjectFlushStatus.PENDING;
			
		}
		#end
		
		return SharedObjectFlushStatus.FLUSHED;
		
	}
	
	
	public static function getLocal (name:String, localPath:String = null, secure:Bool = false /* note: unsupported */) {
		
		#if js
		if (localPath == null) {
			
			localPath = Browser.window.location.href;
			
		}
		#end
		
		var so = new SharedObject ();
		so.__key = localPath + ":" + name;
		var rawData = null;
		
		#if js
		try {
			
			// user may have privacy settings which prevent reading
			rawData = __getLocalStorage ().getItem (so.__key);
			
		} catch (e:Dynamic) { }
		#end
		
		so.data = { };
		
		if (rawData != null && rawData != "") {
			
			var unserializer = new Unserializer (rawData);
			unserializer.setResolver (cast { resolveEnum: Type.resolveEnum, resolveClass: resolveClass } );
			so.data = unserializer.unserialize ();
			
		}
		
		if (so.data == null) {
			
			so.data = { };
			
		}
		
		return so;
		
	}
	
	
	#if js
	@:noCompletion private static function __getLocalStorage ():Storage {
		
		var res = Browser.getLocalStorage ();
		if (res == null) throw new Error ("SharedObject not supported");
		return res;
		
	}
	#end
	
	
	@:noCompletion private static function resolveClass (name:String):Class <Dynamic> {
		
		if (name != null) {
			
			return Type.resolveClass (StringTools.replace (StringTools.replace (name, "jeash.", "flash."), "browser.", "flash."));
			
		}
		
		return null;
		
	}
	
	
	public function setProperty (propertyName:String, ?value:Dynamic):Void {
		
		if (data != null) {
			
			Reflect.setField (data, propertyName, value);
		}
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	@:noCompletion private function get_size ():Int {
		
		var d = Serializer.run (data);
		return Bytes.ofString (d).length;
		
	}
	
	
}


#else
typedef SharedObject = openfl._v2.net.SharedObject;
#end
#else
typedef SharedObject = flash.net.SharedObject;
#end