package openfl.errors; #if (!display && !flash)


class RangeError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "RangeError";
		
	}
	
	
}


#else


#if flash
@:native("RangeError")
#end

extern class RangeError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#end