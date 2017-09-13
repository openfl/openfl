package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagJPEGTables implements ITag
{
	public static inline var TYPE:Int = 8;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var jpegTables (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "JPEGTables";
		version = 1;
		level = 1;
		jpegTables = new ByteArray();
		jpegTables.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		if(length > 0) {
			data.readBytes(jpegTables, 0, length);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, jpegTables.length);
		if (jpegTables.length > 0) {
			data.writeBytes(jpegTables);
		}
	}

	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) + "Length: " + jpegTables.length;
	}
}