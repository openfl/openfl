package format.swf.timeline;

import flash.utils.ByteArray;

class SoundStream
{
	public var startFrame:Int;
	public var numFrames:Int;
	public var numSamples:Int;

	public var compression:Int;
	public var rate:Int;
	public var size:Int;
	public var type:Int;
	
	public var data (default, null):ByteArray;
	
	public function new()
	{
		data = new ByteArray();
		data.endian = BIG_ENDIAN;
	}
	
	public function toString():String {
		return "[SoundStream] " +
			"StartFrame: " + startFrame + ", " +
			"Frames: " + numFrames + ", " +
			"Samples: " + numSamples + ", " +
			"Bytes: " + data.length;
	}
}