package format.swf.tags;

import format.swf.SWFData;

class TagDefineFontInfo2 extends TagDefineFontInfo implements ITag
{
	public static inline var TYPE:Int = 62;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "DefineFontInfo2";
		version = 6;
		level = 2;
		
	}
	
	override private function parseLangCode(data:SWFData):Void {
		langCode = data.readUI8();
		langCodeLength = 1;
	}
	
	override private function publishLangCode(data:SWFData):Void {
		data.writeUI8(langCode);
	}
	
	override public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"FontID: " + fontId + ", " +
			"FontName: " + fontName + ", " +
			"Italic: " + italic + ", " +
			"Bold: " + bold + ", " +
			"LanguageCode: " + langCode + ", " +
			"Codes: " + codeTable.length;
	}
}