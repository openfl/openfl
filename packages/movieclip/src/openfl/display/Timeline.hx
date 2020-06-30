package openfl.display;

import openfl.errors.ArgumentError;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Timeline
{
	public var frameRate:Null<Float>;
	public var scenes:Array<Scene>;
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

	@:noCompletion public function attachMovieClip(movieClip:MovieClip):Void {}

	@:noCompletion public function enterFrame(frame:Int):Void {}

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
				// TODO: Merge multiple scripts from the same frame together
				__frameScripts.set(script.frame, script.script);
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
