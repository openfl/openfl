package openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.Constraints;
import js.html.Element;
import js.Browser;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl._internal.bindings.typedarray.UInt16Array;
import openfl.geom.Rectangle;
import openfl.utils.Endian;

@:access(openfl._internal.backend.lime_standalone.Display)
@:access(openfl._internal.backend.lime_standalone.DisplayMode)
class System
{
	public static var allowScreenTimeout(get, set):Bool;
	public static var applicationDirectory(get, never):String;
	public static var applicationStorageDirectory(get, never):String;
	public static var desktopDirectory(get, never):String;
	public static var deviceModel(get, never):String;
	public static var deviceVendor(get, never):String;
	public static var disableCFFI:Bool;
	public static var documentsDirectory(get, never):String;
	public static var endianness(get, never):Endian;
	public static var fontsDirectory(get, never):String;
	public static var numDisplays(get, never):Int;
	public static var platformLabel(get, never):String;
	public static var platformName(get, never):String;
	public static var platformVersion(get, never):String;
	public static var userDirectory(get, never):String;
	@:noCompletion private static var __applicationDirectory:String;
	@:noCompletion private static var __applicationEntryPoint:Map<String, Function>;
	@:noCompletion private static var __applicationStorageDirectory:String;
	@:noCompletion private static var __desktopDirectory:String;
	@:noCompletion private static var __deviceModel:String;
	@:noCompletion private static var __deviceVendor:String;
	@:noCompletion private static var __directories = new Map<SystemDirectory, String>();
	@:noCompletion private static var __documentsDirectory:String;
	@:noCompletion private static var __endianness:Endian;
	@:noCompletion private static var __fontsDirectory:String;
	@:noCompletion private static var __platformLabel:String;
	@:noCompletion private static var __platformName:String;
	@:noCompletion private static var __platformVersion:String;
	@:noCompletion private static var __userDirectory:String;

	@:keep @:expose("lime.embed")
	public static function embed(projectName:String, element:Dynamic, width:Null<Int> = null, height:Null<Int> = null, config:Dynamic = null):Void
	{
		if (__applicationEntryPoint == null) return;

		if (__applicationEntryPoint.exists(projectName))
		{
			var htmlElement:Element = null;

			if (Std.is(element, String))
			{
				htmlElement = cast Browser.document.getElementById(element);
			}
			else if (element == null)
			{
				htmlElement = cast Browser.document.createElement("div");
			}
			else
			{
				htmlElement = cast element;
			}

			if (htmlElement == null)
			{
				Browser.window.console.log("[lime.embed] ERROR: Cannot find target element: " + element);
				return;
			}

			if (width == null)
			{
				width = 0;
			}

			if (height == null)
			{
				height = 0;
			}

			if (config == null) config = {};

			if (Reflect.hasField(config, "background") && Std.is(config.background, String))
			{
				var background = StringTools.replace(Std.string(config.background), "#", "");

				if (background.indexOf("0x") > -1)
				{
					config.background = Std.parseInt(background);
				}
				else
				{
					config.background = Std.parseInt("0x" + background);
				}
			}

			config.element = htmlElement;
			config.width = width;
			config.height = height;

			__applicationEntryPoint[projectName](config);
		}
	}

	public static function exit(code:Int):Void {}

	public static function getDisplay(id:Int):Display
	{
		if (id == 0)
		{
			var display = new Display();
			display.id = 0;
			display.name = "Generic Display";

			// var div = Browser.document.createElement ("div");
			// div.style.width = "1in";
			// Browser.document.body.appendChild (div);
			// var ppi = Browser.document.defaultView.getComputedStyle (div, null).getPropertyValue ("width");
			// Browser.document.body.removeChild (div);
			// display.dpi = Std.parseFloat (ppi);
			display.dpi = 96 * Browser.window.devicePixelRatio;
			display.currentMode = new DisplayMode(Browser.window.screen.width, Browser.window.screen.height, 60, ARGB32);

			display.supportedModes = [display.currentMode];
			display.bounds = new Rectangle(0, 0, display.currentMode.width, display.currentMode.height);
			return display;
		}

		return null;
	}

	public static function getTimer():Int
	{
		return Std.int(Browser.window.performance.now());
	}

	public static inline function load(library:String, method:String, args:Int = 0, lazy:Bool = false):Dynamic
	{
		return null;
	}

