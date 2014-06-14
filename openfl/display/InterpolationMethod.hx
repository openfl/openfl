package openfl.display; #if !flash


enum InterpolationMethod {
	
	RGB;
	LINEAR_RGB;
	
}


#else
typedef InterpolationMethod = flash.display.InterpolationMethod;
#end