package openfl.desktop;

#if (!flash && sys)
#if lime
import lime.system.System;
#end
import openfl.display.NativeWindow;
import openfl.events.EventDispatcher;
import openfl.utils._internal.Lib;

/**
	The NativeApplication class represents this AIR application.

	The NativeApplication class provides application information,
	application-wide functions, and dispatches application-level events.

	The NativeApplication object is a singleton object, created automatically
	at startup. Get the NativeApplication instance of an application with the
	static property `NativeApplication.nativeApplication`.
**/
class NativeApplication extends EventDispatcher
{
	@:noCompletion private static var __nativeApplication:NativeApplication;

	/**
		The singleton instance of the `NativeApplication` object.
	**/
	public static var nativeApplication(get, never):NativeApplication;

	@:noCompletion private static function get_nativeApplication():NativeApplication
	{
		if (__nativeApplication == null)
		{
			__nativeApplication = new NativeApplication();
		}

		return __nativeApplication;
	}

	/**
		Indicates whether `setAsDefaultApplication()`,
		`removeAsDefaultApplication()`, and `isSetAsDefaultApplication()` are
		supported on the current platform.

		If `true`, then the above methods will work as documented. If `false`,
		then `setAsDefaultApplication()` and `removeDefaultApplication()` do
		nothing and `isSetAsDefaultApplication()` returns `false`.

		@see `NativeApplication.setAsDefaultApplication()`
		@see `NativeApplication.removeAsDefaultApplication()`
		@see `NativeApplication.isSetAsDefaultApplication()`
	**/
	public static var supportsDefaultApplication(get, never):Bool;

	@:noCompletion private static function get_supportsDefaultApplication():Bool
	{
		return false;
	}

	/**
		Indicates whether AIR supports dock-style application icons on the
		current operating system.

		If `true`, the `NativeApplication.icon` property is of type `DockIcon`.

		The Mac OS X user interface provides an application "dock" containing
		icons for applications that are running or are frequently used.

		Be sure to use the `NativeApplication.supportsDockIcon` property to
		determine whether the operating system supports application dock icons.
		Using other means (such as `Capabilities.os`) to determine support can
		lead to programming errors (if some possible target operating systems
		are not considered).
	**/
	public static var supportsDockIcon(get, never):Bool;

	@:noCompletion private static function get_supportsDockIcon():Bool
	{
		return false;
	}

	/**
		Specifies whether the current operating system supports a global
		application menu bar.

		When `true`, the `NativeApplication.menu` property can be used to
		define (or access) a native application menu.

		Be sure to use the `NativeApplication.supportsMenu` property to
		determine whether the operating system supports the application menu
		bar. Using other means (such as `Capabilities.os`) to determine support
		can lead to programming errors (if some possible target operating
		systems are not considered).
	**/
	public static var supportsMenu(get, never):Bool;

	@:noCompletion private static function get_supportsMenu():Bool
	{
		return false;
	}

	/**
		Indicates whether `startAtLogin` is supported on the current platform.

		If `true`, then `startAtLogin` works as documented. If `false`, then
		`startAtLogin` has no effect.

		@see `NativeApplication.startAtLogin`
	**/
	public static var supportsStartAtLogin(get, never):Bool;

	@:noCompletion private static function get_supportsStartAtLogin():Bool
	{
		return false;
	}

	/**
		Specifies whether AIR supports system tray icons on the current
		operating system.

		If true, the `NativeApplication.icon` property is of type
		`SystemTrayIcon`.

		The Windows user interface provides the "system tray" region of the task
		bar, officially called the Notification Area, in which application icons
		can be displayed. No default icon is shown. You must set the bitmaps
		array of the icon object to display an icon.

		Be sure to use the `NativeApplication.supportsSystemTrayIcon` property
		to determine whether the operating system supports system tray icons.
		Using other means (such as `Capabilities.os`) to determine support can
		lead to programming errors (if some possible target operating systems
		are not considered).
	**/
	public static var supportsSystemTrayIcon(get, never):Bool;

