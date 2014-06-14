package openfl.filters; #if !flash


class BitmapFilterQuality {
	
	public static var HIGH = 3;
	public static var MEDIUM = 2;
	public static var LOW = 1;
	
}


#else
typedef BitmapFilterQuality = flash.filters.BitmapFilterQuality;
#end