package openfl.display;

#if (display || !flash)
import openfl.events.EventDispatcher;

#if !openfl_global
@:jsRequire("openfl/display/FrameLabel", "default")
#end
@:final extern class FrameLabel extends EventDispatcher
{
	public var frame:Int;
	public var name:String;
	public function new(name:String, frame:Int):Void;
}
#else
typedef FrameLabel = flash.display.FrameLabel;
#end