	@:noCompletion private static function get_supportsSystemTrayIcon():Bool
	{
		return false;
	}

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped global.Object.defineProperty(NativeApplication, "nativeApplication", {
			get: function()
			{
				return NativeApplication.get_nativeApplication();
			}
		});
	}
	#end

	@:noCompletion private var __activeWindow:NativeWindow;

	/**
		The active application window.

		If the active desktop window does not belong to this application, or
		there is no active window, `activeWindow` is `null`.

		This property is not supported on platforms that do not support the
		NativeWindow class.
	**/
	public var activeWindow(get, never):NativeWindow;

	@:noCompletion private function get_activeWindow():NativeWindow
	{
		return __activeWindow;
	}

	/**
		The application ID of this application.

		The value of this ID is set in the application descriptor file.
	**/
	public var applicationID(get, never):String;

	@:noCompletion private function get_applicationID():String
	{
		return Lib.application.meta.get("packageName");
	}

	/**
		Specifies whether the application should automatically terminate when
		all windows have been closed.

		When `autoExit` is `true`, which is the default, the application
		terminates when all windows are closed. Both `exiting` and `exit` events
		are dispatched. When `autoExit` is `false`, you must call
		`NativeApplication.nativeApplication.exit()` to terminate the
		application.

		This property is not supported on platforms that do not support the
		`NativeWindow` class.
	**/
	public var autoExit:Bool = true;

	/**
		The application icon.

		Use `NativeApplication.supportsDockIcon` and
		`NativeApplication.supportsSystemTrayIcon` to determine the icon class.
		The type will be one of the subclasses of InteractiveIcon. On macOS,
		`NativeApplication.icon` is an object of type DockIcon. On Windows,
		`NativeApplication.icon` is an object of type SystemTrayIcon. When an
		application icon is not supported, `NativeApplication.supportsDockIcon`
		and `NativeApplication.supportsSystemTrayIcon` are both `false` and the
		`icon` property is `null`.

		The `icon` object is automatically created, but it is not initialized
		with image data. On some operating systems, such as macOS, a default
		image is supplied. On others, such as Windows, the icon is not displayed
		unless image data is assigned to it. To assign an icon image, set the
		`icon.bitmaps` property with an array containing at least one BitmapData
		object. If more than one BitmapData object is included in the array,
		then the operating system chooses the image that is closest in size to
		the icon's display dimensions, scaling the image if necessary.
	**/
	public var icon(default, never):InteractiveIcon = null;

	/**
		In Adobe AIR, when targeting iOS, this property indicates if the
		application was compiled AOT or if code is using the slower interpreter
		without JIT. On all other platforms and operating systems, this
		property returns `false`.
	**/
	public var isCompiledAOT(get, never):Bool;

	@:noCompletion private function get_isCompiledAOT():Bool
	{
		return false;
	}

	@:noCompletion private var __openedWindows:Array<NativeWindow> = [];

	/**
		An array containing all the open native windows of this application.

		This property is not supported on platforms that do not support the
		NativeWindow class.
	**/
	public var openedWindows(get, never):Array<NativeWindow>;

	@:noCompletion private function get_openedWindows():Array<NativeWindow>
	{
		// don't allow the original value to be edited externally
		return __openedWindows.copy();
	}

	/**
		Specifies whether this application is automatically launched whenever
		the current user logs in.

		You can test for support at run time using the
		`NativeApplication.supportsStartAtLogin` property.

		_OpenFL target support:_ Not currently supported, except when targeting AIR.

		_Adobe AIR profile support:_ This feature is supported on all desktop
		operating systems, but is not supported on mobile devices or AIR for
		TV devices. See
		[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
		for more information regarding API support across multiple profiles.

		The `startAtLogin` property reflects the status of the
		operating-system-defined mechanism for designating that an application
		should start automatically when a user logs in. The user can change the
		status manually by using the operating system user interface. This
		property reflects the current status, whether the status was last
		changed by the application or by the operating system.

		@see `NativeApplication.supportsStartAtLogin`
	**/
	public var startAtLogin(default, default):Bool;

	private function new()
	{
		super();
	}

	/**
		Terminates this application.

		The call to the `exit()` method will return; the shutdown sequence does
		not begin until the currently executing code (such as a current event
		handler) has completed. Pending asynchronous operations are canceled and
		may or may not complete.

		Note that an `exiting` event is not dispatched. If an `exiting` event is
		required by application logic, call
		`NativeApplication.nativeApplication.dispatchEvent()`, passing in an
		`Event` object of type `exiting`. For any open windows, `NativeWindow`
		objects do dispatch `closing` and `close` events. Calling the
		`preventDefault()` method of `closing` event object prevents the
		application from exiting.

		**Note:** This method is not supported on the iOS operating system.
	**/
	public function exit(code:Int = 0):Void
	{
		#if lime
		System.exit(code);
		#end
	}

	/**
		Specifies whether this application is currently the default application
		for opening files with the specified extension.

		You can test for support at run time using the
		`NativeApplication.supportsDefaultApplication` property.

		_OpenFL target support:_ Not currently supported, except when targeting AIR.

		_Adobe AIR profile support:_ This feature is supported on all desktop
		operating systems, but is not supported on mobile devices or AIR for TV
		devices. See
		[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
		for more information regarding API support across multiple profiles.
	**/
	public function isSetAsDefaultApplication(extension:String):Bool
	{
		return false;
	}

	/**
		Removes this application as the default for opening files with the
		specified extension.

		**Note:** This method can only be used with file types listed in the
		fileTypes statement in the application descriptor.
	**/
	public function removeAsDefaultApplication(extension:String):Void {}

	/**
		Sets this application as the default application for opening files with
		the specified extension.

		**Note:** This method can only be used with file types declared in the
		fileTypes statement in the application descriptor.
	**/
	public function setAsDefaultApplication(extension:String):Void {}
}
#else
#if air
typedef NativeApplication = flash.desktop.NativeApplication;
#end
#end
