package openfl.display;

#if (display || !flash)
import openfl.events.EventDispatcher;

/**
	The FrameLabel object contains properties that specify a frame number and
	the corresponding label name. The Scene class includes a `labels`
	property, which is an array of FrameLabel objects for the scene.
**/
@:jsRequire("openfl/display/FrameLabel", "default")
@:final extern class FrameLabel extends EventDispatcher
{
	/**
		The frame number containing the label.
	**/
	public var frame(default, never):Int;

	/**
		The name of the label.
	**/
	public var name(default, never):String;

	public function new(name:String, frame:Int):Void;
}
#else
typedef FrameLabel = flash.display.FrameLabel;
#end
