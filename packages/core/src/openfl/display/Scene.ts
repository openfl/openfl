import FrameLabel from "../display/FrameLabel";

/**
	The Scene class includes properties for identifying the name, labels, and number
	of frames in a scene. A Scene object instance is created in Flash Professional,
	not by writing ActionScript code. The MovieClip class includes a `currentScene`
	property, which is a Scene object that identifies the scene in which the playhead
	is located in the timeline of the MovieClip instance. The `scenes` property of
	the MovieClip class is an array of Scene objects. Also, the `gotoAndPlay()` and
	`gotoAndStop()` methods of the MovieClip class use Scene objects as parameters.
**/
export default class Scene
{
	/**
		An array of FrameLabel objects for the scene. Each FrameLabel object contains
		a `frame` property, which specifies the frame number corresponding to the label,
		and a `name` property.
	**/
	public readonly labels: Array<FrameLabel>;

	/**
		The name of the scene.
	**/
	public readonly name: string;

	/**
		The number of frames in the scene.
	**/
	public readonly numFrames: number;

	public constructor(name: string, labels: Array<FrameLabel>, numFrames: number)
	{
		this.name = name;
		this.labels = labels;
		this.numFrames = numFrames;
	}
}
