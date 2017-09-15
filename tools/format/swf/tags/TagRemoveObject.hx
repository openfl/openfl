package format.swf.tags;

import format.swf.SWFData;

class TagRemoveObject implements IDisplayListTag
{
	public static inline var TYPE:Int = 5;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var characterId:Int = 0;
	public var depth:Int;
	
	public function new() {
		
		type = TYPE;
		name = "RemoveObject";
		version = 1;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		depth = data.readUI16();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 4);
		data.writeUI16(characterId);
		data.writeUI16(depth);
	}

	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"CharacterID: " + characterId + ", " +
			"Depth: " + depth;
	}
}