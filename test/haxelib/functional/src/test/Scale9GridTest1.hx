package test;

import haxe.Timer;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.MovieClip;
import openfl.utils.Assets;
import openfl.events.Event;

class Scale9GridTest1 extends FunctionalTest
{
	private var buttons:Array<MovieClip> = [];

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		var movieClip = Assets.getMovieClip("scale9Grid:Frame");
		movieClip.x = 100;
		movieClip.y = 100;
		movieClip.width = 400;
		movieClip.height = 300;
		content.addChild(movieClip);

		buttons.push(Assets.getMovieClip("scale9Grid:ButtonPrimary"));
		buttons.push(Assets.getMovieClip("scale9Grid:ButtonSecondary"));

		for (i in 0...buttons.length)
		{
			var button = buttons[i];
			button.x = 600;
			button.y = 100 + (i * 50);
			button.width = 128;
			button.height = 32;
			content.addChild(button);
		}
		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
		buttons = [];
	}

	private function update(e:Event):Void
	{
		var sinT = Math.sin(Timer.stamp());
		for (i in 0...buttons.length)
		{
			var button = buttons[i];
			button.width = 128 + sinT * 32;
		}
	}
}
