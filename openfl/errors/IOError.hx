package openfl.errors;


class IOError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
		name = "IOError";
		
	}
	
	
}