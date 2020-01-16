package test;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.geom.Rectangle;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import openfl.ui.Keyboard;

/**
 * Class: SurfaceAllocationTest1Impl
 *
 * Pressing the following keys have the following effects:
 * - Up: Create a BitmapData object of size 100x100, add it to the scene
 * - Right: Create a BitmapData object of size 500x500, add it to the scene
 * - 1: Create a BitmapData object of size 1000x1000, add it to the scene
 * - Down: Remove the oldest 100x100 BitmapData
 * - Left: Remove the oldest 500x500 BitmapData
 * - 4: Remove the oldest 1000x1000 BitmapData
 * - 5: Rmeove all BimapData objects from the scene
 * - Enter: Force a garbage collection
 */
class SurfaceAllocationTest1 extends FunctionalTest
{
	private var children100:Array<Bitmap>;
	private var children500:Array<Bitmap>;
	private var children1000:Array<Bitmap>;
	private var nextX:Int;
	private var nextY:Int;
	private var text:TextField;

	public function new()
	{
		super();
	}

	private function addNewBitmap(child:Bitmap):Void
	{
		child.x = nextX;
		child.y = nextY;

		var red:Int = SeededRandom.random(255);
		var green:Int = SeededRandom.random(255);
		var blue:Int = SeededRandom.random(255);
		var alpha:Int = SeededRandom.random(255);

		child.bitmapData.fillRect(new Rectangle(0, 0, child.width, child.height), (alpha << 24) | (red << 16) | (green << 8) | blue);
		content.addChild(child);

		nextX += 10;
		nextY += 10;

		if ((nextX >= (contentWidth - 400)) || (nextY >= (contentHeight - 200)))
		{
			nextX = 50;
			nextY = 50;
		}
		else
		{
			nextX += 20;
			nextY += 20;
		}
	}

	public override function start():Void
	{
		content = new Sprite();

		children100 = new Array<Bitmap>();
		children500 = new Array<Bitmap>();
		children1000 = new Array<Bitmap>();

		nextX = 50;
		nextY = 50;

		content.graphics.beginFill(0);
		content.graphics.drawRect(0, 0, contentWidth, contentHeight);
		content.graphics.endFill();

		var boldTextFormat = new TextFormat("_sans", 44, 0, true);
		boldTextFormat.align = TextFormatAlign.LEFT;

		text = new TextField();
		text.antiAliasType = AntiAliasType.ADVANCED;
		text.selectable = false;
		text.defaultTextFormat = boldTextFormat;
		text.x = (contentWidth / 2) - 100;
		text.y = 50;
		text.autoSize = TextFieldAutoSize.LEFT;
		text.textColor = 0xffffff;
		content.addChild(text);

		text.text = "0x100, 0x500, 0x1000";

		stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
	}

	public override function stop():Void
	{
		children100 = null;
		children500 = null;
		children1000 = null;

		stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
		content = null;
	}

	private function onKey(event:KeyboardEvent):Void
	{
		if (children100 == null) return;

		var extra:String = "";

		switch (event.keyCode)
		{
			case Keyboard.UP:
				var child = new Bitmap(new BitmapData(100, 100));
				children100.push(child);
				addNewBitmap(child);

			case Keyboard.RIGHT:
				var child = new Bitmap(new BitmapData(500, 500));
				children500.push(child);
				addNewBitmap(child);

			case Keyboard.NUMBER_1:
				var child = new Bitmap(new BitmapData(1000, 1000));
				children1000.push(child);
				addNewBitmap(child);

			case Keyboard.DOWN:
				if (children100.length > 0)
				{
					var child = children100[0];
					content.removeChild(child);
				}
				children100.shift();

			case Keyboard.LEFT:
				if (children500.length > 0)
				{
					var child = children500[0];
					content.removeChild(child);
				}
				children500.shift();

			case Keyboard.NUMBER_4:
				if (children1000.length > 0)
				{
					var child = children1000[0];
					content.removeChild(child);
				}
				children1000.shift();

			case Keyboard.NUMBER_5:
				for (child in children100)
				{
					content.removeChild(child);
				}
				for (child in children500)
				{
					content.removeChild(child);
				}
				for (child in children1000)
				{
					content.removeChild(child);
				}
				children100 = new Array<Bitmap>();
				children500 = new Array<Bitmap>();
				children1000 = new Array<Bitmap>();

			#if cpp
			case Keyboard.ENTER:
				cpp.vm.Gc.run(true);
				extra = " *";
			#end

			default:
		}

		text.text = ("" + children100.length + "x100, " + children500.length + "x500, " + children1000.length + "x1000" + extra);
	}
}
