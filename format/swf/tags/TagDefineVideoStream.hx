package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.VideoCodecID;
import format.swf.data.consts.VideoDeblockingType;

class TagDefineVideoStream implements IDefinitionTag
{
	public static inline var TYPE:Int = 60;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;

	public var numFrames:Int;
	public var width:Int;
	public var height:Int;
	public var deblocking:Int;
	public var smoothing:Bool;
	public var codecId:Int;
	
	public var characterId:Int;
	
	public function new() {
		
		type = TYPE;
		name = "DefineVideoStream";
		version = 6;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		numFrames = data.readUI16();
		width = data.readUI16();
		height = data.readUI16();
		data.readUB(4);
		deblocking = data.readUB(3);
		smoothing = (data.readUB(1) == 1);
		codecId = data.readUI8();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, 10);
		data.writeUI16(characterId);
		data.writeUI16(numFrames);
		data.writeUI16(width);
		data.writeUI16(height);
		data.writeUB(4, 0); // Reserved
		data.writeUB(3, deblocking);
		data.writeUB(1, smoothing ? 1 : 0);
		data.writeUI8(codecId);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineVideoStream = new TagDefineVideoStream();
		tag.characterId = characterId;
		tag.numFrames = numFrames;
		tag.width = width;
		tag.height = height;
		tag.deblocking = deblocking;
		tag.smoothing = smoothing;
		tag.codecId = codecId;
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"ID: " + characterId + ", " +
			"Frames: " + numFrames + ", " +
			"Width: " + width + ", " +
			"Height: " + height + ", " +
			"Deblocking: " + VideoDeblockingType.toString(deblocking) + ", " +
			"Smoothing: " + smoothing + ", " +
			"Codec: " + VideoCodecID.toString(codecId);
	}
}