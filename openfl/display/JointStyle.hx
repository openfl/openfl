package openfl.display; #if !openfl_legacy


enum JointStyle {
	
	MITER;
	ROUND;
	BEVEL;
	
}


#else
typedef JointStyle = openfl._legacy.display.JointStyle;
#end