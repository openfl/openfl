package format.swf.tags;

import format.swf.SWFData;

class TagSetTabIndex implements ITag
{
	public static inline var TYPE:Int = 66;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var depth:Int;
	public var tabIndex:Int;
	
	public function new() {
		type = TYPE;
		name = "SetTabIndex";
		version = 7;
		level = 1;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		depth = data.readUI16();
		tabIndex = data.readUI16();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 4);
		data.writeUI16(depth);
		data.writeUI16(tabIndex);
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"Depth: " + depth + ", " +
			"TabIndex: " + tabIndex;
	}
}