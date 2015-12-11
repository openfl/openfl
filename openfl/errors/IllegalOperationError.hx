package openfl.errors;


class IllegalOperationError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "IllegalOperationError";
		
	}
	
	
}