package flash.display;

#if flash
import openfl.display._internal.FlashRenderer;
import openfl.display.Timeline;
import openfl.events.MouseEvent;
import openfl.utils.Object;

extern class MovieClip extends Sprite #if openfl_dynamic implements Dynamic #end
{
	@:noCompletion public static var __constructor:MovieClip->Void;

	#if (haxe_ver < 4.3)
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
	public var trackAsMenu:Bool;
	#else
	@:flash.property var currentFrame(get, never):Int;
	@:flash.property @:require(flash10) var currentFrameLabel(get, never):String;
	@:flash.property var currentLabel(get, never):String;
	@:flash.property var currentLabels(get, never):Array<FrameLabel>;
	@:flash.property var currentScene(get, never):Scene;
	@:flash.property var enabled(get, set):Bool;
	@:flash.property var framesLoaded(get, never):Int;
	@:flash.property @:require(flash11) var isPlaying(get, never):Bool;
	@:flash.property var scenes(get, never):Array<Scene>;
	@:flash.property var totalFrames(get, never):Int;
	@:flash.property var trackAsMenu(get, set):Bool;
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

	#if (haxe_ver >= 4.3)
	private function get_currentFrame():Int;
	private function get_currentFrameLabel():String;
	private function get_currentLabel():String;
	private function get_currentLabels():Array<FrameLabel>;
	private function get_currentScene():Scene;
	private function get_enabled():Bool;
	private function get_framesLoaded():Int;
	private function get_isPlaying():Bool;
	private function get_scenes():Array<Scene>;
	private function get_totalFrames():Int;
	private function get_trackAsMenu():Bool;
	private function set_enabled(value:Bool):Bool;
	private function set_trackAsMenu(value:Bool):Bool;
	#end
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
	@:noCompletion #if (haxe_ver >= 4.3) override #else @:setter(buttonMode) #end private function set_buttonMode(value:Bool):#if (haxe_ver >= 4.3) Bool #else Void #end
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

			#if (haxe_ver >= 4.3)
			return super.buttonMode = value;
			#else
			this.buttonMode = value;
			#end
		}
		#if (haxe_ver >= 4.3)
		return this.buttonMode;
		#end
	}

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(currentFrame) #end private function get_currentFrame():Int
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(currentFrameLabel) #end private function get_currentFrameLabel():String
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(currentLabel) #end private function get_currentLabel():String
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(currentLabels) #end private function get_currentLabels():Array<FrameLabel>
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(currentScene) #end private function get_currentScene():Scene
	{
		if (__timeline != null)
		{
			return __timeline.__currentScene;
		}
		else
		{
			#if (haxe_ver >= 4.3)
			return super.currentScene;
			#else
			return this.currentScene;
			#end
		}
	}

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(framesLoaded) #end private function get_framesLoaded():Int
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(isPlaying) #end private function get_isPlaying():Bool
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(scenes) #end private function get_scenes():Array<Scene>
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

	@:noCompletion #if (haxe_ver >= 4.3) override #else @:getter(totalFrames) #end private function get_totalFrames():Int
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
