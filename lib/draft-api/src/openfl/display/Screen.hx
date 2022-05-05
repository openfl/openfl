package openfl.display;

import lime.system.Display;
import lime.system.System;
import openfl.Lib;
import openfl.events.EventDispatcher;
import openfl.geom.Rectangle;

@:access(openfl.display.ScreenMode)
class Screen extends EventDispatcher
{
	public static var screens(get, null):Array<Screen>;
	public static var mainScreen(get, null):Screen;

	private static function get_mainScreen():Screen
	{
		return new Screen(Lib.application.window.display);
	}

	private static function get_screens():Array<Screen>
	{
		var screens:Array<Screen> = [];

		var numDisplays:Int = System.numDisplays;

		for (i in 0...numDisplays)
		{
			screens.push(new Screen(System.getDisplay(i)));
		}
		return screens;
	}

	public static function getScreensForRectangle(rect:Rectangle):Array<Screen>
	{
		var numDisplays:Int = System.numDisplays;
		var screens:Array<Screen> = [];

		for (i in 0...numDisplays)
		{
			var display = System.getDisplay(i);
			var rectB:Rectangle = cast display.bounds;
			if (rect.intersects(rectB)) screens.push(new Screen(display));
		}

		return screens;
	}

	public var bounds(get, null):Rectangle;
	public var mode(get, null):ScreenMode;
	public var modes(get, null):Array<ScreenMode>;
	public var visibleBounds(get, null):Rectangle;

	private var _display:Display;

	private function get_modes():Array<ScreenMode>
	{
		var screenModes = [];
		var displayModes = _display.supportedModes;

		for (displayMode in displayModes)
		{
			screenModes.push(new ScreenMode(displayMode));
		}

		return screenModes;
	}

	private function get_visibleBounds():Rectangle
	{
		var currentMode = _display.currentMode;
		var rect:Rectangle = new Rectangle(0, 0, currentMode.width, currentMode.height);

		return rect;
	}

	private function get_mode():ScreenMode
	{
		return new ScreenMode(_display.currentMode);
	}

	private function get_bounds():Rectangle
	{
		return cast _display.bounds;
	}

	private function new(display:Display)
	{
		super();
		_display = display;
	}
}
