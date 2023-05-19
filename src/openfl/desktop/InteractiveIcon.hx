package openfl.desktop;

#if (!flash && sys)
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;

/**
	The InteractiveIcon class is the base class for the operating system icons
	associated with applications.

	Use the `icon` property of the NativeApplication object to get an instance
	of the application icon. The icon type will be one of the subclasses of
	InteractiveIcon, either DockIcon on macOS or SystemTrayIcon on Windows and
	Linux.

	You cannot instantiate the InteractiveIcon class directly. Calls to the
	`new InteractiveIcon()` constructor will throw an ArgumentError exception.
**/
class InteractiveIcon extends Icon
{
	public function new()
	{
		super();
	}

	/**
		The current display width of the icon in pixels.

		Some icon contexts support dynamic sizes. The `width` property indicates
		the width of the icon chosen from the `bitmaps` array for the current
		context. The actual display width may be different if the operating
		system has scaled the icon.
	**/
	public var width(default, never):Int = 0;

	/**
		The current display height of the icon in pixels.

		Some icon contexts support dynamic sizes. The `height` property
		indicates the height of the icon chosen from the `bitmaps` array for the
		current context. The actual display height may be different if the
		operating system has scaled the icon.
	**/
	public var height(default, never):Int = 0;
}
#else
#if air
typedef InteractiveIcon = flash.desktop.InteractiveIcon;
#end
#end
