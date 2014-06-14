package openfl.errors; #if !flash


class IOError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
	}
	
	
}


#else
typedef IOError = flash.errors.IOError;
#end