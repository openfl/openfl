package openfl.errors; #if !flash


class SecurityError extends Error {
	
	
	public function new (inMessage:String = "") {
		
		super (inMessage, 0);
		
	}
	

}


#else
typedef SecurityError = flash.errors.SecurityError;
#end