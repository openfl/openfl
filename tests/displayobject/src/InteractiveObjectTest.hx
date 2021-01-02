package;

import openfl.display.InteractiveObject;
import openfl.display.Sprite;
import openfl.errors.RangeError;
import openfl.events.Event;
import openfl.geom.Rectangle;
import utest.Assert;
import utest.Test;

class InteractiveObjectTest extends Test
{
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
}
