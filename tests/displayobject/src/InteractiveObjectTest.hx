package;

import lime.ui.Touch;
import openfl.Lib;
import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;
import openfl.geom.Rectangle;
import utest.Assert;
import utest.Test;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)
class InteractiveObjectTest extends Test
{
	private var __touch:Touch = new Touch(0.0, 0.0, 0, 0.0, 0.0, 0.0, 0);

	public function test_new_()
	{
		#if flash
		var obj = new Sprite();
		#else
		var obj = new InteractiveObject();
		#end

		Assert.isTrue(obj.mouseEnabled);

		Assert.isFalse(obj.doubleClickEnabled);
		Assert.isFalse(obj.needsSoftKeyboard);
		Assert.isFalse(obj.tabEnabled);

		Assert.equals(-1, obj.tabIndex);
	}

	public function test_doubleClickEnabled()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.doubleClickEnabled;

		Assert.isFalse(exists);
	}

	public function test_focusRect()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.focusRect;

		Assert.isNull(exists);
	}

	public function test_mouseEnabled()
	{
		#if flash
		var obj = new Sprite();
		#else
		var obj = new InteractiveObject();
		#end

		Assert.isTrue(obj.mouseEnabled);

		obj.mouseEnabled = false;

		Assert.isFalse(obj.mouseEnabled);
	}

	public function test_needsSoftKeyboard()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.needsSoftKeyboard;

		Assert.isFalse(exists);
	}

	public function test_softKeyboardInputAreaOfInterest()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.softKeyboardInputAreaOfInterest;

		Assert.isNull(exists);
	}

	public function test_tabEnabled()
	{
		var events_no:Int = 0;

		#if flash
		var obj = new Sprite();
		#else
		var obj = new InteractiveObject();
		#end

		obj.addEventListener(Event.TAB_ENABLED_CHANGE, function(e)
		{
			events_no++;
		});

		Assert.isFalse(obj.tabEnabled);

		#if flash
		obj.buttonMode = true;
		Assert.isTrue(obj.tabEnabled);
		#end

		obj.tabEnabled = false;
		Assert.isFalse(obj.tabEnabled);

		Assert.equals(1, events_no);

		#if flash
		obj.buttonMode = false;
		obj.buttonMode = true;
		Assert.isFalse(obj.tabEnabled);
		#end

		obj.tabEnabled = true;
		Assert.isTrue(obj.tabEnabled);

		Assert.equals(2, events_no);
	}

	public function test_tabIndex()
	{
		var events_no:Int = 0;

		#if flash
		var obj = new Sprite();
		#else
		var obj = new InteractiveObject();
		#end

		obj.addEventListener(Event.TAB_INDEX_CHANGE, function(e)
		{
			events_no++;
		});

		obj.tabIndex = 5;

		Assert.equals(5, obj.tabIndex);
		Assert.equals(1, events_no);

		obj.tabIndex = 0;

		Assert.equals(0, obj.tabIndex);
		Assert.equals(2, events_no);
	}

	public function test_tabIndexNegativeValueError()
	{
		#if flash
		var obj = new Sprite();
		#else
		var obj = new InteractiveObject();
		#end

		Assert.raises(function():Void
		{
			obj.tabIndex = -5;
		}, RangeError);
	}

	public function test_requestSoftKeyboard()
	{
		// TODO: Confirm functionality

		#if !openfl_strict
		var sprite = new Sprite();
		var exists = sprite.requestSoftKeyboard;

		Assert.notNull(exists);
		#end
	}

	#if !flash
	public function test_mouseOverEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOver event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var dispatched = false;
		var bubbled = false;
		function libCurrent_mouseOverHandler(event:MouseEvent):Void
		{
			Lib.current.removeEventListener(MouseEvent.MOUSE_OVER, libCurrent_mouseOverHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(MouseEvent.MOUSE_OVER, libCurrent_mouseOverHandler);
		sprite.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(MouseEvent.MOUSE_OVER, libCurrent_mouseOverHandler);
		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		var bubbled = false;
		function libCurrent_mouseOutHandler(event:MouseEvent):Void
		{
			Lib.current.removeEventListener(MouseEvent.MOUSE_OUT, libCurrent_mouseOutHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(MouseEvent.MOUSE_OUT, libCurrent_mouseOutHandler);
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseMove.dispatch(0.0, 0.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(MouseEvent.MOUSE_OUT, libCurrent_mouseOutHandler);
		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEventOnRemovedFromStage()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event from removedFromStage test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.parent.removeChild(sprite);

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
	}

	public function test_mouseOutEventOnSetInvisible()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event from visible = false test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.visible = false;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEventOnSetMouseDisabled()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event from mouseEnabled = false test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.mouseEnabled = false;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEventOnSetNewPosition()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event from set position test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.x += 200.0;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEventOnSetNewScale()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event from set scale test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.scaleX *= 0.01;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEventOnSetNewRotation()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event from set rotation test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.rotation = 90.0;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_mouseOutEventOnParentRemovedFromStage()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.visible = false;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_mouseOutEventOnSetParentInvisible()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.parent.removeChild(spriteParent);

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
	}

	public function test_mouseOutEventOnSetParentMouseChildrenDisabled()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.mouseChildren = false;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_mouseOutEventOnSetParentNewPosition()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.x += 200.0;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_mouseOutEventOnSetParentNewScale()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.scaleX = 0.01;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_mouseOutEventOnSetParentNewRotation()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.MOUSE_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.rotation = 90.0;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_mouseDownEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseDown event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var dispatched = false;
		var bubbled = false;
		function libCurrent_mouseDownHandler(event:MouseEvent):Void
		{
			Lib.current.removeEventListener(MouseEvent.MOUSE_DOWN, libCurrent_mouseDownHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(MouseEvent.MOUSE_DOWN, libCurrent_mouseDownHandler);
		sprite.addEventListener(MouseEvent.MOUSE_DOWN, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isTrue(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseDown.dispatch(25.0, 35.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(MouseEvent.MOUSE_DOWN, libCurrent_mouseDownHandler);
		sprite.parent.removeChild(sprite);
	}

	public function test_mouseUpEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseUp event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseDown.dispatch(25.0, 35.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		var bubbled = false;
		function libCurrent_mouseUpHandler(event:MouseEvent):Void
		{
			Lib.current.removeEventListener(MouseEvent.MOUSE_UP, libCurrent_mouseUpHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(MouseEvent.MOUSE_UP, libCurrent_mouseUpHandler);
		sprite.addEventListener(MouseEvent.MOUSE_UP, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseUp.dispatch(25.0, 35.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(MouseEvent.MOUSE_UP, libCurrent_mouseUpHandler);
		sprite.parent.removeChild(sprite);
	}

	public function test_mouseMoveEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseMove event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var dispatched = false;
		var bubbled = false;
		function libCurrent_mouseMoveHandler(event:MouseEvent):Void
		{
			Lib.current.removeEventListener(MouseEvent.MOUSE_MOVE, libCurrent_mouseMoveHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, libCurrent_mouseMoveHandler);
		sprite.addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseMove.dispatch(25.0, 36.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(MouseEvent.MOUSE_MOVE, libCurrent_mouseMoveHandler);
		sprite.parent.removeChild(sprite);
	}

	public function test_mouseMoveEventAfterMouseDown()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping mouseMove event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseDown.dispatch(25.0, 35.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		var bubbled = false;
		function libCurrent_mouseMoveHandler(event:MouseEvent):Void
		{
			Lib.current.removeEventListener(MouseEvent.MOUSE_MOVE, libCurrent_mouseMoveHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(MouseEvent.MOUSE_MOVE, libCurrent_mouseMoveHandler);
		sprite.addEventListener(MouseEvent.MOUSE_MOVE, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isTrue(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseMove.dispatch(25.0, 36.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		stage.window.onMouseUp.dispatch(25.0, 36.0, 0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Lib.current.removeEventListener(MouseEvent.MOUSE_MOVE, libCurrent_mouseMoveHandler);
		sprite.parent.removeChild(sprite);
	}

	public function test_rollOverEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOver event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OVER, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		stage.window.onMouseMove.dispatch(0.0, 0.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEventOnRemovedFromStage()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event from removedFromStage test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.parent.removeChild(sprite);

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
	}

	public function test_rollOutEventOnSetInvisible()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event from visible = false test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.visible = false;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEventOnSetMouseDisabled()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event from mouseEnabled = false test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.mouseEnabled = false;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEventOnSetNewPosition()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event from set position test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.x += 200.0;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEventOnSetNewScale()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event from set scale test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.scaleX *= 0.01;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEventOnSetNewRotation()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event from set rotation test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		sprite.rotation = 90.0;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		sprite.parent.removeChild(sprite);
	}

	public function test_rollOutEventOnParentRemovedFromStage()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.visible = false;

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_rollOutEventOnSetParentInvisible()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.parent.removeChild(spriteParent);

		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
	}

	public function test_rollOutEventOnSetParentMouseChildrenDisabled()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var dispatchedForParent = false;
		spriteParent.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatchedForParent = true;
		});

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.mouseChildren = false;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isFalse(dispatchedForParent);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_rollOutEventOnSetParentNewPosition()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.x += 200.0;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_rollOutEventOnSetParentNewScale()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.scaleX = 0.01;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_rollOutEventOnSetParentNewRotation()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOut event test");
			return;
		}

		var stage = Lib.current.stage;

		var spriteParent = new Sprite();
		spriteParent.x = 20.0;
		spriteParent.y = 30.0;
		Lib.current.addChild(spriteParent);

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		spriteParent.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isFalse(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.isFalse(event.buttonDown);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
			Assert.equals(0, event.delta);
			Assert.equals(0, event.clickCount);
		});

		spriteParent.rotation = 90.0;
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);

		spriteParent.parent.removeChild(spriteParent);
	}

	public function test_rollOverThenMouseOverEvents()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping rollOver/mouseOver event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var dispatchedMouseOver = false;
		var dispatchedRollOver = false;
		sprite.addEventListener(MouseEvent.ROLL_OVER, function(event:MouseEvent):Void
		{
			dispatchedRollOver = true;
			Assert.isFalse(dispatchedMouseOver);
		});
		sprite.addEventListener(MouseEvent.MOUSE_OVER, function(event:MouseEvent):Void
		{
			dispatchedMouseOver = true;
			Assert.isTrue(dispatchedRollOver);
		});

		stage.window.onMouseMove.dispatch(25.0, 35.0);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatchedMouseOver);
		Assert.isTrue(dispatchedRollOver);

		sprite.parent.removeChild(sprite);
	}

	@Ignored
	public function test_touchBeginEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping touchBegin event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var dispatched = false;
		var bubbled = false;
		function libCurrent_touchBeginHandler(event:TouchEvent):Void
		{
			Lib.current.removeEventListener(TouchEvent.TOUCH_BEGIN, libCurrent_touchBeginHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(TouchEvent.TOUCH_BEGIN, libCurrent_touchBeginHandler);
		sprite.addEventListener(TouchEvent.TOUCH_BEGIN, function(event:TouchEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.equals(0, event.touchPointID);
			Assert.isTrue(event.isPrimaryTouchPoint);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
		});

		var xPos = 25.0 / stage.window.scale / stage.window.width;
		var yPos = 35.0 / stage.window.scale / stage.window.height;
		__touch.x = xPos;
		__touch.y = yPos;
		Touch.onStart.dispatch(__touch);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(TouchEvent.TOUCH_BEGIN, libCurrent_touchBeginHandler);
		sprite.parent.removeChild(sprite);
	}

	@Ignored
	public function test_touchEndEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping touchEnd event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var xPos = 25.0 / stage.window.scale / stage.window.width;
		var yPos = 35.0 / stage.window.scale / stage.window.height;
		__touch.x = xPos;
		__touch.y = yPos;
		Touch.onStart.dispatch(__touch);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		var bubbled = false;
		function libCurrent_touchEndHandler(event:TouchEvent):Void
		{
			Lib.current.removeEventListener(TouchEvent.TOUCH_END, libCurrent_touchEndHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(TouchEvent.TOUCH_END, libCurrent_touchEndHandler);
		sprite.addEventListener(TouchEvent.TOUCH_END, function(event:TouchEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.equals(0, event.touchPointID);
			Assert.isTrue(event.isPrimaryTouchPoint);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
		});

		Touch.onEnd.dispatch(__touch);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Lib.current.removeEventListener(TouchEvent.TOUCH_END, libCurrent_touchEndHandler);
		sprite.parent.removeChild(sprite);
	}

	@Ignored
	public function test_touchMoveEvent()
	{
		if (Lib.current == null || Lib.current.stage == null)
		{
			Assert.pass("Skipping touchMove event test");
			return;
		}

		var stage = Lib.current.stage;

		var sprite = new Sprite();
		sprite.graphics.beginFill(0xff0000);
		sprite.graphics.drawRect(0.0, 0.0, 100.0, 50.0);
		sprite.graphics.endFill();
		sprite.x = 20.0;
		sprite.y = 30.0;
		Lib.current.addChild(sprite);

		// ensure that __transformDirty flag is cleared
		@:privateAccess Lib.current.stage.__renderAfterEvent();

		var xPos = 25.0 / stage.window.scale / stage.window.width;
		var yPos = 35.0 / stage.window.scale / stage.window.height;
		__touch.x = xPos;
		__touch.y = yPos;
		Touch.onStart.dispatch(__touch);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		var dispatched = false;
		var bubbled = false;
		function libCurrent_touchMoveHandler(event:TouchEvent):Void
		{
			Lib.current.removeEventListener(TouchEvent.TOUCH_MOVE, libCurrent_touchMoveHandler);
			bubbled = true;
			Assert.notEquals(sprite, Lib.current);
			Assert.equals(sprite, event.target);
			Assert.equals(Lib.current, event.currentTarget);
		}
		Lib.current.addEventListener(TouchEvent.TOUCH_MOVE, libCurrent_touchMoveHandler);
		sprite.addEventListener(TouchEvent.TOUCH_MOVE, function(event:TouchEvent):Void
		{
			dispatched = true;
			Assert.equals(sprite, event.target);
			Assert.equals(sprite, event.currentTarget);
			Assert.isTrue(event.bubbles);
			Assert.isFalse(event.cancelable);
			Assert.equals(0, event.touchPointID);
			Assert.isTrue(event.isPrimaryTouchPoint);
			Assert.isFalse(event.altKey);
			Assert.isFalse(event.shiftKey);
			Assert.isFalse(event.ctrlKey);
			Assert.isFalse(event.controlKey);
			Assert.isFalse(event.commandKey);
			Assert.isNull(event.relatedObject);
		});

		__touch.x += 0.01;
		Touch.onMove.dispatch(__touch);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Assert.isTrue(dispatched);
		Assert.isTrue(bubbled);

		Touch.onEnd.dispatch(__touch);
		// ensure that pending mouse events are dispatched
		stage.application.onUpdate.dispatch(0);

		Lib.current.removeEventListener(TouchEvent.TOUCH_MOVE, libCurrent_touchMoveHandler);
		sprite.parent.removeChild(sprite);
	}
	#end
}
