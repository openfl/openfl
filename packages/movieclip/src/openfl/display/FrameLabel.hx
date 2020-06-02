package openfl.display;

#if !flash
import openfl.events.EventDispatcher;

/**
	The FrameLabel object contains properties that specify a frame number and
	the corresponding label name. The Scene class includes a `labels`
	property, which is an array of FrameLabel objects for the scene.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class FrameLabel extends EventDispatcher
{
	/**
		The frame number containing the label.
	**/
	public var frame(get, never):Int;

	/**
		The name of the label.
	**/
	public var name(get, never):String;

	@:noCompletion private var __frame:Int;
	@:noCompletion private var __name:String;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(FrameLabel.prototype, "frame", {
			get: untyped __js__("function () { return this.get_frame (); }")
		});
		untyped Object.defineProperty(FrameLabel.prototype, "name", {
			get: untyped __js__("function () { return this.get_name (); }")
		});
	}
	#end

	public function new(name:String, frame:Int)
	{
		super();

		__name = name;
		__frame = frame;
	}

	// Getters & Setters
	@:noCompletion private function get_frame():Int
	{
		return __frame;
	}

	@:noCompletion private function get_name():String
	{
		return __name;
	}
}
#else
typedef FrameLabel = flash.display.FrameLabel;
#end
