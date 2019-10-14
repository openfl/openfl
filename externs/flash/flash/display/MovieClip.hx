package flash.display;

import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.utils.Timeline;
import openfl.display.ITimeline;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.utils.Object;
import openfl.Lib;

#if flash
extern class MovieClip extends Sprite #if openfl_dynamic implements Dynamic #end
{
	@:noCompletion public static var __constructor:MovieClip->Void;
	public var currentFrame(default, never):Int;
	@:require(flash10) public var currentFrameLabel(default, never):String;
	public var currentLabel(default, never):String;
	public var currentLabels(default, never):Array<FrameLabel>;
	public var enabled:Bool;
	public var framesLoaded(default, never):Int;
	@:require(flash11) public var isPlaying(default, never):Bool;
	#if flash
	public var scenes(default, never):Array<flash.display.Scene>;
	#end
	public var totalFrames(default, never):Int;
	#if flash
	public var trackAsMenu:Bool;
	#end
	public function new();
	public function addFrameScript(index:Int, method:Void->Void):Void;
	public static function fromTimeline(timeline:ITimeline):MovieClip
	{
		var movieClip = new MovieClip2();
		movieClip.__timeline = new Timeline(movieClip, timeline);
		movieClip.play();
		return;
	}
	public function gotoAndPlay(frame:Object, scene:String = null):Void;
	public function gotoAndStop(frame:Object, scene:String = null):Void;
	public function nextFrame():Void;
	#if flash
	public function nextScene():Void;
	#end
	public function play():Void;
	public function prevFrame():Void;
	#if flash
	public function prevScene():Void;
	#end
	public function stop():Void;
}

@:noCompletion class MovieClip2 extends MovieClip implements IDisplayObject
{
	@:noCompletion private var __cacheTime:Int; // TODO: Move to FlashRenderer?
	@:noCompletion private var __hasDown:Bool;
	@:noCompletion private var __hasOver:Bool;
	@:noCompletion private var __hasUp:Bool;
	@:noCompletion private var __mouseIsDown:Bool;
	@:noCompletion private var __timeline:Timeline;

	public function new()
	{
		super();

		__cacheTime = Lib.getTimer();

		if (MovieClip.__constructor != null)
		{
			var method = MovieClip.__constructor;
			MovieClip.__constructor = null;

			method(this);
		}

		FlashRenderer.register(this);
	}

	// public override function addFrameScript(index:Int, method:Void->Void):Void
	// {
	// 	if (__timeline != null) __timeline.addFrameScript(index, method);
	// }

	public override function gotoAndPlay(frame:Object, scene:String = null):Void
	{
		if (__timeline != null) __timeline.gotoAndPlay(frame, scene);
	}

	public override function gotoAndStop(frame:Object, scene:String = null):Void
	{
		if (__timeline != null) __timeline.gotoAndStop(frame, scene);
	}

	public override function nextFrame():Void
	{
		if (__timeline != null) __timeline.nextFrame();
	}

	public override function play():Void
	{
		if (__timeline != null) __timeline.play();
	}

	public override function prevFrame():Void
	{
		if (__timeline != null) __timeline.prevFrame();
	}

	public override function stop():Void
	{
		if (__timeline != null) __timeline.stop();
	}

	@:noCompletion private function __renderFlash():Void
	{
		var currentTime = Lib.getTimer();
		var deltaTime = currentTime - __cacheTime;
		__cacheTime = currentTime;
		if (__timeline != null)
		{
			__timeline.enterFrame(deltaTime);
		}
	}

	// Event Handlers
	@:noCompletion private function __onMouseDown(event:MouseEvent):Void
	{
		if (enabled && __hasDown)
		{
			gotoAndStop("_down");
		}

		__mouseIsDown = true;
		stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp, true);
	}

	@:noCompletion private function __onMouseUp(event:MouseEvent):Void
	{
		__mouseIsDown = false;

		if (stage != null)
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}

		if (!buttonMode)
		{
			return;
		}

		if (event.target == this && enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (enabled && __hasUp)
		{
			gotoAndStop("_up");
		}
	}

	@:noCompletion private function __onRollOut(event:MouseEvent):Void
	{
		if (!enabled) return;

		if (__mouseIsDown && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (__hasUp)
		{
			gotoAndStop("_up");
		}
	}

	@:noCompletion private function __onRollOver(event:MouseEvent):Void
	{
		if (enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
	}

	// Getters & Setters
	@:setter(buttonMode) @:noCompletion private function set_buttonMode(value:Bool):Void
	{
		if (this.buttonMode != value)
		{
			if (value)
			{
				__hasDown = false;
				__hasOver = false;
				__hasUp = false;

				for (frameLabel in currentLabels)
				{
					switch (frameLabel.name)
					{
						case "_up":
							__hasUp = true;
						case "_over":
							__hasOver = true;
						case "_down":
							__hasDown = true;
						default:
					}
				}

				if (__hasDown || __hasOver || __hasUp)
				{
					addEventListener(MouseEvent.ROLL_OVER, __onRollOver);
					addEventListener(MouseEvent.ROLL_OUT, __onRollOut);
					addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
				}
			}
			else
			{
				removeEventListener(MouseEvent.ROLL_OVER, __onRollOver);
				removeEventListener(MouseEvent.ROLL_OUT, __onRollOut);
				removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDown);
			}

			this.buttonMode = value;
		}
	}

	@:getter(currentFrame) @:noCompletion private function get_currentFrame():Int
	{
		if (__timeline != null)
		{
			return __timeline.currentFrame;
		}
		else
		{
			return 1;
		}
	}

	@:getter(currentFrameLabel) @:noCompletion private function get_currentFrameLabel():String
	{
		if (__timeline != null)
		{
			return __timeline.currentFrameLabel;
		}
		else
		{
			return null;
		}
	}

	@:getter(currentLabel) @:noCompletion private function get_currentLabel():String
	{
		if (__timeline != null)
		{
			return __timeline.currentLabel;
		}
		else
		{
			return null;
		}
	}

	@:getter(currentLabels) @:noCompletion private function get_currentLabels():Array<FrameLabel>
	{
		if (__timeline != null)
		{
			return __timeline.currentLabels;
		}
		else
		{
			return null;
		}
	}

	@:getter(framesLoaded) @:noCompletion private function get_framesLoaded():Int
	{
		if (__timeline != null)
		{
			return __timeline.framesLoaded;
		}
		else
		{
			return 1;
		}
	}

	@:getter(isPlaying) @:noCompletion private function get_isPlaying():Bool
	{
		if (__timeline != null)
		{
			return __timeline.isPlaying;
		}
		else
		{
			return false;
		}
	}

	@:getter(totalFrames) @:noCompletion private function get_totalFrames():Int
	{
		if (__timeline != null)
		{
			return __timeline.totalFrames;
		}
		else
		{
			return 1;
		}
	}
}
#else
typedef MovieClip = openfl.display.MovieClip;
#end
