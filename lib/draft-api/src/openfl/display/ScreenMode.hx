package openfl.display;

import lime.system.DisplayMode;

class ScreenMode
{
	public var height(get, null):Int;
	public var refreshRate(get, null):Int;
	public var width(get, null):Int;

	private function get_height():Int
	{
		return _displayMode.height;
	}

	private function get_refreshRate():Int
	{
		return _displayMode.refreshRate;
	}

	private function get_width():Int
	{
		return _displayMode.width;
	}

	private var _displayMode:DisplayMode;

	private function new(displayMode:DisplayMode)
	{
		_displayMode = displayMode;
	}
}
