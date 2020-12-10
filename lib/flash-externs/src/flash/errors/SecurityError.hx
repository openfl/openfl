package flash.errors;

#if flash
@:native("SecurityError") extern class SecurityError extends Error
{
	public function new(message:String = "");
}
#else
typedef SecurityError = openfl.errors.SecurityError;
#end
