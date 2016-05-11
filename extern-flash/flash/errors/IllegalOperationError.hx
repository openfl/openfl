package flash.errors; #if (!display && flash)


extern class IllegalOperationError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef IllegalOperationError = openfl.errors.IllegalOperationError;
#end