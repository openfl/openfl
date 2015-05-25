package openfl.errors; #if !flash


class ArgumentError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
		name = "ArgumentError";
		
	}
	
	
}


#else
typedef ArgumentError = flash.errors.ArgumentError;
#end