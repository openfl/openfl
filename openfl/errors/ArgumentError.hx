package openfl.errors;


class ArgumentError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
		name = "ArgumentError";
		
	}
	
	
}