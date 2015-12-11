package openfl.errors; #if (display || !flash)


extern class IOError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef IOError = flash.errors.IOError;
#end