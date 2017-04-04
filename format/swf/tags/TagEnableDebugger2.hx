package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagEnableDebugger2 extends TagEnableDebugger implements ITag
{
	public static inline var TYPE:Int = 64;
	
	// Reserved, SWF File Format v10 says this is always zero.
	// Observed other values from generated SWFs, e.g. 0x1975.
	public var reserved (default, null):Int;
	
	public function new() {
		super();
		reserved = 0;
		
		type = TYPE;
		name = "EnableDebugger2";
		version = 6;
		level = 2;
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		reserved = data.readUI16(); 
		if (length > 2) {
			data.readBytes(password, 0, length - 2);
		}
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, password.length + 2);
		data.writeUI16(reserved);
		if (password.length > 0) {
			data.writeBytes(password);
		}
	}

	override public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"Password: " + (password.length > 0 ? 'null' : password.readUTF()) + ", " +
			"Reserved: 0x" + StringTools.hex (reserved);
	}
}