package openfl.errors;

#if !flash
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class EOFError extends IOError
{
	public function new(message:String = null, id:Int = 0)
	{
		super("End of file was encountered");

		name = "EOFError";
		errorID = 2030;
	}
}
#else
typedef EOFError = flash.errors.EOFError;
#end
