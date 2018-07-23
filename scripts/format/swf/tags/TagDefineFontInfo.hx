package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagDefineFontInfo implements ITag
{
	public static inline var TYPE:Int = 13;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var fontId:Int;
	public var fontName:String;
	public var smallText:Bool;
	public var shiftJIS:Bool;
	public var ansi:Bool;
	public var italic:Bool;
	public var bold:Bool;
	public var wideCodes:Bool;
	public var langCode:Int = 0;
	
	public var codeTable (default, null):Array<Int>;
	
	private var langCodeLength:Int = 0;
	
	public function new() {
		type = TYPE;
		name = "DefineFontInfo";
		version = 1;
		level = 1;
		codeTable = new Array<Int>();
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void
	{
		fontId = data.readUI16();

		var fontNameLen:Int = data.readUI8();
		var fontNameRaw:ByteArray = new ByteArray();
		fontNameRaw.endian = BIG_ENDIAN;
		data.readBytes(fontNameRaw, 0, fontNameLen);
		#if (cpp || neko || nodejs)
		fontName = fontNameRaw.readUTFBytes(fontNameLen - 1);
		#else
		fontName = fontNameRaw.readUTFBytes(fontNameLen);
		#end
		
		var flags:Int = data.readUI8();
		smallText = ((flags & 0x20) != 0);
		shiftJIS = ((flags & 0x10) != 0);
		ansi = ((flags & 0x08) != 0);
		italic = ((flags & 0x04) != 0);
		bold = ((flags & 0x02) != 0);
		wideCodes = ((flags & 0x01) != 0);
		
		parseLangCode(data);
		
		var numGlyphs:Int = length - fontNameLen - langCodeLength - 4;
		for (i in 0...numGlyphs) {
			codeTable.push(wideCodes ? data.readUI16() : data.readUI8());
		}
	}
	
	public function publish(data:SWFData, version:Int):Void
	{
		var body:SWFData = new SWFData();
		body.writeUI16(fontId);
		
		var fontNameRaw:ByteArray = new ByteArray();
		fontNameRaw.endian = BIG_ENDIAN;
		fontNameRaw.writeUTFBytes(fontName);
		body.writeUI8(fontNameRaw.length);
		body.writeBytes(fontNameRaw);
		
		var flags:Int = 0;
		if(smallText) { flags |= 0x20; }
		if(shiftJIS) { flags |= 0x10; }
		if(ansi) { flags |= 0x08; }
		if(italic) { flags |= 0x04; }
		if(bold) { flags |= 0x02; }
		if(wideCodes) { flags |= 0x01; }
		body.writeUI8(flags);
		
		publishLangCode(body);

		var numGlyphs:Int = codeTable.length;
		for (i in 0...numGlyphs) {
			if(wideCodes) {
				body.writeUI16(codeTable[i]);
			} else {
				body.writeUI8(codeTable[i]);
			}
		}
		
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	private function parseLangCode(data:SWFData):Void {
		// Does nothing here.
		// Overridden in TagDefineFontInfo2, where it:
		// - reads langCode
		// - sets langCodeLength to 1
	}
	
	private function publishLangCode(data:SWFData):Void {
		// Does nothing here.
		// Overridden in TagDefineFontInfo2
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"FontID: " + fontId + ", " +
			"FontName: " + fontName + ", " +
			"Italic: " + italic + ", " +
			"Bold: " + bold + ", " +
			"Codes: " + codeTable.length;
	}
}