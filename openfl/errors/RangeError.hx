package openfl.errors; #if !flash


class RangeError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "RangeError";
		
	}
	
	
}


#else
typedef RangeError = flash.errors.RangeError;
#end