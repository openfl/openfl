package format.swf.tags;

import format.swf.SWFData;

class TagCSMTextSettings implements ITag
{
	public static inline var TYPE:Int = 74;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var textId:Int;
	public var useFlashType:Int;
	public var gridFit:Int;
	public var thickness:Float;
	public var sharpness:Float;
	
	public function new() {
		
		type = TYPE;
		name = "CSMTextSettings";
		version = 8;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		textId = data.readUI16();
		useFlashType = data.readUB(2);
		gridFit = data.readUB(3);
		data.readUB(3); // reserved, always 0
		thickness = data.readFIXED();
		sharpness = data.readFIXED();
		data.readUI8(); // reserved, always 0
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 12);
		data.writeUI16(textId);
		data.writeUB(2, useFlashType);
		data.writeUB(3, gridFit);
		data.writeUB(3, 0); // reserved, always 0
		data.writeFIXED(thickness);
		data.writeFIXED(sharpness);
		data.writeUI8(0); // reserved, always 0
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"TextID: " + textId + ", " +
			"UseFlashType: " + useFlashType + ", " +
			"GridFit: " + gridFit + ", " +
			"Thickness: " + thickness + ", " +
			"Sharpness: " + sharpness;
	}
}