package openfl.errors; #if !flash


class TypeError extends Error {
	

	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "TypeError";
		
	}
	
	
}


#else
typedef TypeError = flash.errors.TypeError;
#end