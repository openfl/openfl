package format.swf.data;

import format.swf.SWFData;
import format.swf.data.consts.LineCapsStyle;
import format.swf.data.consts.LineJointStyle;
import format.swf.utils.ColorUtils;

class SWFLineStyle implements hxbit.Serializable
{
	@:s public var width:Int;
	@:s public var color:Int;

	@:s public var _level:Int;

	// Forward declaration of SWFLineStyle2 properties
	@:s public var startCapsStyle:Int;
	@:s public var endCapsStyle:Int;
	@:s public var jointStyle:Int;
	@:s public var hasFillFlag:Bool;
	@:s public var noHScaleFlag:Bool;
	@:s public var noVScaleFlag:Bool;
	@:s public var pixelHintingFlag:Bool;
	@:s public var noClose:Bool;
	@:s public var miterLimitFactor:Float;
	@:s public var fillType:SWFFillStyle;

	public function new(data:SWFData = null, level:Int = 1) {
		startCapsStyle = LineCapsStyle.ROUND;
		endCapsStyle = LineCapsStyle.ROUND;
		jointStyle = LineJointStyle.ROUND;
		hasFillFlag = false;
		noHScaleFlag = false;
		noVScaleFlag = false;
		pixelHintingFlag = false;
		noClose = false;
		miterLimitFactor = 3;
		color = 0;

		if (data != null) {
			parse(data, level);
		}
	}

	public function parse(data:SWFData, level:Int = 1):Void {
		_level = level;
		width = data.readUI16();
		color = (level <= 2) ? data.readRGB() : data.readRGBA();
	}

	public function publish(data:SWFData, level:Int = 1):Void {
		data.writeUI16(width);
		if(level <= 2) {
			data.writeRGB(color);
		} else {
			data.writeRGBA(color);
		}
	}

	public function clone():SWFLineStyle {
		var lineStyle:SWFLineStyle = new SWFLineStyle();
		lineStyle.width = width;
		lineStyle.color = color;
		lineStyle.startCapsStyle = startCapsStyle;
		lineStyle.endCapsStyle = endCapsStyle;
		lineStyle.jointStyle = jointStyle;
		lineStyle.hasFillFlag = hasFillFlag;
		lineStyle.noHScaleFlag = noHScaleFlag;
		lineStyle.noVScaleFlag = noVScaleFlag;
		lineStyle.pixelHintingFlag = pixelHintingFlag;
		lineStyle.noClose = noClose;
		lineStyle.miterLimitFactor = miterLimitFactor;
		lineStyle.fillType = fillType.clone();
		return lineStyle;
	}

	public function toString():String {
		return "[SWFLineStyle] Width: " + width + " Color: " + ((_level <= 2) ? ColorUtils.rgbToString(color) : ColorUtils.rgbaToString(color));
	}
}