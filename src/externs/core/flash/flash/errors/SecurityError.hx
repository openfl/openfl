package flash.errors; #if (!display && flash)


@:native("SecurityError") extern class SecurityError extends Error {
	
	
	public function new (message:String = "");
	
	
}


#else
typedef SecurityError = openfl.errors.SecurityError;
#end