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
	@:native('video_init') private static function __videoInit():Bool;	
	@:native('video_software_load') private static function __videoSoftwareLoad(path:String, buffer:Pointer<UInt8>, length:Int):Bool;	
	@:native('video_gl_load') private static function __videoGLLoad(path:String):Bool;	
	@:native('video_gl_update_frame') private static function __videoGLUpdateFrame():Bool;	
	@:native('video_software_update_frame') private static function __videoSoftwareUpdateFrame():Bool;	
	@:native('video_get_frame_pixels') private static function __videoGetFramePixels(width:Pointer<Int>, height:Pointer<Int>):RawPointer<UInt8>;	
	@:native('video_shutdown') private static function __videoShutdown():Void;
	@:native('video_gl_get_texture_id_y') private static function __getTextureIDY():Int;
	@:native('video_gl_get_texture_id_uv') private static function __getTextureIDUV():Int;
	@:native('video_get_width') private static function __videoGetWidth(path:String):Int;
	@:native('video_get_height') private static function __videoGetHeight(path:String):Int;
	@:native('video_get_frame_rate') private static function __videoGetFrameRate():Float;
	@:native('video_get_audio_channel_count') private static function __videoGetAudioChannelCount():Int;
	@:native('video_get_audio_samples') private static function __videoGetAudioSamples(buffer:Pointer<UInt8>, length:Int):Int;
	@:native('video_get_audio_sample_rate') private static function __videoGetAudioSampleRate():Int;
	@:native('video_get_audio_bits_per_sample') private static function __videoGetAudioBitsPerSample():Int;
	@:native('video_get_duration') private static function __videoGetDuration():Int;	
	@:native('video_get_audio_position') private static function __videoGetAudioPosition():Int;
	@:native('video_get_video_position') private static function __videoGetVideoPosition():Int;
	@:native('video_frames_seek_to') private static function __videoFramesSeekTo(time:Int):Void;
}