package;

import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import utest.Assert;
import utest.Test;

class SimpleButtonTest extends Test
{
	public function test_new_()
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

	public function test_downState()
	{
		var down = new Sprite();

		var button = new SimpleButton();

		Assert.isNull(button.downState);

		button.downState = down;

		Assert.equals(down, cast(button.downState, Sprite));
	}

	public function test_enabled()
	{
		var button = new SimpleButton();

		Assert.isTrue(button.enabled);

		button.enabled = false;

		Assert.isFalse(button.enabled);
	}

	public function test_hitTestState()
	{
		var hit = new Sprite();

		var button = new SimpleButton();

		#if flash
		Assert.isNull(button.hitTestState);
		#else
		Assert.notNull(button.hitTestState);
		Assert.isOfType(button.hitTestState, DisplayObject);
		#end

		button.hitTestState = hit;

		Assert.equals(hit, cast(button.hitTestState, Sprite));
	}

	public function test_overState()
	{
		var over = new Sprite();

		var button = new SimpleButton();

		Assert.isNull(button.overState);

		button.overState = over;

		Assert.equals(over, cast(button.overState, Sprite));
	}

	public function test_soundTransform()
	{
		var button = new SimpleButton();

		var t1 = button.soundTransform;
		var t2 = button.soundTransform;

		Assert.notNull(t1);
		Assert.notNull(t2);

		Assert.notEquals(t1, t2);

		Assert.equals(t1.volume, t2.volume);
		Assert.equals(t1.pan, t2.pan);
	}

	public function test_tabEnabled()
	{
		var simpleButton = new SimpleButton();
		Assert.isTrue(simpleButton.tabEnabled);

		simpleButton.tabEnabled = false;
		Assert.isFalse(simpleButton.tabEnabled);

		simpleButton.tabEnabled = true;
		Assert.isTrue(simpleButton.tabEnabled);
	}

	public function test_trackAsMenu()
	{
		var button = new SimpleButton();

		Assert.isFalse(button.trackAsMenu);

		button.trackAsMenu = true;

		Assert.isTrue(button.trackAsMenu);
	}

	public function test_upState()
	{
		var up = new Sprite();

		var button = new SimpleButton();

		#if flash
		Assert.isNull(button.upState);
		#else
		Assert.notNull(button.upState);
		Assert.isOfType(button.upState, DisplayObject);
		#end

		button.upState = up;

		Assert.equals(up, cast(button.upState, Sprite));
	}

	public function test_useHandCursor()
	{
		var button = new SimpleButton();

		Assert.isTrue(button.useHandCursor);

		button.useHandCursor = false;

		Assert.isFalse(button.useHandCursor);
	}
}
