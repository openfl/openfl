package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract GraphicsPathWinding(String) from String to String

{
	public var EVEN_ODD = "evenOdd";
	public var NON_ZERO = "nonZero";
}
#else
typedef GraphicsPathWinding = openfl.display.GraphicsPathWinding;
#end
