package test;

import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.utils.Assets;

class Scale9GridTest1 extends FunctionalTest
{
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

		var button1 = Assets.getMovieClip("scale9Grid:ButtonPrimary");
		button1.x = 600;
		button1.y = 100;
		button1.width = 128;
		button1.height = 32;
		content.addChild(button1);

		var button2 = Assets.getMovieClip("scale9Grid:ButtonSecondary");
		button2.x = 600;
		button2.y = 200;
		button2.width = 128;
		button2.height = 32;
		content.addChild(button2);
	}

	public override function stop():Void
	{
		content = null;
	}
}
