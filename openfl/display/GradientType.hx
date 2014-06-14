package openfl.display; #if !flash


enum GradientType {
	
	RADIAL;
	LINEAR;
	
}


#else
typedef GradientType = flash.display.GradientType;
#end