package openfl._internal.backend.dummy;

import openfl.display.Stage;
import openfl.ui.MouseCursor;

class DummyMouseBackend
{
	public static function getCursor():MouseCursor
	{
		return null;
	}

	public static function hide():Void {}

	public static function setCursor(value:MouseCursor):Void {}

	public static function setStageCursor(stage:Stage, cursor:MouseCursor):Void {}

	public static function show():Void {}
}
