package openfl.display; #if !flash


#if (haxe_ver > 3.100)

@:enum abstract JointStyle(String) to String {
	
	var MITER = "miter";
	var ROUND = "round";
	var BEVEL = "bevel";
	
}

#else

enum JointStyle {
	
	MITER;
	ROUND;
	BEVEL;
	
}

#end


#else
typedef JointStyle = flash.display.JointStyle;
#end