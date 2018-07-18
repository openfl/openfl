package format.swf.tags;

import format.swf.SWFData;
import format.swf.utils.StringUtils;

import flash.utils.ByteArray;

class TagNameCharacter implements ITag
{
	public static inline var TYPE:Int = 40;
	
	public var type(default, null):Int = TYPE;
	public var name(default, null):String = "NameCharacter";
	public var version(default, null):Int = 3;
	public var level(default, null):Int = 1;
	
	public var binaryData(default, null):ByteArray;
	public var characterId:Int;
	
	public function new() {
		binaryData = new ByteArray();
		binaryData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		if (length > 2) {
			data.readBytes(binaryData, 0, length - 2);
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		if (binaryData.length > 0) {
			body.writeBytes(binaryData);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():ITag {
		var tag:TagNameCharacter = new TagNameCharacter();
		tag.characterId = characterId;
		if (binaryData.length > 0) {
			tag.binaryData.writeBytes(binaryData);
		}
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId;
		if (binaryData.length > 0) {
			binaryData.position = 0;
			str += ", Name: " + binaryData.readUTFBytes(binaryData.length - 1);
			binaryData.position = 0;
		}
		return str;
	}
}
