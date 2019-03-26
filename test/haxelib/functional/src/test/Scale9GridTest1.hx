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
	}

	public override function stop():Void
	{
		content = null;
	}
}
