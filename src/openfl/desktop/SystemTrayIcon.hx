package openfl.desktop;

#if (!flash && sys)
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
