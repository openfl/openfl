package;

import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.events.EventPhase;
import openfl.geom.Point;
import utest.Assert;
import utest.Test;

@:access(openfl.events.Event)
@:access(openfl.display.DisplayObject)
class DisplayObjectContainerTest extends Test
{
	// The update a render starts with leaves the children of an invisible container out
	public function test_updateOfInvisibleContainer()
	{
		var root = new Sprite();
		var hidden = new Sprite();
		var child = new Sprite();
		var leaf = new Sprite();
		child.x = 10;
		leaf.y = 5;
		root.addChild(hidden);
		hidden.addChild(child);
		child.addChild(leaf);
		root.__update(false, true);

		Assert.equals(10, child.__worldTransform.tx);

		hidden.visible = false;
		root.x = 100;
		root.__update(false, true);

		Assert.isFalse(hidden.__renderable);
		Assert.equals(100, hidden.__worldTransform.tx);
		// left as they were, to be computed when asked for
		Assert.equals(10, child.__worldTransform.tx);
		Assert.isTrue(child.__worldTransformInvalid);
		Assert.isTrue(leaf.__worldTransformInvalid);

		var global = leaf.localToGlobal(new Point());
		Assert.equals(110, global.x);
		Assert.equals(5, global.y);

		// moved again after its transforms were asked for
		root.x = 200;
		root.__update(false, true);
		global = leaf.localToGlobal(new Point());
		Assert.equals(210, global.x);

		hidden.x = 1;
		global = child.localToGlobal(new Point());
		Assert.equals(211, global.x);

		hidden.visible = true;
		root.__update(false, true);

		Assert.isTrue(leaf.__renderable);
		Assert.equals(211, leaf.__worldTransform.tx);
		Assert.equals(5, leaf.__worldTransform.ty);
		Assert.isFalse(leaf.__worldTransformInvalid);
	}

	// A mask is drawn whatever its visibility and that of its children, wherever it is in the display list
	public function test_updateOfMaskBelowInvisibleContainer()
	{
		var root = new Sprite();
		var target = new Sprite();
		var hidden = new Sprite();
		var holder = new Sprite();
		var mask = new Sprite();
		var part = new Sprite();
		var shape = new Sprite();
		root.addChild(target);
		root.addChild(hidden);
		hidden.addChild(holder);
		holder.addChild(mask);
		mask.addChild(part);
		part.addChild(shape);
		target.mask = mask;
		root.__update(false, true);

		hidden.visible = false;
		part.visible = false;
		holder.x = 30;
		shape.y = 7;
		root.__update(false, true);

		Assert.equals(30, mask.__worldTransform.tx);
		Assert.equals(30, shape.__worldTransform.tx);
		Assert.equals(7, shape.__worldTransform.ty);

		root.x = 100;
		root.__update(false, true);

		Assert.equals(130, mask.__worldTransform.tx);
		Assert.equals(130, shape.__worldTransform.tx);
	}

	// BitmapData.draw() updates its source alone, from a parent that may be out of date
	public function test_updateOfDrawnSourceBelowInvisibleContainer()
	{
		var root = new Sprite();
		var hidden = new Sprite();
		var holder = new Sprite();
		var source = new Sprite();
		source.graphics.beginFill(0xFF0000);
		source.graphics.drawRect(0, 0, 10, 10);
		source.graphics.endFill();
		source.x = 3;
		root.addChild(hidden);
		hidden.addChild(holder);
		holder.addChild(source);
		hidden.visible = false;
		root.__update(false, true);

		root.x = 50;
		root.__update(false, true);

		var bitmapData = new BitmapData(20, 20, true, 0);
		bitmapData.draw(source);

		Assert.equals(0xFFFF0000, bitmapData.getPixel32(5, 5));
		Assert.equals(53, source.localToGlobal(new Point()).x);
	}

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
		var sprites:Array<Sprite> = [];

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

	public function test_getBoundsWithScale0Child()
	{
		var sprite = new Sprite();
		var child = new Sprite();
		child.graphics.beginFill(0xFF0000);
		child.graphics.drawRect(0, 0, 150, 100);
		sprite.addChild(child);

		var bounds = sprite.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(150, bounds.width);
		Assert.equals(100, bounds.height);

		child.scaleX = 0.0;

		bounds = sprite.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(0, bounds.width);
		Assert.equals(100, bounds.height);

		child.scaleX = 1.0;
		child.scaleY = 0.0;

		bounds = sprite.getBounds(sprite);
		Assert.equals(0, bounds.x);
		Assert.equals(0, bounds.y);
		Assert.equals(150, bounds.width);
		Assert.equals(0, bounds.height);
	}

