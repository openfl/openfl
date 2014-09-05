package openfl.display; #if !flash


enum JointStyle {
	
	MITER;
	ROUND;
	BEVEL;
	
}


#else
typedef JointStyle = flash.display.JointStyle;
#end