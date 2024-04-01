package flash.external;

#if flash
@:final extern class ExternalInterface
{
	#if (haxe_ver < 4.3)
	public static var available(default, never):Bool;
	public static var objectID(default, never):String;
	#else
	@:flash.property static var available(get, never):Bool;
	@:flash.property static var objectID(get, never):String;
	#end

	public static var marshallExceptions:Bool;

	public static function addCallback(functionName:String, closure:Dynamic):Void;
	public static function call(functionName:String, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;

	#if (haxe_ver >= 4.3)
	private static function get_available():Bool;
	private static function get_objectID():String;
	#end
}
#else
typedef ExternalInterface = openfl.external.ExternalInterface;
#end
