package openfl.errors;

#if (display || !flash)
#if !openfl_global
@:jsRequire("openfl/errors/TypeError", "default")
#end
extern class TypeError extends Error
{
	public function new(message:String = "");
}
#else
typedef TypeError = flash.errors.TypeError;
#end
