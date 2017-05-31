package openfl.errors;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class IOError extends Error {
	
	
	public function new (message:String = "") {
		
		super (message);
		
		name = "IOError";
		
	}
	
	
}