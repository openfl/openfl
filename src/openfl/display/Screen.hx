package openfl.display;

import openfl.events.EventDispatcher;
import lime.system.System;
import openfl.geom.Rectangle;

#if (!flash && sys)
/**
	The Screen class provides information about the display screens available to
	this application.

	Screens are independent desktop areas within a possibly larger "virtual
	desktop." The origin of the virtual desktop is the top-left corner of the
	operating-system-designated main screen. Thus, the coordinates for the
	bounds of an individual display screen may be negative. There may also be
	areas of the virtual desktop that are not within any of the display screens.

	The Screen class includes static class members for accessing the available
	screen objects and instance members for accessing the properties of an
	individual screen. Screen information should not be cached since it can be
	changed by a user at any time.

	Note that there is not necessarily a one-to-one correspondance between
	screens and the physical monitors attached to a computer. For example, two
	monitors may display the same screen.

	You cannot instantiate the Screen class directly. Calls to the
	`new Screen()` constructor throw an ArgumentError exception.
**/
class Screen extends EventDispatcher
{
	private function new(index:Int)
	{
		super();
		__displayIndex = index;
	}

	@:noCompletion private var __displayIndex:Int;

	/**
		The bounds of this screen.

		The screen location is relative to the virtual desktop.

		On Linux systems that use certain window managers, this property returns
		the desktop bounds, not the screen's visible bounds.
	**/
	public var bounds(get, never):Rectangle;

	@:noCompletion private function get_bounds():Rectangle
	{
		var display = System.getDisplay(__displayIndex);
		var displayBounds = display.bounds;
		return new Rectangle(displayBounds.x, displayBounds.y, displayBounds.width, displayBounds.height);
	}

	/**
		The array of the currently available screens.

		Modifying the returned array has no effect on the available screens.
	**/
	public static var screens(get, never):Array<Screen>;

	@:noCompletion private static function get_screens():Array<Screen>
	{
		var result:Array<Screen> = [];
		for (i in 0...System.numDisplays)
		{
			var screen = new Screen(i);
			result.push(screen);
		}
		return result;
	}

	/**
		The primary display.
	**/
	public static var mainScreen(get, never):Screen;

	@:noCompletion private static function get_mainScreen():Screen
	{
		return new Screen(0);
	}

	/**
		Returns the (possibly empty) set of screens that intersect the provided
		rectangle.
	**/
	public static function getScreensForRectangle(rect:Rectangle):Array<Screen>
	{
		var result:Array<Screen> = [];
		for (i in 0...System.numDisplays)
		{
			var screen = new Screen(i);
			if (screen.bounds.intersects(rect))
			{
				result.push(screen);
			}
		}
		return result;
	}
}
#else
#if air
typedef Screen = flash.display.Screen;
#end
#end
