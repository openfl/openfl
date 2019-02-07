package flash.media;

#if flash
import openfl.display.DisplayObject;
import openfl.net.NetStream;

extern class Video extends DisplayObject
{
	public var deblocking:Int;
	public var smoothing:Bool;
	public var videoHeight(default, never):Int;
	public var videoWidth(default, never):Int;
	public function new(width:Int = 320, height:Int = 240):Void;
	#if flash
	public function attachCamera(camera:flash.media.Camera):Void;
	#end
	public function attachNetStream(netStream:NetStream):Void;
	public function clear():Void;
}
#else
typedef Video = openfl.media.Video;
#end
