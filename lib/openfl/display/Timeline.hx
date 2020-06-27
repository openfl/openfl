package openfl.display;

import openfl.errors.ArgumentError;

/**
	The Timeline class is the base class for frame-by-frame animation.

	Timeline is an abstract base class; therefore, you cannot call
	Timeline directly. Extend the Timeline class in order to provide animation
	compatible with the MovieClip class.

	It is possible to create a MovieClip with a Timeline using the
	`MovieClip.fromTimeline` static constructor.
**/
extern class Timeline
{
	/**
		The frame rate of the Timeline. The frame rate is defined as
		frames per second.

		The frame rate can be different than the Stage `frameRate` and will
		playback at an independent rate, or the frame rate value can be
		`null` to match the rate of Stage.
	**/
	public var frameRate:Null<Float>;

	/**
		An array of Scene objects, each listing the name, the number of frames,
		and the frame labels for a scene in the Timeline instance.
	**/
	public var scenes:Array<Scene>;

	/**
		An array of scripts to be run when the playhead enters each frame.
	**/
	public var scripts:Array<FrameScript>;

	/**
		Called internally when the Timeline object has a movie clip attached.

		This is an abstract method, so it should be overridden with an implementation
		in child classes.

		@param	movieClip	The parent MovieClip being attached to this Timeline
	**/
	@:noCompletion public function attachMovieClip(movieClip:MovieClip):Void;

	/**
		Called internally when the Timeline object enters a new frame.

		This is an abstract method, so it should be overridden with an implementation
		in child classes.

		Do not rely on this method being called for every sequential frame. Due to
		frame rate as well as default looping at the end of timelines, the `frame`
		value represents only the current frame required.

		@param	frame	The current frame
	**/
	@:noCompletion public function enterFrame(frame:Int):Void;
}
