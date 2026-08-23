package flash.system;

#if flash
extern class SecurityPanel
{
	public static var CAMERA(default, never):String;
	public static var DEFAULT(default, never):String;
	public static var DISPLAY(default, never):String;
	public static var LOCAL_STORAGE(default, never):String;
	public static var MICROPHONE(default, never):String;
	public static var PRIVACY(default, never):String;
	public static var SETTINGS_MANAGER(default, never):String;
}
#else
typedef SecurityPanel = openfl.system.SecurityPanel;
#end
