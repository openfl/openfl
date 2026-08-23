package openfl.system;

#if !flash
/**
	The SecurityPanel class provides values for specifying which Security
	Settings panel to display when `Security.showSettings()` is called.

	Calling `Security.showSettings()` has no effect in Adobe AIR or on OpenFL
	native and HTML5 targets.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class SecurityPanel
{
	/**
		The Camera panel.
	**/
	public static inline var CAMERA:String = "camera";

	/**
		The default panel.
	**/
	public static inline var DEFAULT:String = "default";

	/**
		The Display panel.
	**/
	public static inline var DISPLAY:String = "display";

	/**
		The Local Storage Settings panel.
	**/
	public static inline var LOCAL_STORAGE:String = "localStorage";

	/**
		The Microphone panel.
	**/
	public static inline var MICROPHONE:String = "microphone";

	/**
		The Privacy panel.
	**/
	public static inline var PRIVACY:String = "privacy";

	/**
		The Settings Manager (Local Settings Manager) panel.
	**/
	public static inline var SETTINGS_MANAGER:String = "settingsManager";
}
#else
typedef SecurityPanel = flash.system.SecurityPanel;
#end
