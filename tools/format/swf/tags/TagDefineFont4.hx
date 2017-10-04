package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagDefineFont4 implements IDefinitionTag
{
	public static inline var TYPE:Int = 91;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var hasFontData:Bool;
	public var italic:Bool;
	public var bold:Bool;
	public var fontName:String;

	public var characterId:Int;
	
	public var fontData (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "DefineFont4";
		version = 10;
		level = 1;
		fontData = new ByteArray();
		fontData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var pos:Int = data.position;
		characterId = data.readUI16();
		var flags:Int = data.readUI8();
		hasFontData = ((flags & 0x04) != 0);
		italic = ((flags & 0x02) != 0);
		bold = ((flags & 0x01) != 0);
		fontName = data.readSTRING();
		if (hasFontData && length > Std.int (data.position) - pos) {
			data.readBytes(fontData, 0, length - (data.position - pos));
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		var flags:Int = 0;
		if(hasFontData) { flags |= 0x04; }
		if(italic) { flags |= 0x02; }
		if(bold) { flags |= 0x01; }
		body.writeUI8(flags);
		body.writeSTRING(fontName);
		if (hasFontData && fontData.length > 0) {
			body.writeBytes(fontData);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineFont4 = new TagDefineFont4();
		tag.characterId = characterId;
		tag.hasFontData = hasFontData;
		tag.italic = italic;
		tag.bold = bold;
		tag.fontName = fontName;
		if (fontData.length > 0) {
			tag.fontData.writeBytes(fontData);
		}
		return tag;
	}

	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"FontName: " + fontName + ", " +
			"HasFontData: " + hasFontData + ", " +
			"Italic: " + italic + ", " +
			"Bold: " + bold;
		return str;
	}
}