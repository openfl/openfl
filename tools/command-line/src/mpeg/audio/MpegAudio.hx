package mpeg.audio;

class MpegAudio {
    public var frames(default, null):Iterable<Frame>;
    public var encoderDelay:Int;
    public var endPadding:Int;

    public function new(frames:Array<Frame>, encoderDelay:Int, endPadding:Int) {
        this.frames = frames;
        this.encoderDelay = encoderDelay;
        this.endPadding = endPadding;
    }
}
