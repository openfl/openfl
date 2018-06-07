package openfl.net; #if !openfljs


@:enum abstract URLLoaderDataFormat(Null<Int>) {
	
	public var BINARY = 0;
	public var TEXT = 1;
	public var VARIABLES = 2;
	
	@:from private static function fromString (value:String):URLLoaderDataFormat {
		
		return switch (value) {
			
			case "binary": BINARY;
			case "text": TEXT;
			case "variables": VARIABLES;
			default: null;
			
		}
		
	}
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
			case URLLoaderDataFormat.BINARY: "binary";
			case URLLoaderDataFormat.TEXT: "text";
			case URLLoaderDataFormat.VARIABLES: "variables";
			default: null;
			
		}
		
	}
	
}


#else


@:enum abstract URLLoaderDataFormat(String) from String to String {
	
	public var BINARY = "binary";
	public var TEXT = "text";
	public var VARIABLES = "variables";
	
}


#end