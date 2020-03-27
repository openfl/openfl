import ArgumentError from "../errors/ArgumentError";

namespace openfl.display
{
	/**
		The Timeline class is the base class for frame-by-frame animation.

		Timeline is an abstract base class; therefore, you cannot call
		Timeline directly. Extend the Timeline class in order to provide animation
		compatible with the MovieClip class.

		It is possible to create a MovieClip with a Timeline using the
		`MovieClip.fromTimeline` static readonlyructor.
	**/
	export class Timeline
	{
		/**
			The frame rate of the Timeline. The frame rate is defined as
			frames per second.

			The frame rate can be different than the Stage `frameRate` and will
			playback at an independent rate, or the frame rate value can be
			`null` to match the rate of Stage.
		**/
		public frameRate: null | number;

		/**
			An array of Scene objects, each listing the name, the number of frames,
			and the frame labels for a scene in the Timeline instance.
		**/
		public scenes: Array<Scene>;

		/**
			An array of scripts to be run when the playhead enters each frame.
		**/
		public scripts: Array<FrameScript>;

		protected __currentFrame: number;
		protected __currentFrameLabel: string;
		protected __currentLabel: string;
		protected __currentLabels: Array<FrameLabel>;
		protected __currentScene: Scene;
		protected __frameScripts: Map<Int, MovieClip-> Void >;
		protected __framesLoaded: number;
		protected __frameTime: number;
		protected __isPlaying: boolean;
		protected __lastFrameScriptEval: number;
		protected __lastFrameUpdate: number;
		protected __scope: MovieClip;
		protected __timeElapsed: number;
		protected __totalFrames: number;

private constructor()
	{
		__framesLoaded = 1;
		__totalFrames = 1;
		__currentLabels = [];

		__currentFrame = 1;

		__lastFrameScriptEval = -1;
		__lastFrameUpdate = -1;
	}

	/**
		Called internally when the Timeline object has a movie clip attached.

		This is an abstract method, so it should be overridden with an implementation
		in child classes.

		@param	movieClip	The parent MovieClip being attached to this Timeline
	**/
	/** @hidden */ public attachMovieClip(movieClip: MovieClip): void {}

	/**
		Called internally when the Timeline object enters a new frame.

		This is an abstract method, so it should be overridden with an implementation
		in child classes.

		Do not rely on this method being called for every sequential frame. Due to
		frame rate as well as default looping at the end of timelines, the `frame`
		value represents only the current frame required.

		@param	frame	The current frame
	**/
	/** @hidden */ public enterFrame(frame : number): void {}

	protected __addFrameScript(index : number, method: void -> Void): void
		{
			if(index < 0) return;

			var frame = index + 1;

			if(method != null)
	{
		if (__frameScripts == null)
		{
			__frameScripts = new Map();
		}

		__frameScripts.set(frame, (scope)
		{
			method();
		});
	}
	else if (__frameScripts != null)
	{
		__frameScripts.remove(frame);
	}
}

	protected __attachMovieClip(movieClip: MovieClip): void
	{
		__scope = movieClip;

		__totalFrames = 0;
		__framesLoaded = 0;

		if(scenes != null && scenes.length > 0)
{
	for (scene in scenes)
	{
		__totalFrames += scene.numFrames;
		__framesLoaded += scene.numFrames;
		if (scene.labels != null)
		{
			// TODO: Handle currentLabels properly for multiple scenes
			__currentLabels = __currentLabels.concat(scene.labels);
		}
	}

	__currentScene = scenes[0];
}

if (scripts != null && scripts.length > 0)
{
	__frameScripts = new Map();
	for (script in scripts)
	{
		// TODO: Merge multiple scripts from the same frame together
		__frameScripts.set(script.frame, script.script);
	}
}

attachMovieClip(movieClip);
}

	protected __enterFrame(deltaTime : number): void
	{
		if(__isPlaying)
		{
			var nextFrame = __getNextFrame(deltaTime);

			if (__lastFrameScriptEval == nextFrame)
			{
				return;
			}

			if (__frameScripts != null)
			{
				if (nextFrame < __currentFrame)
				{
					if (!__evaluateFrameScripts(__totalFrames))
					{
						return;
					}

					__currentFrame = 1;
				}

				if (!__evaluateFrameScripts(nextFrame))
				{
					return;
				}
			}
			else
			{
				__currentFrame = nextFrame;
			}
		}

	__updateSymbol(__currentFrame);
	}

