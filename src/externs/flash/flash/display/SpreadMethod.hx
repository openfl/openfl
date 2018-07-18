package flash.display; #if flash


@:enum abstract SpreadMethod(String) from String to String {
	
	public var PAD = "pad";
	public var REFLECT = "reflect";
	public var REPEAT = "repeat";
	
}


#else
typedef SpreadMethod = openfl.display.SpreadMethod;
#end