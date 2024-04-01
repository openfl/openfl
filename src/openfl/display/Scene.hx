package openfl.display;

#if !flash
/**
	The Scene class includes properties for identifying the name, labels, and
	number of frames in a scene. A Scene object instance is created in Adobe
	Animate (formerly Adobe Flash Professional), not by writing ActionScript
	code. The MovieClip class includes a `currentScene` property, which is a
	Scene object that identifies the scene in which the playhead is located in
	the timeline of the MovieClip instance. The `scenes` property of the
	MovieClip class is an array of Scene objects. Also, the `gotoAndPlay()` and
	`gotoAndStop()` methods of the MovieClip class use Scene objects as
	parameters.

	@see `openfl.display.MovieClip.currentScene`
	@see `openfl.display.MovieClip.scenes`
	@see `openfl.display.MovieClip.gotoAndPlay()`
	@see `openfl.display.MovieClip.gotoAndStop()`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Scene
{
	/**
		An array of FrameLabel objects for the scene. Each FrameLabel object
		contains a `frame` property, which specifies the frame number
		corresponding to the label, and a `name` property.

		@see openfl.display.FrameLabel
	**/
	public var labels(default, null):Array<FrameLabel>;

	/**
		The name of the scene.
	**/
	public var name(default, null):String;

	/**
		The number of frames in the scene.
	**/
	public var numFrames(default, null):Int;

	public function new(name:String, labels:Array<FrameLabel>, numFrames:Int)
	{
		this.name = name;
		this.labels = labels;
		this.numFrames = numFrames;
	}
}
#else
typedef Scene = flash.display.Scene;
#end
