package format.swf.tags;

import format.swf.SWFData;
import format.swf.data.consts.SoundCompression;
import format.swf.data.consts.SoundRate;
import format.swf.data.consts.SoundSize;
import format.swf.data.consts.SoundType;
import format.swf.data.etc.MPEGFrame;

import flash.utils.ByteArray;
import flash.errors.Error;

class TagDefineSound implements IDefinitionTag
{
	public static inline var TYPE:Int = 14;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;
	
	public var soundFormat:Int;
	public var soundRate:Int;
	public var soundSize:Int;
	public var soundType:Int;
	public var soundSampleCount:Int;

	public var characterId:Int;
	
	public var soundData (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "DefineSound";
		version = 1;
		level = 1;
		soundData = new ByteArray();
		soundData.endian = BIG_ENDIAN;
	}
	
	public static function create(id:Int, soundFormat:Int = SoundCompression.MP3, rate:Int = SoundRate.KHZ_44, size:Int = SoundSize.BIT_16, type:Int = SoundType.STEREO, sampleCount:Int = 0, aSoundData:ByteArray = null):TagDefineSound {
		var defineSound:TagDefineSound = new TagDefineSound();
		defineSound.characterId = id;
		defineSound.soundFormat = soundFormat;
		defineSound.soundRate = rate;
		defineSound.soundSize = size;
		defineSound.soundType = type;
		defineSound.soundSampleCount = sampleCount;
		if (aSoundData != null && aSoundData.length > 0) {
			defineSound.soundData.writeBytes(aSoundData);
		}
		return defineSound;
	}
	
	public static function createWithMP3(id:Int, mp3:ByteArray):TagDefineSound {
		if (mp3 != null && mp3.length > 0) {
			var defineSound:TagDefineSound = new TagDefineSound();
			defineSound.characterId = id;
			defineSound.processMP3(mp3);
			return defineSound;
		} else {
			throw(new Error("No MP3 data."));
		}
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		characterId = data.readUI16();
		soundFormat = data.readUB(4);
		soundRate = data.readUB(2);
		soundSize = data.readUB(1);
		soundType = data.readUB(1);
		soundSampleCount = data.readUI32();
		data.readBytes(soundData, 0, length - 7);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		var body:SWFData = new SWFData();
		body.writeUI16(characterId);
		body.writeUB(4, soundFormat);
		body.writeUB(2, soundRate);
		body.writeUB(1, soundSize);
		body.writeUB(1, soundType);
		body.writeUI32(soundSampleCount);
		if (soundData.length > 0) {
			body.writeBytes(soundData);
		}
		data.writeTagHeader(type, body.length);
		data.writeBytes(body);
	}
	
	public function clone():IDefinitionTag {
		var tag:TagDefineSound = new TagDefineSound();
		tag.characterId = characterId;
		tag.soundFormat = soundFormat;
		tag.soundRate = soundRate;
		tag.soundSize = soundSize;
		tag.soundType = soundType;
		tag.soundSampleCount = soundSampleCount;
		if (soundData.length > 0) {
			tag.soundData.writeBytes(soundData);
		}
		return tag;
	}
	
	public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent) +
			"SoundID: " + characterId + ", " +
			"Format: " + SoundCompression.toString(soundFormat) + ", " +
			"Rate: " + SoundRate.toString(soundRate) + ", " +
			"Size: " + SoundSize.toString(soundSize) + ", " +
			"Type: " + SoundType.toString(soundType) + ", " +
			"Samples: " + soundSampleCount;
		return str;
	}
	
	private function processMP3(mp3:ByteArray):Void {
		var i:Int = 0;
		var beginIdx:Int = 0;
		var endIdx:Int = mp3.length;
		var samples:Int = 0;
		var firstFrame:Bool = true;
		var samplingrate:Int = 0;
		var channelmode:Int = 0;
		var frame:MPEGFrame = new MPEGFrame();
		var state:String = "id3v2";
		while (i < Std.int (mp3.length)) {
			switch(state) {
				case "id3v2":
					if (mp3[i] == 0x49 && mp3[i + 1] == 0x44 && mp3[i + 2] == 0x33) {
						i += 10 + ((mp3[i + 6] << 21)
							| (mp3[i + 7] << 14)
							| (mp3[i + 8] << 7)
							| mp3[i + 9]);
					}
					beginIdx = i;
					state = "sync";
				case "sync":
					if (mp3[i] == 0xff && (mp3[i + 1] & 0xe0) == 0xe0) {
						state = "frame";
					} else if (mp3[i] == 0x54 && mp3[i + 1] == 0x41 && mp3[i + 2] == 0x47) {
						endIdx = i;
						i = mp3.length;
					} else {
						i++;
					}
				case "frame":
					frame.setHeaderByteAt(0, mp3[i++]);
					frame.setHeaderByteAt(1, mp3[i++]);
					frame.setHeaderByteAt(2, mp3[i++]);
					frame.setHeaderByteAt(3, mp3[i++]);
					if (frame.hasCRC) {
						frame.setCRCByteAt(0, mp3[i++]);
						frame.setCRCByteAt(1, mp3[i++]);
					}
					if (firstFrame) {
						firstFrame = false;
						samplingrate = frame.samplingrate;
						channelmode = frame.channelMode;
					}
					samples += frame.samples;
					i += frame.size;
					state = "sync";
			}
		}
		soundSampleCount = samples;
		soundFormat = SoundCompression.MP3;
		soundSize = SoundSize.BIT_16;
		soundType = (channelmode == MPEGFrame.CHANNEL_MODE_MONO) ? SoundType.MONO : SoundType.STEREO;
		switch(samplingrate) {
			case 44100: soundRate = SoundRate.KHZ_44;
			case 22050: soundRate = SoundRate.KHZ_22;
			case 11025: soundRate = SoundRate.KHZ_11;
			default: throw(new Error("Unsupported sampling rate: " + samplingrate + " Hz"));
		}
		// Clear ByteArray
		//soundData.length = 0;
		soundData = new ByteArray ();
		soundData.endian = BIG_ENDIAN;
		// Write SeekSamples (here always 0)
		soundData.writeShort(0);
		// Write raw MP3 (without ID3 metadata)
		soundData.writeBytes(mp3, beginIdx, endIdx - beginIdx);
	}
}