package flash.display; #if (!display && flash)


@:enum abstract GraphicsPathWinding(String) from String to String {
	
	public var EVEN_ODD = "evenOdd";
	public var NON_ZERO = "nonZero";
	
}


#else
typedef GraphicsPathWinding = openfl.display.GraphicsPathWinding;
#end