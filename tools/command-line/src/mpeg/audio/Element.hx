package mpeg.audio;

import haxe.io.Bytes;

enum Element {
    Frame(frame:Frame);
    Info(info:Info);
    GaplessInfo(encoderDelay:Int, endPadding:Int);
    Unknown(bytes:Bytes);
    End;
}