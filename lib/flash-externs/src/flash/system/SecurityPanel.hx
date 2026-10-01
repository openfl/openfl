package flash.system;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract SecurityPanel(String) from String to String
{
	public var CAMERA = "camera";
	public var DEFAULT = "default";
	public var DISPLAY = "display";
	public var LOCAL_STORAGE = "localStorage";
	public var MICROPHONE = "microphone";
	public var PRIVACY = "privacy";
	public var SETTINGS_MANAGER = "settingsManager";
}
#else
typedef SecurityPanel = openfl.system.SecurityPanel;
#end
