package openfl.display; #if !openfl_legacy


@:enum abstract TriangleCulling(String) from String to String {
	
	public var NEGATIVE = "negative";
	public var NONE = "none";
	public var POSITIVE = "positive";
	
}


#else
typedef TriangleCulling = openfl._legacy.display.TriangleCulling;
#end