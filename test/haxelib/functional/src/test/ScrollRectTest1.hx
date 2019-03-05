package test;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.GridFitType;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.text.TextFieldAutoSize;
import openfl.utils.Assets;

/**
 * Class: ScrollRectTest1
 *
 * This test renders a long text field and uses a scroll rect to
 * scroll in the list. Also inside this scroll rect is an image
 * of an owl, which is in it's own scroll rect that is moving back
 * and forth. Both of these are wrapped in a full screen scroll
 * rect that is moving in a circle, the speed a size of which
 * are controlled with the variables defined at the top of the
 * class.
 *
 */
class ScrollRectTest1 extends FunctionalTest
{
	private static var FRAMES_PER_ROTATION:Int = 200;
	private static var RADIUS:Int = 120;

	private var inc:Int;
	private var outerAngle:Float;
	private var outerInc:Float;
	private var outerRect:Rectangle;
	private var outerSprite:Sprite;
	private var owlRect:Rectangle;
	private var owlSprite:Sprite;
	private var status:TextField;
	private var textField:TextField;
	private var textRect:Rectangle;
	private var textSprite:Sprite;

	public function new()
	{
		super();
	}

	public override function start():Void
	{
		content = new Sprite();

		inc = 5;
		outerInc = 2 * Math.PI / FRAMES_PER_ROTATION;
		outerAngle = 0;

		var owlData = Assets.getBitmapData("assets/OwlAlpha.png");
		owlSprite = new Sprite();
		owlSprite.graphics.beginBitmapFill(owlData);
		owlSprite.graphics.drawRect(0, 0, owlData.width, owlData.height);
		owlSprite.graphics.endFill();

		owlRect = new Rectangle(0, 300, 200, 250); // just the eyes
		owlSprite.scrollRect = textRect;

		var normalTextFormat = new TextFormat("_sans", 28, 0, false);
		normalTextFormat.align = TextFormatAlign.LEFT;

		textField = new TextField();
		textField.antiAliasType = AntiAliasType.ADVANCED;
		textField.gridFitType = GridFitType.SUBPIXEL;
		textField.defaultTextFormat = normalTextFormat;
		textField.width = 1280;
		textField.height = 2000;
		textField.textColor = 0xe8c343;
		textField.selectable = false;
		textField.multiline = true;
		textField.wordWrap = false;
		// IMDB top 20 movies
		textField
			.text = "The Shawshank Redemption (1994)\nThe Godfather (1972)\nThe Godfather: Part II (1974)\nPulp Fiction (1994)\nThe Good, the Bad and the Ugly (1966)\nThe Dark Knight (2008)\n12 Angry Men (1957)\nSchindler's List (1993)\nThe Lord of the Rings: The Return of the Kind (2003)\nFight Club (1999)\nStar Wars: Episode V - The Empire Strikes Back (1980)\nThe Lord of the Rings: The Fellowship of the Ring (2001)\nOne Flew Over the Cuckoo's Next (1975)\nGoodfellas (1990)\nSeven Samurai (1954)\nInception (2010)\nStar Wars: Episode IV - A New Hope (1977)\nForrest Gump (1994)\nThe Matrix (1999)\nThe Lord of the Rings: The Two Towers (2002)";

		textSprite = new Sprite();

		textSprite.addChild(textField);
		owlSprite.x = 100;
		owlSprite.y = 630;
		textSprite.addChild(owlSprite);

		textSprite.x = 300;
		textSprite.y = 350;
		textRect = new Rectangle(0, 0, 400, 300);
		textSprite.scrollRect = textRect;

		outerSprite = new Sprite();
		// Draw a border where the text area is because without it,
		// it's a little hard for our eyes/brain to process what's
		// moving where here.
		outerSprite.graphics.beginFill(0xe8c343);
		outerSprite.graphics.drawRect(textSprite.x - 2, textSprite.y - 2, textRect.width + 4, 2);
		outerSprite.graphics.endFill();
		outerSprite.graphics.beginFill(0xe8c343);
		outerSprite.graphics.drawRect(textSprite.x - 2, textSprite.y - 2, 2, textRect.height + 4);
		outerSprite.graphics.endFill();
		outerSprite.graphics.beginFill(0xe8c343);
		outerSprite.graphics.drawRect(textSprite.x + textRect.width, textSprite.y - 2, 2, textRect.height + 4);
		outerSprite.graphics.endFill();
		outerSprite.graphics.beginFill(0xe8c343);
		outerSprite.graphics.drawRect(textSprite.x - 2, textSprite.y + textRect.height, textRect.width + 4, 2);
		outerSprite.graphics.endFill();

		outerSprite.addChild(textSprite);
		content.addChild(outerSprite);

		outerRect = new Rectangle(0, 0, contentWidth, contentHeight);
		outerSprite.scrollRect = outerRect;

		status = new TextField();
		status.antiAliasType = AntiAliasType.ADVANCED;
		status.gridFitType = GridFitType.SUBPIXEL;
		status.selectable = false;
		status.defaultTextFormat = normalTextFormat;
		status.x = 0;
		status.y = 0;
		status.autoSize = TextFieldAutoSize.LEFT;
		status.textColor = 0xe8c343;

		textSprite.cacheAsBitmap = true;
		status.text = "CacheAsBitmap: TRUE";
		content.addChild(status);

		content.addEventListener(Event.ENTER_FRAME, update);
	}

	public override function stop():Void
	{
		content.removeEventListener(Event.ENTER_FRAME, update);
		content = null;
	}

	private function update(e:Event):Void
	{
		textRect.y += inc;

		if (textRect.y >= 550)
		{
			inc = -5;
			textSprite.cacheAsBitmap = false;
			status.text = "CacheAsBitmap: FALSE";
		}
		else if (textRect.y <= 0)
		{
			inc = 5;
			textSprite.cacheAsBitmap = true;
			status.text = "CacheAsBitmap: TRUE";
		}

		textSprite.scrollRect = textRect;

		owlRect.x += inc;
		owlSprite.scrollRect = owlRect;

		outerAngle += outerInc;
		if (outerAngle > 2 * Math.PI)
		{
			outerAngle -= 2 * Math.PI;
		}
		outerRect.x = RADIUS + RADIUS * Math.cos(outerAngle);
		outerRect.y = RADIUS + RADIUS * Math.sin(outerAngle) + ((720 - contentHeight) / 2);
		outerSprite.scrollRect = outerRect;
	}
}
