package openfl.media._internal;

import cpp.Int16;
import cpp.Pointer;
import cpp.RawPointer;
import cpp.UInt16;
import cpp.UInt8;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.UInt16Array;
import haxe.io.UInt16Array.UInt16ArrayData;
import lime.utils.Int16Array;

/**
 * ...
 * @author Christopher Speciale
 */
@:include('./NativeVideoBackend.cpp')
extern class NativeVideoBackend
{
	@:native('video_create') private static function __videoCreate():Int;
	@:native('video_software_load') private static function __videoSoftwareLoad(handle:Int, path:String, buffer:Pointer<UInt8>, length:Int):Bool;
	@:native('video_gl_load') private static function __videoGLLoad(handle:Int, path:String):Bool;
	@:native('video_gl_update_frame') private static function __videoGLUpdateFrame(handle:Int):Bool;
	@:native('video_software_update_frame') private static function __videoSoftwareUpdateFrame(handle:Int):Bool;
	@:native('video_get_frame_pixels') private static function __videoGetFramePixels(handle:Int, width:Pointer<Int>, height:Pointer<Int>):RawPointer<UInt8>;
	@:native('video_shutdown') private static function __videoShutdown(handle:Int):Void;
	@:native('video_gl_get_texture_id_y') private static function __getTextureIDY(handle:Int):Int;
	@:native('video_gl_get_texture_id_uv') private static function __getTextureIDUV(handle:Int):Int;
	@:native('video_get_width') private static function __videoGetWidth(handle:Int, path:String):Int;
	@:native('video_get_height') private static function __videoGetHeight(handle:Int, path:String):Int;
	@:native('video_get_frame_width') private static function __videoGetFrameWidth(handle:Int):Int;
	@:native('video_get_frame_height') private static function __videoGetFrameHeight(handle:Int):Int;
	@:native('video_get_frame_rate') private static function __videoGetFrameRate(handle:Int):Float;
	@:native('video_get_audio_channel_count') private static function __videoGetAudioChannelCount(handle:Int):Int;
	@:native('video_get_audio_samples') private static function __videoGetAudioSamples(handle:Int, buffer:Pointer<UInt8>, length:Int):Int;
	@:native('video_get_audio_sample_rate') private static function __videoGetAudioSampleRate(handle:Int):Int;
	@:native('video_get_audio_bits_per_sample') private static function __videoGetAudioBitsPerSample(handle:Int):Int;
	@:native('video_get_duration') private static function __videoGetDuration(handle:Int):Int;
	@:native('video_get_audio_position') private static function __videoGetAudioPosition(handle:Int):Int;
	@:native('video_get_video_position') private static function __videoGetVideoPosition(handle:Int):Int;
	@:native('video_frames_seek_to') private static function __videoFramesSeekTo(handle:Int, time:Int):Void;
}
