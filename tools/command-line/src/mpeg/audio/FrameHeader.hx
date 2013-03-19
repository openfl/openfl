package mpeg.audio;

import haxe.io.Bytes;

class FrameHeader {
    public var version(default, null):MpegVersion;
    public var layer(default, null):Layer;
    public var hasCrc(default, null):Bool;
    public var bitrate(default, null):Int;
    public var samplingFrequency(default, null):Int;
    public var hasPadding(default, null):Bool;
    public var privateBit(default, null):Bool;
    public var mode(default, null):Mode;
    public var modeExtension(default, null):Int;
    public var copyright(default, null):Bool;
    public var original(default, null):Bool;
    public var emphasis(default, null):Emphasis;

    public function new(version:MpegVersion, layer:Layer, hasCrc:Bool, bitrate:Int, samplingFrequency:Int,
                        hasPadding:Bool, privateBit:Bool, mode:Mode, modeExtension:Int, copyright:Bool, original:Bool,
                        emphasis:Emphasis) {
        this.version = version;
        this.layer = layer;
        this.hasCrc = hasCrc;
        this.bitrate = bitrate;
        this.samplingFrequency = samplingFrequency;
        this.hasPadding = hasPadding;
        this.privateBit = privateBit;
        this.mode = mode;
        this.modeExtension = modeExtension;
        this.copyright = copyright;
        this.original = original;
        this.emphasis = emphasis;
    }
}
