package openfl.display;

import openfl.errors.RangeError;
import openfl.events.Event;
import massive.munit.Assert;
import openfl.display.InteractiveObject;
import openfl.geom.Rectangle;

class InteractiveObjectTest
{
	@Test public function new_()
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

		Assert.areEqual(-1, obj.tabIndex);
	}

	@Test public function doubleClickEnabled()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.doubleClickEnabled;

		Assert.isFalse(exists);
	}

	@Test public function focusRect()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.focusRect;

		Assert.isNull(exists);
	}

	@Test public function mouseEnabled()
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

	@Test public function needsSoftKeyboard()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.needsSoftKeyboard;

		Assert.isFalse(exists);
	}

	@Test public function softKeyboardInputAreaOfInterest()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.softKeyboardInputAreaOfInterest;

		Assert.isNull(exists);
	}

	@Test public function tabEnabled()
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

		Assert.areEqual(1, events_no);

		#if flash
		obj.buttonMode = false;
		obj.buttonMode = true;
		Assert.isFalse(obj.tabEnabled);
		#end

		obj.tabEnabled = true;
		Assert.isTrue(obj.tabEnabled);

		Assert.areEqual(2, events_no);
	}

	@Test public function tabIndex()
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

		Assert.areEqual(5, obj.tabIndex);
		Assert.areEqual(1, events_no);

		obj.tabIndex = 0;

		Assert.areEqual(0, obj.tabIndex);
		Assert.areEqual(2, events_no);
	}

	@Test public function tabIndexNegativeValueError()
	{
		#if flash
		var obj = new Sprite();
		#else
		var obj = new InteractiveObject();
		#end

		Assert.throws(RangeError, function():Void
		{
			obj.tabIndex = -5;
		});
	}

	@Test public function requestSoftKeyboard()
	{
		// TODO: Confirm functionality

		var sprite = new Sprite();
		var exists = sprite.requestSoftKeyboard;

		Assert.isNotNull(exists);
	}
}
