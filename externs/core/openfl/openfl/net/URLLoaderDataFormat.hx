package openfl.net; #if (display || !flash)


/**
 * The URLLoaderDataFormat class provides values that specify how downloaded
 * data is received.
 */
@:enum abstract URLLoaderDataFormat(Null<Int>) {
	
	/**
	 * Specifies that downloaded data is received as raw binary data.
	 */
	public var BINARY = 0;
	
	/**
	 * Specifies that downloaded data is received as text.
	 */
	public var TEXT = 1;
	
	/**
	 * Specifies that downloaded data is received as URL-encoded variables.
	 */
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
typedef URLLoaderDataFormat = flash.net.URLLoaderDataFormat;
#end