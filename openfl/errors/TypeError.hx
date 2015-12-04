package openfl.errors; #if (!display && !flash)


class TypeError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "TypeError";
		
	}
	
	
}


#else


#if flash
@:native("TypeError")
#end

class TypeError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#end