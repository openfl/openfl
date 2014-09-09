package openfl.display; #if !flash


enum CapsStyle {
	
	NONE;
	ROUND;
	SQUARE;
	
}


#else
typedef CapsStyle = flash.display.CapsStyle;
#end