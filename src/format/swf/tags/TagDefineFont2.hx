package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFKerningRecord;
import format.swf.data.SWFRectangle;
import format.swf.utils.StringUtils;

import flash.utils.ByteArray;

class TagDefineFont2 extends TagDefineFont implements IDefinitionTag
{
	public static inline var TYPE:Int = 48;
	
	public var hasLayout:Bool;
	public var shiftJIS:Bool;
	public var smallText:Bool;
	public var ansi:Bool;
	public var wideOffsets:Bool;
	public var wideCodes:Bool;
	public var italic:Bool;
	public var bold:Bool;
	public var languageCode:Int;
	public var fontName:String;
	public var ascent:Int;
	public var descent:Int;
	public var leading:Int;
	
	public var codeTable (default, null):Array<Int>;
	public var fontAdvanceTable (default, null):Array<Int>;
	public var fontBoundsTable (default, null):Array<SWFRectangle>;
	public var fontKerningTable (default, null):Array<SWFKerningRecord>;
	
	public function new() {
		super ();
		type = TYPE;
		name = "DefineFont2";
		version = 3;
		level = 2;
		codeTable = new Array<Int>();
		fontAdvanceTable = new Array<Int>();
		fontBoundsTable = new Array<SWFRectangle>();
		fontKerningTable = new Array<SWFKerningRecord>();
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		var flags:Int = data.readUI8();
		hasLayout = ((flags & 0x80) != 0);
		shiftJIS = ((flags & 0x40) != 0);
		smallText = ((flags & 0x20) != 0);
		ansi = ((flags & 0x10) != 0);
		wideOffsets = ((flags & 0x08) != 0);
		wideCodes = ((flags & 0x04) != 0);
		italic = ((flags & 0x02) != 0);
		bold = ((flags & 0x01) != 0);
		languageCode = data.readLANGCODE();
		var fontNameLen:Int = data.readUI8();
		var fontNameRaw:ByteArray = new ByteArray();
		fontNameRaw.endian = BIG_ENDIAN;
		data.readBytes(fontNameRaw, 0, fontNameLen);
		#if (cpp || neko)
		fontName = fontNameRaw.readUTFBytes(fontNameLen - 1);
		#else
		fontName = fontNameRaw.readUTFBytes(fontNameLen);
		#end
		var i:Int;
		var numGlyphs:Int = data.readUI16();
		if(numGlyphs > 0) {
			// Skip offsets. We don't need them.
			data.skipBytes(numGlyphs << (wideOffsets ? 2 : 1));
			// Not used
			var codeTableOffset:Int = (wideOffsets ? data.readUI32() : data.readUI16());
			for (i in 0...numGlyphs) {
				glyphShapeTable.push(data.readSHAPE());
			}
			for (i in 0...numGlyphs) {
				codeTable.push(wideCodes ? data.readUI16() : data.readUI8());
			}
		}
		if (hasLayout) {
			ascent = data.readUI16();
			descent = data.readUI16();
			leading = data.readSI16();
			for (i in 0...numGlyphs) {
				fontAdvanceTable.push(data.readSI16());
			}
			for (i in 0...numGlyphs) {
				fontBoundsTable.push(data.readRECT());
			}
			var kerningCount:Int = data.readUI16();
			for (i in 0...kerningCount) {
				fontKerningTable.push(data.readKERNINGRECORD(wideCodes));
			}
		}
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		var numGlyphs:Int = glyphShapeTable.length;
		var i:Int;
		body.writeUI16(characterId);
		var flags:Int = 0;
		if(hasLayout) { flags |= 0x80; }
		if(shiftJIS) { flags |= 0x40; }
		if(smallText) { flags |= 0x20; }
		if(ansi) { flags |= 0x10; }
		if(wideOffsets) { flags |= 0x08; }
		if(wideCodes) { flags |= 0x04; }
		if(italic) { flags |= 0x02; }
		if(bold) { flags |= 0x01; }
		body.writeUI8(flags);
		body.writeLANGCODE(languageCode);
		var fontNameRaw:ByteArray = new ByteArray();
		fontNameRaw.endian = BIG_ENDIAN;
		fontNameRaw.writeUTFBytes(fontName);
		body.writeUI8(fontNameRaw.length);
		body.writeBytes(fontNameRaw);
		body.writeUI16(numGlyphs);
		if(numGlyphs > 0) {
			var offsetTableLength:Int = (numGlyphs << (wideOffsets ? 2 : 1));
			var codeTableOffsetLength:Int = (wideOffsets ? 4 : 2);
			var codeTableLength:Int = (wideOffsets ? (numGlyphs << 1) : numGlyphs);
			var offset:Int = offsetTableLength + codeTableOffsetLength;
			var shapeTable:SWFData = new SWFData();
			for (i in 0...numGlyphs) {
				// Write out the offset table for the current glyph
				if(wideOffsets) {
					body.writeUI32(offset + shapeTable.position);
				} else {
					body.writeUI16(offset + shapeTable.position);
				}
				// Serialize the glyph's shape to a separate bytearray
				shapeTable.writeSHAPE(glyphShapeTable[i]);
			}
			// Code table offset
			if(wideOffsets) {
				body.writeUI32(offset + shapeTable.length);
			} else {
				body.writeUI16(offset + shapeTable.length);
			}
			// Now concatenate the glyph shape table to the end (after
			// the offset table that we were previously writing inside
			// the for loop above).
			body.writeBytes(shapeTable);
			// Write the code table
			for (i in 0...numGlyphs) {
				if(wideCodes) {
					body.writeUI16(codeTable[i]);
				} else {
					body.writeUI8(codeTable[i]);
				}
			}
		}
		if (hasLayout) {
			body.writeUI16(ascent);
			body.writeUI16(descent);
			body.writeSI16(leading);
			for (i in 0...numGlyphs) {
				body.writeSI16(fontAdvanceTable[i]);
			}
			for (i in 0...numGlyphs) {
				body.writeRECT(fontBoundsTable[i]);
			}
			var kerningCount:Int = fontKerningTable.length;
			body.writeUI16(kerningCount);
			for (i in 0...kerningCount) {
				body.writeKERNINGRECORD(fontKerningTable[i], wideCodes);
			}
		}
		// Now write the tag with the known body length, and the
		// actual contents out to the provided SWFData instance.
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"FontName: " + fontName + ", " +
			"Italic: " + italic + ", " +
			"Bold: " + bold + ", " +
			"Glyphs: " + glyphShapeTable.length;
		return str + toStringCommon(indent);
	}
	
