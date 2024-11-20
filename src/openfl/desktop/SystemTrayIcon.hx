package openfl.desktop;

#if (!flash && sys && (!flash_doc_gen || air_doc_gen))
/**
	The SystemTrayIcon class represents the Windows® taskbar notification area
	(system tray)-style icon.

	_OpenFL target support:_ Not currently supported, except when targeting AIR.

	_Adobe AIR profile support:_ This feature is supported on desktop operating systems,
	but it is not supported on mobile devices or AIR for TV devices. See
	[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.

	Not all desktop operating systems have system tray icons. Check
	`NativeApplication.supportsSystemTrayIcon` to determine whether system tray
	icons are supported on the current system.

	An instance of the SystemTrayIcon class cannot be created. Get the object
	representing the system tray icon from the `icon` property of the "global"
	NativeApplication object.

	When system tray icons are supported, the icon will be of type
	SystemTrayIcon. Otherwise, the type of `icon` will be another subclass of
	InteractiveIcon, typically DockIcon.

	Important: Attempting to call a SystemTrayIcon class method on the
	`NativeApplication.icon` object on an operating system for which OpenFL does
	not support system tray icons will generate a run-time exception.
**/
class SystemTrayIcon extends InteractiveIcon
{
	/**
		The permitted length of the system tray icon tooltip.
	**/
	public static final MAX_TIP_LENGTH:Int = 63;

	@:noCompletion public function new()
	{
		super();
	}

	#if false
	/**
		The system tray icon menu.
	**/
	// public var menu:NativeMenu;
	#end

	/**
		The tooltip that pops up for the system tray icon. If the string is
		longer than `SystemTrayIcon.MAX_TIP_LENGTH`, the tip will be truncated.
	**/
	public var tooltip:String;
}
#else
#if air
typedef SystemTrayIcon = flash.desktop.SystemTrayIcon;
#end
#end
