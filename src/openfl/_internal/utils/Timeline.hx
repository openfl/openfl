package openfl._internal.utils;

import openfl.display.FrameLabel;
import openfl.display.ITimeline;
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

	public var currentFrame:Int;
	public var currentFrameLabel:String;
	public var currentLabel:String;
	public var currentLabels:Array<FrameLabel>;
	public var framesLoaded:Int;
	public var isPlaying:Bool;
	public var totalFrames:Int;

	@:noCompletion private var __frameRate:Float;
	@:noCompletion private var __frameScripts:Map<Int, Void->Void>;
	@:noCompletion private var __frameTime:Int;
	@:noCompletion private var __lastFrameScriptEval:Int;
	@:noCompletion private var __lastFrameUpdate:Int;
	@:noCompletion private var __movieClip:MovieClip;
	@:noCompletion private var __timeElapsed:Int;
	@:noCompletion private var __timeline:ITimeline;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		__useParentFPS = true;
		untyped __js__("/// #if (typeof ENV === 'undefined' || (!ENV['swflite-parent-fps'] && !ENV['swf-parent-fps'])) && (typeof swf_parent_fps === 'undefined' || !swf_parent_fps) && (typeof swflite_parent_fps === 'undefined' || !swflite-parent-fps) && (typeof defines === 'undefined' || (!defines['swf-parent-fps'] && !defines['swflite-parent-fps']))");
		__useParentFPS = false;
		untyped __js__("/// #endif");
	}
	#end

	public function new(movieClip:MovieClip, timeline:ITimeline)
	{
		__movieClip = movieClip;
		__timeline = timeline;

		currentFrame = 1;
		currentLabels = [];
		framesLoaded = timeline.framesLoaded; // TODO: Support for this to change?
		totalFrames = timeline.totalFrames;
		__frameRate = timeline.frameRate;

		if (timeline.frameLabels != null)
		{
			var labels, frameLabel;
			for (frame in timeline.frameLabels.keys())
			{
				labels = timeline.frameLabels.get(frame);
				if (labels == null) continue;

				for (label in labels)
				{
					frameLabel = new FrameLabel(label, frame);
					currentLabels.push(frameLabel);
				}
			}
		}

		if (timeline.frameScripts != null)
		{
			var script;
			for (frame in timeline.frameScripts.keys())
			{
				script = timeline.frameScripts.get(frame);
				if (script == null) continue;

				addFrameScript(frame - 1, script.bind(__movieClip));
			}
		}

		timeline.updateMovieClip(__movieClip, 0, 1);
	}

	public function addFrameScript(index:Int, method:Void->Void):Void
	{
		if (index < 0) return;

		var frame = index + 1;

		if (method != null)
		{
			if (__frameScripts == null)
			{
				__frameScripts = new Map();
			}

			__frameScripts.set(frame, method);
		}
		else if (__frameScripts != null)
		{
			__frameScripts.remove(frame);
		}
	}

	public function gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		play();
		__goto(__resolveFrameReference(frame));
	}

	public function gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		stop();
		__goto(__resolveFrameReference(frame));
	}

	public function nextFrame():Void
	{
		stop();
		__goto(currentFrame + 1);
	}

	public function play():Void
	{
		if (isPlaying || totalFrames < 2) return;

		isPlaying = true;

		if (!__useParentFPS)
		{
			__frameTime = Std.int(1000 / __frameRate);
			__timeElapsed = 0;
		}
	}

	public function prevFrame():Void
	{
		stop();
		__goto(currentFrame - 1);
	}

	public function stop():Void
	{
		isPlaying = false;
	}

	public function enterFrame(deltaTime:Int):Void
	{
		__updateFrameScript(deltaTime);
		__updateSymbol(currentFrame);
	}

	@:noCompletion private function __evaluateFrameScripts(advanceToFrame:Int):Bool
	{
		for (frame in currentFrame...advanceToFrame + 1)
		{
			if (frame == __lastFrameScriptEval) continue;

			__lastFrameScriptEval = frame;
			currentFrame = frame;

			if (__frameScripts.exists(frame))
			{
				__updateSymbol(frame);
				var script = __frameScripts.get(frame);
				script();

				if (currentFrame != frame)
				{
					return false;
				}
			}

			if (!isPlaying)
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
			nextFrame = currentFrame + Math.floor(__timeElapsed / __frameTime);
			if (nextFrame < 1) nextFrame = 1;
			if (nextFrame > totalFrames) nextFrame = Math.floor((nextFrame - 1) % totalFrames) + 1;
			__timeElapsed = (__timeElapsed % __frameTime);
		}
		else
		{
			nextFrame = currentFrame + 1;
			if (nextFrame > totalFrames) nextFrame = 1;
		}

		return nextFrame;
	}

	@:noCompletion private function __goto(frame:Int):Void
	{
		if (frame < 1) frame = 1;
		else if (frame > totalFrames) frame = totalFrames;

		currentFrame = frame;
		enterFrame(0);
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
		currentLabel = null;
		currentFrameLabel = null;

		// TODO: Update without looping so much

		for (label in currentLabels)
		{
			if (label.frame < currentFrame)
			{
				currentLabel = label.name;
			}
			else if (label.frame == currentFrame)
			{
				currentLabel = label.name;
				currentFrameLabel = label.name;
			}
			else
			{
				break;
			}
		}
	}

	@:noCompletion private function __updateFrameScript(deltaTime:Int):Void
	{
		if (isPlaying)
		{
			var nextFrame = __getNextFrame(deltaTime);

			if (__lastFrameScriptEval == nextFrame)
			{
				return;
			}

			if (__frameScripts != null)
			{
				if (nextFrame < currentFrame)
				{
					if (!__evaluateFrameScripts(totalFrames))
					{
						return;
					}

					currentFrame = 1;
				}

				if (!__evaluateFrameScripts(nextFrame))
				{
					return;
				}
			}
			else
			{
				currentFrame = nextFrame;
			}
		}
	}

	@:noCompletion private function __updateSymbol(targetFrame:Int):Void
	{
		if (currentFrame != __lastFrameUpdate)
		{
			__updateFrameLabel();
			__timeline.updateMovieClip(__movieClip, __lastFrameUpdate, targetFrame);
			__lastFrameUpdate = currentFrame;
		}
	}
}
