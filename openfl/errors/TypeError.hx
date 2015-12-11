package openfl.errors;


class TypeError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "TypeError";
		
	}
	
	
}