package flash.errors;

#if flash
@:native("Error") extern class Error #if openfl_dynamic implements Dynamic #end
{
	#if (haxe_ver < 4.3)
	public var errorID(default, never):Int;
	#else
	@:flash.property var errorID(get, never):Int;
	#end

	public static var length:Int;
	public var message:String; // Dynamic
	public var name:String; // Dynamic
	public function new(message:String = "", id:Int = 0);
	public static function getErrorMessage(index:Int):String;
	public function getStackTrace():String;
	public static function throwError(type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;

	#if (haxe_ver >= 4.3)
	private function get_errorID():Int;
	#end
}
#else
typedef Error = openfl.errors.Error;
#end
