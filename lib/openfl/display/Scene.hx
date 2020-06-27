package openfl.display;

#if (display || !flash)
/**
	The Scene class includes properties for identifying the name, labels, and number
	of frames in a scene. A Scene object instance is created in Flash Professional,
	not by writing ActionScript code. The MovieClip class includes a `currentScene`
	property, which is a Scene object that identifies the scene in which the playhead
	is located in the timeline of the MovieClip instance. The `scenes` property of
	the MovieClip class is an array of Scene objects. Also, the `gotoAndPlay()` and
	`gotoAndStop()` methods of the MovieClip class use Scene objects as parameters.
**/
@:jsRequire("openfl/display/Scene", "default")
@:final extern class Scene
{
	/**
		An array of FrameLabel objects for the scene. Each FrameLabel object contains
		a `frame` property, which specifies the frame number corresponding to the label,
		and a `name` property.
	**/
	public var labels(default, never):Array<FrameLabel>;

	/**
		The name of the scene.
	**/
	public var name(default, never):String;

	/**
		The number of frames in the scene.
	**/
	public var numFrames(default, never):Int;

	public function new(name:String, labels:Array<FrameLabel>, numFrames:Int);
}
#else
typedef Scene = flash.display.Scene;
#end
