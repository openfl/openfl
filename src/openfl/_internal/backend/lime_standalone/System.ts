namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.Constraints;
import js.html.Element;
import js.Browser;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl._internal.bindings.typedarray.UInt16Array;
import Rectangle from "openfl/geom/Rectangle";
import openfl.utils.Endian;

@: access(openfl._internal.backend.lime_standalone.Display)
@: access(openfl._internal.backend.lime_standalone.DisplayMode)
class System
{
	public static allowScreenTimeout(get, set): boolean;
	public static applicationDirectory(get, never): string;
	public static applicationStorageDirectory(get, never): string;
	public static desktopDirectory(get, never): string;
	public static deviceModel(get, never): string;
	public static deviceVendor(get, never): string;
	public static disableCFFI: boolean;
	public static documentsDirectory(get, never): string;
	public static endianness(get, never): Endian;
	public static fontsDirectory(get, never): string;
	public static numDisplays(get, never): number;
	public static platformLabel(get, never): string;
	public static platformName(get, never): string;
	public static platformVersion(get, never): string;
	public static userDirectory(get, never): string;
	protected static __applicationDirectory: string;
	protected static __applicationEntryPoint: Map<string, Function>;
	protected static __applicationStorageDirectory: string;
	protected static __desktopDirectory: string;
	protected static __deviceModel: string;
	protected static __deviceVendor: string;
	protected static __directories = new Map<SystemDirectory, String>();
	protected static __documentsDirectory: string;
	protected static __endianness: Endian;
	protected static __fontsDirectory: string;
	protected static __platformLabel: string;
	protected static __platformName: string;
	protected static __platformVersion: string;
	protected static __userDirectory: string;

	@: expose("lime.embed")
public static embed(projectName: string, element: Dynamic, width: Null < Int > = null, height: Null < Int > = null, config: Dynamic = null): void
	{
		if(__applicationEntryPoint == null) return;

if (__applicationEntryPoint.exists(projectName))
{
	var htmlElement: Element = null;

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
		var background = StringTools.replace(String(config.background), "#", "");

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

public static exit(code : number): void {}

public static getDisplay(id : number): Display
{
	if (id == 0)
	{
		var display = new Display();
		display.id = 0;
		display.name = "Generic Display";

		// div = Browser.document.createElement ("div");
		// div.style.width = "1in";
		// Browser.document.body.appendChild (div);
		// ppi = Browser.document.defaultView.getComputedStyle (div, null).getPropertyValue ("width");
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

public static getTimer() : number
{
	return Std.int(Browser.window.performance.now());
}

	public static readonly load(library: string, method: string, args : number = 0, lazy : boolean = false): Dynamic
{
	return null;
}

public static openFile(path: string): void
	{
		if(path != null)
{
	Browser.window.open(path, "_blank");
}
}

public static openURL(url: string, target: string = "_blank"): void
	{
		if(url != null)
{
	Browser.window.open(url, target);
}
}

	protected static __copyMissingFields(target: Dynamic, source: Dynamic): void
	{
		if(source == null || target == null) return;

for (field in Reflect.fields(source))
{
	if (!Reflect.hasField(target, field))
	{
		Reflect.setField(target, field, Reflect.field(source, field));
	}
}
}

	protected static __getDirectory(type: SystemDirectory): string
{
	return null;
}

	protected static readonly __parseBool(value: string) : boolean
{
	return (value == "true");
}

	protected static __registerEntryPoint(projectName: string, entryPoint: Function): void
	{
		if(__applicationEntryPoint == null)
{
	__applicationEntryPoint = new Map();
}

__applicationEntryPoint[projectName] = entryPoint;
}

	protected static __runProcess(command: string, args: Array < String > = null): string
{
	return null;
}

// Get & Set Methods
private static get_allowScreenTimeout() : boolean
{
	return true;
}

private static set_allowScreenTimeout(value : boolean) : boolean
{
	return true;
}

private static get_applicationDirectory(): string
{
	if (__applicationDirectory == null)
	{
		__applicationDirectory = __getDirectory(APPLICATION);
	}

	return __applicationDirectory;
}

private static get_applicationStorageDirectory(): string
{
	if (__applicationStorageDirectory == null)
	{
		__applicationStorageDirectory = __getDirectory(APPLICATION_STORAGE);
	}

	return __applicationStorageDirectory;
}

private static get_deviceModel(): string
{
	if (__deviceModel == null) { }

	return __deviceModel;
}

private static get_deviceVendor(): string
{
	if (__deviceVendor == null) { }

	return __deviceVendor;
}

private static get_desktopDirectory(): string
{
	if (__desktopDirectory == null)
	{
		__desktopDirectory = __getDirectory(DESKTOP);
	}

	return __desktopDirectory;
}

private static get_documentsDirectory(): string
{
	if (__documentsDirectory == null)
	{
		__documentsDirectory = __getDirectory(DOCUMENTS);
	}

	return __documentsDirectory;
}

private static get_endianness(): Endian
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

private static get_fontsDirectory(): string
{
	if (__fontsDirectory == null)
	{
		__fontsDirectory = __getDirectory(FONTS);
	}

	return __fontsDirectory;
}

private static get_numDisplays() : number
{
	return 1;
}

private static get_platformLabel(): string
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

private static get_platformName(): string
{
	if (__platformName == null)
	{
		__platformName = "HTML5";
	}

	return __platformName;
}

private static get_platformVersion(): string
{
	if (__platformVersion == null) { }

	return __platformVersion;
}

private static get_userDirectory(): string
{
	if (__userDirectory == null)
	{
		__userDirectory = __getDirectory(USER);
	}

	return __userDirectory;
}
}

@: enum private abstract SystemDirectory(Int) from Int to Int from UInt to UInt
{
	var APPLICATION = 0;
	var APPLICATION_STORAGE = 1;
	var DESKTOP = 2;
	var DOCUMENTS = 3;
	var FONTS = 4;
	var USER = 5;
}
#end
