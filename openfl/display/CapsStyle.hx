package openfl.display; #if !flash #if (display || next || js)


enum CapsStyle {
	
	NONE;
	ROUND;
	SQUARE;
	
}


#else
typedef CapsStyle = openfl._v2.display.CapsStyle;
#end
#else
typedef CapsStyle = flash.display.CapsStyle;
#end