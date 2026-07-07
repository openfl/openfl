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
}
