package format.swf.tags;

import format.swf.SWFData;

class TagRemoveObject2 extends TagRemoveObject implements IDisplayListTag
{
	public static inline var TYPE:Int = 28;
	
	public function new() {
		super();
		
		type = TYPE;
		name = "RemoveObject2";
		version = 3;
		level = 2;
		
	}
	
	override public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		depth = data.readUI16();
	}
	
	override public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 2);
		data.writeUI16(depth);
	}
	
	override public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"Depth: " + depth;
	}
}