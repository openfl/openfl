namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
import openfl._internal.backend.lime_standalone.Window;

@: access(openfl._internal.backend.lime_standalone.Window)
class Clipboard
{
	public static onUpdate = new LimeEvent < Void -> Void > ();
	public static text(get, set): string;
	private static _text: string;

	private static __update(): void
	{
		var cacheText = _text;
		_text = null;

		if (_text != cacheText)
		{
			onUpdate.dispatch();
		}
	}

	// Get & Set Methods
	private static get_text(): string
	{
		// Native clipboard calls __update when clipboard changes
		__update();
		return _text;
	}

	private static set_text(value: string): string
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
