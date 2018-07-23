package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.SWFSoundInfo;

class TagStartSound2 implements ITag
{
	public static inline var TYPE:Int = 89;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var soundClassName:String;
	public var soundInfo:SWFSoundInfo;
	
	public function new() {
		type = TYPE;
		name = "StartSound2";
		version = 9;
		level = 2;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		soundClassName = data.readSTRING();
		soundInfo = data.readSOUNDINFO();
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeSTRING(soundClassName);
		body.writeSOUNDINFO(soundInfo);
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"SoundClassName: " + soundClassName + ", " +
			"SoundInfo: " + soundInfo;
		return str;
	}
}