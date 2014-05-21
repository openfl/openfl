package openfl.display;


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