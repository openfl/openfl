package openfl._internal.backend.lime_standalone;

#if openfl_html5
import openfl._internal.backend.lime_standalone.Window;

@:access(openfl._internal.backend.lime_standalone.Window)
class Clipboard
{
	public static var onUpdate = new LimeEvent<Void->Void>();
	public static var text(get, set):String;
	private static var _text:String;

	private static function __update():Void
	{
		var cacheText = _text;
		_text = null;

		if (_text != cacheText)
		{
			onUpdate.dispatch();
		}
	}

	// Get & Set Methods
	private static function get_text():String
	{
		// Native clipboard calls __update when clipboard changes
		__update();
		return _text;
	}

	private static function set_text(value:String):String
	{
		var cacheText = _text;
		_text = value;

		var window = Application.current.window;
		if (window != null)
		{
			window.__backend.setClipboard(value);
		}

		if (_text != cacheText)
		{
			onUpdate.dispatch();
		}

		return value;
	}
}
#end
