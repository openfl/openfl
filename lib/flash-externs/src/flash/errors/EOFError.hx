package flash.errors;

#if flash
extern class EOFError extends IOError
{
	public function new(?message:String, id:Int = 0):Void;
}
#else
typedef EOFError = openfl.errors.EOFError;
#end
