package openfl.display;

import openfl.errors.ArgumentError;

/**
	Provides support for MovieClip animations (or a single frame Sprite) when
	this class is overridden.

	For example, the OpenFL SWF library provides a Timeline generated from SWF
	assets. However, any editor that may provide UI or display elements could
	be used to generate assets for OpenFL timelines.

	To implement a custom Timeline, please override this class. Each Timeline
	can set their original animation frame rate, and can also provide Scenes or
	FrameScripts. OpenFL will automatically execute FrameScripts and request frame
	updates.

	There are currently three internal methods which should not be called by the user,
	which can be overridden to implement a new type of Timeline:

	   attachMovieClip();
	   enterFrame();
	   initializeSprite();
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Timeline
{
	/**
		The original frame rate for this Timeline.
	**/
	public var frameRate:Null<Float>;

	/**
		An Array of Scenes contained within this Timeline.

		Scenes are assumed to occur in order, so if the first Scene
		contains 10 frames, then the beginning of the second Scene will
		be treated as frame 11 when setting FrameScripts or implementing
		enterFrame().
	**/
	public var scenes:Array<Scene>;

	/**
		An optional array of frame scripts to be executed.
	**/
	public var scripts:Array<FrameScript>;

	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __currentFrameLabel:String;
	@:noCompletion private var __currentLabel:String;
	@:noCompletion private var __currentLabels:Array<FrameLabel>;
	@:noCompletion private var __currentScene:Scene;
	@:noCompletion private var __frameScripts:Map<Int, MovieClip->Void>;
	@:noCompletion private var __framesLoaded:Int;
	@:noCompletion private var __frameTime:Int;
	@:noCompletion private var __isPlaying:Bool;
	@:noCompletion private var __lastFrameScriptEval:Int;
	@:noCompletion private var __lastFrameUpdate:Int;
	@:noCompletion private var __scope:MovieClip;
	@:noCompletion private var __timeElapsed:Int;
	@:noCompletion private var __totalFrames:Int;

	private function new()
	{
		__framesLoaded = 1;
		__totalFrames = 1;
		__currentLabels = [];

		__currentFrame = 1;

		__lastFrameScriptEval = -1;
		__lastFrameUpdate = -1;
	}

	/**
		OpenFL will call this method automatically.

		If you are making your own Timeline type, please override this method
		and implement the first frame initialization for a MovieClip.

		OpenFL will expect to use one Timeline instance per MovieClip.

		Please initialize the first frame in this method. Afterward enterFrame()
		will be called automatically when it is time to enter a different frame.
	**/
	@:noCompletion public function attachMovieClip(movieClip:MovieClip):Void {}

	/**
		OpenFL will call this method automatically for MovieClips with
		attached timelines.

		Please update your attached MovieClip instance to the requested frame
		when this method is called.
	**/
	@:noCompletion public function enterFrame(frame:Int):Void {}

	/**
		OpenFL will call this method automatically.

		If you are making your own Timeline type, please override this method
		and implement the initialization of a Sprite.

		Sprites do not use frame scripts, or enter multiple frames. In other
		words, they will be similar to the first frame of a MovieClip.

		enterFrame() will not be called, and this Timeline object might be
		re-used again.
	**/
	@:noCompletion public function initializeSprite(sprite:Sprite):Void {}

	@:noCompletion private function __addFrameScript(index:Int, method:Void->Void):Void
	{
		if (index < 0) return;

		var frame = index + 1;

		if (method != null)
		{
			if (__frameScripts == null)
			{
				__frameScripts = new Map();
			}

			__frameScripts.set(frame, function(scope)
			{
				method();
			});
		}
		else if (__frameScripts != null)
		{
			__frameScripts.remove(frame);
		}
	}

	@:noCompletion private function __attachMovieClip(movieClip:MovieClip):Void
	{
		__scope = movieClip;

		__totalFrames = 0;
		__framesLoaded = 0;

		if (scenes != null && scenes.length > 0)
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
				if (__frameScripts.exists(script.frame))
				{
					// TODO: Does this merging code work?
					var existing = __frameScripts.get(script.frame);
					var append = script.script;
					__frameScripts.set(script.frame, function(clip:MovieClip)
					{
						existing(clip);
						append(clip);
					});
				}
				else
				{
					__frameScripts.set(script.frame, script.script);
				}
			}
		}

		attachMovieClip(movieClip);
	}

	@:noCompletion private function __enterFrame(deltaTime:Int):Void
	{
		if (__isPlaying)
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

	@:noCompletion private function __evaluateFrameScripts(advanceToFrame:Int):Bool
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

	@:noCompletion private function __getNextFrame(deltaTime:Int):Int
	{
		var nextFrame:Int = 0;

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

	@:noCompletion private function __goto(frame:Int):Void
	{
		if (frame < 1) frame = 1;
		else if (frame > __totalFrames) frame = __totalFrames;

		__lastFrameScriptEval = -1;
		__currentFrame = frame;

		__updateSymbol(__currentFrame);
		__evaluateFrameScripts(__currentFrame);
	}

	@:noCompletion private function __gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		__play();
		__goto(__resolveFrameReference(frame));
	}

	@:noCompletion private function __gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		__stop();
		__goto(__resolveFrameReference(frame));
	}

	@:noCompletion private function __nextFrame():Void
	{
		__stop();
		__goto(__currentFrame + 1);
	}

	@:noCompletion private function __nextScene():Void
	{
		// TODO
	}

	@:noCompletion private function __play():Void
	{
		if (__isPlaying || __totalFrames < 2) return;

		__isPlaying = true;

		if (frameRate != null)
		{
			__frameTime = Std.int(1000 / frameRate);
			__timeElapsed = 0;
		}
	}

	@:noCompletion private function __prevFrame():Void
	{
		__stop();
		__goto(__currentFrame - 1);
	}

	@:noCompletion private function __prevScene():Void
	{
		// TODO
	}

	@:noCompletion private function __stop():Void
	{
		__isPlaying = false;
	}

	@:noCompletion private function __resolveFrameReference(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end):Int
	{
		if ((frame is Int))
		{
			return cast frame;
		}
		else if ((frame is String))
		{
			var label:String = cast frame;

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

	@:noCompletion private function __updateFrameLabel():Void
	{
		__currentLabel = null;
		__currentFrameLabel = null;

		// TODO: Update without looping so much

		for (label in __currentLabels)
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

	@:noCompletion private function __updateSymbol(targetFrame:Int):Void
	{
		if (__currentFrame != __lastFrameUpdate)
		{
			__updateFrameLabel();
			enterFrame(targetFrame);
			__lastFrameUpdate = __currentFrame;
		}
	}
}
