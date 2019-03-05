package test;

import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.ColorTransform;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.utils.Assets;

/**
 * Class: CacheBitmapTest3
 *
 *
 * This test renders a loosely simulated version of an app screen.
 * It then slides this screen across the screen with and without
 * cacheAsBitmap enabled to check the speed and visual correctness.
 *
 */
class CacheBitmapTest3 extends FunctionalTest
{
	private static var menuStrings = [
		"Lady and the Tramp",
		"The Adventures of Milo and Otis",
		"Mary Poppins",
		"Charlotte's Web",
		"The Secret World of Arrietty",
		"Babe",
		"It's a Wonderful Life",
		"Bringing Up Baby",
		"It Happened One Night"
	];
	private static var lastTime:Float;
	private static var menuObject:Sprite;
	private static var menuX:Int;
	private static var menuXInc:Int;
	private static var posters:Sprite;
	private static var status:TextField;

	public function new()
	{
		super();
	}

	private function pos(i:Float):Float
	{
		return (i * contentHeight) / 720;
	}

	public override function start():Void
	{
		content = new Sprite();

		content.graphics.beginFill(0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);
		content.graphics.endFill();

		menuX = 0;
		menuXInc = 5;

		posters = new Sprite();

		var image = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
		image.scaleX = pos(1.0);
		image.scaleY = pos(1.0);
		posters.addChild(image);

		image = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
		image.alpha = 0.5;
		image.x = pos(125);
		image.scaleX = pos(1.0);
		image.scaleY = pos(1.0);
		posters.addChild(image);

		image = new Bitmap(Assets.getBitmapData("assets/openfl.png"));
		image.x = pos(250);
		image.scaleX = pos(1.0);
		image.scaleY = pos(1.0);
		image.transform.colorTransform = new ColorTransform(1, 0, 1, 1);
		posters.addChild(image);

		content.addChild(posters);

		var bigTextFormat = new TextFormat("_sans", Std.int(pos(44)), 0, false);
		bigTextFormat.align = TextFormatAlign.LEFT;

		menuObject = new Sprite();

		// Blue rectangle background
		menuObject.graphics.beginFill(0xFF22FF);
		menuObject.graphics.drawRect(pos(109), pos(186), pos(1171), pos(572));

		var text = new TextField();
		text.antiAliasType = AntiAliasType.ADVANCED;
		text.gridFitType = GridFitType.SUBPIXEL;
		text.selectable = false;
		text.defaultTextFormat = bigTextFormat;
		text.x = pos(109);
		text.y = pos(186);
		text.autoSize = TextFieldAutoSize.LEFT;
		text.textColor = 0xe8c343;
		text.text = "My Collection";
		menuObject.addChild(text);
		menuObject.cacheAsBitmap = true;

		var normalTextFormat = new TextFormat("_sans", Std.int(pos(28)), 0, false);
		normalTextFormat.align = TextFormatAlign.LEFT;

		var y = 291;
		for (m in menuStrings)
		{
			text = new TextField();
			text.selectable = false;
			text.defaultTextFormat = normalTextFormat;
			text.x = pos(109);
			text.y = pos(y);
			text.autoSize = TextFieldAutoSize.LEFT;
			text.textColor = 0xffffff;
			text.text = m;
			menuObject.addChild(text);
			y += 44;
		}

		content.addChild(menuObject);

		status = new TextField();
		status.antiAliasType = AntiAliasType.ADVANCED;
		status.gridFitType = GridFitType.SUBPIXEL;
		status.selectable = false;
		status.defaultTextFormat = normalTextFormat;
		status.x = 0;
		status.y = 0;
		status.autoSize = TextFieldAutoSize.LEFT;
		status.textColor = 0xe8c343;
		status.text = "CacheAsBitmap: ";

		if (menuObject.cacheAsBitmap)
		{
			status.text += "TRUE";
		}
		else
		{
			status.text += "FALSE";
		}

		content.addChild(status);

		lastTime = Timer.stamp();

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
	}

	private function update(e:Event):Void
	{
		var timeNow = Timer.stamp();

		menuX += Std.int(pos(menuXInc));
		if ((menuX <= 0) || (menuX >= 640))
		{
			menuXInc = -menuXInc;

			lastTime = timeNow;
			menuObject.cacheAsBitmap = !menuObject.cacheAsBitmap;
			status.text = "CacheAsBitmap: ";

			if (menuObject.cacheAsBitmap)
			{
				status.text += "TRUE";
			}
			else
			{
				status.text += "FALSE";
			}
		}

		posters.x = menuX;
		menuObject.x = menuX;
		menuObject.alpha = (pos(640) - menuX) / pos(640);
		posters.alpha = menuObject.alpha;
	}
}
