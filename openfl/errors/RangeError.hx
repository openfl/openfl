package openfl.errors;


class RangeError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "RangeError";
		
	}
	
	
}