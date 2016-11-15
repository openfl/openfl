package format.swf.data;

import format.swf.SWFData;
import format.swf.data.consts.LineCapsStyle;
import format.swf.data.consts.LineJointStyle;
import format.swf.utils.ColorUtils;

class SWFMorphLineStyle
{
	public var startWidth:Int;
	public var endWidth:Int;
	public var startColor:Int;
	public var endColor:Int;

	// Forward declaration of SWFMorphLineStyle2 properties
	public var startCapsStyle:Int;
	public var endCapsStyle:Int;
	public var jointStyle:Int;
	public var hasFillFlag:Bool;
	public var noHScaleFlag:Bool;
	public var noVScaleFlag:Bool;
	public var pixelHintingFlag:Bool;
	public var noClose:Bool;
	public var miterLimitFactor:Float;
	public var fillType:SWFMorphFillStyle;
	
	public function new(data:SWFData = null, level:Int = 1) {
		startCapsStyle = LineCapsStyle.ROUND;
		endCapsStyle = LineCapsStyle.ROUND;
		jointStyle = LineJointStyle.ROUND;
		miterLimitFactor = 3;
		if (data != null) {
			parse(data, level);
		}
	}
	
	public function parse(data:SWFData, level:Int = 1):Void {
		startWidth = data.readUI16();
		endWidth = data.readUI16();
		startColor = data.readRGBA();
		endColor = data.readRGBA();
	}
	
	public function publish(data:SWFData, level:Int = 1):Void {
		data.writeUI16(startWidth);
		data.writeUI16(endWidth);
		data.writeRGBA(startColor);
		data.writeRGBA(endColor);
	}
	
	public function getMorphedLineStyle(ratio:Float = 0):SWFLineStyle {
		var lineStyle:SWFLineStyle = new SWFLineStyle();
		if(hasFillFlag) {
			lineStyle.fillType = fillType.getMorphedFillStyle(ratio);
		} else {
			lineStyle.color = ColorUtils.interpolate(startColor, endColor, ratio);
			lineStyle.width = Std.int (startWidth + (endWidth - startWidth) * ratio);
		}
		lineStyle.startCapsStyle = startCapsStyle;
		lineStyle.endCapsStyle = endCapsStyle;
		lineStyle.jointStyle = jointStyle;
		lineStyle.hasFillFlag = hasFillFlag;
		lineStyle.noHScaleFlag = noHScaleFlag;
		lineStyle.noVScaleFlag = noVScaleFlag;
		lineStyle.pixelHintingFlag = pixelHintingFlag;
		lineStyle.noClose = noClose;
		lineStyle.miterLimitFactor = miterLimitFactor;
		return lineStyle;
	}
	
	public function toString():String {
		return "[SWFMorphLineStyle] " +
			"StartWidth: " + startWidth + ", " +
			"EndWidth: " + endWidth + ", " +
			"StartColor: " + ColorUtils.rgbaToString(startColor) + ", " +
			"EndColor: " + ColorUtils.rgbaToString(endColor);
	}
}