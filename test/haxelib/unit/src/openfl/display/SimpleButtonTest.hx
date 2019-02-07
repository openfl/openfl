package openfl.display;

import openfl.events.MouseEvent;
import massive.munit.Assert;
import openfl.display.SimpleButton;

class SimpleButtonTest
{
	@Test public function new_()
	{
		var button = new SimpleButton();

		Assert.isTrue(button.enabled);
		Assert.isTrue(button.useHandCursor);
		Assert.isTrue(button.tabEnabled);

		Assert.isFalse(button.trackAsMenu);

		#if flash
		Assert.isFalse(button.hasEventListener(MouseEvent.MOUSE_DOWN));
		Assert.isFalse(button.hasEventListener(MouseEvent.MOUSE_OUT));
		Assert.isFalse(button.hasEventListener(MouseEvent.MOUSE_OVER));
		Assert.isFalse(button.hasEventListener(MouseEvent.MOUSE_UP));
		#else
		Assert.isTrue(button.hasEventListener(MouseEvent.MOUSE_DOWN));
		Assert.isTrue(button.hasEventListener(MouseEvent.MOUSE_OUT));
		Assert.isTrue(button.hasEventListener(MouseEvent.MOUSE_OVER));
		Assert.isTrue(button.hasEventListener(MouseEvent.MOUSE_UP));
		#end
	}

	@Test public function downState()
	{
		var down = new Sprite();

		var button = new SimpleButton();

		Assert.isNull(button.downState);

		button.downState = down;

		Assert.areSame(down, cast(button.downState, Sprite));
	}

	@Test public function enabled()
	{
		var button = new SimpleButton();

		Assert.isTrue(button.enabled);

		button.enabled = false;

		Assert.isFalse(button.enabled);
	}

	@Test public function hitTestState()
	{
		var hit = new Sprite();

		var button = new SimpleButton();

		#if flash
		Assert.isNull(button.hitTestState);
		#else
		Assert.isNotNull(button.hitTestState);
		Assert.isType(button.hitTestState, DisplayObject);
		#end

		button.hitTestState = hit;

		Assert.areSame(hit, cast(button.hitTestState, Sprite));
	}

	@Test public function overState()
	{
		var over = new Sprite();

		var button = new SimpleButton();

		Assert.isNull(button.overState);

		button.overState = over;

		Assert.areSame(over, cast(button.overState, Sprite));
	}

	@Test public function soundTransform()
	{
		var button = new SimpleButton();

		var t1 = button.soundTransform;
		var t2 = button.soundTransform;

		Assert.isNotNull(t1);
		Assert.isNotNull(t2);

		Assert.areNotSame(t1, t2);

		Assert.areEqual(t1.volume, t2.volume);
		Assert.areEqual(t1.pan, t2.pan);
	}

	@Test public function tabEnabled()
	{
		var simpleButton = new SimpleButton();
		Assert.isTrue(simpleButton.tabEnabled);

		simpleButton.tabEnabled = false;
		Assert.isFalse(simpleButton.tabEnabled);

		simpleButton.tabEnabled = true;
		Assert.isTrue(simpleButton.tabEnabled);
	}

	@Test public function trackAsMenu()
	{
		var button = new SimpleButton();

		Assert.isFalse(button.trackAsMenu);

		button.trackAsMenu = true;

		Assert.isTrue(button.trackAsMenu);
	}

	@Test public function upState()
	{
		var up = new Sprite();

		var button = new SimpleButton();

		#if flash
		Assert.isNull(button.upState);
		#else
		Assert.isNotNull(button.upState);
		Assert.isType(button.upState, DisplayObject);
		#end

		button.upState = up;

		Assert.areSame(up, cast(button.upState, Sprite));
	}

	@Test public function useHandCursor()
	{
		var button = new SimpleButton();

		Assert.isTrue(button.useHandCursor);

		button.useHandCursor = false;

		Assert.isFalse(button.useHandCursor);
	}
}
