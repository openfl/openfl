package openfl.display3D;


@:enum abstract Context3DClearMask(String) from String to String {
	
	public var ALL = "all";
	public var COLOR = "color";
	public var DEPTH = "depth";
	public var STENCIL = "stencil";
	
}