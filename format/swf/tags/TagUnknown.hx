package format.swf.tags;

import format.swf.SWFData;
import flash.errors.Error;

class TagUnknown implements ITag
{
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public function new(type:Int = 0) {
		this.type = type;
		name = "????";
		version = 0;
		level = 1;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		data.skipBytes(length);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		throw(new Error("No raw tag data available."));
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent);
	}
}