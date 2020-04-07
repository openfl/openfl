import MovieClip from "../display/MovieClip";

/**
	The FrameScript object contains properties that specify a frame number and
	the corresponding script. The Timeline class includes a `scripts`
	property, which is an array of FrameScript objects for the timeline.
**/
export default class FrameScript
{
	/**
		The frame number containing the label.
	**/
	public readonly frame: number;

	/**
		The script to be executed, taking a MovieClip object as the scope of the method.
	**/
	public readonly script: (scope: MovieClip) => void;

	public constructor(script: (scope: MovieClip) => void, frame: number)
	{
		this.script = script;
		this.frame = frame;
	}
}
