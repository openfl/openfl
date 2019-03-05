package flash.display;

#if flash
import openfl.events.EventDispatcher;

@:final extern class FrameLabel extends EventDispatcher
{
	public var frame(default, never):Int;
	public var name(default, never):String;
	public function new(name:String, frame:Int):Void;
}
#else
typedef FrameLabel = openfl.display.FrameLabel;
#end
