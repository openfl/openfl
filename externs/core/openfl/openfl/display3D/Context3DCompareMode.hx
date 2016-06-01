package openfl.display3D;


@:enum abstract Context3DCompareMode(String) from String to String {
	
	public var ALWAYS = "always";
	public var EQUAL = "equal";
	public var GREATER = "greater";
	public var GREATER_EQUAL = "greaterEqual";
	public var LESS = "less";
	public var LESS_EQUAL = "lessEqual";
	public var NEVER = "never";
	public var NOT_EQUAL = "notEqual";
	
}