package openfl.display;

#if (display || !flash)
import openfl.events.EventDispatcher;

@:jsRequire("openfl/display/FrameLabel", "default")
@:final extern class FrameLabel extends EventDispatcher
{
	public var frame(get, never):Int;
	@:noCompletion private function get_frame():Int;
	public var name(get, never):String;
	@:noCompletion private function get_name():String;
	public function new(name:String, frame:Int):Void;
}
#else
typedef FrameLabel = flash.display.FrameLabel;
#end
