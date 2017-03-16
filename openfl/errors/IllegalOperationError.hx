package openfl.errors;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class IllegalOperationError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message, 0);
		
		name = "IllegalOperationError";
		
	}
	
	
}