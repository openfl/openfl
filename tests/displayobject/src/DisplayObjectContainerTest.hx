package;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Point;
import utest.Assert;
import utest.Test;

class DisplayObjectContainerTest extends Test
{
	public function test_addChild()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();

		sprite.addChild(sprite2);

		Assert.equals(1, sprite.numChildren);
		Assert.equals(sprite2, cast sprite.getChildAt(0));

		var sprite3 = new Sprite();

		sprite.addChild(sprite3);

		Assert.equals(2, sprite.numChildren);
		Assert.equals(0, sprite.getChildIndex(sprite2));
		Assert.equals(1, sprite.getChildIndex(sprite3));

		sprite.addChild(sprite2);

		Assert.equals(0, sprite.getChildIndex(sprite3));
		Assert.equals(1, sprite.getChildIndex(sprite2));

		sprite2.addChild(sprite3);

		Assert.equals(sprite3.parent, sprite2);
	}

	public function test_addChildAt()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();

		sprite.addChildAt(sprite2, 0);

		Assert.equals(1, sprite.numChildren);
		Assert.equals(sprite2, cast sprite.getChildAt(0));

		var sprite3 = new Sprite();

		sprite.addChildAt(sprite3, 1);

		Assert.equals(2, sprite.numChildren);
		Assert.equals(0, sprite.getChildIndex(sprite2));
		Assert.equals(1, sprite.getChildIndex(sprite3));

		sprite.addChildAt(sprite2, 0);

		Assert.equals(0, sprite.getChildIndex(sprite2));
		Assert.equals(1, sprite.getChildIndex(sprite3));

		sprite.addChildAt(sprite2, 1);

		Assert.equals(0, sprite.getChildIndex(sprite3));
		Assert.equals(1, sprite.getChildIndex(sprite2));
	}

	public function test_areInaccessibleObjectsUnderPoint()
	{
		var sprite = new Sprite();
		Assert.isFalse(sprite.areInaccessibleObjectsUnderPoint(new Point()));
		Assert.isFalse(sprite.areInaccessibleObjectsUnderPoint(new Point(100.0, 100.0)));
	}

	public function test_contains()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();

		Assert.isTrue(sprite.contains(sprite));
		Assert.isFalse(sprite.contains(sprite2));

		sprite.addChild(sprite2);

		Assert.isTrue(sprite.contains(sprite2));

		var sprite3 = new Sprite();
		var sprite4 = new Sprite();

		sprite3.addChild(sprite4);
		sprite.addChild(sprite3);

		Assert.isTrue(sprite.contains(sprite3));
		Assert.isTrue(sprite.contains(sprite4));
		Assert.isFalse(sprite3.contains(sprite));
		Assert.isFalse(sprite4.contains(sprite));

		sprite.removeChild(sprite3);
		sprite.removeChild(sprite2);

		Assert.isFalse(sprite.contains(sprite2));
		Assert.isFalse(sprite.contains(sprite3));
		Assert.isFalse(sprite.contains(sprite4));
	}

	public function test_getChildAt()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();

		sprite.addChild(sprite2);

		Assert.equals(sprite2, cast sprite.getChildAt(0));

		var sprite3 = new Sprite();
		sprite.addChild(sprite3);

		Assert.equals(sprite3, cast sprite.getChildAt(1));

		sprite2.addChild(sprite3);

		Assert.equals(sprite3, cast sprite2.getChildAt(0));

		// try
		// {
		// 	sprite.getChildAt(2);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	public function test_getChildByName()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite2.name = "a";
		sprite3.name = "a";

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);

		Assert.isNull(sprite.getChildByName("b"));
		Assert.equals(sprite2, cast sprite.getChildByName("a"));

		sprite3.name = "b";

		Assert.equals(sprite3, cast sprite.getChildByName("b"));
	}

	public function test_getChildIndex()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);

		Assert.equals(0, sprite.getChildIndex(sprite2));
		Assert.equals(1, sprite.getChildIndex(sprite3));

		// try
		// {
		// 	sprite2.getChildIndex(sprite3);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	#if (cpp || neko) // TODO: works but sometimes suffers from a race condition when run immediately
	public function test_getObjectsUnderPoint()
	{
		var sprite = new Sprite();

		var sprite2 = new Sprite();
		sprite2.graphics.beginFill(0xFF0000);
		sprite2.graphics.drawRect(0, 0, 100, 100);
		sprite.addChild(sprite2);

		Assert.equals(sprite2, sprite.getObjectsUnderPoint(new Point(10, 10))[0]);
		Assert.equals(0, sprite.getObjectsUnderPoint(new Point()).length);

		sprite.removeChild(sprite2);

		Assert.equals(0, sprite.getObjectsUnderPoint(new Point()).length);
	}
	#end

	public function test_removeChild()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);
		sprite.removeChild(sprite2);
		sprite.removeChild(sprite3);

		Assert.equals(0, sprite.numChildren);

		// try
		// {
		// 	sprite.removeChild(sprite2);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	public function test_removeChildAt()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);
		sprite.removeChildAt(0);
		sprite.removeChildAt(0);

		Assert.equals(0, sprite.numChildren);

		// try
		// {
		// 	sprite.removeChildAt(0);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	public function test_removeChildrenDefaults()
	{
		var container = new Sprite();

		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		container.addChild(sprite);
		container.addChild(sprite2);
		container.addChild(sprite3);

		container.removeChildren();

		Assert.equals(0, container.numChildren);
	}

	public function test_removeChildren()
	{
		var container = new Sprite();

		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		container.addChild(sprite);
		container.addChild(sprite2);
		container.addChild(sprite3);

		// remove first
		container.removeChildren(0, 0);

		Assert.equals(2, container.numChildren);
		Assert.equals(sprite2, container.getChildAt(0));
		Assert.equals(sprite3, container.getChildAt(1));

		// remove last
		container.removeChildren(1, 1);

		Assert.equals(1, container.numChildren);
		Assert.equals(sprite2, container.getChildAt(0));

		container.removeChildren(0);

		Assert.equals(0, container.numChildren);
	}

	public function test_removeChildrenRangeError()
	{
		var container = new Sprite();

		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		container.addChild(sprite);
		container.addChild(sprite2);
		container.addChild(sprite3);

		Assert.raises(function():Void
		{
			container.removeChildren(0, 100);
		}, RangeError);
	}

	public function test_setChildIndex()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);

		sprite.setChildIndex(sprite3, 0);

		Assert.equals(0, sprite.getChildIndex(sprite3));

		sprite.setChildIndex(sprite2, 0);

		Assert.equals(0, sprite.getChildIndex(sprite2));

		// try
		// {
		// 	sprite.removeChild(sprite2);
		// 	sprite.setChildIndex(sprite2, 0);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	public function test_stopAllMovieClips()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.stopAllMovieClips;

		Assert.notNull(exists);
	}

	public function test_swapChildren()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);

		sprite.swapChildren(sprite2, sprite3);

		Assert.equals(0, sprite.getChildIndex(sprite3));
		Assert.equals(1, sprite.getChildIndex(sprite2));

		// try
		// {
		// 	sprite.removeChild(sprite2);
		// 	sprite.swapChildren(sprite2, sprite3);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	public function test_swapChildrenAt()
	{
		var sprite = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();

		sprite.addChild(sprite2);
		sprite.addChild(sprite3);

		sprite.swapChildrenAt(0, 1);

		Assert.equals(0, sprite.getChildIndex(sprite3));
		Assert.equals(1, sprite.getChildIndex(sprite2));

		// try
		// {
		// 	sprite.removeChild(sprite2);
		// 	sprite.swapChildrenAt(0, 1);
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	// Properties
	public function test_mouseChildren()
	{
		var sprite = new Sprite();
		Assert.isTrue(sprite.mouseChildren);
		sprite.mouseChildren = false;
		Assert.isFalse(sprite.mouseChildren);
	}

	public function test_numChildren()
	{
		var sprites = [];

		for (i in 0...4)
		{
			sprites.push(new Sprite());
		}

		Assert.equals(0, sprites[0].numChildren);

		for (i in 1...4)
		{
			sprites[0].addChild(sprites[i]);
			Assert.equals(i, sprites[0].numChildren);
		}

		for (i in 1...4)
		{
			sprites[0].removeChild(sprites[i]);
			Assert.equals(3 - i, sprites[0].numChildren);
		}
	}

	public function test_tabChildren()
	{
		var sprite = new Sprite();
		Assert.isTrue(sprite.tabChildren);
		sprite.tabChildren = false;
		Assert.isFalse(sprite.tabChildren);
	}

	public function test_addedToStageEvent()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping addedToStage event test");
			return;
		}

		var sprite1 = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();
		var sprite4 = new Sprite();

		openfl.Lib.current.addChild(sprite1);
		openfl.Lib.current.addChild(sprite2);

		var addedToStageCount = 0;
		sprite3.addEventListener(Event.ADDED_TO_STAGE, function(event:Event):Void
		{
			addedToStageCount++;
		});

		Assert.equals(0, addedToStageCount);

		sprite1.addChild(sprite3);
		Assert.equals(1, addedToStageCount);

		sprite1.removeChild(sprite3);
		Assert.equals(1, addedToStageCount);

		sprite1.addChild(sprite3);
		Assert.equals(2, addedToStageCount);

		sprite2.addChild(sprite3);
		Assert.equals(3, addedToStageCount);

		sprite2.addChild(sprite4);
		// when sprite3.parent == sprite2, adding it again to sprite2 does not
		// dispatch events. it is more like calling setChildIndex()
		sprite2.addChild(sprite3);
		Assert.equals(3, addedToStageCount);

		openfl.Lib.current.removeChild(sprite1);
		openfl.Lib.current.removeChild(sprite2);
	}

	public function test_removedFromStageEvent()
	{
		if (openfl.Lib.current == null || openfl.Lib.current.stage == null)
		{
			Assert.pass("Skipping removedFromStage event test");
			return;
		}

		var sprite1 = new Sprite();
		var sprite2 = new Sprite();
		var sprite3 = new Sprite();
		var sprite4 = new Sprite();

		openfl.Lib.current.addChild(sprite1);
		openfl.Lib.current.addChild(sprite2);

		var removedFromStageCount = 0;
		sprite3.addEventListener(Event.REMOVED_FROM_STAGE, function(event:Event):Void
		{
			removedFromStageCount++;
		});

		Assert.equals(0, removedFromStageCount);

		sprite1.addChild(sprite3);
		Assert.equals(0, removedFromStageCount);

		sprite1.removeChild(sprite3);
		Assert.equals(1, removedFromStageCount);

		sprite1.addChild(sprite3);
		Assert.equals(1, removedFromStageCount);

		// when sprite3.parent sprite1, adding it to sprite2 without manually
		// removing it from sprite1 will automatically remove it from sprite1
		sprite2.addChild(sprite3);
		Assert.equals(2, removedFromStageCount);

		sprite2.addChild(sprite4);
		// when sprite3.parent == sprite2, adding it again to sprite2 does not
		// dispatch events. it is more like calling setChildIndex()
		sprite2.addChild(sprite3);
		Assert.equals(2, removedFromStageCount);

		openfl.Lib.current.removeChild(sprite1);
		openfl.Lib.current.removeChild(sprite2);
	}
}
