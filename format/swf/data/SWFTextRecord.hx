package format.swf.data;

import format.swf.SWFData;
import format.swf.utils.ColorUtils;
import format.swf.utils.StringUtils;

class SWFTextRecord
{
	public var type:Int;
	public var hasFont:Bool;
	public var hasColor:Bool;
	public var hasXOffset:Bool;
	public var hasYOffset:Bool;
	
	public var fontId:Int;
	public var textColor:Int;
	public var textHeight:Int;
	public var xOffset:Int;
	public var yOffset:Int;
	
	public var glyphEntries(default, null):Array<SWFGlyphEntry>;

	private var _level:Int;
	
	public function new(data:SWFData = null, glyphBits:Int = 0, advanceBits:Int = 0, previousRecord:SWFTextRecord = null, level:Int = 1) {
		glyphEntries = new Array<SWFGlyphEntry>();
		if (data != null) {
			parse(data, glyphBits, advanceBits, previousRecord, level);
		}
	}
	
	public function parse(data:SWFData, glyphBits:Int, advanceBits:Int, previousRecord:SWFTextRecord = null, level:Int = 1):Void {
		_level = level;
		var styles:Int = data.readUI8();
		type = styles >> 7;
		hasFont = ((styles & 0x08) != 0);
		hasColor = ((styles & 0x04) != 0);
		hasYOffset = ((styles & 0x02) != 0);
		hasXOffset = ((styles & 0x01) != 0);
		if (hasFont) {
			fontId = data.readUI16();
		} else if (previousRecord != null) {
			fontId = previousRecord.fontId;
		}
		if (hasColor) {
			textColor = (level < 2) ? data.readRGB() : data.readRGBA();
		} else if (previousRecord != null) {
			textColor = previousRecord.textColor;
		}
		if (hasXOffset) {
			xOffset = data.readSI16();
		} else if (previousRecord != null) {
			xOffset = previousRecord.xOffset;
		}
		if (hasYOffset) {
			yOffset = data.readSI16();
		} else if (previousRecord != null) {
			yOffset = previousRecord.yOffset;
		}
		if (hasFont) {
			textHeight = data.readUI16();
		} else if (previousRecord != null) {
			textHeight = previousRecord.textHeight;
		}
		var glyphCount:Int = data.readUI8();
		for (i in 0...glyphCount) {
			glyphEntries.push(data.readGLYPHENTRY(glyphBits, advanceBits));
		}
	}
	
	public function publish(data:SWFData, glyphBits:Int, advanceBits:Int, previousRecord:SWFTextRecord = null, level:Int = 1):Void {
		var flags:Int = (type << 7);
		hasFont = (previousRecord == null
			|| (previousRecord.fontId != fontId)
			|| (previousRecord.textHeight != textHeight));
		hasColor = (previousRecord == null || (previousRecord.textColor != textColor));
		hasXOffset = (previousRecord == null || (previousRecord.xOffset != xOffset));
		hasYOffset = (previousRecord == null || (previousRecord.yOffset != yOffset));
		if(hasFont) { flags |= 0x08; }
		if(hasColor) { flags |= 0x04; }
		if(hasYOffset) { flags |= 0x02; }
		if(hasXOffset) { flags |= 0x01; }
		data.writeUI8(flags);
		if(hasFont) {
			data.writeUI16(fontId);
		}
		if(hasColor) {
			if(level >= 2) {
				data.writeRGBA(textColor);
			} else {
				data.writeRGB(textColor);
			}
		}
		if(hasXOffset) {
			data.writeSI16(xOffset);
		}
		if(hasYOffset) {
			data.writeSI16(yOffset);
		}
		if(hasFont) {
			data.writeUI16(textHeight);
		}
		var glyphCount:Int = glyphEntries.length;
		data.writeUI8(glyphCount);
		for (i in 0...glyphCount) {
			data.writeGLYPHENTRY(glyphEntries[i], glyphBits, advanceBits);
		}
	}
	
	public function clone():SWFTextRecord {
		var record:SWFTextRecord = new SWFTextRecord();
		record.type = type;
		record.hasFont = hasFont;
		record.hasColor = hasColor;
		record.hasXOffset = hasXOffset;
		record.hasYOffset = hasYOffset;
		record.fontId = fontId;
		record.textColor = textColor;
		record.textHeight = textHeight;
		record.xOffset = xOffset;
		record.yOffset = yOffset;
		for (i in 0...glyphEntries.length) {
			record.glyphEntries.push(glyphEntries[i].clone());
		}
		return record;
	}
	
	public function toString(indent:Int = 0):String {
		var params:Array<String> = ["Glyphs: " + Std.string (glyphEntries.length)];
		if (hasFont) { params.push("FontID: " + fontId); params.push("Height: " + textHeight); }
		if (hasColor) { params.push("Color: " + ((_level <= 2) ? ColorUtils.rgbToString(textColor) : ColorUtils.rgbaToString(textColor))); }
		if (hasXOffset) { params.push("XOffset: " + xOffset); }
		if (hasYOffset) { params.push("YOffset: " + yOffset); }
		var str:String = params.join(", ");
		for (i in 0...glyphEntries.length) {
			str += "\n" + StringUtils.repeat(indent + 2) + "[" + i + "] " + glyphEntries[i].toString();
		}
		return str;
	}
}