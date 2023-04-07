package flash.events;

#if flash
import openfl.events.EventType;

extern class VideoTextureEvent extends Event
{
	public static var RENDER_STATE(default, never):EventType<VideoTextureEvent>;

	#if (haxe_ver < 4.3)
	public var codecInfo(default, never):String;
	public var colorSpace(default, null):String;
	public var status(default, null):String;
	#else
	final codecInfo:String;
	@:flash.property var colorSpace(get, never):String;
	@:flash.property var status(get, never):String;
	#end

	public function new(type:String, bubbles:Bool = true, cancelable:Bool = true, status:String = null, colorSpace:String = null);
	public override function clone():VideoTextureEvent;

	#if (haxe_ver >= 4.3)
	private function get_colorSpace():String;
	private function get_status():String;
	#end
}
#else
typedef VideoTextureEvent = openfl.events.VideoTextureEvent;
#end
