package openfl.display;

/**
	The FrameScript object contains properties that specify a frame number and
	the corresponding script. The Timeline class includes a `scripts`
	property, which is an array of FrameScript objects for the timeline.
**/
@:jsRequire("openfl/display/FrameScript", "default")
@:final extern class FrameScript
{
	/**
		The frame number containing the label.
	**/
	public var frame(default, null):Int;

	/**
		The script to be executed, taking a MovieClip object as the scope of the method.
	**/
	public var script(default, null):MovieClip->Void;

	public function new(script:MovieClip->Void, frame:Int);
}
