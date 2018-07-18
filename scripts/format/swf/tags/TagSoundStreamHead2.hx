package format.swf.tags;

import format.swf.data.consts.SoundRate;
import format.swf.data.consts.SoundSize;
import format.swf.data.consts.SoundType;
import format.swf.data.consts.SoundCompression;

class TagSoundStreamHead2 extends TagSoundStreamHead implements ITag
{
	public static inline var TYPE:Int = 45;
	
	public function new() {
		
		super ();
		
		type = TYPE;
		name = "SoundStreamHead2";
		version = 3;
		level = 2;
		
	}

	override public function toString(indent:Int = 0):String {
		var str:String = Tag.toStringCommon(type, name, indent);
		if(streamSoundSampleCount > 0) {
			str += "Format: " + SoundCompression.toString(streamSoundCompression) + ", " +
				"Rate: " + SoundRate.toString(streamSoundRate) + ", " +
				"Size: " + SoundSize.toString(streamSoundSize) + ", " +
				"Type: " + SoundType.toString(streamSoundType) + ", ";
		}
		str += "Samples: " + streamSoundSampleCount;
		return str;
	}
}