package openfl.display;

import openfl.events.MouseEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _MovieClip extends _Sprite
{
	public var currentFrame(get, never):Int;
	public var currentFrameLabel(get, never):String;
	public var currentLabel(get, never):String;
	public var currentLabels(get, never):Array<FrameLabel>;
	public var currentScene(get, never):Scene;
	public var enabled(get, set):Bool;
	public var framesLoaded(get, never):Int;
	public var isPlaying(get, never):Bool;
	public var scenes(get, never):Array<Scene>;
	public var totalFrames(get, never):Int;

	public static var __constructor:MovieClip->Void;

	public var __enabled:Bool;
	public var __hasDown:Bool;
	public var __hasOver:Bool;
	public var __hasUp:Bool;
	public var __mouseIsDown:Bool;
	public var __scene:Scene;
	public var __timeline:Timeline;

	private var movieClip:MovieClip;

	public function new(movieClip:MovieClip)
	{
		this.movieClip = movieClip;

		super(movieClip);

		__enabled = true;
		__type = MOVIE_CLIP;

		if (__constructor != null)
		{
			var method = __constructor;
			__constructor = null;

			method(movieClip);
		}
	}

	public function addFrameScript(index:Int, method:Void->Void):Void
	{
		if (__timeline != null)
		{
			__timeline._.__addFrameScript(index, method);
		}
	}

	public function attachTimeline(timeline:Timeline):Void
	{
		__timeline = timeline;
		if (timeline != null)
		{
			timeline._.__attachMovieClip(this.movieClip);
			play();
		}
	}

	public static function fromTimeline(timeline:Timeline):MovieClip
	{
		var movieClip = new MovieClip();
		movieClip.attachTimeline(timeline);
		return movieClip;
	}

	public function gotoAndPlay(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		if (__timeline != null)
		{
			__timeline._.__gotoAndPlay(frame, scene);
		}
	}

	public function gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		if (__timeline != null)
		{
			__timeline._.__gotoAndStop(frame, scene);
		}
	}

	public function nextFrame():Void
	{
		if (__timeline != null)
		{
			__timeline._.__nextFrame();
		}
	}

	public function nextScene():Void
	{
		if (__timeline != null)
		{
			__timeline._.__nextScene();
		}
	}

	public function play():Void
	{
		if (__timeline != null)
		{
			__timeline._.__play();
		}
	}

	public function prevFrame():Void
	{
		if (__timeline != null)
		{
			__timeline._.__prevFrame();
		}
	}

	public function prevScene():Void
	{
		if (__timeline != null)
		{
			__timeline._.__prevScene();
		}
	}

	public function stop():Void
	{
		if (__timeline != null)
		{
			__timeline._.__stop();
		}
	}

	public override function __stopAllMovieClips():Void
	{
		super.__stopAllMovieClips();
		stop();
	}

	public override function __tabTest(stack:Array<InteractiveObject>):Void
	{
		if (!__enabled) return;
		super.__tabTest(stack);
	}

	// Event Handlers

	public function __onMouseDown(event:MouseEvent):Void
	{
		if (__enabled && __hasDown)
		{
			gotoAndStop("_down");
		}

		__mouseIsDown = true;
		stage.addEventListener(MouseEvent.MOUSE_UP, __onMouseUp, true);
	}

	public function __onMouseUp(event:MouseEvent):Void
	{
		__mouseIsDown = false;

		if (stage != null)
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, __onMouseUp);
		}

		if (!__buttonMode)
		{
			return;
		}

		if (event.target == this.movieClip && __enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (__enabled && __hasUp)
		{
			gotoAndStop("_up");
		}
	}

	public function __onRollOut(event:MouseEvent):Void
	{
		if (!__enabled) return;

		if (__mouseIsDown && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (__hasUp)
		{
			gotoAndStop("_up");
		}
	}

	public function __onRollOver(event:MouseEvent):Void
	{
		if (__enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
	}

	// Get & Set Methods

	public override function set_buttonMode(value:Bool):Bool
	{
		if (__buttonMode != value)
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

			__buttonMode = value;
		}

		return value;
	}

	private function get_currentFrame():Int
	{
		if (__timeline != null)
		{
			return __timeline._.__currentFrame;
		}
		else
		{
			return 1;
		}
	}

	private function get_currentFrameLabel():String
	{
		if (__timeline != null)
		{
			return __timeline._.__currentFrameLabel;
		}
		else
		{
			return null;
		}
	}

	private function get_currentLabel():String
	{
		if (__timeline != null)
		{
			return __timeline._.__currentLabel;
		}
		else
		{
			return null;
		}
	}

	private function get_currentLabels():Array<FrameLabel>
	{
		if (__timeline != null)
		{
			return __timeline._.__currentLabels.copy();
		}
		else
		{
			return [];
		}
	}

	private function get_currentScene():Scene
	{
		if (__timeline != null)
		{
			return __timeline._.__currentScene;
		}
		else
		{
			if (__scene == null)
			{
				__scene = new Scene("", [], 1);
			}
			return __scene;
		}
	}

	private function get_enabled():Bool
	{
		return __enabled;
	}

	private function set_enabled(value:Bool):Bool
	{
		return __enabled = value;
	}

	private function get_framesLoaded():Int
	{
		if (__timeline != null)
		{
			return __timeline._.__framesLoaded;
		}
		else
		{
			return 1;
		}
	}

	private function get_isPlaying():Bool
	{
		if (__timeline != null)
		{
			return __timeline._.__isPlaying;
		}
		else
		{
			return false;
		}
	}

	private function get_scenes():Array<Scene>
	{
		if (__timeline != null)
		{
			return __timeline.scenes.copy();
		}
		else
		{
			return [currentScene];
		}
	}

	private function get_totalFrames():Int
	{
		if (__timeline != null)
		{
			return __timeline._.__totalFrames;
		}
		else
		{
			return 1;
		}
	}
}
