package flash.errors;

#if flash
@:native("ArgumentError") extern class ArgumentError extends Error
{
	public function new(message:String = "");
}
#else
typedef ArgumentError = openfl.errors.ArgumentError;
#end
