package openfl.errors; #if (display || !flash)


extern class TypeError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef TypeError = flash.errors.TypeError;
#end