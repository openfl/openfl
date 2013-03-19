package mpeg.audio;

import haxe.io.Bytes;

class Info {
    public var header(default, null):FrameHeader;
    public var infoStartIndex(default, null):Int;
    public var frameData(default, null):Bytes;

    public function new(header:FrameHeader, startIndex:Int, frameData:Bytes) {
        this.header = header;
        this.infoStartIndex = startIndex;
        this.frameData = frameData;
    }
}
