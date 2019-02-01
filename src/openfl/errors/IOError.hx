package openfl.errors;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class IOError extends Error
{
	public function new(message:String = "")
	{
		super(message);

		name = "IOError";
	}
}
#else
typedef IOError = flash.errors.IOError;
#end
