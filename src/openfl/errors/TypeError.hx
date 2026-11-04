package openfl.errors;

#if !flash
/**
	A TypeError exception is thrown when the actual type of an operand is
	different from the expected type.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class TypeError extends Error
{
	public function new(message:String = "", id:Int = 0)
	{
		super(message, id);

		name = "TypeError";
	}
}
#else
typedef TypeError = flash.errors.TypeError;
#end
