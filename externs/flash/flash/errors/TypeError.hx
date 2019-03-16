package flash.errors;

#if flash
@:native("TypeError") extern class TypeError extends Error
{
	public function new(message:String = "");
}
#else
typedef TypeError = openfl.errors.TypeError;
#end
