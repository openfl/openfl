package openfl._v2; #if lime_legacy


import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.display.Stage;
import openfl.events.UncaughtErrorEvent;
import openfl.net.URLRequest;
import openfl.Lib;
import haxe.io.Bytes;
import haxe.CallStack;
import haxe.Timer;
import openfl._v2.display.ManagedStage;
import sys.io.Process;


class Lib {
	
	
	static public var FULLSCREEN = 0x0001;
	static public var BORDERLESS = 0x0002;
	static public var RESIZABLE = 0x0004;
	static public var HARDWARE = 0x0008;
	static public var VSYNC = 0x0010;
	static public var HW_AA = 0x0020;
	static public var HW_AA_HIRES = 0x0060;
	static public var ALLOW_SHADERS = 0x0080;
	static public var REQUIRE_SHADERS = 0x0100;
	static public var DEPTH_BUFFER = 0x0200;
	static public var STENCIL_BUFFER = 0x0400;
	
	static public var company (default, null):String;
	public static var current (get, null):MovieClip;
	static public var file (default, null):String;
	public static var initHeight (default, null):Int;
	public static var initWidth (default, null):Int;
	static public var packageName (default, null):String;
	static public var silentRecreate:Bool = false;
	public static var stage (get, null):Stage;
	static public var version (default, null):String;
	
