package flash.errors;

#if flash
extern class IOError extends Error
{
	public function new(message:String = "");
}
#else
typedef IOError = openfl.errors.IOError;
#end
