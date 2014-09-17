package openfl.display; #if !flash #if (next || js)


enum JointStyle {
	
	MITER;
	ROUND;
	BEVEL;
	
}


#else
typedef JointStyle = openfl._v2.display.JointStyle;
#end
#else
typedef JointStyle = flash.display.JointStyle;
#end