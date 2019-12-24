package openfl._internal.backend.lime_standalone;

package lime.system;

import lime._internal.backend.native.NativeCFFI;
import lime.app.Application;
import lime.app.Event;
#if flash
import flash.desktop.Clipboard as FlashClipboard;
#elseif (js && html5)
import lime._internal.backend.html5.HTML5Window;
#end

#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(lime._internal.backend.native.NativeCFFI)
@:access(lime.ui.Window)
class Clipboard
{
	public static var onUpdate = new Event<Void->Void>();
	public static var text(get, set):String;
	private static var _text:String;

	private static function __update():Void
	{
		var cacheText = _text;
		_text = null;

		#if (lime_cffi && !macro)
		#if hl
		var utf = NativeCFFI.lime_clipboard_get_text();
		if (utf != null)
		{
			_text = @:privateAccess String.fromUTF8(utf);
		}
		#else
		_text = NativeCFFI.lime_clipboard_get_text();
		#end
		#elseif flash
		if (FlashClipboard.generalClipboard.hasFormat(TEXT_FORMAT))
		{
			_text = FlashClipboard.generalClipboard.getData(TEXT_FORMAT);
		}
		#end

		if (_text != cacheText)
		{
			onUpdate.dispatch();
		}
	}

	// Get & Set Methods
	private static function get_text():String
	{
		// Native clipboard calls __update when clipboard changes

		#if (flash || js || html5)
		__update();
		#end

		return _text;
	}

	private static function set_text(value:String):String
	{
		var cacheText = _text;
		_text = value;

		#if (lime_cffi && !macro)
		NativeCFFI.lime_clipboard_set_text(value);
		#elseif flash
		FlashClipboard.generalClipboard.setData(TEXT_FORMAT, value);
		#elseif (js && html5)
		var window = Application.current.window;
		if (window != null)
		{
			window.__backend.setClipboard(value);
		}
		#end

		if (_text != cacheText)
		{
			onUpdate.dispatch();
		}

		return value;
	}
}
