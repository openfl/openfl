package openfl.errors;

#if (display || !flash)
@:jsRequire("openfl/errors/TypeError", "default")
extern class TypeError extends Error
{
	public function new(message:String = "");
}
#else
typedef TypeError = flash.errors.TypeError;
#end
