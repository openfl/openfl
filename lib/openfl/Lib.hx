package openfl;

// import openfl.display.Application;
import openfl.display.MovieClip;
import openfl.net.URLRequest;

@:jsRequire("openfl/Lib", "default")
extern class Lib
{
	// public static var application:Application;
	public static var current:MovieClip;
	public static function as<T>(v:Dynamic, c:Class<T>):Null<T>;
	public static function attach(name:String):MovieClip;
	public static function getTimer():Int;
	public static function getURL(request:URLRequest, target:String = null):Void;
	// public static function notImplemented (?posInfo:Dynamic):Dynamic;
	// public static function preventDefaultTouchMove ():Dynamic;
	public static function trace(arg:Dynamic):Void;
}
