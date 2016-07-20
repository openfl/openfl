package flash.display3D; #if (!display && flash)


@:enum abstract Context3DClearMask(String) from String to String {
	
	public var ALL = "all";
	public var COLOR = "color";
	public var DEPTH = "depth";
	public var STENCIL = "stencil";
	
}


#else
typedef Context3DClearMask = openfl.display3D.Context3DClearMask;
#end