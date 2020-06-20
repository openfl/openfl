package openfl.errors;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class IllegalOperationError extends Error
{
	public function new(message:String = "")
	{
		super(message, 0);

		name = "IllegalOperationError";
	}
}
#else
typedef IllegalOperationError = flash.errors.IllegalOperationError;
#end
