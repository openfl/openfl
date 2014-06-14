package openfl.errors; #if !flash


class TypeError extends Error {
	

	public function new (inMessage:String = "") {
		
		super (inMessage, 0);
		
	}
	
	
}


#else
typedef TypeError = flash.errors.TypeError;
#end