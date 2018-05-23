package openfl.errors; #if (display || !flash)


extern class ArgumentError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef ArgumentError = flash.errors.ArgumentError;
#end