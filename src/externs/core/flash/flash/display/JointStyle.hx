package flash.display; #if (!display && flash)


@:enum abstract JointStyle(String) from String to String {
	
	public var MITER = "miter";
	public var ROUND = "round";
	public var BEVEL = "bevel";
	
}


#else
typedef JointStyle = openfl.display.JointStyle;
#end