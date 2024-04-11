package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract TriangleCulling(String) from String to String

{
	public var NEGATIVE = "negative";
	public var NONE = "none";
	public var POSITIVE = "positive";
}
#else
typedef TriangleCulling = openfl.display.TriangleCulling;
#end