	public static function openFile(path:String):Void
	{
		if (path != null)
		{
			Browser.window.open(path, "_blank");
		}
	}

	public static function openURL(url:String, target:String = "_blank"):Void
	{
		if (url != null)
		{
			Browser.window.open(url, target);
		}
	}

	@:noCompletion private static function __copyMissingFields(target:Dynamic, source:Dynamic):Void
	{
		if (source == null || target == null) return;

		for (field in Reflect.fields(source))
		{
			if (!Reflect.hasField(target, field))
			{
				Reflect.setField(target, field, Reflect.field(source, field));
			}
		}
	}

	@:noCompletion private static function __getDirectory(type:SystemDirectory):String
	{
		return null;
	}

	@:noCompletion private static inline function __parseBool(value:String):Bool
	{
		return (value == "true");
	}

	@:noCompletion private static function __registerEntryPoint(projectName:String, entryPoint:Function):Void
	{
		if (__applicationEntryPoint == null)
		{
			__applicationEntryPoint = new Map();
		}

		__applicationEntryPoint[projectName] = entryPoint;
	}

	@:noCompletion private static function __runProcess(command:String, args:Array<String> = null):String
	{
		return null;
	}

	// Get & Set Methods
	private static function get_allowScreenTimeout():Bool
	{
		return true;
	}

	private static function set_allowScreenTimeout(value:Bool):Bool
	{
		return true;
	}

	private static function get_applicationDirectory():String
	{
		if (__applicationDirectory == null)
		{
			__applicationDirectory = __getDirectory(APPLICATION);
		}

		return __applicationDirectory;
	}

	private static function get_applicationStorageDirectory():String
	{
		if (__applicationStorageDirectory == null)
		{
			__applicationStorageDirectory = __getDirectory(APPLICATION_STORAGE);
		}

		return __applicationStorageDirectory;
	}

	private static function get_deviceModel():String
	{
		if (__deviceModel == null) {}

		return __deviceModel;
	}

	private static function get_deviceVendor():String
	{
		if (__deviceVendor == null) {}

		return __deviceVendor;
	}

	private static function get_desktopDirectory():String
	{
		if (__desktopDirectory == null)
		{
			__desktopDirectory = __getDirectory(DESKTOP);
		}

		return __desktopDirectory;
	}

	private static function get_documentsDirectory():String
	{
		if (__documentsDirectory == null)
		{
			__documentsDirectory = __getDirectory(DOCUMENTS);
		}

		return __documentsDirectory;
	}

	private static function get_endianness():Endian
	{
		if (__endianness == null)
		{
			var arrayBuffer = new ArrayBuffer(2);
			var uint8Array = new UInt8Array(arrayBuffer);
			var uint16array = new UInt16Array(arrayBuffer);
			uint8Array[0] = 0xAA;
			uint8Array[1] = 0xBB;
			if (uint16array[0] == 0xAABB) __endianness = BIG_ENDIAN;
			else
				__endianness = LITTLE_ENDIAN;
		}

		return __endianness;
	}

	private static function get_fontsDirectory():String
	{
		if (__fontsDirectory == null)
		{
			__fontsDirectory = __getDirectory(FONTS);
		}

		return __fontsDirectory;
	}

	private static function get_numDisplays():Int
	{
		return 1;
	}

	private static function get_platformLabel():String
	{
		if (__platformLabel == null)
		{
			var name = System.platformName;
			var version = System.platformVersion;
			if (name != null && version != null) __platformLabel = name + " " + version;
			else if (name != null) __platformLabel = name;
		}

		return __platformLabel;
	}

	private static function get_platformName():String
	{
		if (__platformName == null)
		{
			__platformName = "HTML5";
		}

		return __platformName;
	}

	private static function get_platformVersion():String
	{
		if (__platformVersion == null) {}

		return __platformVersion;
	}

	private static function get_userDirectory():String
	{
		if (__userDirectory == null)
		{
			__userDirectory = __getDirectory(USER);
		}

		return __userDirectory;
	}
}

@:enum private abstract SystemDirectory(Int) from Int to Int from UInt to UInt
{
	var APPLICATION = 0;
	var APPLICATION_STORAGE = 1;
	var DESKTOP = 2;
	var DOCUMENTS = 3;
	var FONTS = 4;
	var USER = 5;
}
#end
