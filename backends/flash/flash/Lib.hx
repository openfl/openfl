package flash;

@:final extern class Lib {
    public static var current:flash.display.MovieClip;
    public static function as<T>(v:Dynamic, c:Class<T>):Null<T>;
    public static function attach(name:String):flash.display.MovieClip;
    public static function eval(path:String):Dynamic;
    public static function fscommand(cmd:String, ?param:String = null):Void;
    public static function getTimer():Int;
    public static function getURL(url:flash.net.URLRequest, ?target:String = null):Void;
    public static function redirectTraces():Void;
    public static function trace(arg:Dynamic):Void;

}
