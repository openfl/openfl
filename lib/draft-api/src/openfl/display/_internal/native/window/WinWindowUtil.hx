package _internal.native.window;

import _internal.native.window.extension.WinWindowUtilExtern;
import haxe.ds.IntMap;
import lime.tools.GUID;
import openfl.display.Window;

/**
 * ...
 * @author Christopher Speciale
 */
@:access(_internal.native.window.extension.WinWindowUtilExtern)
class WinWindowUtil
{
	private static var systemTrayCallback:Void->Void;

	public static function getHWND(window:Window):Int
	{
		var actualTitle:String = window.title;
		var guid:String = GUID.createRandomIdentifier(32);

		window.title = guid;
		var hWnd:Int = WinWindowUtilExtern.__getHWNDByName(guid);

		window.title = actualTitle;

		return hWnd;
	}

	public static function setTransparencyMask(id:Int, colorMask:UInt):Bool
	{
		return WinWindowUtilExtern.__setTransparencyMask(id, colorMask);
	}

	public static function setBlurBehindWindow(id:Int, active:Bool):Bool
	{
		return WinWindowUtilExtern.__setBlurBehindWindow(id, active);
	}

	public static function setWindowOverlapped(id:Int, value:Bool):Bool
	{
		return WinWindowUtilExtern.__setWindowOverlapped(id, value);
	}

	public static function createSystemTray(id:Int, callback:Void->Void, ?name:String):Bool
	{
		if (name == null)
		{
			name = "";
		}

		var systemTrayCreated:Bool = WinWindowUtilExtern.__createSystemTray(id, callback, name);

		if (systemTrayCreated)
		{
			systemTrayCallback = callback;
		}

		return systemTrayCreated;
	}

	public static function removeSystemTray(id:Int):Bool
	{
		if (systemTrayCallback != null)
		{
			systemTrayCallback = null;
		}

		return WinWindowUtilExtern.__removeSystemTray(id);
	}
}
