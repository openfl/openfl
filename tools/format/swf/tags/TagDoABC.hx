package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagDoABC implements ITag
{
	public static inline var TYPE:Int = 82;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var lazyInitializeFlag:Bool;
	public var abcName:String = "";
	
	public var bytes (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "DoABC";
		version = 9;
		level = 1;
		bytes = new ByteArray();
		bytes.endian = BIG_ENDIAN;
	}
	
	public static function create(abcData:ByteArray = null, aName:String = "", aLazyInitializeFlag:Bool = true):TagDoABC {
		var doABC:TagDoABC = new TagDoABC();
		if (abcData != null && abcData.length > 0) {
			doABC.bytes.writeBytes(abcData);
		}
		doABC.abcName = aName;
		doABC.lazyInitializeFlag = aLazyInitializeFlag;
		return doABC;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var pos:Int = data.position;
		var flags:Int = data.readUI32();
		lazyInitializeFlag = ((flags & 0x01) != 0);
		abcName = data.readSTRING();
		data.readBytes(bytes, 0, length - (data.position - pos));
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI32(lazyInitializeFlag ? 1 : 0);
		body.writeSTRING(abcName);
		if (bytes.length > 0) {
			body.writeBytes(bytes);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"Lazy: " + lazyInitializeFlag + ", " +
			((abcName.length > 0) ? "Name: " + abcName + ", " : "") +
			"Length: " + bytes.length;
	}
}