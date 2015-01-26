package openfl._v2.filesystem; #if lime_legacy


import openfl.Lib;

#if android
import openfl.utils.JNI;
#end


class File {
	
	
	public static var applicationDirectory (get, null):File;
	public static var applicationStorageDirectory (get, null):File;
	public static var desktopDirectory (get, null):File;
	public static var documentsDirectory (get, null):File;
	public static var userDirectory (get, null):File;
	
	static inline var APP = 0;
	static inline var STORAGE = 1;
	static inline var DESKTOP = 2;
	static inline var DOCS = 3;
	static inline var USER = 4;
	
	public var nativePath (default, set):String;
	public var url (default, set):String;
	
	
	public function new (path:String = null) {
		
		this.url = path;
		this.nativePath = path;
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_applicationDirectory ():File { return new File (lime_filesystem_get_special_dir (APP)); }
	private static function get_applicationStorageDirectory ():File { return new File (lime_filesystem_get_special_dir (STORAGE)); }
	private static function get_desktopDirectory ():File { return new File (lime_filesystem_get_special_dir (DESKTOP)); }
	private static function get_documentsDirectory ():File { return new File (lime_filesystem_get_special_dir (DOCS)); }
	private static function get_userDirectory ():File { return new File (lime_filesystem_get_special_dir (USER)); }
	
	
	private function set_nativePath (value:String):String {
		
		nativePath = value;
		return nativePath;
		
	}
	
	
	private function set_url (value:String):String {
		
		if (value == null) {
			
			url = null;
			
		} else {
			
			url = StringTools.replace (value, " ", "%20");
			
			#if iphone
			if (StringTools.startsWith (value, lime_get_resource_path ())) {
				
				url = "app:" + url;
				
			} else
			#end
			{
				url = "file:" + url;
			}
			
		}
		
		return url;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if iphone
	private static var lime_get_resource_path = Lib.load ("lime", "lime_get_resource_path", 0);
	#end
	
	#if !android
	private static var lime_filesystem_get_special_dir = Lib.load ("lime", "lime_filesystem_get_special_dir", 1);
	#else
	private static var jni_filesystem_get_special_dir:Dynamic = null;
	private static function lime_filesystem_get_special_dir (which:Int):String {
		
		if (jni_filesystem_get_special_dir == null) {
			
			jni_filesystem_get_special_dir = JNI.createStaticMethod ("org/haxe/lime/GameActivity", "getSpecialDir", "(I)Ljava/lang/String;");
			
		}
		
		return jni_filesystem_get_special_dir (which);
		
	}
	#end
	
	
}


#end