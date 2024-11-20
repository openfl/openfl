package openfl.display;

#if (!flash && sys && (!flash_doc_gen || air_doc_gen))
import openfl.events.EventDispatcher;
import lime.system.System;
import openfl.geom.Rectangle;

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
@:access(openfl.display.ScreenMode)
class Screen extends EventDispatcher
{
	/**
		The bounds of this screen.

		The screen location is relative to the virtual desktop.

		On Linux systems that use certain window managers, this property returns
		the desktop bounds, not the screen's visible bounds.
	**/
	public var bounds(get, never):Rectangle;

	/**
		The array of the currently available screens.

		Modifying the returned array has no effect on the available screens.
	**/
	public static var screens(get, never):Array<Screen>;

	/**
		The primary display.
	**/
	public static var mainScreen(get, never):Screen;

	/**
		The current screen mode of the Screen object.
	**/
	public var mode(get, null):ScreenMode;

	/**
		The array of ScreenMode objects of the Screen object.
	**/
	public var modes(get, null):Array<ScreenMode>;

	/**
		The bounds of the area on this screen in which windows can be visible.

		The visibleBounds of a screen excludes the task bar (and other docked desk bars) on Windows, 
		and excludes the menu bar and, depending on system settings, the dock on Mac OS X. On some Linux 
		configurations, it is not possible to determine the visible bounds. 

		In these cases, the visibleBounds property returns the same value as the screenBounds property.
	**/
	public var visibleBounds(get, null):Rectangle;

	@:noCompletion private var __displayIndex:Int;

	private function new(index:Int)
	{
		super();
		__displayIndex = index;
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

	@:noCompletion private function get_modes():Array<ScreenMode>
	{
		var display = System.getDisplay(__displayIndex);
		var screenModes = [];
		var displayModes = display.supportedModes;

		for (displayMode in displayModes)
		{
			screenModes.push(new ScreenMode(displayMode));
		}

		return screenModes;
	}

	@:noCompletion private function get_visibleBounds():Rectangle
	{
		var display = System.getDisplay(__displayIndex);
		var currentMode = display.currentMode;
		var rect:Rectangle = new Rectangle(0, 0, currentMode.width, currentMode.height);

		return rect;
	}

	@:noCompletion private function get_mode():ScreenMode
	{
		var display = System.getDisplay(__displayIndex);
		return new ScreenMode(display.currentMode);
	}

	@:noCompletion private function get_bounds():Rectangle
	{
		var display = System.getDisplay(__displayIndex);
		var displayBounds = display.bounds;

		return new Rectangle(displayBounds.x, displayBounds.y, displayBounds.width, displayBounds.height);
	}

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

	@:noCompletion private static function get_mainScreen():Screen
	{
		return new Screen(0);
	}
}
#else
#if air
typedef Screen = flash.display.Screen;
#end
#end
