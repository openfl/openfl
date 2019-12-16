package flash.display;

#if flash
@:enum abstract TriangleCulling(String) from String to String
{
	public var NEGATIVE = "negative";
	public var NONE = "none";
	public var POSITIVE = "positive";
}
#else
typedef TriangleCulling = openfl.display.TriangleCulling;
#end
