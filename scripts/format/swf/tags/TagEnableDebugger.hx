package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagEnableDebugger implements ITag
{
	public static inline var TYPE:Int = 58;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var password (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "EnableDebugger";
		version = 5;
		level = 1;
		password = new ByteArray();
		password.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		if (length > 0) {
			data.readBytes(password, 0, length);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, password.length);
		if (password.length > 0) {
			data.writeBytes(password);
		}
	}

	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent);
	}
}