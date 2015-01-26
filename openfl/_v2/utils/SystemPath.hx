package openfl._v2.utils; #if lime_legacy


import openfl.Lib;
import openfl._v2.utils.JNI;


class SystemPath {
  
	
	public static var applicationDirectory (get, null):String;
	public static var applicationStorageDirectory (get, null):String;
	public static var desktopDirectory (get, null):String;
	public static var documentsDirectory (get, null):String;
	public static var userDirectory (get, null):String;
	
	private static inline var APP = 0;
	private static inline var STORAGE = 1;
	private static inline var DESKTOP = 2;
	private static inline var DOCS = 3;
	private static inline var USER = 4;
	
	
	
	
	// Getters & Setters
	
	
	
	
	private static function get_applicationDirectory ():String { return lime_filesystem_get_special_dir (APP); }
	private static function get_applicationStorageDirectory ():String { return lime_filesystem_get_special_dir (STORAGE); }
	private static function get_desktopDirectory ():String { return lime_filesystem_get_special_dir (DESKTOP); }
	private static function get_documentsDirectory ():String { return lime_filesystem_get_special_dir (DOCS); }
	private static function get_userDirectory ():String { return lime_filesystem_get_special_dir (USER); }
	
	
	
	
	// Native Methods
	
	
	
	
	#if !android
	
	private static var lime_filesystem_get_special_dir = Lib.load ("lime", "lime_filesystem_get_special_dir", 1);
	
	#else
	
	private static var jni_filesystem_get_special_dir:Dynamic = null;
	
	private static function lime_filesystem_get_special_dir (inWhich:Int):String {
		
		if (jni_filesystem_get_special_dir == null) {
			
			jni_filesystem_get_special_dir = JNI.createStaticMethod ("org.haxe.lime.GameActivity", "getSpecialDir", "(I)Ljava/lang/String;");
			
		}
		
		return jni_filesystem_get_special_dir (inWhich);
		
	}
	
	#end
	
	
}


#end