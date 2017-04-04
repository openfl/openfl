package format.swf.tags;

import format.swf.SWFData;

class TagFrameLabel implements ITag
{
	public static inline var TYPE:Int = 43;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var frameName:String;
	public var namedAnchorFlag:Bool;
	
	public function new() {
		
		type = TYPE;
		name = "FrameLabel";
		version = 3;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var start:Int = data.position;
		frameName = data.readSTRING();
		if ((Std.int (data.position) - start) < length) {
			data.readUI8();	// Named anchor flag, always 1
			namedAnchorFlag = true;
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeSTRING(frameName);
		
		if (namedAnchorFlag) {
			data.writeUI8(1);
		}
		
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	public function toString(indent:Int = 0):String {
		var str:String = "Name: " + frameName;
		if (namedAnchorFlag) {
			str += ", NamedAnchor = true";
		}
		return Tag.toStringCommon(type, name, indent) + str;
	}
}