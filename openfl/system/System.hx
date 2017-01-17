package openfl.system;


import lime.system.Clipboard;
import lime.system.System in LimeSystem;

#if neko
import neko.vm.Gc;
#elseif cpp
import cpp.vm.Gc;
#end


@:final class System {
	
	
	public static var totalMemory (get, never):Int;
	public static var useCodePage:Bool = false;
	public static var vmVersion (get, never):String;
	
	
	public static function exit (code:Int):Void {
		
		LimeSystem.exit (code);
		
	}
	
	
	public static function gc ():Void {
		
		#if (cpp || neko)
		return Gc.run (true);
		#end
		
	}
	
	
	public static function pause ():Void {
		
		openfl.Lib.notImplemented ();
		
	}
	
	
	public static function resume ():Void {
		
		openfl.Lib.notImplemented ();
		
	}
	
	
	public static function setClipboard (string:String):Void {
		
		#if html5 // HTML5 needs focus on <input> field for clipboard events to work
		flash.Lib.current.stage.window.enableTextEvents = true;
		#end
		
		Clipboard.text = string;
		
		#if html5
		flash.Lib.current.stage.window.enableTextEvents = false;
		#end
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_totalMemory ():Int {
		
		#if neko
		return Gc.stats ().heap;
		#elseif cpp
		return untyped __global__.__hxcpp_gc_used_bytes ();
		#elseif (js && html5)
		return untyped __js__ ("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
		#else
		return 0;
		#end
		
	}
	
	
	private static function get_vmVersion ():String {
		
		return "1.0.0";
		
	}
	
	
}