package openfl.errors; #if !flash


class IllegalOperationError extends Error {
	
	
	public function new (inMessage:String = "") {
		
		super (inMessage, 0);
		
	}
	
	
}


#else
typedef IllegalOperationError = flash.errors.IllegalOperationError;
#end