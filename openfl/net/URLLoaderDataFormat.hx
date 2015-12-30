package openfl.net;


@:enum abstract URLLoaderDataFormat(Int) {
	
	public var BINARY = 0;
	public var TEXT = 1;
	public var VARIABLES = 2;
	
	@:from private static inline function fromString (value:String):URLLoaderDataFormat {
		
		return switch (value) {
			
			case "binary": BINARY;
			case "variables": VARIABLES;
			default: return TEXT;
			
		}
		
	}
	
	@:to private static inline function toString (value:Int):String {
		
		return switch (value) {
			
			case URLLoaderDataFormat.BINARY: "binary";
			case URLLoaderDataFormat.VARIABLES: "variables";
			default: "text";
			
		}
		
	}
	
}