package openfl.display;

import openfl.display.FrameLabel;
import openfl.display.MovieClip;
import openfl.errors.ArgumentError;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Timeline
{
	#if openfljs
	@:noCompletion private static var __useParentFPS:Bool;
	#else
	@:noCompletion private static inline var __useParentFPS:Bool = #if (swflite_parent_fps || swf_parent_fps) true #else false #end;
	#end

	public var currentLabels:Array<FrameLabel>;
	public var frameRate:Float;
	public var frameScripts:Map<Int, MovieClip->Void>;
	public var framesLoaded:Int;
	public var totalFrames:Int;

	@:noCompletion private var __currentFrame:Int;
	@:noCompletion private var __currentFrameLabel:String;
	@:noCompletion private var __currentLabel:String;
	@:noCompletion private var __frameTime:Int;
	@:noCompletion private var __isPlaying:Bool;
	@:noCompletion private var __lastFrameScriptEval:Int;
	@:noCompletion private var __lastFrameUpdate:Int;
	@:noCompletion private var __scope:MovieClip;
	@:noCompletion private var __timeElapsed:Int;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		__useParentFPS = true;
		untyped __js__("/// #if (typeof ENV === 'undefined' || (!ENV['swflite-parent-fps'] && !ENV['swf-parent-fps'])) && (typeof swf_parent_fps === 'undefined' || !swf_parent_fps) && (typeof swflite_parent_fps === 'undefined' || !swflite-parent-fps) && (typeof defines === 'undefined' || (!defines['swf-parent-fps'] && !defines['swflite-parent-fps']))");
		__useParentFPS = false;
		untyped __js__("/// #endif");
	}
	#end

	private function new()
	{
		__currentFrame = 1;
		currentLabels = [];
		frameRate = 24;
		totalFrames = 1;
		framesLoaded = 1;
	}

	public function attachMovieClip(movieClip:MovieClip):Void {}

	public function enterFrame(frame:Int):Void {}

	private function __addFrameScript(index:Int, method:Void->Void):Void
	{
		if (index < 0) return;

		var frame = index + 1;

		if (method != null)
		{
			if (frameScripts == null)
			{
				frameScripts = new Map();
			}

			frameScripts.set(frame, function(scope)
			{
				method();
			});
		}
		else if (frameScripts != null)
		{
			frameScripts.remove(frame);
		}
	}

	private function __enterFrame(deltaTime:Int):Void
	{
		__updateFrameScript(deltaTime);
		__updateSymbol(__currentFrame);
	}

	@:noCompletion private function __evaluateFrameScripts(advanceToFrame:Int):Bool
	{
		for (frame in __currentFrame...advanceToFrame + 1)
		{
			if (frame == __lastFrameScriptEval) continue;

			__lastFrameScriptEval = frame;
			__currentFrame = frame;

			if (frameScripts.exists(frame))
			{
				__updateSymbol(frame);
				var script = frameScripts.get(frame);
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

		if (!__useParentFPS)
		{
			__timeElapsed += deltaTime;
			nextFrame = __currentFrame + Math.floor(__timeElapsed / __frameTime);
			if (nextFrame < 1) nextFrame = 1;
			if (nextFrame > totalFrames) nextFrame = Math.floor((nextFrame - 1) % totalFrames) + 1;
			__timeElapsed = (__timeElapsed % __frameTime);
		}
		else
		{
			nextFrame = __currentFrame + 1;
			if (nextFrame > totalFrames) nextFrame = 1;
		}

		return nextFrame;
	}

	@:noCompletion private function __goto(frame:Int):Void
	{
		if (frame < 1) frame = 1;
		else if (frame > totalFrames) frame = totalFrames;

		__currentFrame = frame;
		__enterFrame(0);
	}

	private function __gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		__play();
		__goto(__resolveFrameReference(frame));
	}

	private function __gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		__stop();
		__goto(__resolveFrameReference(frame));
	}

	private function __nextFrame():Void
	{
		__stop();
		__goto(__currentFrame + 1);
	}

	private function __play():Void
	{
		if (__isPlaying || totalFrames < 2) return;

		__isPlaying = true;

		if (!__useParentFPS)
		{
			__frameTime = Std.int(1000 / frameRate);
			__timeElapsed = 0;
		}
	}

	private function __prevFrame():Void
	{
		__stop();
		__goto(__currentFrame - 1);
	}

	private function __stop():Void
	{
		__isPlaying = false;
	}

	@:noCompletion private function __resolveFrameReference(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end):Int
	{
		if (Std.is(frame, Int))
		{
			return cast frame;
		}
		else if (Std.is(frame, String))
		{
			var label:String = cast frame;

			for (frameLabel in currentLabels)
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

		for (label in currentLabels)
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

	@:noCompletion private function __updateFrameScript(deltaTime:Int):Void
	{
		if (__isPlaying)
		{
			var nextFrame = __getNextFrame(deltaTime);

			if (__lastFrameScriptEval == nextFrame)
			{
				return;
			}

			if (frameScripts != null)
			{
				if (nextFrame < __currentFrame)
				{
					if (!__evaluateFrameScripts(totalFrames))
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
