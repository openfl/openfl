package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFRectangle;

class TagDefineScalingGrid implements ITag
{
	public static inline var TYPE:Int = 78;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var splitter:SWFRectangle;

	public var characterId:Int;
	
	public function new() {
		
		type = TYPE;
		name = "DefineScalingGrid";
		version = 8;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		splitter = data.readRECT();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeRECT(splitter);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():ITag {
		var tag:TagDefineScalingGrid = new TagDefineScalingGrid();
		tag.characterId = characterId;
		tag.splitter = splitter.clone();
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"CharacterID: " + characterId + ", " +
			"Splitter: " + splitter;
	}
}