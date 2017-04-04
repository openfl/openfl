package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;

class SWFMorphGradientRecord
{
	public var startRatio:Int;
	public var startColor:Int;
	public var endRatio:Int;
	public var endColor:Int;
	
	public function new(data:SWFData = null) {
		if (data != null) {
			parse(data);
		}
	}
	
	public function parse(data:SWFData):Void {
		startRatio = data.readUI8();
		startColor = data.readRGBA();
		endRatio = data.readUI8();
		endColor = data.readRGBA();
	}
	
	public function publish(data:SWFData):Void {
		data.writeUI8(startRatio);
		data.writeRGBA(startColor);
		data.writeUI8(endRatio);
		data.writeRGBA(endColor);
	}
	
	public function getMorphedGradientRecord(ratio:Float = 0):SWFGradientRecord {
		var gradientRecord:SWFGradientRecord = new SWFGradientRecord();
		gradientRecord.color = ColorUtils.interpolate(startColor, endColor, ratio);
		gradientRecord.ratio = Std.int (startRatio + (endRatio - startRatio) * ratio);
		return gradientRecord;
	}
	
	public function toString():String {
		return "[" + startRatio + "," + ColorUtils.rgbaToString(startColor) + "," + endRatio + "," + ColorUtils.rgbaToString(endColor) + "]";
	}
}