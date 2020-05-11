package openfl.system;

import openfl.desktop.Clipboard;
#if lime
import lime.system.System as LimeSystem;
#if neko
import neko.vm.Gc;
#elseif cpp
import cpp.vm.Gc;
#end
#end
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _System
{
	public static var totalMemory(get, never):Int;
	public static var useCodePage:Bool = false;
	public static var vmVersion(get, never):String;

	public static function disposeXML(node:Dynamic):Void {}

	public static function exit(code:Int):Void
	{
		LimeSystem.exit(code);
	}

	public static function gc():Void
	{
		#if (cpp || neko)
		return Gc.run(true);
		#end
	}

	// public static function pause():Void
	// {
	// 	openfl._internal.Lib.notImplemented();
	// }
	// public static function resume():Void
	// {
	// 	openfl._internal.Lib.notImplemented();
	// }

	public static function setClipboard(string:String):Void
	{
		Clipboard.generalClipboard.setData(TEXT_FORMAT, string);
	}

	// Get & Set Methods

	public static function get_totalMemory():Int
	{
		#if neko
		return Gc.stats().heap;
		#elseif cpp
		return untyped __global__._.__hxcpp_gc_used_bytes();
		#elseif openfl_html5
		return untyped __js__("(window.performance && window.performance.memory) ? window.performance.memory.usedJSHeapSize : 0");
		#else
		return 0;
		#end
	}

	public static function get_vmVersion():String
	{
		return "1.0.0";
	}
}
