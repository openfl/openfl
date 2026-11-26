package;

import openfl.display.BitmapData;
import openfl.geom.Point;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.ui.MouseCursorData;
import openfl.Lib;
import openfl.Vector;
import utest.Assert;
import utest.Test;

class MouseTest extends Test
{
	public function test_hide()
	{
		// TODO: Confirm functionality

		var exists = Mouse.hide;

		Assert.notNull(exists);
	}

	public function test_registerCursor()
	{
		#if flash
		// Flash Player and AIR show registered cursors themselves
		Assert.pass();
		#elseif (lime >= "8.4.0")
		#if html5
		Assert.isTrue(Mouse.supportsNativeCursor);
		#elseif desktop
		Assert.isTrue(Mouse.supportsNativeCursor);

		var cursor = new MouseCursorData();
		cursor.data = Vector.ofArray([new BitmapData(16, 16, true, 0x80FF0000)]);
		cursor.hotSpot = new Point(3, 5);
		Mouse.registerCursor("test", cursor);

		var window = Lib.current.stage.window;
		Mouse.cursor = "test";
		Assert.equals("test", Mouse.cursor);
		Assert.equals(lime.ui.MouseCursor.CUSTOM, window.cursor, "the registered cursor was not shown");

		Mouse.cursor = MouseCursor.ARROW;
		Assert.equals(lime.ui.MouseCursor.ARROW, window.cursor);
		Mouse.cursor = "test";
		Assert.equals(lime.ui.MouseCursor.CUSTOM, window.cursor, "the registered cursor was not shown again");

		// a name that is not registered keeps the current cursor
		Mouse.cursor = "unknown";
		Assert.equals(lime.ui.MouseCursor.CUSTOM, window.cursor);

		Mouse.cursor = "test";
		Mouse.unregisterCursor("test");
		Assert.equals(MouseCursor.AUTO, Mouse.cursor, "the cursor stayed on an unregistered cursor");
		#else
		Assert.isFalse(Mouse.supportsNativeCursor);
		#end
		#else
		Assert.isFalse(Mouse.supportsNativeCursor);
		#end
	}

	public function test_show()
	{
		// TODO: Confirm functionality

		var exists = Mouse.show;

		Assert.notNull(exists);
	}
}
