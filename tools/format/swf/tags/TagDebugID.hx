package format.swf.tags;

import format.swf.SWFData;
import format.swf.utils.StringUtils;

import flash.utils.ByteArray;

class TagDebugID implements ITag
{
	public static inline var TYPE:Int = 63;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var uuid (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "DebugID";
		version = 6;
		level = 1;
		uuid = new ByteArray();
		uuid.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		if(length > 0) {
			data.readBytes(uuid, 0, length);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, uuid.length);
		if(uuid.length > 0) {
			data.writeBytes(uuid);
		}
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) + "UUID: ";
		if (uuid.length == 16) {
			str += StringUtils.printf("%02x%02x%02x%02x-", [uuid[0], uuid[1], uuid[2], uuid[3]]);
			str += StringUtils.printf("%02x%02x-", [uuid[4], uuid[5]]);
			str += StringUtils.printf("%02x%02x-", [uuid[6], uuid[7]]);
			str += StringUtils.printf("%02x%02x-", [uuid[8], uuid[9]]);
			str += StringUtils.printf("%02x%02x%02x%02x%02x%02x", [uuid[10], uuid[11], uuid[12], uuid[13], uuid[14], uuid[15]]);
		} else {
			str += "(invalid length: " + uuid.length + ")";
		}
		return str;
	}
}