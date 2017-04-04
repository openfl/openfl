package format.swf.tags;

import format.swf.SWFData;

class TagEnd implements ITag
{
	public static inline var TYPE:Int = 0;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public function new() {
		type = TYPE;
		name = "End";
		version = 1;
		level = 1;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		// Do nothing. The End tag has no body.
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 0);
	}

	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent);
	}
}