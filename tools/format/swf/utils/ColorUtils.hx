package format.swf.utils;

import format.swf.utils.StringUtils;

class ColorUtils
{
	public static function alpha(color:Int):Float {
		return (color >>> 24) / 255;
	}

	public static function rgb(color:Int):Int {
		return (color & 0xffffff);
	}
	
	public static function r(color:Int):Float {
		return ((rgb(color) >> 16) & 0xff) / 255;
	}
	
	public static function g(color:Int):Float {
		return ((rgb(color) >> 8) & 0xff) / 255;
	}
	
	public static function b(color:Int):Float {
		return (rgb(color) & 0xff) / 255;
	}
	
	public static function interpolate(color1:Int, color2:Int, ratio:Float):Int {
		var r1:Float = r(color1);
		var g1:Float = g(color1);
		var b1:Float = b(color1);
		var alpha1:Float = alpha(color1);
		var ri:Int = Std.int((r1 + (r(color2) - r1) * ratio) * 255);
		var gi:Int = Std.int((g1 + (g(color2) - g1) * ratio) * 255);
		var bi:Int = Std.int((b1 + (b(color2) - b1) * ratio) * 255);
		var alphai:Int = Std.int((alpha1 + (alpha(color2) - alpha1) * ratio) * 255);
		return bi | (gi << 8) | (ri << 16) | (alphai << 24);
	}
	
	public static function rgbToString(color:Int):String
	{
		return StringUtils.printf("#%06x", [(color & 0xffffff)]);
	}
	
	public static function rgbaToString(color:Int):String
	{
		return StringUtils.printf("#%06x(%02x)", [(color & 0xffffff), (color >>> 24)]);
	}
	
	public static function argbToString(color:Int):String
	{
		return StringUtils.printf("#(%02x)%06x", [(color >>> 24), (color & 0xffffff)]);
	}
}