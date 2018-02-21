package openfl.errors; #if (display || !flash)


@:jsRequire("openfl/errors/RangeError", "default")

extern class RangeError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef RangeError = flash.errors.RangeError;
#end