package flash.display; #if flash


@:enum abstract InterpolationMethod(String) from String to String {
	
	public var LINEAR_RGB = "linearRGB";
	public var RGB = "rgb";
	
}


#else
typedef InterpolationMethod = openfl.display.InterpolationMethod;
#end