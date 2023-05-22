package openfl.desktop;

#if (!flash && sys)
import openfl.errors.IllegalOperationError;

/**
	The DockIcon class represents the macOS-style dock icon.

	You can test for support at run time using the
	`NativeApplication.supportsDockIcon` property.

	_OpenFL target support:_ Not currently supported, except when targeting AIR.

	_Adobe AIR profile support:_ This feature is supported on all desktop
	operating systems, but it is not supported on mobile devices or AIR for TV
	devices. See
	[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.

	You can use the DockIcon class to change the appearance of the standard
	icon; for example, to animate the icon or add informational graphics. You
	can also add items to the dock icon menu. The menu items that you add are
	displayed above the standard menu items.

	An instance of the DockIcon class cannot be created. Get the object
	representing the operating system dock icon from `NativeApplication.icon`.

	Not all operating systems have dock icons. Check
	`NativeApplication.supportsDockIcon` to determine whether dock icons are
	supported on the current system. If dock icons are supported, the
	`NativeApplication.icon` property is of type DockIcon. Otherwise, the type
	of `NativeApplication.icon` is another subclass of InteractiveIcon,
	typically SystemTrayIcon.

	Important: Attempting to call a DockIcon class method on the
	`NativeApplication.icon` object on an operating system for which OpenFL does
	not support dock icons generates a run-time exception.
**/
class DockIcon extends InteractiveIcon
{
	@:noCompletion public function new()
	{
		super();
	}

	#if false
	/**
		The system-supplied menu of this dock icon.

		Any items in the menu are displayed above the standard items. The
		standard items cannot be modified or removed.
	**/
	// public var menu:NativeMenu;
	#end

	/**
		Notifies the user that an event has occurred that may require attention.

		Calling this method bounces the dock icon if, and only if, the
		application is in the background. If the `priority` is
		`NotificationType.INFORMATIONAL` then the icon bounces once. If the
		priority is `NotificationType.CRITICAL` then the icon bounces until the
		application is brought to the foreground.
	**/
	public function bounce(priority:NotificationType = INFORMATIONAL):Void
	{
		throw new IllegalOperationError("Not supported");
	}
}
#else
#if air
typedef DockIcon = flash.desktop.DockIcon;
#end
#end
