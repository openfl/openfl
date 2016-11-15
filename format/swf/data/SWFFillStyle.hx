package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;
import format.swf.utils.StringUtils;
import flash.errors.Error;

class SWFFillStyle
{
	public var type:Int;

	public var rgb:Int;
	public var gradient:SWFGradient;
	public var gradientMatrix:SWFMatrix;
	public var bitmapId:Int;
	public var bitmapMatrix:SWFMatrix;

	private var _level:Int;
	
	public function new(data:SWFData = null, level:Int = 1) {
		if (data != null) {
			parse(data, level);
		}
	}
	
	public function parse(data:SWFData, level:Int = 1):Void {
		_level = level;
		type = data.readUI8();
		switch(type) {
			case 0x00:
				rgb = (level <= 2) ? data.readRGB() : data.readRGBA();
			case 0x10, 0x12, 0x13:
				gradientMatrix = data.readMATRIX();
				gradient = (type == 0x13) ? data.readFOCALGRADIENT(level) : data.readGRADIENT(level);
			case 0x40, 0x41, 0x42, 0x43:
				bitmapId = data.readUI16();
				bitmapMatrix = data.readMATRIX();
			default:
				throw(new Error("Unknown fill style type: 0x" + StringTools.hex (type)));
		}
	}
	
	public function publish(data:SWFData, level:Int = 1):Void {
		data.writeUI8(type);
		switch(type) {
			case 0x00:
				if(level <= 2) {
					data.writeRGB(rgb);
				} else {
					data.writeRGBA(rgb);
				}
			case 0x10, 0x12:
				data.writeMATRIX(gradientMatrix);
				data.writeGRADIENT(gradient, level);
			case 0x13:
				data.writeMATRIX(gradientMatrix);
				data.writeFOCALGRADIENT(cast(gradient,SWFFocalGradient), level);
			case 0x40, 0x41, 0x42, 0x43:
				data.writeUI16(bitmapId);
				data.writeMATRIX(bitmapMatrix);
			default:
				throw(new Error("Unknown fill style type: 0x" + StringTools.hex (type)));
		}
	}
	
	public function clone():SWFFillStyle {
		var fillStyle:SWFFillStyle = new SWFFillStyle();
		fillStyle.type = type;
		fillStyle.rgb = rgb;
		fillStyle.gradient = gradient.clone();
		fillStyle.gradientMatrix = gradientMatrix.clone();
		fillStyle.bitmapId = bitmapId;
		fillStyle.bitmapMatrix = bitmapMatrix.clone();
		return fillStyle;
	}
	
	public function toString():String {
		var str:String = "[SWFFillStyle] Type: " + StringUtils.printf("%02x", [ type ]);
		switch(type) {
			case 0x00: str += " (solid), Color: " + ((_level <= 2) ? ColorUtils.rgbToString(rgb) : ColorUtils.rgbaToString(rgb));
			case 0x10: str += " (linear gradient), Gradient: " + gradient + ", Matrix: " + gradientMatrix;
			case 0x12: str += " (radial gradient), Gradient: " + gradient + ", Matrix: " + gradientMatrix;
			case 0x13: str += " (focal radial gradient), Gradient: " + gradient + ", Matrix: " + gradientMatrix + ", FocalPoint: " + gradient.focalPoint;
			case 0x40: str += " (repeating bitmap), BitmapID: " + bitmapId;
			case 0x41: str += " (clipped bitmap), BitmapID: " + bitmapId;
			case 0x42: str += " (non-smoothed repeating bitmap), BitmapID: " + bitmapId;
			case 0x43: str += " (non-smoothed clipped bitmap), BitmapID: " + bitmapId;
		}
		return str;
	}
}