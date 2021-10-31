package flash.display;

#if flash
import openfl.display._internal.FlashRenderer;
import openfl.display.Timeline;
import openfl.events.MouseEvent;
import openfl.utils.Object;

extern class MovieClip extends Sprite #if openfl_dynamic implements Dynamic #end
{
	@:noCompletion public static var __constructor:MovieClip->Void;
	public var currentFrame(default, never):Int;
	@:require(flash10) public var currentFrameLabel(default, never):String;
	public var currentLabel(default, never):String;
	public var currentLabels(default, never):Array<FrameLabel>;
	public var currentScene(default, never):Scene;
	public var enabled:Bool;
	public var framesLoaded(default, never):Int;
	@:require(flash11) public var isPlaying(default, never):Bool;
	public var scenes(default, never):Array<flash.display.Scene>;
	public var totalFrames(default, never):Int;
	#if flash
	public var trackAsMenu:Bool;
	#end
	public function new();
	public function addFrameScript(index:Int, method:Void->Void):Void;
	public static inline function fromTimeline(timeline:Timeline):MovieClip
	{
		var movieClip = new MovieClip2();
		movieClip.attachTimeline(timeline);
		return movieClip;
	}
	public function gotoAndPlay(frame:Object, scene:String = null):Void;
	public function gotoAndStop(frame:Object, scene:String = null):Void;
	public function nextFrame():Void;
	public function nextScene():Void;
	public function play():Void;
	public function prevFrame():Void;
	public function prevScene():Void;
	public function stop():Void;
}

@:access(openfl.display.Timeline)
@:noCompletion class MovieClip2 extends MovieClip implements IDisplayObject
{
	@:noCompletion private var __cacheTime:Int; // TODO: Move to FlashRenderer?
	@:noCompletion private var __hasDown:Bool;
	@:noCompletion private var __hasOver:Bool;
	@:noCompletion private var __hasUp:Bool;
	@:noCompletion private var __mouseIsDown:Bool;
	@:noCompletion private var __timeline:Timeline;

	public function new(timeline:Timeline = null)
	{
		super();

		__cacheTime = Lib.getTimer();

		if (timeline != null)
		{
			__timeline = timeline;
			__timeline.__attachMovieClip(this);
			play();
		}

		if (MovieClip.__constructor != null)
		{
			var method = MovieClip.__constructor;
			MovieClip.__constructor = null;

			method(this);
		}

		FlashRenderer.register(this);
	}

	public function attachTimeline(timeline:Timeline):Void
	{
		__timeline = timeline;
		if (timeline != null)
		{
			timeline.__attachMovieClip(this);
			play();
		}
	}

	// public override function addFrameScript(index:Int, method:Void->Void):Void
	// {
	// 	if (__timeline != null) __timeline.addFrameScript(index, method);
	// }

	public override function gotoAndPlay(frame:Object, scene:String = null):Void
	{
		if (__timeline != null) __timeline.__gotoAndPlay(frame, scene);
	}

	public override function gotoAndStop(frame:Object, scene:String = null):Void
	{
		if (__timeline != null) __timeline.__gotoAndStop(frame, scene);
	}

	public override function nextFrame():Void
	{
		if (__timeline != null) __timeline.__nextFrame();
	}

	public override function nextScene():Void
	{
		if (__timeline != null) __timeline.__nextScene();
	}

	public override function play():Void
	{
		if (__timeline != null) __timeline.__play();
	}

	public override function prevFrame():Void
	{
		if (__timeline != null) __timeline.__prevFrame();
	}

	public override function prevScene():Void
	{
		if (__timeline != null) __timeline.__prevScene();
	}

	public override function stop():Void
	{
		if (__timeline != null) __timeline.__stop();
	}

	@:noCompletion private function __renderFlash():Void
	{
		var currentTime = Lib.getTimer();
		var deltaTime = currentTime - __cacheTime;
		__cacheTime = currentTime;
		if (__timeline != null)
		{
			__timeline.__enterFrame(deltaTime);
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
			return __timeline.__currentFrame;
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
			return __timeline.__currentFrameLabel;
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
			return __timeline.__currentLabel;
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
			return __timeline.__currentLabels;
		}
		else
		{
			return [];
		}
	}

	@:getter(currentScene) @:noCompletion private function get_currentScene():Scene
	{
		if (__timeline != null)
		{
			return __timeline.__currentScene;
		}
		else
		{
			return this.currentScene;
		}
	}

	@:getter(framesLoaded) @:noCompletion private function get_framesLoaded():Int
	{
		if (__timeline != null)
		{
			return __timeline.__framesLoaded;
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
			return __timeline.__isPlaying;
		}
		else
		{
			return false;
		}
	}

	@:getter(scenes) @:noCompletion private function get_scenes():Array<Scene>
	{
		if (__timeline != null)
		{
			return __timeline.scenes;
		}
		else
		{
			return null;
		}
	}

	@:getter(totalFrames) @:noCompletion private function get_totalFrames():Int
	{
		if (__timeline != null)
		{
			return __timeline.__totalFrames;
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
