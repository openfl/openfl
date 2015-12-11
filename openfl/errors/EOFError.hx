package openfl.errors;


class EOFError extends IOError {
	
	
	public function new () {
		
		super ("End of file was encountered");
		
		name = "EOFError";
		errorID = 2030;
		
	}
	
	
}