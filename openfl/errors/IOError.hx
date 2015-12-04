package openfl.errors; #if (!display && !flash)


class IOError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
		name = "IOError";
		
	}
	
	
}


#else


#if flash
@:native("flash.errors.IOError")
#end

extern class IOError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#end