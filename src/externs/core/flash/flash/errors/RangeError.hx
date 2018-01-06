package flash.errors; #if (!display && flash)


@:native("RangeError") extern class RangeError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef RangeError = openfl.errors.RangeError;
#end