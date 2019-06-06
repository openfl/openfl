package flash.display;

import openfl._internal.formats.swf.SWFLite;
import openfl._internal.renderer.flash.FlashRenderer;
import openfl._internal.symbols.timeline.Timeline;
import openfl._internal.symbols.SpriteSymbol;
import openfl.events.Event;
import openfl.utils.Object;
import openfl.Lib;

#if flash
extern class MovieClip extends Sprite #if openfl_dynamic implements Dynamic #end
{
	@:noCompletion public static var __initSWF:SWFLite;
	@:noCompletion public static var __initSymbol:SpriteSymbol;
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
	@:noCompletion private var __timeline:Timeline;

	public function new()
	{
		super();

		__cacheTime = Lib.getTimer();

		if (MovieClip.__initSymbol != null)
		{
			var swf = MovieClip.__initSWF;
			var symbol = MovieClip.__initSymbol;

			MovieClip.__initSWF = null;
			MovieClip.__initSymbol = null;

			__timeline = new Timeline(this, swf, symbol);
			FlashRenderer.register(this);
		}
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
		__timeline.__enterFrame(deltaTime);
	}
}
#else
typedef MovieClip = openfl.display.MovieClip;
#end
