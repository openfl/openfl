package format.swf.tags;

import format.swf.SWFData;

class TagProductInfo implements ITag
{
	public static inline var TYPE:Int = 41;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	//private static inline var UINT_MAX_CARRY:Float = uint.MAX_VALUE + 1;
	private static inline function UINT_MAX_CARRY () { return SWFData.MAX_FLOAT_VALUE + 1; };

	public var productId:Int;
	public var edition:Int;
	public var majorVersion:Int;
	public var minorVersion:Int;
	public var build:Float;
	public var compileDate:Date;
	
	public function new() {
		
		type = TYPE;
		name = "ProductInfo";
		version = 3;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		productId = data.readUI32();
		edition = data.readUI32();
		majorVersion = data.readUI8();
		minorVersion = data.readUI8();

		build = data.readUI32()
				+ data.readUI32() * UINT_MAX_CARRY();

		var sec:Float = data.readUI32()
				+ data.readUI32() * UINT_MAX_CARRY();

		compileDate = Date.fromTime(sec);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI32(productId);
		body.writeUI32(edition);
		body.writeUI8(majorVersion);
		body.writeUI8(minorVersion);
		body.writeUI32(Std.int (build));
		body.writeUI32(Std.int (build / UINT_MAX_CARRY()));
		body.writeUI32(Std.int (compileDate.getTime ()));
		body.writeUI32(Std.int (compileDate.getTime () / UINT_MAX_CARRY()));
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"ProductID: " + productId + ", " +
			"Edition: " + edition + ", " +
			"Version: " + majorVersion + "." + minorVersion + " r" + build + ", " +
			"CompileDate: " + compileDate.toString();
	}
}