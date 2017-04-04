package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;
import format.swf.utils.MatrixUtils;
import flash.errors.Error;

class SWFMorphFillStyle
{
	public var type:Int;

	public var startColor:Int;
	public var endColor:Int;
	public var startGradientMatrix:SWFMatrix;
	public var endGradientMatrix:SWFMatrix;
	public var gradient:SWFMorphGradient;
	public var bitmapId:Int;
	public var startBitmapMatrix:SWFMatrix;
	public var endBitmapMatrix:SWFMatrix;
	
	public function new(data:SWFData = null, level:Int = 1) {
		if (data != null) {
			parse(data, level);
		}
	}
	
	public function parse(data:SWFData, level:Int = 1):Void {
		type = data.readUI8();
		switch(type) {
			case 0x00:
				startColor = data.readRGBA();
				endColor = data.readRGBA();
			case 0x10, 0x12, 0x13:
				startGradientMatrix = data.readMATRIX();
				endGradientMatrix = data.readMATRIX();
				gradient = (type == 0x13) ? data.readMORPHFOCALGRADIENT(level) : data.readMORPHGRADIENT(level);
			case 0x40, 0x41, 0x42, 0x43:
				bitmapId = data.readUI16();
				startBitmapMatrix = data.readMATRIX();
				endBitmapMatrix = data.readMATRIX();
			default:
				throw(new Error("Unknown fill style type: 0x" + StringTools.hex (type)));
		}
	}
	
	public function publish(data:SWFData, level:Int = 1):Void {
		data.writeUI8(type);
		switch(type) {
			case 0x00:
				data.writeRGBA(startColor);
				data.writeRGBA(endColor);
			case 0x10, 0x12, 0x13:
				data.writeMATRIX(startGradientMatrix);
				data.writeMATRIX(endGradientMatrix);
				if (type == 0x13) {
					data.writeMORPHFOCALGRADIENT(cast (gradient, SWFMorphFocalGradient), level);
				} else {
					data.writeMORPHGRADIENT(gradient, level);
				}
			case 0x40, 0x41, 0x42, 0x43:
				data.writeUI16(bitmapId);
				data.writeMATRIX(startBitmapMatrix);
				data.writeMATRIX(endBitmapMatrix);
			default:
				throw(new Error("Unknown fill style type: 0x" + StringTools.hex (type)));
		}
	}
	
	public function getMorphedFillStyle(ratio:Float = 0):SWFFillStyle {
		var fillStyle:SWFFillStyle = new SWFFillStyle();
		fillStyle.type = type;
		switch(type) {
			case 0x00:
				fillStyle.rgb = ColorUtils.interpolate(startColor, endColor, ratio);
			case 0x10, 0x12:
				fillStyle.gradientMatrix = MatrixUtils.interpolate(startGradientMatrix, endGradientMatrix, ratio);
				fillStyle.gradient = gradient.getMorphedGradient(ratio);
			case 0x40, 0x41, 0x42, 0x43:
				fillStyle.bitmapId = bitmapId;
				fillStyle.bitmapMatrix = MatrixUtils.interpolate(startBitmapMatrix, endBitmapMatrix, ratio);
		}
		return fillStyle;
	}
	
	public function toString():String {
		var str:String = "[SWFMorphFillStyle] Type: " + StringTools.hex (type);
		switch(type) {
			case 0x00: str += " (solid), StartColor: " + ColorUtils.rgbaToString(startColor) + ", EndColor: " + ColorUtils.rgbaToString(endColor);
			case 0x10: str += " (linear gradient), Gradient: " + gradient;
			case 0x12: str += " (radial gradient), Gradient: " + gradient;
			case 0x13: str += " (focal radial gradient), Gradient: " + gradient;
			case 0x40: str += " (repeating bitmap), BitmapID: " + bitmapId;
			case 0x41: str += " (clipped bitmap), BitmapID: " + bitmapId;
			case 0x42: str += " (non-smoothed repeating bitmap), BitmapID: " + bitmapId;
			case 0x43: str += " (non-smoothed clipped bitmap), BitmapID: " + bitmapId;
		}
		return str;
	}
}