	@:noCompletion private static var __current:MovieClip = null;
	@:noCompletion private static var __isInit = false;
	@:noCompletion private static var __loadedNekoAPI:Bool;
	@:noCompletion private static var __mainFrame:Dynamic = null;
	@:noCompletion private static var __moduleNames:Map<String, String> = null;
	@:noCompletion private static var __sentWarnings = new Map<String, Bool> ();
	@:noCompletion private static var __stage:Stage = null;
	@:noCompletion private static var __uncaughtExceptionHandler:UncaughtErrorEvent->Bool = null;
	
	
	public inline static function as<T> (v:Dynamic, c:Class<T>):Null<T> {
		
		return cast v;
		
	}
	
	
	public static function attach (name:String):MovieClip {
		
		return new MovieClip ();
		
	}
	
	
	public static function close ():Void {
		
		Stage.__exiting = true;
		var close = Lib.load ("lime", "lime_close", 0);
		close ();
		
	}
	
	
	public static function create (onLoaded:Void->Void, width:Int, height:Int, frameRate:Float = 60.0, color:Int = 0xffffff, flags:Int = 0x0f, title:String = "OpenFL", icon:BitmapData = null, stageClass:Class<Stage> = null):Void {
		
		if (__isInit) {
			
			if (silentRecreate) {
				
				onLoaded ();
				return;
				
			}
			
			throw ("flash.Lib.create called multiple times. This function is automatically called by the project code.");
			
		}
		
		__isInit = true;
		initWidth = width;
		initHeight = height;
		
		var create_main_frame = Lib.load ("lime", "lime_create_main_frame", -1);
		
		create_main_frame (function (frameHandle:Dynamic) {
			
			try {
				
				__mainFrame = frameHandle;
				var stage_handle = lime_get_frame_stage (__mainFrame);
				
				Lib.__stage = (stageClass == null ? new Stage (stage_handle, width, height) : Type.createInstance (stageClass, [ stage_handle, width, height]));
				Lib.__stage.frameRate = frameRate;
				Lib.__stage.opaqueBackground = color;
				Lib.__stage.onQuit = close;
				
				if (__current != null) {
					
					Lib.__stage.addChild (__current);
					
				}
				
				onLoaded ();
				
			} catch (error:Dynamic) { 
				
				rethrow (error);
				
			}
			
		}, width, height, flags, title, icon == null ? null : icon.__handle);
		
	}
	
	
	public static function createManagedStage (width:Int, height:Int, flags:Int = 0):ManagedStage {
		
		initWidth = width;
		initHeight = height;
		
		var result = new ManagedStage (width, height, flags);
		__stage = result;
		
		return result;
		
	}
	
	
	macro public static function defined (haxedef:String):Bool {
		
		return false;
		
	}
	
	
	macro public static function definedValue (haxedef:String):String {
		
		return null;
		
	}
	
	
	static private function findHaxeLib (library:String):String {
		
		try {
			
			var proc = new Process ("haxelib", [ "path", library ]);
			
			if (proc != null) {
				
				var stream = proc.stdout;
				
				try {
					
					while (true) {
						
						var s = stream.readLine ();
						
						if (s.substr (0, 1) != "-") {
							
							stream.close ();
							proc.close ();
							loaderTrace ("Found haxelib " + s);
							return s;
							
						}
						
					}
					
				} catch(e:Dynamic) { }
				
				stream.close ();
				proc.close ();
				
			}
			
		} catch (e:Dynamic) { }
		
		return "";
		
	}
	
	
	public static function load (library:String, method:String, args:Int = 0):Dynamic {
		
		#if (iphone || emscripten || android)
		return cpp.Lib.load (library, method, args);
		#end
		
		if (__moduleNames == null) __moduleNames = new Map<String, String> ();
		if (__moduleNames.exists (library)) {
			
			#if cpp
			return cpp.Lib.load (__moduleNames.get (library), method, args);
			#elseif neko
			return neko.Lib.load (__moduleNames.get (library), method, args);
			#else
			return null;
			#end
			
		}
		
		#if waxe
		if (library == "lime") {
			
			flash.Lib.load ("waxe", "wx_boot", 1);
			
		}
		#end
		
		__moduleNames.set (library, library);
		
		#if blackberry
		var result:Dynamic = tryLoad ("/app/native/" + library, library, method, args);
		
		if (result == null) {
			
			result = tryLoad ("./" + library, library, method, args);
			
		}
		#else
		var result:Dynamic = tryLoad ("./" + library, library, method, args);
		#end
		
		if (result == null) {
			
			result = tryLoad (".\\" + library, library, method, args);
			
		}
		
		if (result == null) {
			
			result = tryLoad (library, library, method, args);
			
		}
		
		if (result == null) {
			
			var slash = (sysName ().substr (7).toLowerCase () == "windows") ? "\\" : "/";
			var haxelib = findHaxeLib ("lime");
			
			if (haxelib != "") {
				
				result = tryLoad (haxelib + slash + "legacy" + slash + "ndll" + slash + sysName () + slash + library, library, method, args);
				
				if (result == null) {
					
					result = tryLoad (haxelib + slash + "legacy" + slash + "ndll" + slash + sysName() + "64" + slash + library, library, method, args);
					
				}
				
			}
			
		}
		
		loaderTrace ("Result : " + result);
		
		#if neko
		if (library == "lime") {
			
			loadNekoAPI ();
			
		}
		#end
		
		return result;
		
	}
	
	
	private static function loaderTrace (message:String) {
		
		#if cpp
		var get_env = cpp.Lib.load ("std", "get_env", 1);
		var debug = (get_env ("OPENFL_LOAD_DEBUG") != null);
		#else
		var debug = (Sys.getEnv ("OPENFL_LOAD_DEBUG") !=null);
		#end
		
		if (debug) {
			
			Sys.println (message);
			
		}
		
	}
	
	
	public static function notImplemented (api:String):Void {
		
		if (!__sentWarnings.exists (api)) {
			
			__sentWarnings.set (api, true);
			
			trace ("Warning: " + api + " is not implemented");
			
		}
		
	}
	
	
	public static function rethrow (error:Dynamic):Void {
		
		var event = new UncaughtErrorEvent (UncaughtErrorEvent.UNCAUGHT_ERROR, true, true, error);
		
		if (__uncaughtExceptionHandler != null && __uncaughtExceptionHandler (event)) {
			
			return;
			
		}
		
		Lib.current.loaderInfo.uncaughtErrorEvents.dispatchEvent (event);
		
		if (!event.__getIsCancelled ()) {
			
			var message = "";
			
			if (error != null && error != "") {
				
				message = error + "";
				
			}
			
			var stack = CallStack.exceptionStack ();
			
			if (stack.length > 0) {
				
				message += CallStack.toString (stack) + "\n";
				
			} else {
				
				message += "\n";
				
			}
			
			#if (mobile && !ios)
			trace (message);
			#else
			Sys.stderr ().write (Bytes.ofString (message));
			#end
			Sys.exit (1);
			
		}
		
	}
	
	
	public static function setUncaughtExceptionHandler (f:UncaughtErrorEvent->Bool):Void {
		
		__uncaughtExceptionHandler = f;
		
	}
	
	
	private static function sysName ():String {
		
		#if cpp
		var sys_string = cpp.Lib.load ("std", "sys_string", 0);
		return sys_string ();
		#else
		return Sys.systemName ();
		#end
		
	}
	
	
	private static function tryLoad (name:String, library:String, func:String, args:Int):Dynamic {
		
		try {
			
			#if cpp
			var result = cpp.Lib.load (name, func, args);
			#elseif (neko)
			var result = neko.Lib.load (name, func, args);
			#else
			var result = null;
			#end
			
			if (result != null) {
				
				loaderTrace ("Got result " + name);
				__moduleNames.set (library, name);
				return result;
				
			}
			
		} catch (e:Dynamic) {
			
			loaderTrace ("Failed to load : " + name);
			
		}
		
		return null;
		
	}
	
	
	#if neko
	
