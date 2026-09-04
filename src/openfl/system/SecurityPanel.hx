package openfl.system;

#if !flash
#if !openfljs
/**
	The SecurityPanel class provides values for specifying which Security
	Settings panel to display when `Security.showSettings()` is called.

	Calling `Security.showSettings()` has no effect in Adobe AIR or on OpenFL
	native and HTML5 targets.
**/
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SecurityPanel(Null<Int>)
{
	/**
		The Camera panel.
	**/
	public var CAMERA = 0;

	/**
		The default panel.
	**/
	public var DEFAULT = 1;

	/**
		The Display panel.
	**/
	public var DISPLAY = 2;

	/**
		The Local Storage Settings panel.
	**/
	public var LOCAL_STORAGE = 3;

	/**
		The Microphone panel.
	**/
	public var MICROPHONE = 4;

	/**
		The Privacy panel.
	**/
	public var PRIVACY = 5;

	/**
		The Settings Manager (Local Settings Manager) panel.
	**/
	public var SETTINGS_MANAGER = 6;

	@:from private static function fromString(value:String):SecurityPanel
	{
		return switch (value)
		{
			case "camera": CAMERA;
			case "default": DEFAULT;
			case "display": DISPLAY;
			case "localStorage": LOCAL_STORAGE;
			case "microphone": MICROPHONE;
			case "privacy": PRIVACY;
			case "settingsManager": SETTINGS_MANAGER;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : SecurityPanel)
		{
			case SecurityPanel.CAMERA: "camera";
			case SecurityPanel.DEFAULT: "default";
			case SecurityPanel.DISPLAY: "display";
			case SecurityPanel.LOCAL_STORAGE: "localStorage";
			case SecurityPanel.MICROPHONE: "microphone";
			case SecurityPanel.PRIVACY: "privacy";
			case SecurityPanel.SETTINGS_MANAGER: "settingsManager";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment") #if (haxe_ver >= 4.0) enum #else @:enum #end abstract SecurityPanel(String) from String to String
{
	public var CAMERA = "camera";
	public var DEFAULT = "default";
	public var DISPLAY = "display";
	public var LOCAL_STORAGE = "localStorage";
	public var MICROPHONE = "microphone";
	public var PRIVACY = "privacy";
	public var SETTINGS_MANAGER = "settingsManager";
}
#end
#else
typedef SecurityPanel = flash.system.SecurityPanel;
#end
