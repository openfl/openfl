package openfl.net;


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
	
	@:to private function toString ():String {
		
		return switch (cast this) {
			
			case URLLoaderDataFormat.BINARY: "binary";
			case URLLoaderDataFormat.TEXT: "text";
			case URLLoaderDataFormat.VARIABLES: "variables";
			default: null;
			
		}
		
	}
	
}