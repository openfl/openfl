import FrameLabel from "../display/FrameLabel";
import FrameScript from "../display/FrameScript";
import MovieClip from "../display/MovieClip";
import Scene from "../display/Scene";
import ArgumentError from "../errors/ArgumentError";

/**
	The Timeline class is the base class for frame-by-frame animation.

	Timeline is an abstract base class; therefore, you cannot call
	Timeline directly. Extend the Timeline class in order to provide animation
	compatible with the MovieClip class.

	It is possible to create a MovieClip with a Timeline using the
	`MovieClip.fromTimeline` static readonlyructor.
**/
export default class Timeline
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
	protected __frameScripts: Map<number, (scope: MovieClip) => void>;
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
		this.__framesLoaded = 1;
		this.__totalFrames = 1;
		this.__currentLabels = [];

		this.__currentFrame = 1;

		this.__lastFrameScriptEval = -1;
		this.__lastFrameUpdate = -1;
	}

	/**
		Called internally when the Timeline object has a movie clip attached.

		This is an abstract method, so it should be overridden with an implementation
		in child classes.

		@param	movieClip	The parent MovieClip being attached to this Timeline
	**/
	/** @hidden */ public attachMovieClip(movieClip: MovieClip): void { }

	/**
		Called internally when the Timeline object enters a new frame.

		This is an abstract method, so it should be overridden with an implementation
		in child classes.

		Do not rely on this method being called for every sequential frame. Due to
		frame rate as well as default looping at the end of timelines, the `frame`
		value represents only the current frame required.

		@param	frame	The current frame
	**/
	/** @hidden */ public enterFrame(frame: number): void { }

	protected __addFrameScript(index: number, method: () => void): void
	{
		if (index < 0) return;

		var frame = index + 1;

		if (method != null)
		{
			if (this.__frameScripts == null)
			{
				this.__frameScripts = new Map();
			}

			this.__frameScripts.set(frame, function (scope)
			{
				method();
			});
		}
		else if (this.__frameScripts != null)
		{
			this.__frameScripts.delete(frame);
		}
	}

	protected __attachMovieClip(movieClip: MovieClip): void
	{
		this.__scope = movieClip;

		this.__totalFrames = 0;
		this.__framesLoaded = 0;

		if (this.scenes != null && this.scenes.length > 0)
		{
			for (let scene of this.scenes)
			{
				this.__totalFrames += scene.numFrames;
				this.__framesLoaded += scene.numFrames;
				if (scene.labels != null)
				{
					// TODO: Handle currentLabels properly for multiple scenes
					this.__currentLabels = this.__currentLabels.concat(scene.labels);
				}
			}

			this.__currentScene = this.scenes[0];
		}

		if (this.scripts != null && this.scripts.length > 0)
		{
			this.__frameScripts = new Map();
			for (let script of this.scripts)
			{
				// TODO: Merge multiple scripts from the same frame together
				this.__frameScripts.set(script.frame, script.script);
			}
		}

		this.attachMovieClip(movieClip);
	}

	protected __enterFrame(deltaTime: number): void
	{
		if (this.__isPlaying)
		{
			var nextFrame = this.__getNextFrame(deltaTime);

			if (this.__lastFrameScriptEval == nextFrame)
			{
				return;
			}

			if (this.__frameScripts != null)
			{
				if (nextFrame < this.__currentFrame)
				{
					if (!this.__evaluateFrameScripts(this.__totalFrames))
					{
						return;
					}

					this.__currentFrame = 1;
				}

				if (!this.__evaluateFrameScripts(nextFrame))
				{
					return;
				}
			}
			else
			{
				this.__currentFrame = nextFrame;
			}
		}

		this.__updateSymbol(this.__currentFrame);
	}

	protected __evaluateFrameScripts(advanceToFrame: number): boolean
	{
		if (this.__frameScripts == null) return true;

		for (let frame = this.__currentFrame; frame < advanceToFrame + 1; frame++)
		{
			if (frame == this.__lastFrameScriptEval) continue;

			this.__lastFrameScriptEval = frame;
			this.__currentFrame = frame;

			if (this.__frameScripts.has(frame))
			{
				this.__updateSymbol(frame);
				var script = this.__frameScripts.get(frame);
				script(this.__scope);

				if (this.__currentFrame != frame)
				{
					return false;
				}
			}

			if (!this.__isPlaying)
			{
				return false;
			}
		}

		return true;
	}

	protected __getNextFrame(deltaTime: number): number
	{
		var nextFrame: number = 0;

		if (this.frameRate != null)
		{
			this.__timeElapsed += deltaTime;
			nextFrame = this.__currentFrame + Math.floor(this.__timeElapsed / this.__frameTime);
			if (nextFrame < 1) nextFrame = 1;
			if (nextFrame > this.__totalFrames) nextFrame = Math.floor((nextFrame - 1) % this.__totalFrames) + 1;
			this.__timeElapsed = (this.__timeElapsed % this.__frameTime);
		}
		else
		{
			nextFrame = this.__currentFrame + 1;
			if (nextFrame > this.__totalFrames) nextFrame = 1;
		}

		return nextFrame;
	}

	protected __goto(frame: number): void
	{
		if (frame < 1) frame = 1;
		else if (frame > this.__totalFrames) frame = this.__totalFrames;

		this.__lastFrameScriptEval = -1;
		this.__currentFrame = frame;

		this.__updateSymbol(this.__currentFrame);
		this.__evaluateFrameScripts(this.__currentFrame);
	}

	protected __gotoAndPlay(frame: number | string, scene: string = null): void
	{
		this.__play();
		this.__goto(this.__resolveFrameReference(frame));
	}

	protected __gotoAndStop(frame: number | string, scene: string = null): void
	{
		this.__stop();
		this.__goto(this.__resolveFrameReference(frame));
	}

	protected __nextFrame(): void
	{
		this.__stop();
		this.__goto(this.__currentFrame + 1);
	}

	protected __nextScene(): void
	{
		// TODO
	}

	protected __play(): void
	{
		if (this.__isPlaying || this.__totalFrames < 2) return;

		this.__isPlaying = true;

		if (this.frameRate != null)
		{
			this.__frameTime = Math.round(1000 / this.frameRate);
			this.__timeElapsed = 0;
		}
	}

	protected __prevFrame(): void
	{
		this.__stop();
		this.__goto(this.__currentFrame - 1);
	}

	protected __prevScene(): void
	{
		// TODO
	}

	protected __stop(): void
	{
		this.__isPlaying = false;
	}

	protected __resolveFrameReference(frame: number | string): number
	{
		if (typeof frame === "number")
		{
			return frame;
		}
		else if (typeof frame === "string")
		{
			var label: string = frame;

			for (let frameLabel of this.__currentLabels)
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
			throw "Invalid type for frame " + (typeof frame);
		}
	}

	protected __updateFrameLabel(): void
	{
		this.__currentLabel = null;
		this.__currentFrameLabel = null;

		// TODO: Update without looping so much

		for (let label of this.__currentLabels)
		{
			if (label.frame < this.__currentFrame)
			{
				this.__currentLabel = label.name;
			}
			else if (label.frame == this.__currentFrame)
			{
				this.__currentLabel = label.name;
				this.__currentFrameLabel = label.name;
			}
			else
			{
				break;
			}
		}
	}

	protected __updateSymbol(targetFrame: number): void
	{
		if (this.__currentFrame != this.__lastFrameUpdate)
		{
			this.__updateFrameLabel();
			this.enterFrame(targetFrame);
			this.__lastFrameUpdate = this.__currentFrame;
		}
	}
}
