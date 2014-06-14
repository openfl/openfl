package openfl.errors; #if !flash


class ArgumentError extends Error {
	
	
	public function new (inMessage:String = "") {
		
		super (inMessage);
		
	}
	
	
}


#else
typedef ArgumentError = flash.errors.ArgumentError;
#end