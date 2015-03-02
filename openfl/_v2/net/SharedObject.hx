package openfl._v2.net; #if lime_legacy


import haxe.io.Eof;
import haxe.io.Path;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.events.EventDispatcher;
import openfl.net.SharedObjectFlushStatus;
import openfl.Lib;
import sys.io.File;
import sys.io.FileInput;
import sys.io.FileOutput;
import sys.FileSystem;


class SharedObject extends EventDispatcher {
	
	
	public var data (default, null):Dynamic;
	public var size (get_size, null):Int;
	
	private var localPath:String;
	private var name:String;
	
	
	private function new (name:String, localPath:String, data:Dynamic) {
		
		super ();
		
		this.name = name;
		this.localPath = localPath;
		this.data = data;
		
	}
	
	
	public function clear ():Void {
		
		#if (iphone || android || tizen)
		
		untyped lime_clear_user_preference (name);
		
		#else
		
		var filePath = getFilePath (name, localPath);
		
		if (FileSystem.exists (filePath)) {
			
			FileSystem.deleteFile (filePath);
			
		}
		
		#end
		
	}
	
	
	public function close ():Void {
		
		// ignored, no server connection to close
		
	}
	
	
	#if (!iphone && !android && !tizen)
	
	static public function mkdir (directory:String):Void {
		
		directory = StringTools.replace (directory, "\\", "/");
		var total = "";
		
		if (directory.substr (0, 1) == "/") {
			
			total = "/";
			
		}
		
		var parts = directory.split("/");
		var oldPath = "";
		
		if (parts.length > 0 && parts[0].indexOf (":") > -1) {
			
			oldPath = Sys.getCwd ();
			Sys.setCwd (parts[0] + "\\");
			parts.shift ();
			
		}
		
		for (part in parts) {
			
			if (part != "." && part != "") {
				
				if (total != "" && total != "/") {
					
					total += "/";
					
				}
				
				total += part;
				
				if (!FileSystem.exists (total)) {
					
					FileSystem.createDirectory (total);
					
				}
				
			}
			
		}
		
		if (oldPath != "") {
			
			Sys.setCwd (oldPath);
			
		}
		
	}
	
	#end
	
	
	public function flush (minDiskSpace:Int = 0):SharedObjectFlushStatus {
		
		var encodedData = Serializer.run (data);
		
		#if (iphone || android || tizen)
		
		untyped lime_set_user_preference (name, encodedData);
		
		#else
		
		var filePath = getFilePath (name, localPath);
		var folderPath = Path.directory (filePath);
		
		if (!FileSystem.exists (folderPath)) {
			
			mkdir (folderPath);
			
		}
		
		var output = File.write (filePath, false);
		output.writeString (encodedData);
		output.close ();
		
		#end
		
		return SharedObjectFlushStatus.FLUSHED;
		
	}
	
	
	private static function getFilePath (name:String, localPath:String):String {
		
		var path = openfl._v2.filesystem.File.applicationStorageDirectory.nativePath;
		path +=  "/" + localPath + "/" + name + ".sol";
		return path;
		
	}
	
	
	public static function getLocal (name:String, localPath:String = null, secure:Bool = false):SharedObject {
		
		if (localPath == null) {
			
			localPath = "";
			
		}
		
		#if (iphone || android || tizen)
		
		var rawData:String = untyped lime_get_user_preference (name);
		
		#else
		
		var filePath = getFilePath (name, localPath);
		var rawData = "";
		
		if (FileSystem.exists (filePath)) {
			
			rawData = File.getContent (filePath);
			
		}
		
		#end
		
		var loadedData:Dynamic = { };
		
		if (rawData != "" && rawData != null) {
			
			try {
				
				var unserializer = new Unserializer (rawData);
				unserializer.setResolver (cast { resolveEnum: Type.resolveEnum, resolveClass: resolveClass } );
				loadedData = unserializer.unserialize ();
				
			} catch (e:Dynamic) {
				
				trace ('Could not unserialize SharedObject: $name');
				loadedData = { };
				
			}
			
		}
		
		var so = new SharedObject (name, localPath, loadedData);
		return so;
		
	}
	
	
	private static function resolveClass (name:String):Class < Dynamic > {
		
		if (name != null) {
			
			if (StringTools.startsWith (name, "neash.")) {
				
				name = StringTools.replace (name, "neash.", "openfl.");
				
			}
			
			if (StringTools.startsWith (name, "native.")) {
				
				name = StringTools.replace (name, "native.", "openfl.");
				
			}
			
			if (StringTools.startsWith (name, "flash.")) {
				
				name = StringTools.replace (name, "flash.", "openfl.");
				
			}
			
			return Type.resolveClass (name);
			
		}
		
		return null;
		
	}
	
	
	public function setProperty (propertyName:String, value:Dynamic = null):Void {
		
		if (data != null) {
			
			Reflect.setField (data, propertyName, value);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_size ():Int {
		
		return 0;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if (iphone || android || tizen)
	private static var lime_get_user_preference = Lib.load ("lime", "lime_get_user_preference", 1);
	private static var lime_set_user_preference = Lib.load ("lime", "lime_set_user_preference", 2);
	private static var lime_clear_user_preference = Lib.load ("lime", "lime_clear_user_preference", 1);
	#end
	
	
}


#end