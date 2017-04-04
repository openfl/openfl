package format.swf.tags;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;

class TagSetBackgroundColor implements ITag
{
	public static inline var TYPE:Int = 9;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var color:Int = 0xffffff;
	
	public function new() {
		
		type = TYPE;
		name = "SetBackgroundColor";
		version = 1;
		level = 1;
		
	}
	
	public static function create(aColor:Int = 0xffffff):TagSetBackgroundColor {
		var setBackgroundColor:TagSetBackgroundColor = new TagSetBackgroundColor();
		setBackgroundColor.color = aColor;
		return setBackgroundColor;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		color = data.readRGB();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 3);
		data.writeRGB(color);
	}

	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) + "Color: " + ColorUtils.rgbToString(color);
	}
}