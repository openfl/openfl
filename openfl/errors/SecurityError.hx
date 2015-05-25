package openfl.errors; #if !flash


class SecurityError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "SecurityError";
		
	}
	

}


#else
typedef SecurityError = flash.errors.SecurityError;
#end