package openfl.errors; #if !flash


class RangeError extends Error {
	
	
	public function new (inMessage:String = "") {
		
		super (inMessage, 0);
		
	}
	
	
}


#else
typedef RangeError = flash.errors.RangeError;
#end