	protected __evaluateFrameScripts(advanceToFrame : number) : boolean
{
	if (__frameScripts == null) return true;

	for (frame in __currentFrame...advanceToFrame + 1)
	{
		if (frame == __lastFrameScriptEval) continue;

		__lastFrameScriptEval = frame;
		__currentFrame = frame;

		if (__frameScripts.exists(frame))
		{
			__updateSymbol(frame);
			var script = __frameScripts.get(frame);
			script(__scope);

			if (__currentFrame != frame)
			{
				return false;
			}
		}

		if (!__isPlaying)
		{
			return false;
		}
	}

	return true;
}

	protected __getNextFrame(deltaTime : number) : number
{
	var nextFrame: number = 0;

	if (frameRate != null)
	{
		__timeElapsed += deltaTime;
		nextFrame = __currentFrame + Math.floor(__timeElapsed / __frameTime);
		if (nextFrame < 1) nextFrame = 1;
		if (nextFrame > __totalFrames) nextFrame = Math.floor((nextFrame - 1) % __totalFrames) + 1;
		__timeElapsed = (__timeElapsed % __frameTime);
	}
	else
	{
		nextFrame = __currentFrame + 1;
		if (nextFrame > __totalFrames) nextFrame = 1;
	}

	return nextFrame;
}

	protected __goto(frame : number): void
	{
		if(frame < 1) frame = 1;
		else if(frame > __totalFrames) frame = __totalFrames;

__lastFrameScriptEval = -1;
__currentFrame = frame;

__updateSymbol(__currentFrame);
__evaluateFrameScripts(__currentFrame);
}

	protected __gotoAndPlay(frame: #if(haxe_ver >= "3.4.2") Any #else Dynamic #end, scene: string = null): void
	{
		__play();
	__goto(__resolveFrameReference(frame));
}

	protected __gotoAndStop(frame: #if(haxe_ver >= "3.4.2") Any #else Dynamic #end, scene: string = null): void
	{
		__stop();
	__goto(__resolveFrameReference(frame));
}

	protected __nextFrame(): void
	{
		__stop();
	__goto(__currentFrame + 1);
}

	protected __nextScene(): void
	{
		// TODO
	}

	protected __play(): void
	{
		if(__isPlaying || __totalFrames < 2) return;

__isPlaying = true;

if (frameRate != null)
{
	__frameTime = Std.int(1000 / frameRate);
	__timeElapsed = 0;
}
}

	protected __prevFrame(): void
	{
		__stop();
	__goto(__currentFrame - 1);
}

	protected __prevScene(): void
	{
		// TODO
	}

	protected __stop(): void
	{
		__isPlaying = false;
	}

	protected __resolveFrameReference(frame: #if(haxe_ver >= "3.4.2") Any #else Dynamic #end) : number
{
	if (Std.is(frame, Int))
	{
		return cast frame;
	}
	else if (Std.is(frame, String))
	{
		var label: string = cast frame;

		for (frameLabel in __currentLabels)
		{
			if (frameLabel.name == label)
			{
				return frameLabel.frame;
			}
		}

		throw new ArgumentError("Error #2109: Frame label " + label + " not found in scene.");
	}
	else
	{
		throw "Invalid type for frame " + Type.getClassName(frame);
	}
}

	protected __updateFrameLabel(): void
	{
		__currentLabel = null;
		__currentFrameLabel = null;

		// TODO: Update without looping so much

		for(label in __currentLabels)
	{
	if (label.frame < __currentFrame)
	{
		__currentLabel = label.name;
	}
	else if (label.frame == __currentFrame)
	{
		__currentLabel = label.name;
		__currentFrameLabel = label.name;
	}
	else
	{
		break;
	}
}
}

	protected __updateSymbol(targetFrame : number): void
	{
		if(__currentFrame != __lastFrameUpdate)
{
	__updateFrameLabel();
	enterFrame(targetFrame);
	__lastFrameUpdate = __currentFrame;
}
}
}
}

export default openfl.display.Timeline;
