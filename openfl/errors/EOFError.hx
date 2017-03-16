package openfl.errors;


#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class EOFError extends IOError {
	
	
	public function new () {
		
		super ("End of file was encountered");
		
		name = "EOFError";
		errorID = 2030;
		
	}
	
	
}