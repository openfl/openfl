package flash.errors;

#if flash
@:native("Error") extern class Error #if openfl_dynamic implements Dynamic #end
{
	#if flash
	public static var length:Int;
	#end
	public var errorID(default, never):Int;
	public var message:String; // Dynamic
	public var name:String; // Dynamic
	public function new(message:String = "", id:Int = 0);
	#if flash
	public static function getErrorMessage(index:Int):String;
	#end
	public function getStackTrace():String;
	#if flash
	public static function throwError(type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;
	#end
}
#else
typedef Error = openfl.errors.Error;
#end
