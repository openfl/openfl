package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import utest.Assert;
import utest.Test;

class MouseEventTest extends Test
{
	public function test_altKey()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.altKey;

		Assert.notNull(exists);
	}

	public function test_buttonDown()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.buttonDown;

		Assert.notNull(exists);
	}

	public function test_ctrlKey()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.ctrlKey;

		Assert.notNull(exists);
	}

	public function test_delta()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.delta;

		Assert.notNull(exists);
	}

	public function test_localX()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localX;

		Assert.notNull(exists);
	}

	public function test_localY()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.localY;

		Assert.notNull(exists);
	}

	public function test_relatedObject()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		mouseEvent.relatedObject = new Sprite();
		var exists = mouseEvent.relatedObject;

		Assert.notNull(exists);
	}

	public function test_shiftKey()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.shiftKey;

		Assert.notNull(exists);
	}

	public function test_stageX()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageX;

		Assert.isTrue(Math.isNaN(exists));
	}

	public function test_stageY()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.stageY;

		Assert.isTrue(Math.isNaN(exists));
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		Assert.notNull(mouseEvent);
	}

	public function test_updateAfterEvent()
	{
		// TODO: Confirm functionality

		var mouseEvent = new MouseEvent(MouseEvent.MOUSE_DOWN);
		var exists = mouseEvent.updateAfterEvent;

		Assert.notNull(exists);
	}
}
