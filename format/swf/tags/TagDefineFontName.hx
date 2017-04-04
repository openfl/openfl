package format.swf.tags;

import format.swf.SWFData;

class TagDefineFontName implements ITag
{
	public static inline var TYPE:Int = 88;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var fontId:Int;
	public var fontName:String;
	public var fontCopyright:String;
	
	public function new() {
		
		type = TYPE;
		name = "DefineFontName";
		version = 9;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		fontId = data.readUI16();
		fontName = data.readSTRING();
		fontCopyright = data.readSTRING();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(fontId);
		body.writeSTRING(fontName);
		body.writeSTRING(fontCopyright);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"FontID: " + fontId + ", " +
			"Name: " + fontName + ", " +
			"Copyright: " + fontCopyright;
	}
}