package format.swf.utils;

class NumberUtils
{
	public static function roundPixels20(pixels:Float):Float {
		return Math.round(pixels * 100) / 100;
	}
	
	public static function roundPixels400(pixels:Float):Float {
		return Math.round(pixels * 10000) / 10000;
	}
}