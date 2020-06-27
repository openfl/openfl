package openfl.display;

#if !flash
import openfl.events.MouseEvent;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display.Timeline)
@:access(openfl.geom.ColorTransform)
class MovieClip extends Sprite #if (openfl_dynamic && haxe_ver < "4.0.0") implements Dynamic<DisplayObject> #end
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

	// @:noCompletion @:dox(hide) public var trackAsMenu:Bool;
	@:noCompletion private static var __constructor:MovieClip->Void;

	@:noCompletion private var __enabled:Bool;
	@:noCompletion private var __hasDown:Bool;
	@:noCompletion private var __hasOver:Bool;
	@:noCompletion private var __hasUp:Bool;
	@:noCompletion private var __mouseIsDown:Bool;
	@:noCompletion private var __scene:Scene;
	@:noCompletion private var __timeline:Timeline;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperties(MovieClip.prototype, {
			"currentFrame": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_currentFrame (); }")},
			"currentFrameLabel": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_currentFrameLabel (); }")},
			"currentLabel": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_currentLabel (); }")},
			"currentLabels": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_currentLabels (); }")},
			"enabled": {
				get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_enabled (); }"),
				set: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function (v) { return this.set_enabled (v); }")
			},
			"framesLoaded": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_framesLoaded (); }")},
			"isPlaying": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_isPlaying (); }")},
			"totalFrames": {get: untyped #if haxe4 js.Syntax.code #else __js__ #end ("function () { return this.get_totalFrames (); }")},
		});
	}
	#end

	public function new()
	{
		super();

		__enabled = true;
		// __type = MOVIE_CLIP;

		if (__constructor != null)
		{
			var method = __constructor;
			__constructor = null;

			method(this);
		}
	}

	public function addFrameScript(index:Int, method:Void->Void):Void
	{
		if (__timeline != null)
		{
			__timeline.__addFrameScript(index, method);
		}
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
			__timeline.__gotoAndPlay(frame, scene);
		}
	}

	public function gotoAndStop(frame:#if (haxe_ver >= "3.4.2") Any #else Dynamic #end, scene:String = null):Void
	{
		if (__timeline != null)
		{
			__timeline.__gotoAndStop(frame, scene);
		}
	}

	public function nextFrame():Void
	{
		if (__timeline != null)
		{
			__timeline.__nextFrame();
		}
	}

	public function nextScene():Void
	{
		if (__timeline != null)
		{
			__timeline.__nextScene();
		}
	}

	public function play():Void
	{
		if (__timeline != null)
		{
			__timeline.__play();
		}
	}

	public function prevFrame():Void
	{
		if (__timeline != null)
		{
			__timeline.__prevFrame();
		}
	}

	public function prevScene():Void
	{
		if (__timeline != null)
		{
			__timeline.__prevScene();
		}
	}

	public function stop():Void
	{
		if (__timeline != null)
		{
			__timeline.__stop();
		}
	}

	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		if (__timeline != null)
		{
			__timeline.__enterFrame(deltaTime);
		}

		for (child in __children)
		{
			child.__enterFrame(deltaTime);
		}
	}

	@:noCompletion private override function __stopAllMovieClips():Void
	{
		super.__stopAllMovieClips();
		stop();
	}

	@:noCompletion private override function __tabTest(stack:Array<InteractiveObject>):Void
	{
		if (!__enabled) return;
		super.__tabTest(stack);
	}

	// Event Handlers
	@:noCompletion private function __onMouseDown(event:MouseEvent):Void
	{
		if (__enabled && __hasDown)
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

		if (!__buttonMode)
		{
			return;
		}

		if (event.target == this && __enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
		else if (__enabled && __hasUp)
		{
			gotoAndStop("_up");
		}
	}

	@:noCompletion private function __onRollOut(event:MouseEvent):Void
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

	@:noCompletion private function __onRollOver(event:MouseEvent):Void
	{
		if (__enabled && __hasOver)
		{
			gotoAndStop("_over");
		}
	}

	// Getters & Setters
	@:noCompletion private override function set_buttonMode(value:Bool):Bool
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

	@:noCompletion private function get_currentFrame():Int
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

	@:noCompletion private function get_currentFrameLabel():String
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

	@:noCompletion private function get_currentLabel():String
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

	@:noCompletion private function get_currentLabels():Array<FrameLabel>
	{
		if (__timeline != null)
		{
			return __timeline.__currentLabels.copy();
		}
		else
		{
			return [];
		}
	}

	@:noCompletion private function get_currentScene():Scene
	{
		if (__timeline != null)
		{
			return __timeline.__currentScene;
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

	@:noCompletion private function get_enabled():Bool
	{
		return __enabled;
	}

	@:noCompletion private function set_enabled(value:Bool):Bool
	{
		return __enabled = value;
	}

	@:noCompletion private function get_framesLoaded():Int
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

	@:noCompletion private function get_isPlaying():Bool
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

	@:noCompletion private function get_scenes():Array<Scene>
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

	@:noCompletion private function get_totalFrames():Int
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
typedef MovieClip = flash.display.MovieClip;
#end
