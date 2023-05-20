package flash.media;

#if flash
import openfl.display.DisplayObject;
import openfl.net.NetStream;

extern class Video extends DisplayObject
{
	#if (haxe_ver < 4.3)
	public var deblocking:Int;
	public var smoothing:Bool;
	public var videoHeight(default, never):Int;
	public var videoWidth(default, never):Int;
	#else
	@:flash.property var deblocking(get, set):Int;
	@:flash.property var smoothing(get, set):Bool;
	@:flash.property var videoHeight(get, never):Int;
	@:flash.property var videoWidth(get, never):Int;
	#end

	public function new(width:Int = 320, height:Int = 240):Void;
	public function attachCamera(camera:flash.media.Camera):Void;
	public function attachNetStream(netStream:NetStream):Void;
	public function clear():Void;

	#if (haxe_ver >= 4.3)
	private function get_deblocking():Int;
	private function get_smoothing():Bool;
	private function get_videoHeight():Int;
	private function get_videoWidth():Int;
	private function set_deblocking(value:Int):Int;
	private function set_smoothing(value:Bool):Bool;
	#end
}
#else
typedef Video = openfl.media.Video;
#end