	private static function loadNekoAPI ():Void {
		
		if (!__loadedNekoAPI) {
			
			var init = load ("lime", "neko_init", 5);
			
			if (init != null) {
				
				loaderTrace ("Found nekoapi @ " + __moduleNames.get ("lime"));
				init (function(s) return new String (s), function (len:Int) { var r = []; if (len > 0) r[len - 1] = null; return r; }, null, true, false);
				
			} else {
				
				throw ("Could not find NekoAPI interface.");
				
			}
			
			__loadedNekoAPI = true;
			
		}
		
	}
	
	#end
	
	
	public static function exit ():Void {
		
		var quit = stage.onQuit;
		
		if (quit != null) {
			
			#if android
			if (quit == close) {
				
				Sys.exit (0);
				
			}
			#end
			
			quit ();
			
		}
		
	}
	
	
	public static function forceClose ():Void {
		
		var terminate = Lib.load ("lime", "lime_terminate", 0);
		terminate ();
		
	}
	
	
	static public function getTimer ():Int {
		#if neko
		return Std.int ( ( Timer.stamp() % 0x7ffff ) * 1000.0);	
		#else
		return Std.int ( Timer.stamp() * 1000.0);	
		#end
	}
	
	
	public static function getURL (url:URLRequest, target:String = null):Void {
		
		lime_get_url (url.url);
		
	}
	
	
	public static function pause ():Void {
		
		lime_pause_animation ();
		
	}
	
	
	public static function postUICallback (inCallback:Void->Void):Void {
		
		#if android
		lime_post_ui_callback (inCallback);
		#else
		inCallback ();
		#end
		
	}
	
	
	public static function resume ():Void {
		
		lime_resume_animation ();
		
	}
	
	
	public static function setIcon (path:String):Void {
		
		var set_icon = Lib.load ("lime", "lime_set_icon", 1);
		set_icon (path);
		
	}
	
	
	public static function setPackage (company:String, file:String, packageName:String, version:String):Void {
		
		Lib.company = company;
		Lib.file = file;
		Lib.packageName = packageName;
		Lib.version = version;
		
		lime_set_package (company, file, packageName, version);
		
	}
	
	
	@:noCompletion public static function __setCurrentStage (stage:Stage):Void {
		
		__stage = stage;
		
	}
	
	
	public static function trace (arg:Dynamic):Void {
		
		trace (arg);
		
	}
	
	
	
	
	// Getters & Setters
	
	
	
	
	static function get_current ():MovieClip {
		
		if (__current == null) {
			
			__current = new MovieClip ();
			
			if (__stage != null) {
				
				__stage.addChild (__current);
				
			}
			
		}
		
		return __current;
		
	}
	
	
	private static function get_stage ():Stage {
		
		if (__stage == null) {
			
			throw ("Error : stage can't be accessed until init is called");
			
		}
		
		return __stage;
		
	}
	
	
	
	
	// Native Methods
	
	
	
	
	#if android
	private static var lime_post_ui_callback = Lib.load ("lime", "lime_post_ui_callback", 1);
	#end
	private static var lime_set_package = Lib.load ("lime", "lime_set_package", 4);
	private static var lime_get_frame_stage = Lib.load ("lime", "lime_get_frame_stage", 1);
	private static var lime_get_url = Lib.load ("lime", "lime_get_url", 1);
	private static var lime_pause_animation = Lib.load ("lime", "lime_pause_animation", 0);
	private static var lime_resume_animation = Lib.load ("lime", "lime_resume_animation", 0);
	
	
}


#end