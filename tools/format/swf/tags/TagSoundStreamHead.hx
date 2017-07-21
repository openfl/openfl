package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.SoundCompression;
import format.swf.data.consts.SoundRate;
import format.swf.data.consts.SoundSize;
import format.swf.data.consts.SoundType;

class TagSoundStreamHead implements ITag
{
	public static inline var TYPE:Int = 18;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var playbackSoundRate:Int;
	public var playbackSoundSize:Int;
	public var playbackSoundType:Int;
	public var streamSoundCompression:Int;
	public var streamSoundRate:Int;
	public var streamSoundSize:Int;
	public var streamSoundType:Int;
	public var streamSoundSampleCount:Int;
	public var latencySeek:Int;
	
	public function new() {
		
		type = TYPE;
		name = "SoundStreamHead";
		version = 1;
		level = 1;
		
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		data.readUB(4);
		playbackSoundRate = data.readUB(2);
		playbackSoundSize = data.readUB(1);
		playbackSoundType = data.readUB(1);
		streamSoundCompression = data.readUB(4);
		streamSoundRate = data.readUB(2);
		streamSoundSize = data.readUB(1);
		streamSoundType = data.readUB(1);
		streamSoundSampleCount = data.readUI16();
		if (streamSoundCompression == SoundCompression.MP3) {
			latencySeek = data.readSI16();
		}
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUB(4, 0);
		body.writeUB(2, playbackSoundRate);
		body.writeUB(1, playbackSoundSize);
		body.writeUB(1, playbackSoundType);
		body.writeUB(4, streamSoundCompression);
		body.writeUB(2, streamSoundRate);
		body.writeUB(1, streamSoundSize);
		body.writeUB(1, streamSoundType);
		body.writeUI16(streamSoundSampleCount);
		if (streamSoundCompression == SoundCompression.MP3) {
			body.writeSI16(latencySeek);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}

	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent);
		if(streamSoundSampleCount > 0) {
			str += "Format: " + SoundCompression.toString(streamSoundCompression) + ", " +
				"Rate: " + SoundRate.toString(streamSoundRate) + ", " +
				"Size: " + SoundSize.toString(streamSoundSize) + ", " +
				"Type: " + SoundType.toString(streamSoundType) + ", ";
		}
		str += "Samples: " + streamSoundSampleCount + ", ";
		str += "LatencySeek: " + latencySeek;
		return str;
	}
}