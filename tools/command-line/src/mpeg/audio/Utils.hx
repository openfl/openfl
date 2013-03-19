package mpeg.audio;

using Lambda;

class Utils {
    public static function calculateAudioLengthSamples(mpegAudio:MpegAudio) {
        return mpegAudio.frames
                .map(function(frame) { return lookupSamplesPerFrame(frame.header.version, frame.header.layer); })
                .fold(function(frameSampleCount, totalSampleCount) { return frameSampleCount + totalSampleCount; },
                        -mpegAudio.encoderDelay - mpegAudio.endPadding);
    }

    public static function lookupSamplesPerFrame(mpegVersion:MpegVersion, layer:Layer) {
        return switch (layer) {
            case Layer1: 384;
            case Layer2: 1152;
            case Layer3: switch (mpegVersion) {
                case Version1: 1152;
                case Version2, Version25: 576;
            };
        };
    }
}
