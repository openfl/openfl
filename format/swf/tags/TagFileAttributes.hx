package format.swf.tags;

import format.swf.SWFData;

class TagFileAttributes implements ITag
{
	public static inline var TYPE:Int = 69;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var useDirectBlit:Bool = false;
	public var useGPU:Bool = false;
	public var hasMetadata:Bool = false;
	public var actionscript3:Bool = true;
	public var useNetwork:Bool = false;

	public function  new() {
		type = TYPE;
		name = "FileAttributes";
		version = 8;
		level = 1;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		var flags:Int = data.readUI8();
		useDirectBlit = ((flags & 0x40) != 0);
		useGPU = ((flags & 0x20) != 0);
		hasMetadata = ((flags & 0x10) != 0);
		actionscript3 = ((flags & 0x08) != 0);
		useNetwork = ((flags & 0x01) != 0);
		data.skipBytes(3);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 4);
		var flags:Int = 0;
		if (useNetwork) { flags |= 0x01; }
		if (actionscript3) { flags |= 0x08; }
		if (hasMetadata) { flags |= 0x10; }
		if (useGPU) { flags |= 0x20; }
		if (useDirectBlit) { flags |= 0x40; }
		data.writeUI8(flags);
		data.writeUI8(0);
		data.writeUI8(0);
		data.writeUI8(0);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"AS3: " + actionscript3 + ", " +
			"HasMetadata: " + hasMetadata + ", " +
			"UseDirectBlit: " + useDirectBlit + ", " +
			"UseGPU: " + useGPU + ", " +
			"UseNetwork: " + useNetwork;
	}
}