	public function test_dispatchEventPhasesWithBubbling()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatch event phases with bubbling test");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured = false;
		var dispatchedToTarget = false;
		var bubbled = false;
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(bubbled);
			bubbled = true;
			Assert.isTrue(captured);
			Assert.isTrue(dispatchedToTarget);
			Assert.notEquals(childSprite, parentSprite);
			Assert.equals(childSprite, event.target);
			Assert.equals(parentSprite, event.currentTarget);
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled);
			Assert.notEquals(childSprite, parentSprite);
			Assert.equals(childSprite, event.target);
			Assert.equals(parentSprite, event.currentTarget);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled);
			Assert.equals(childSprite, event.target);
			Assert.equals(childSprite, event.currentTarget);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
		});

		childSprite.dispatchEvent(new Event(eventType, true, false));

		Assert.isTrue(dispatchedToTarget);
		Assert.isTrue(bubbled);
		Assert.isTrue(captured);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventPhasesWithoutBubbling()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatch event phases without bubbling test");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured = false;
		var dispatchedToTarget = false;
		var bubbled = false;
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(bubbled);
			bubbled = true;
			Assert.isTrue(captured);
			Assert.isTrue(dispatchedToTarget);
			Assert.notEquals(childSprite, parentSprite);
			Assert.equals(childSprite, event.target);
			Assert.equals(parentSprite, event.currentTarget);
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled);
			Assert.notEquals(childSprite, parentSprite);
			Assert.equals(childSprite, event.target);
			Assert.equals(parentSprite, event.currentTarget);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled);
			Assert.equals(childSprite, event.target);
			Assert.equals(childSprite, event.currentTarget);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
		});

		childSprite.dispatchEvent(new Event(eventType, false, false));

		Assert.isTrue(dispatchedToTarget);
		Assert.isFalse(bubbled);
		Assert.isTrue(captured);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithCancelableEventAndPreventDefaultCall()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with cancelable and preventDefault() test");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isTrue(event.isDefaultPrevented());
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(event.isDefaultPrevented());
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the AT_TARGET because it was added first.
			Assert.isFalse(event.isDefaultPrevented());
			event.preventDefault();
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called second in the AT_TARGET because it was added second.
			Assert.isTrue(event.isDefaultPrevented());
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		Assert.isTrue(event.isDefaultPrevented());
		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithCancelableEventAndNoPreventDefaultCall()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with cancelable and no preventDefault() test");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(event.isDefaultPrevented());
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.isFalse(event.isDefaultPrevented());
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the AT_TARGET because it was added first.
			Assert.isFalse(event.isDefaultPrevented());
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called second in the AT_TARGET because it was added second.
			Assert.isFalse(event.isDefaultPrevented());
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		Assert.isFalse(event.isDefaultPrevented());
		// successful because preventDefault() was not called
		Assert.isTrue(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithStopPropagationInAtTargetPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with stopPropagation() in AT_TARGET phase");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured = false;
		var bubbled = false;
		var dispatchedToTarget1 = false;
		var dispatchedToTarget2 = false;

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() in the AT_TARGET phase means that no listeners
			// in the BUBBLING_PHASE phase will be called.
			Assert.isFalse(bubbled);
			bubbled = true;
			Assert.fail();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() in the AT_TARGET phase is after the
			// CAPTURING_PHASE, so this listener will be called normally.
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget1);
			Assert.isFalse(dispatchedToTarget2);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the AT_TARGET because it was added first.
			Assert.isFalse(dispatchedToTarget1);
			Assert.isFalse(dispatchedToTarget2);
			dispatchedToTarget1 = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
			event.stopPropagation();
		});
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() does not stop the current phase, so this
			// listener will be called.
			// listeners without priority are called in order, so this listener
			// is called second in the AT_TARGET phase because it was added
			// second.
			Assert.isTrue(dispatchedToTarget1);
			Assert.isFalse(dispatchedToTarget2);
			dispatchedToTarget2 = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// successful because preventDefault() was not called
		Assert.isTrue(result);

		Assert.isTrue(captured);
		Assert.isTrue(dispatchedToTarget1);
		Assert.isTrue(dispatchedToTarget2);
		Assert.isFalse(bubbled);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithStopPropagationInCapturingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with stopPropagation() in CAPTURING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured1 = false;
		var captured2 = false;
		var bubbled = false;
		var dispatchedToTarget = false;

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() in the CAPTURING_PHASE means that no listeners
			// in the AT_TARGET or BUBBLING_PHASE phase will be called.
			Assert.isFalse(bubbled);
			bubbled = true;
			Assert.fail();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the CAPTURING_PHASE because it was added
			// first.
			Assert.isFalse(captured1);
			Assert.isFalse(captured2);
			captured1 = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
			event.stopPropagation();
		}, true);
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() does not stop the current phase, so this
			// listener will be called.
			// listeners without priority are called in order, so this listener
			// is called second in the CAPTURING_PHASE because it was added
			// second.
			Assert.isTrue(captured1);
			Assert.isFalse(captured2);
			captured2 = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() in the CAPTURING_PHASE means that no listeners
			// in the AT_TARGET or BUBBLING_PHASE will be called.
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.fail();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// successful because preventDefault() was not called
		Assert.isTrue(result);

		Assert.isTrue(captured1);
		Assert.isTrue(captured2);
		Assert.isFalse(dispatchedToTarget);
		Assert.isFalse(bubbled);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithStopPropagationInBubblingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with stopPropagation() in BUBBLING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured = false;
		var bubbled1 = false;
		var bubbled2 = false;
		var dispatchedToTarget = false;

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the BUBBLING_PHASE because it was added first.
			Assert.isFalse(bubbled1);
			Assert.isFalse(bubbled2);
			bubbled1 = true;
			Assert.isTrue(captured);
			Assert.isTrue(dispatchedToTarget);
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
			event.stopPropagation();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() does not stop the current phase, so this
			// listener will be called.
			// listeners without priority are called in order, so this listener
			// is called first in the BUBBLING_PHASE because it was added first.
			Assert.isTrue(bubbled1);
			Assert.isFalse(bubbled2);
			bubbled2 = true;
			Assert.isTrue(captured);
			Assert.isTrue(dispatchedToTarget);
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() in the BUBBLING_PHASE phase is after the
			// CAPTURING_PHASE, so this listener will be called normally.
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled1);
			Assert.isFalse(bubbled2);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopPropagation() in the BUBBLING_PHASE phase is after the
			// AT_TARGET phase, so this listener will be called normally.
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled1);
			Assert.isFalse(bubbled2);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// successful because preventDefault() was not called
		Assert.isTrue(result);

		Assert.isTrue(dispatchedToTarget);
		Assert.isTrue(bubbled1);
		Assert.isTrue(bubbled2);
		Assert.isTrue(captured);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithStopImmediatePropagationInAtTargetPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with stopImmediatePropagation() in AT_TARGET phase");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured = false;
		var bubbled = false;
		var dispatchedToTarget1 = false;
		var dispatchedToTarget2 = false;

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() in the AT_TARGET phase means that no
			// listeners in the BUBBLING_PHASE phase will be called.
			Assert.isFalse(bubbled);
			bubbled = true;
			Assert.fail();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() in the AT_TARGET phase is after the
			// CAPTURING_PHASE, so this listener will be called normally.
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget1);
			Assert.isFalse(dispatchedToTarget2);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the AT_TARGET phase because it was added
			// first.
			Assert.isFalse(dispatchedToTarget1);
			Assert.isFalse(dispatchedToTarget2);
			dispatchedToTarget1 = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
			event.stopImmediatePropagation();
		});
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() prevents this listener from being called
			Assert.isFalse(dispatchedToTarget2);
			dispatchedToTarget2 = true;
			Assert.fail();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// successful because preventDefault() was not called
		Assert.isTrue(result);

		Assert.isTrue(captured);
		Assert.isTrue(dispatchedToTarget1);
		Assert.isFalse(dispatchedToTarget2);
		Assert.isFalse(bubbled);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithStopImmediatePropagationInCapturingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with stopImmediatePropagation() in CAPTURING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured1 = false;
		var captured2 = false;
		var bubbled = false;
		var dispatchedToTarget = false;

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() in the CAPTURING_PHASE means that no
			// listeners in the AT_TARGET or BUBBLING_PHASE phase will be called.
			Assert.isFalse(bubbled);
			bubbled = true;
			Assert.fail();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the CAPTURING_PHASE because it was added
			// first.
			Assert.isFalse(captured1);
			Assert.isFalse(captured2);
			captured1 = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
			event.stopImmediatePropagation();
		}, true);
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() prevents this listener from being called
			Assert.isFalse(captured2);
			captured2 = true;
			Assert.fail();
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() in the CAPTURING_PHASE means that no
			// listeners in the AT_TARGET or BUBBLING_PHASE will be called.
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.fail();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// successful because preventDefault() was not called
		Assert.isTrue(result);

		Assert.isTrue(captured1);
		Assert.isFalse(captured2);
		Assert.isFalse(dispatchedToTarget);
		Assert.isFalse(bubbled);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithStopImmediatePropagationInBubblingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with stopImmediatePropagation() in BUBBLING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		var captured = false;
		var bubbled1 = false;
		var bubbled2 = false;
		var dispatchedToTarget = false;

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// listeners without priority are called in order, so this listener
			// is called first in the BUBBLING_PHASE because it was added first.
			Assert.isFalse(bubbled1);
			Assert.isFalse(bubbled2);
			bubbled1 = true;
			Assert.isTrue(captured);
			Assert.isTrue(dispatchedToTarget);
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
			event.stopImmediatePropagation();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() prevents this listener from being called
			Assert.isFalse(bubbled2);
			bubbled2 = true;
			Assert.fail();
		});
		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() in the BUBBLING_PHASE phase is after
			// the CAPTURING_PHASE, so this listener will be called normally.
			Assert.isFalse(captured);
			captured = true;
			Assert.isFalse(dispatchedToTarget);
			Assert.isFalse(bubbled1);
			Assert.isFalse(bubbled2);
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
		}, true);
		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			// stopImmediatePropagation() in the BUBBLING_PHASE phase is after
			// the AT_TARGET phase, so this listener will be called normally.
			Assert.isFalse(dispatchedToTarget);
			dispatchedToTarget = true;
			Assert.isTrue(captured);
			Assert.isFalse(bubbled1);
			Assert.isFalse(bubbled2);
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// successful because preventDefault() was not called
		Assert.isTrue(result);

		Assert.isTrue(captured);
		Assert.isTrue(dispatchedToTarget);
		Assert.isTrue(bubbled1);
		Assert.isFalse(bubbled2);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithPreventDefaultAndStopPropagationInAtTargetPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with preventDefault() and stopPropagation() in AT_TARGET phase");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
			event.preventDefault();
			event.stopPropagation();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithPreventDefaultAndStopPropagationInCapturingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with preventDefault() and stopPropagation() in CAPTURING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
			event.preventDefault();
			event.stopPropagation();
		}, true);

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithPreventDefaultAndStopPropagationInBubblingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with preventDefault() and stopPropagation() in BUBBLING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
			event.preventDefault();
			event.stopPropagation();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithPreventDefaultAndStopImmediatePropagationInAtTargetPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with preventDefault() and stopImmediatePropagation() in AT_TARGET phase");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		childSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.equals(EventPhase.AT_TARGET, event.eventPhase);
			event.preventDefault();
			event.stopImmediatePropagation();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithPreventDefaultAndStopImmediatePropagationInCapturingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with preventDefault() and stopImmediatePropagation() in CAPTURING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.equals(EventPhase.CAPTURING_PHASE, event.eventPhase);
			event.preventDefault();
			event.stopImmediatePropagation();
		}, true);

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	public function test_dispatchEventWithPreventDefaultAndStopImmediatePropagationInBubblingPhase()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping dispatchEvent() with preventDefault() and stopImmediatePropagation() in BUBBLING_PHASE");
			return;
		}

		var stage = Lib.current.stage;

		var parentSprite = new Sprite();
		parentSprite.x = 20.0;
		parentSprite.y = 30.0;
		Lib.current.addChild(parentSprite);

		var childSprite = new Sprite();
		childSprite.graphics.beginFill(0xff0000);
		childSprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		childSprite.graphics.endFill();
		parentSprite.addChild(childSprite);

		var eventType = "myCustomEvent";

		parentSprite.addEventListener(eventType, function(event:Event):Void
		{
			Assert.equals(EventPhase.BUBBLING_PHASE, event.eventPhase);
			event.preventDefault();
			event.stopImmediatePropagation();
		});

		var event = new Event(eventType, true, true);
		var result = childSprite.dispatchEvent(event);

		// not successful because preventDefault() was called
		Assert.isFalse(result);

		parentSprite.parent.removeChild(parentSprite);
	}

	// if any of these methods are overridden, the overrides should not be
	// called for things that happen internally.
	public function test_overrideDisplayListMethods()
	{
		var sprite = new SpriteWithCallCounts();
		sprite.addChild(new Sprite());

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		sprite.addChildAt(new Sprite(), 0);

		Assert.equals(0, sprite.addChildCallCount);
		Assert.equals(1, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		var child = new Sprite();
		sprite.addChild(child);
		sprite.removeChild(child);

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(1, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		sprite.addChild(new Sprite());
		sprite.removeChildAt(0);

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(1, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		sprite.addChild(new Sprite());
		sprite.removeChildren();

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(1, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		sprite.addChild(new Sprite());
		var numChildren:Int = sprite.numChildren;

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(1, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		sprite.addChild(new Sprite());
		sprite.getChildAt(0);

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(1, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		var child = new Sprite();
		child.name = "abc";
		sprite.addChild(child);
		sprite.getChildByName("abc");

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(1, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		var child1 = new Sprite();
		var child2 = new Sprite();
		sprite.addChild(child1);
		sprite.addChild(child2);
		sprite.setChildIndex(child1, 1);

		Assert.equals(2, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(1, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		var child1 = new Sprite();
		var child2 = new Sprite();
		sprite.addChild(child1);
		sprite.addChild(child2);
		sprite.swapChildren(child1, child2);

		Assert.equals(2, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(1, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		var child1 = new Sprite();
		var child2 = new Sprite();
		sprite.addChild(child1);
		sprite.addChild(child2);
		sprite.swapChildrenAt(0, 1);

		Assert.equals(2, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(1, sprite.swapChildrenAtCallCount);
		Assert.equals(0, sprite.containsCallCount);

		var sprite = new SpriteWithCallCounts();
		var child = new Sprite();
		sprite.addChild(child);
		sprite.contains(child);

		Assert.equals(1, sprite.addChildCallCount);
		Assert.equals(0, sprite.addChildAtCallCount);
		Assert.equals(0, sprite.removeChildCallCount);
		Assert.equals(0, sprite.removeChildAtCallCount);
		Assert.equals(0, sprite.removeChildrenCallCount);
		Assert.equals(0, sprite.numChildrenCallCount);
		Assert.equals(0, sprite.getChildAtCallCount);
		Assert.equals(0, sprite.getChildByNameCallCount);
		Assert.equals(0, sprite.setChildIndexCallCount);
		Assert.equals(0, sprite.swapChildrenCallCount);
		Assert.equals(0, sprite.swapChildrenAtCallCount);
		Assert.equals(1, sprite.containsCallCount);
	}

	// there's a similar test for EventDispatcher
	// this one also covers bubbling
	public function test_redispatchEventFromListener()
	{
		var eventType = "myCustomEvent";

		var event1a:Event = null;
		var event1b:Event = null;
		var event1c:Event = null;
		var event2a:Event = null;
		var event2b:Event = null;
		var container1 = new Sprite();
		var container2 = new Sprite();
		var dispatcher1 = new Sprite();
		container1.addChild(dispatcher1);
		var dispatcher2 = new Sprite();
		container2.addChild(dispatcher2);
		dispatcher1.addEventListener(eventType, function(event:Event):Void
		{
			event1a = event;
			// set these flags because they need to be cleared when redispatched
			event1a.preventDefault();
			event1a.stopPropagation();
			dispatcher2.dispatchEvent(event1a);
		});
		dispatcher1.addEventListener(eventType, function(event:Event):Void
		{
			event1b = event;
			Assert.equals(event1a, event1b);
			Assert.notNull(event2a);
			Assert.notEquals(event2a, event1b);

			// this listener is called after the redispatch
			// make sure that no properties were affected by the redispatch
			Assert.equals(eventType, event1b.type);
			Assert.equals(dispatcher1, event1b.target);
			Assert.equals(dispatcher1, event1b.currentTarget);
			Assert.equals(EventPhase.AT_TARGET, event1b.eventPhase);
			Assert.isTrue(event1b.bubbles);
			Assert.isTrue(event1b.cancelable);
			Assert.isTrue(event1b.isDefaultPrevented());
			#if !flash
			Assert.isTrue(event1b.__isCanceled);
			#end
		});
		container1.addEventListener(eventType, function(event:Event):Void
		{
			event1c = event;
		});
		dispatcher2.addEventListener(eventType, function(event:Event):Void
		{
			event2a = event;

			Assert.notEquals(event1a, event2a);
			Assert.isNull(event1b);
			Assert.isNull(event2b);

			Assert.equals(eventType, event2a.type);
			Assert.equals(dispatcher2, event2a.target);
			Assert.equals(dispatcher2, event2a.currentTarget);
			Assert.equals(EventPhase.AT_TARGET, event2a.eventPhase);
			Assert.isTrue(event2a.bubbles);
			Assert.isTrue(event2a.cancelable);
			Assert.isFalse(event2a.isDefaultPrevented());
			#if !flash
			Assert.isFalse(event2a.__isCanceled);
			#end
		});
		container2.addEventListener(eventType, function(event:Event):Void
		{
			event2b = event;

			Assert.notEquals(event1a, event2b);
			Assert.isNull(event1b);
			Assert.equals(event2a, event2b);

			Assert.equals(eventType, event2b.type);
			Assert.equals(dispatcher2, event2b.target);
			Assert.equals(container2, event2b.currentTarget);
			Assert.equals(EventPhase.BUBBLING_PHASE, event2b.eventPhase);
			Assert.isTrue(event2b.bubbles);
			Assert.isTrue(event2b.cancelable);
			Assert.isFalse(event2b.isDefaultPrevented());
			#if !flash
			Assert.isFalse(event2b.__isCanceled);
			#end
		});
		var event = new Event(eventType, true, true);
		var result = dispatcher1.dispatchEvent(event);
		// the original dispatch is cancelled, so expect false
		// the redispatch is not cancelled, and should not affect the first
		Assert.isFalse(result);

		Assert.notNull(event1a);
		Assert.notNull(event1b);
		Assert.isNull(event1c); // stopped propagation
		Assert.notNull(event2a);
		Assert.notNull(event2b);
	}
}

class SpriteWithCallCounts extends Sprite
{
	public function new()
	{
		super();
	}

	public var numChildrenCallCount:Int = 0;

	#if (flash && haxe_ver < 4.3) @:getter(numChildren) #else override #end private function get_numChildren():Int
	{
		numChildrenCallCount++;
		return super.numChildren;
	}

	public var addChildCallCount:Int = 0;

	override public function addChild(child:DisplayObject):DisplayObject
	{
		addChildCallCount++;
		return super.addChild(child);
	}

	public var addChildAtCallCount:Int = 0;

	override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		addChildAtCallCount++;
		return super.addChildAt(child, index);
	}

	public var removeChildCallCount:Int = 0;

	override public function removeChild(child:DisplayObject):DisplayObject
	{
		removeChildCallCount++;
		return super.removeChild(child);
	}

	public var removeChildAtCallCount:Int = 0;

	override public function removeChildAt(index:Int):DisplayObject
	{
		removeChildAtCallCount++;
		return super.removeChildAt(index);
	}

	public var removeChildrenCallCount:Int = 0;

	override public function removeChildren(beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void
	{
		removeChildrenCallCount++;
		return super.removeChildren(beginIndex, endIndex);
	}

	public var getChildAtCallCount:Int = 0;

	override public function getChildAt(index:Int):DisplayObject
	{
		getChildAtCallCount++;
		return super.getChildAt(index);
	}

	public var setChildIndexCallCount:Int = 0;

	override public function setChildIndex(child:DisplayObject, index:Int):Void
	{
		setChildIndexCallCount++;
		super.setChildIndex(child, index);
	}

	public var getChildByNameCallCount:Int = 0;

	override public function getChildByName(name:String):DisplayObject
	{
		getChildByNameCallCount++;
		return super.getChildByName(name);
	}

	public var swapChildrenCallCount:Int = 0;

	override public function swapChildren(child1:DisplayObject, child2:DisplayObject):Void
	{
		swapChildrenCallCount++;
		return super.swapChildren(child1, child2);
	}

	public var swapChildrenAtCallCount:Int = 0;

	override public function swapChildrenAt(index1:Int, index2:Int):Void
	{
		swapChildrenAtCallCount++;
		return super.swapChildrenAt(index1, index2);
	}

	public var containsCallCount:Int = 0;

	override public function contains(child:DisplayObject):Bool
	{
		containsCallCount++;
		return super.contains(child);
	}
}
