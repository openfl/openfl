package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagDoABCDeprecated implements ITag
{
	public static inline var TYPE:Int = 72;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var bytes (default, null):ByteArray;

	public function new() {
		type = TYPE;
		name = "DoABCDeprecated";
		version = 9;
		level = 1;
		bytes = new ByteArray();
		bytes.endian = BIG_ENDIAN;
		
		//trace("Hello " + name);
	}

	public static function create(abcData:ByteArray = null):TagDoABCDeprecated {
		var doABC:TagDoABCDeprecated = new TagDoABCDeprecated();
		if (abcData != null && abcData.length > 0) {
			doABC.bytes.writeBytes(abcData);
		}
		return doABC;
	}

	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var pos:Int = data.position;
		data.readBytes(bytes, 0, length - (data.position - pos));
	}

	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		if (bytes.length > 0) {
			body.writeBytes(bytes);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"Length: " + bytes.length;
	}
}