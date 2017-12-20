package openfl;

@:jsRequire("openfl/Lib", "default")

extern class Lib implements Dynamic {

	static var application:Dynamic;
	static var current:Dynamic;
	static function as(v:Dynamic, c:Dynamic):Dynamic;
	static function attach(name:Dynamic):Dynamic;
	static function getTimer():Dynamic;
	static function getURL(request:Dynamic, ?target:Dynamic):Dynamic;
	static function notImplemented(?posInfo:Dynamic):Dynamic;
	static function preventDefaultTouchMove():Dynamic;
	static function trace(arg:Dynamic):Dynamic;


}