package openfl.errors;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class RangeError extends Error
{
	public function new(message:String = "")
	{
		super(message, 0);

		name = "RangeError";
	}
}
#else
typedef RangeError = flash.errors.RangeError;
#end
