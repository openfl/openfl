package mpeg.audio;

import haxe.io.Bytes;

class Frame {
    public var header(default, null):FrameHeader;
    public var frameData(default, null):Bytes;

    public function new(header:FrameHeader, frameData:Bytes) {
        this.header = header;
        this.frameData = frameData;
    }
}
