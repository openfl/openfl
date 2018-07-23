package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFColorTransform;

class TagDefineButtonCxform implements IDefinitionTag
{
	public static inline var TYPE:Int = 23;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var buttonColorTransform:SWFColorTransform;

	public var characterId:Int;

	public function new() {
		
		type = TYPE;
		name = "DefineButtonCxform";
		version = 2;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		buttonColorTransform = data.readCXFORM();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeCXFORM(buttonColorTransform);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineButtonCxform = new TagDefineButtonCxform();
		tag.characterId = characterId;
		tag.buttonColorTransform = buttonColorTransform.clone();
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"ColorTransform: " + buttonColorTransform;
		return str;
	}
}