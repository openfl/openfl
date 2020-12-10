package openfl.errors;

#if !flash
import haxe.CallStack;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Error #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic #end
{
	@:noCompletion private static inline var DEFAULT_TO_STRING:String = "Error";

	// @:noCompletion @:dox(hide) public static var length:Int;
	public var errorID(default, null):Int;
	public var message:String;
	public var name:String;

	public function new(message:String = "", id:Int = 0)
	{
		this.message = message;
		this.errorID = id;
		name = "Error";
	}

	// @:noCompletion @:dox(hide) public static function getErrorMessage (index:Int):String;

	public function getStackTrace():String
	{
		return CallStack.toString(CallStack.exceptionStack());
	}

	// @:noCompletion @:dox(hide) public static function throwError (type:Class<Dynamic>, index:UInt, ?p1:Dynamic, ?p2:Dynamic, ?p3:Dynamic, ?p4:Dynamic, ?p5:Dynamic):Dynamic;

	public function toString():String
	{
		if (message != null)
		{
			return message;
		}
		else
		{
			return DEFAULT_TO_STRING;
		}
	}
}
#else
typedef Error = flash.errors.Error;
#end
