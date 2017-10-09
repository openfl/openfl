package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagSoundStreamBlock implements ITag
{
	public static inline var TYPE:Int = 19;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var soundData (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "SoundStreamBlock";
		version = 1;
		level = 1;
		soundData = new ByteArray();
		soundData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		data.readBytes(soundData, 0, length);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, soundData.length, true);
		if (soundData.length > 0) {
			data.writeBytes(soundData);
		}
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) + "Length: " + soundData.length;
	}
}