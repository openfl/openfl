package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;

class SWFGradientRecord
{
	public var ratio:Int;
	public var color:Int;
	
	private var _level:Int;
	
	public function new(data:SWFData = null, level:Int = 1) {
		if (data != null) {
			parse(data, level);
		}
	}
	
	public function parse(data:SWFData, level:Int):Void {
		_level = level;
		ratio = data.readUI8();
		color = (level <= 2) ? data.readRGB() : data.readRGBA();
	}
	
	public function publish(data:SWFData, level:Int):Void {
		data.writeUI8(ratio);
		if(level <= 2) {
			data.writeRGB(color);
		} else {
			data.writeRGBA(color);
		}
	}
	
	public function clone():SWFGradientRecord {
		var gradientRecord:SWFGradientRecord = new SWFGradientRecord();
		gradientRecord.ratio = ratio;
		gradientRecord.color = color;
		return gradientRecord;
	}
	
	public function toString():String {
		return "[" + ratio + "," + ((_level <= 2) ? ColorUtils.rgbToString(color) : ColorUtils.rgbaToString(color)) + "]";
	}
}