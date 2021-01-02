package flash.profiler;

#if flash
@:require(flash11_4)
@:final extern class Telemetry
{
	public static var connected(default, never):Bool;
	public static var spanMarker(default, never):Float;
	public static function registerCommandHandler(commandName:String, handler:Dynamic):Bool;
	public static function sendMetric(metric:String, value:Dynamic):Void;
	public static function sendSpanMetric(metric:String, startSpanMarker:Float, value:Dynamic):Void;
	public static function unregisterCommandHandler(commandName:String):Bool;
}
#else
typedef Telemetry = openfl.profiler.Telemetry;
#end
