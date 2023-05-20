package flash.profiler;

#if flash
@:require(flash11_4)
@:final extern class Telemetry
{
	#if (haxe_ver < 4.3)
	public static var connected(default, never):Bool;
	public static var spanMarker(default, never):Float;
	#else
	@:flash.property static var connected(get, never):Bool;
	@:flash.property static var spanMarker(get, never):Float;
	#end

	public static function registerCommandHandler(commandName:String, handler:Dynamic):Bool;
	public static function sendMetric(metric:String, value:Dynamic):Void;
	public static function sendSpanMetric(metric:String, startSpanMarker:Float, value:Dynamic):Void;
	public static function unregisterCommandHandler(commandName:String):Bool;

	#if (haxe_ver >= 4.3)
	private static function get_connected():Bool;
	private static function get_spanMarker():Float;
	#end
}
#else
typedef Telemetry = openfl.profiler.Telemetry;
#end
