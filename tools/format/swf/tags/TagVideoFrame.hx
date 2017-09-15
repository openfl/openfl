package format.swf.tags;

import format.swf.SWFData;

import flash.utils.ByteArray;

class TagVideoFrame implements ITag
{
	public static inline var TYPE:Int = 61;
	
	public var type(default, null):Int;
	public var name(default, null):String;
	public var version(default, null):Int;
	public var level(default, null):Int;

	public var streamId:Int;
	public var frameNum:Int;
	
	public var videoData (default, null):ByteArray;
	
	public function new() {
		type = TYPE;
		name = "VideoFrame";
		version = 6;
		level = 1;
		videoData = new ByteArray();
		videoData.endian = BIG_ENDIAN;
	}
	
	public function parse(data:SWFData, length:Int, version:Int, async:Bool = false):Void {
		streamId = data.readUI16();
		frameNum = data.readUI16();
		data.readBytes(videoData, 0, length - 4);
	}
	
	public function publish(data:SWFData, version:Int):Void {
		data.writeTagHeader(type, videoData.length + 4);
		data.writeUI16(streamId);
		data.writeUI16(frameNum);
		if (videoData.length > 0) {
			data.writeBytes(videoData);
		}
	}
	
	public function toString(indent:Int = 0):String {
		return Tag.toStringCommon(type, name, indent) +
			"StreamID: " + streamId + ", " +
			"Frame: " + frameNum;
	}
}