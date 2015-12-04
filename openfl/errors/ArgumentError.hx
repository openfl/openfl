package openfl.errors; #if (!display && !flash)


class ArgumentError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
		name = "ArgumentError";
		
	}
	
	
}


#else


@:native("ArgumentError") extern class ArgumentError extends Error {}


#end