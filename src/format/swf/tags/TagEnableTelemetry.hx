package format.swf.tags;

import format.swf.SWFData;
import flash.utils.ByteArray;

class TagEnableTelemetry implements ITag
{
	public static inline var TYPE:Int = 93;
	
	public var password(default, null):ByteArray;
	public var type(default, null):Int = TYPE;
	public var name(default, null):String = "EnableTelemetry";
	public var version(default, null):Int = 19;
	public var level(default, null):Int = 1;
	
	public function new() {
		password = new ByteArray();
		password.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		if (length > 2) {
			data.readByte();
			data.readByte();
			data.readBytes(password, 0, length - 2);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, password.length + 2);
		data.writeByte(0);
		data.writeByte(0);
		if (password.length > 0) {
			data.writeBytes(password);
		}
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent);
	}
	
}