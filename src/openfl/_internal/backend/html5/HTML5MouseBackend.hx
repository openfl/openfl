package openfl._internal.backend.html5;

#if openfl_html5
import openfl._internal.backend.lime_standalone.Application;
import openfl._internal.backend.lime_standalone.MouseCursor as LimeMouseCursor;
import openfl.display.Stage;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;

@:access(openfl.ui.Mouse)
class HTML5MouseBackend
{
	public static function hide():Void
	{
		for (window in Application.current.windows)
		{
			window.cursor = null;
		}
	}

	public static function setCursor(value:MouseCursor):Void
	{
		var limeCursor:LimeMouseCursor = null;

		switch (value)
		{
			case MouseCursor.ARROW:
				limeCursor = ARROW;
			case MouseCursor.BUTTON:
				limeCursor = POINTER;
			case MouseCursor.HAND:
				limeCursor = MOVE;
			case MouseCursor.IBEAM:
				limeCursor = TEXT;
			case MouseCursor.__CROSSHAIR:
				limeCursor = CROSSHAIR;
			case MouseCursor.__CUSTOM:
				limeCursor = CUSTOM;
			case MouseCursor.__RESIZE_NESW:
				limeCursor = RESIZE_NESW;
			case MouseCursor.__RESIZE_NS:
				limeCursor = RESIZE_NS;
			case MouseCursor.__RESIZE_NWSE:
				limeCursor = RESIZE_NWSE;
			case MouseCursor.__RESIZE_WE:
				limeCursor = RESIZE_WE;
			case MouseCursor.__WAIT:
				limeCursor = WAIT;
			case MouseCursor.__WAIT_ARROW:
				limeCursor = WAIT_ARROW;
			default:
		}

		if (limeCursor != null && !Mouse.__hidden)
		{
			for (window in Application.current.windows)
			{
				window.cursor = limeCursor;
			}
		}
	}

	public static function setStageCursor(stage:Stage, value:MouseCursor):Void
	{
		var limeCursor:LimeMouseCursor = null;

		switch (value)
		{
			case MouseCursor.ARROW:
				limeCursor = ARROW;
			case MouseCursor.BUTTON:
				limeCursor = POINTER;
			case MouseCursor.HAND:
				limeCursor = MOVE;
			case MouseCursor.IBEAM:
				limeCursor = TEXT;
			case MouseCursor.__CROSSHAIR:
				limeCursor = CROSSHAIR;
			case MouseCursor.__CUSTOM:
				limeCursor = CUSTOM;
			case MouseCursor.__RESIZE_NESW:
				limeCursor = RESIZE_NESW;
			case MouseCursor.__RESIZE_NS:
				limeCursor = RESIZE_NS;
			case MouseCursor.__RESIZE_NWSE:
				limeCursor = RESIZE_NWSE;
			case MouseCursor.__RESIZE_WE:
				limeCursor = RESIZE_WE;
			case MouseCursor.__WAIT:
				limeCursor = WAIT;
			case MouseCursor.__WAIT_ARROW:
				limeCursor = WAIT_ARROW;
			default:
		}

		if (limeCursor != null && !Mouse.__hidden)
		{
			// TODO
			//stage.window.cursor = limeCursor;
		}
	}

	public static function show():Void
	{
		var cacheCursor = Mouse.__cursor;
		Mouse.__cursor = null;
		setCursor(cacheCursor);
	}
}
#end
