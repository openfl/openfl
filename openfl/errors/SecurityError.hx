package openfl.errors;


class SecurityError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "SecurityError";
		
	}
	

}