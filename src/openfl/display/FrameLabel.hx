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
	public var frame(default, null):Int;

	/**
		The name of the label.
	**/
	public var name(default, null):String;

	public function new(name:String, frame:Int)
	{
		super();

		this.name = name;
		this.frame = frame;
	}
}
#else
typedef FrameLabel = flash.display.FrameLabel;
#end