	override private function toStringCommon(indent:Int):String {
		var i:Int;
		var str:String = super.toStringCommon(indent);
		if (hasLayout) {
			str += "\n" + StringUtils.repeat(indent + 2) + "Ascent: " + ascent;
			str += "\n" + StringUtils.repeat(indent + 2) + "Descent: " + descent;
			str += "\n" + StringUtils.repeat(indent + 2) + "Leading: " + leading;
		}
		if (codeTable.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "CodeTable:";
			for (i in 0...codeTable.length) {
				if ((i & 0x0f) == 0) {
					str += "\n" + StringUtils.repeat(indent + 4) + Std.string (codeTable[i]);
				} else {
					str += ", " + Std.string (codeTable[i]);
				}
			}
		}
		if (fontAdvanceTable.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "FontAdvanceTable:";
			for (i in 0...fontAdvanceTable.length) {
				if ((i & 0x07) == 0) {
					str += "\n" + StringUtils.repeat(indent + 4) + Std.string (fontAdvanceTable[i]);
				} else {
					str += ", " + Std.string (fontAdvanceTable[i]);
				}
			}
		}
		if (fontBoundsTable.length > 0) {
			var hasNonNullBounds:Bool = false;
			for (i in 0...fontBoundsTable.length) {
				var rect:SWFRectangle = fontBoundsTable[i];
				if (rect.xmin != 0 || rect.xmax != 0 || rect.ymin != 0 || rect.ymax != 0) {
					hasNonNullBounds = true;
					break;
				}
			}
			if (hasNonNullBounds) {
				str += "\n" + StringUtils.repeat(indent + 2) + "FontBoundsTable:";
				for (i in 0...fontBoundsTable.length) {
					str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + fontBoundsTable[i].toString();
				}
			}
		}
		if (fontKerningTable.length > 0) {
			str += "\n" + StringUtils.repeat(indent + 2) + "KerningTable:";
			for (i in 0...fontKerningTable.length) {
				str += "\n" + StringUtils.repeat(indent + 4) + "[" + i + "] " + fontKerningTable[i].toString();
			}
		}
		return str;
	}
}