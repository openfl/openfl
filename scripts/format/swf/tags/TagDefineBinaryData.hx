package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagDefineBinaryData implements IDefinitionTag
{
	public static inline var TYPE:Int = 87;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var characterId:Int;

	public var binaryData (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "DefineBinaryData";
		version = 9;
		level = 1;
		binaryData = new ByteArray();
		binaryData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		data.readUI32(); // reserved, always 0
		if (length > 6) {
			data.readBytes(binaryData, 0, length - 6);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeUI32(0); // reserved, always 0
		if (binaryData.length > 0) {
			body.writeBytes(binaryData);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineBinaryData = new TagDefineBinaryData();
		tag.characterId = characterId;
		if (binaryData.length > 0) {
			tag.binaryData.writeBytes(binaryData);
		}
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Length: " + binaryData.length;
	}
}