package openfl.display;

#if (!flash && sys)
/**
	The NativeWindowInitOptions class defines the initialization options used
	to construct a new NativeWindow instance.

	The properties defined in the initialization options cannot be changed after
	a window is created.

	**Note:** For the initial application window created automatically by AIR,
	all of these properties (except `type`) are set in the application
	descriptor. The initial window is always type `NativeWindowType.NORMAL`.

	@see `openfl.display.NativeWindow`
	@see `openfl.display.NativeWindowType`
	@see `openfl.display.NativeWindowSystemChrome`
**/
class NativeWindowInitOptions
{
	/**
		Creates a new NativeWindowInitOptions object.

		The default values of the newly created object are:

		- `systemChrome = NativeWindowSystemChrome.STANDARD`
		- `type = NativeWindowType.NORMAL`
		- `transparent = false`
		- `owner = null`
		- `resizable = true`
		- `maximizable = true`
		- `minimizable = true`
	**/
	public function new() {}

	/**
		Specifies whether the window can be maximized by the user.

		For windows with system chrome, this setting will affect the appearance
		of the window maximize button. It will also affect other parts of the
		system-managed user interface, such as the window menu on Microsoft
		Windows.

		When set to `false`, the window cannot be maximized by the user. Calling
		the NativeWindow `maximize()` method directly will maximize the window.

		**OS behavior notes:**

		- On operating systems, such as Mac OS X, in which maximizing a window
		does not also prevent resizing, both `maximizable` and `resizable` must
		be set to `false` to prevent the window from being zoomed or resized.
		- Some Linux window managers allow windows to be maximized by the user
		even when the `maximizable` property is set to `false`.
	**/
	public var maximizable:Bool = true;

	/**
		Specifies whether the window can be minimized by the user.

		For windows with system chrome, this setting will affect the appearance
		of the window minimize button. It will also affect other parts of the
		system-managed user interface, such as the window menu on Microsoft
		Windows.

		When set to `false`, the window cannot be minimized by the user. Calling
		the NativeWindow `minimize()` method directly will minimize the window.

		**Note:** Some Linux window managers allow windows to be minimized by
		the user even when the `minimizable` property is set to `false`.
	**/
	public var minimizable:Bool = true;

	/**
		Specifies the NativeWindow object that should own any windows created
		with this NativeWindowInitOptions.

		When a window has an owner, that window is always displayed in front of
		its owner, is minimized and hidden along with its owner, and closes when
		its owner closes.
	**/
	public var owner:NativeWindow = null;

	/**
		Specifies the render mode of the NativeWindow object created with this
		NativeWindowInitOptions.

		Constants for the valid values of this property are defined in the
		NativeWindowRenderMode class.
	**/
	public var renderMode:String = null;

	/**
		Specifies whether the window can be resized by the user.

		When set to `false`, the window cannot be resized by the user using
		system chrome. Calling the NativeWindow `startResize()` method in
		response to a mouse event will allow the user to resize the window.
		Setting the window bounds directly will also change the window size.

		**OS behavior notes:**

		- On operating systems, such as Mac OS X, in which maximizing windows
		is a resizing operation, both `maximizable` and `resizable` must be set
		to `false` to prevent the window from being zoomed or resized.
		- Some Linux window managers allow windows to be resized by the user
		even when the `resizable` property is set to false.
	**/
	public var resizable:Bool = true;

	/**
		Specifies whether system chrome is provided for the window.

		Chrome refers to the window controls that allow a user to control the
		desktop properties of a window. System chrome uses the standard controls
		for the desktop environment in which the OpenFL application is run and
		conforms to the standard look-and-feel of the native operating system.

		To use chrome provided by a framework (such as Feathers UI or Flex), or
		to provide your own window chrome, set `systemChrome` to
		`NativeWindowSystemChrome.NONE`.

		Setting the `transparent` property to true for a window with system
		chrome is not supported.
	**/
	public var systemChrome:NativeWindowSystemChrome = NativeWindowSystemChrome.STANDARD;

	/**
		Specifies whether the window supports transparency and alpha blending
		against the desktop.

		If `true`, the window display is composited against the desktop. Areas
		of the window not covered by a display object, or covered by display
		objects with an alpha setting near zero, are effectively invisible and
		will not intercept mouse events (which will be received by the desktop
		object below the window). The `alpha` value at which an object will no
		longer intercepting mouse events varies between about `.06` and `.01`,
		depending on the operating system.

		Setting the `transparent` property to `true` for a window with system
		chrome is not supported.

		**Note:** Not all Linux window managers support transparency. On such
		systems, transparent areas of a window are composited against black.
	**/
	public var transparent:Bool = false;

	/**
		Specifies the type of the window to be created.

		Constants for the valid values of this property are defined in the
		NativeWindowType class:

		- NativeWindowType.NORMAL — A typical window. Normal windows use
		full-size chrome and appear on the Windows or Linux task bar.
		- NativeWindowType.UTILITY — A tool palette. Utility windows use a
		slimmer version of the system chrome and do not appear on the Windows
		task bar.
		- NativeWindowType.LIGHTWEIGHT — Lightweight windows cannot have system
		chrome and do not appear on the Windows or Linux task bar. In addition,
		lightweight windows do not have the System (Alt-Space) menu on Windows.
		Lightweight windows are suitable for notification bubbles and controls
		such as combo-boxes that open a short-lived display area. When the
		lightweight type is used, `systemChrome` must be set to
		`NativeWindowSystemChrome.NONE`.
	**/
	public var type:NativeWindowType = NativeWindowType.NORMAL;

	// used by openfl.display.Application for the initial window
	@:noCompletion private var __window:Window;
}
#else
#if air
typedef NativeWindowInitOptions = flash.display.NativeWindowInitOptions;
#end
#end
