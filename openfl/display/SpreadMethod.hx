package openfl.display; #if !openfl_legacy


@:enum abstract SpreadMethod(String) from String to String {
	
	public var PAD = "pad";
	public var REFLECT = "reflect";
	public var REPEAT = "repeat";
	
}


#else
typedef SpreadMethod = openfl._legacy.display.SpreadMethod;
#end