package openfl.errors; #if (!display && !flash)


class SecurityError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "SecurityError";
		
	}
	

}


#else


#if flash
@:native("SecurityError")
#end

extern class SecurityError extends Error {
	
	
	public function new (message:String = "");
	

}


#end