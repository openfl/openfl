package openfl.display;

#if (!flash && sys)
import openfl.Lib;
import openfl.desktop.NativeApplication;
import openfl.display.Stage;
import openfl.display.Window;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.NativeWindowBoundsEvent;
import openfl.events.NativeWindowDisplayStateEvent;
import openfl.geom.Rectangle;
#if (lime >= "8.1.0")
import openfl.geom.Point;
#end

/**
	The NativeWindow class provides an interface for creating and controlling
	native desktop windows.

	You can test for support at run time on desktop devices using the
	`NativeWindow.isSupported` property.

	_OpenFL target support:_ This feature is supported on all desktop operating
	systems, but is not supported on mobile operating systems, including iOS and
	Android.

	_Adobe AIR profile support:_ This feature is supported on all desktop
	operating systems, but is not supported on mobile devices or AIR for TV
	devices. See
	[AIR Profile Support](http://help.adobe.com/en_US/air/build/WS144092a96ffef7cc16ddeea2126bb46b82f-8000.html)
	for more information regarding API support across multiple profiles.

	A reference to the NativeWindow instance is returned by the window
	constructor. A reference to a NativeWindow instance can also be accessed
	using the `stage.nativeWindow `property of any display object on that
	window's stage:

	```haxe
	var window:NativeWindow = displayObject.stage.nativeWindow;
	```

	The properties of a NativeWindow instance can only be accessed by
	application content. If non-application content attempts to access the
	NativeWindow object, a security error will be thrown.

	Content can be added to a window using the DisplayObjectContainer methods of
	the Stage object such as `addChild()`.

	The following operations on NativeWindow objects are asynchronous:
	`close()`, `maximize()`, `minimize()`, `restore()`, and bounds changes. An
	application can detect when these operations have completed by listening for
	the appropriate events.

	If the `NativeApplication.autoExit` property is `true`, which is the
	default, the application will close when its last window is closed (and all
	close event handlers have returned). If `autoExit` is false, then
	`NativeApplication.nativeApplication.exit()` must be called to terminate the
	application.

	NativeWindow objects will not be garbage collected after the window
	constructor has been called and before `close()` has been called. It is the
	responsibility of the application to close its own windows.
**/
@:access(openfl.desktop.NativeApplication)
@:access(openfl.display.NativeWindowInitOptions)
@:access(openfl.display.Stage)
@:access(lime.ui.Window)
class NativeWindow extends EventDispatcher
{
	@:noCompletion private static var ERROR_CLOSED = "Cannot perform operation on closed window.";

	/**
		Indicates whether native windows are supported on the client system.
	**/
	public static var isSupported(get, never):Bool;

	@:noCompletion private static function get_isSupported():Bool
	{
		#if (!sys || !desktop)
		return false;
		#else
		return true;
		#end
	}

	/**
		Indicates whether OpenFL supports native window menus on the current
		computer system.

		When `NativeWindow.supportsMenu` is `true`, a native menu will be
		displayed for a window when a NativeMenu object is assigned to the
		window `menu` property (unless the window `systemChrome` property is
		`NativeWindowSystemChrome.NONE`). Be sure to use the
		`NativeWindow.supportsMenu` property to determine whether the operating
		system supports native window menus. Using other means (such as
		`Capabilities.os`) to determine support can lead to programming errors
		(if some possible target operating systems are not considered).

		Note: Assigning a menu to a window when `NativeWindow.supportsMenu` is
		`false` or when the window `systemChrome` property is
		`NativeWindowSystemChrome.NONE` is allowed, but does nothing.
	**/
	public static var supportsMenu(get, never):Bool;

	@:noCompletion private static function get_supportsMenu():Bool
	{
		return false;
	}

	/**
		Indicates whether OpenFL supports native windows with transparent pixels.

		When `NativeWindow.supportsTransparency` is `true`, transparency in
		pixels of a native window will be honored, if the window transparent
		property is set to `true`. Opacity of all pixels will be set to `1` if
		`NativeWindow.supportsTransparency` is `fals`e, regardless of the value
		of the window transparent property. Fully transparent pixels will render
		as black when `NativeWindow.supportsTransparency` is `false`. Be sure to
		use the `NativeWindow.supportsTransparency` property to determine
		whether the operating system supports transparency. Using other means
		(such as `Capabilities.os`) to determine support can lead to programmin
		 errors (if some possible target operating systems are not considered).

		Note: The value of this property might change while an application is
		running, based on user preferences set for the operating system.
	**/
	public static var supportsTransparency(get, never):Bool;

	@:noCompletion private static function get_supportsTransparency():Bool
	{
		return false;
	}

	@:noCompletion private var __initOptions:NativeWindowInitOptions;
	@:noCompletion private var __window:Window;
	#if (lime < "8.1.0")
	@:noCompletion private var __opened:Bool = false;
	@:noCompletion private var __pendingWidth:Int = 400;
	@:noCompletion private var __pendingHeight:Int = 228;
	#end
	@:noCompletion private var __closed:Bool = false;
	@:noCompletion private var __previousX:Int;
	@:noCompletion private var __previousY:Int;
	@:noCompletion private var __previousWidth:Int;
	@:noCompletion private var __previousHeight:Int;
	@:noCompletion private var __previousDisplayState:NativeWindowDisplayState;
	@:noCompletion private var __active:Bool = false;
	@:noCompletion private var __ownedWindows:Vector<NativeWindow> = new Vector();

	/**
		Creates a new NativeWindow instance and a corresponding operating system
		window.

		The settings defined in the `initOptions` parameter cannot be changed
		after the window is created. Invalid `initOptions` settings will cause
		an illegal operation error to be thrown. Settings that are valid but not
		available on the current system will not throw an exception. The window
		capabilities specific to the current operating system can be detected,
		if desired, using the static `NativeWindow` members such as
		`systemMaxSize`.

		The default window size is determined by the operating system, and
		windows are created in an invisible state. To prevent changes to the
		window from being visible, do not change the window `visible` property
		to `true` or call `activate()` until the window changes are finished.
	**/
	public function new(initOptions:NativeWindowInitOptions)
	{
		super();
		__initOptions = initOptions;
		if (__initOptions.__window != null)
		{
			__window = __initOptions.__window;
			#if (lime < "8.1.0")
			__opened = true;
			__pendingWidth = __window.width;
			__pendingHeight = __window.height;
			#end
			NativeApplication.nativeApplication.__activeWindow = this;
		}
		else
		{
			var app = Lib.application;
			__window = app.createWindow({
				allowHighDPI: app.window.__attributes.allowHighDPI,
				alwaysOnTop: false,
				title: "",
				resizable: __initOptions.resizable,
				hidden: #if (lime < "8.1.0") false #else true #end,
				minimized: false,
				maximized: false,
				fullscreen: false,
				frameRate: app.window.stage.frameRate,
				borderless: __initOptions.systemChrome == NONE,
				width: #if (lime < "8.1.0") 0 #else 400 #end,
				height: #if (lime < "8.1.0") 0 #else 228 #end
			});
			if (__initOptions.owner != null)
			{
				__initOptions.owner.__ownedWindows.push(this);
			}
		}
		__previousX = __window.x;
		__previousY = __window.y;
		#if (lime < "8.1.0")
		__previousWidth = __pendingWidth;
		__previousHeight = __pendingHeight;
		#else
		__previousWidth = __window.width;
		__previousHeight = __window.height;
		#end
		__previousDisplayState = NORMAL;
		__window.stage.nativeWindow = this;
		NativeApplication.nativeApplication.__openedWindows.push(this);
		__window.onFocusIn.add(window_onFocusIn);
		__window.onFocusOut.add(window_onFocusOut);
		__window.onMove.add(window_onMove);
		__window.onResize.add(window_onResize);
		__window.onMinimize.add(window_onMinimize);
		__window.onMaximize.add(window_onMaximize);
		__window.onRestore.add(window_onRestore);
		__window.onClose.add(window_onClose);
	}

	/**
		The Stage object for this window. The Stage object is the root object in
		the display list architecture used in OpenFL.

		The stage is the root of the display list for the window. Add visual
		display objects to a window by adding them to the stage or to another
		object already in the display list of this stage. The stage dimensions
		are those of the window client area when the window uses system chrome.
		The stage dimensions are equal to the dimensions of the window if
		system chrome is not used.
	**/
	public var stage(get, never):Stage;

	@:noCompletion private function get_stage():Stage
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.stage;
	}

	/**
		The horizontal axis coordinate of this window's top left corner relative
		to the origin of the operating system desktop.

		On systems with more than one monitor, `x` can be negative. If you save
		the value, perhaps to reposition a window at its previous location, you
		should always verify that the window is placed in a usable location when
		the position is restored. Changes in screen resolution or monitor
		arrangement can can result in a window being placed off screen. Use the
		`Screen` class to obtain information about the desktop geometry.

		Changing the `x` property of a window is equivalent to changing the
		location through the `bounds` property.

		On Linux, setting the `x` property is an asynchronous operation.

		To detect the completion of the position change, listen for the `move`
		event, which is dispatched on all platforms.

		Pixel values are rounded to the nearest integer when the x-coordinate
		of a window is changed.
	**/
	public var x(get, set):Float;

	@:noCompletion private function get_x():Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.x;
	}

	@:noCompletion private function set_x(value:Float):Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.x = Std.int(value);
	}

	/**
		The vertical axis coordinate of this window's top left corner relative
		to the upper left corner of the operating system's desktop.

		On systems with more than one monitor, `y` can be negative. If you save
		the value, perhaps to reposition a window at its previous location, you
		should always verify that the window is placed in a usable location when
		the position is restored. Changes in screen resolution or monitor
		arrangement can can result in a window being placed off screen. Use the
		`Screen` class to obtain information about the desktop geometry.

		Changing the `y` property of a window is equivalent to changing the
		location through the `bounds` property.

		On Linux, setting the `y` property is an asynchronous operation.

		To detect the completion of the position change, listen for the `move`
		event, which is dispatched on all platforms.

		Pixel values are rounded to the nearest integer when the y-coordinate of
		a window is changed.
	**/
	public var y(get, set):Float;

	@:noCompletion private function get_y():Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.y;
	}

	@:noCompletion private function set_y(value:Float):Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.y = Std.int(value);
	}

	/**
		The width of this window in pixels.

		The dimensions reported for a native window include any system window
		chrome that is displayed. The width of the usable display area inside a
		window is available from the `Stage.stageWidth` property.

		Changing the `width` property of a window is equivalent to changing the
		width through the `bounds` property.

		If the width specified is less than the minimum or greater than the
		maximum allowed width, then the window width is set to the closest
		legal size. The factors that determine the minimum and maximum width are the following:

		- The `minSize.x` and `maxSize.x` properties of the NativeWindow object
		- The minimum and maximum operating system limits, which are the values
		of `NativeWindow.systemMinSize.x` and `NativeWindow.systemMaxSize.x`.
		- The maximum width of a window in Adobe AIR, which is 4095 pixels (2880
		pixels in AIR 1.5 and earlier).

		On Linux, setting the `width` property is an asynchronous operation.

		To detect the completion of the width change, listen for the `resize`
		event, which is dispatched on all platforms.

		Pixel values are rounded to the nearest integer when the width of a window is changed.
	**/
	public var width(get, set):Float;

	@:noCompletion private function get_width():Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		#if (lime < "8.1.0")
		if (!__opened)
		{
			return __pendingWidth;
		}
		#end
		return __window.width;
	}

	@:noCompletion private function set_width(value:Float):Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		#if (lime < "8.1.0")
		if (!__opened)
		{
			return __pendingWidth = Std.int(value);
		}
		#end
		return __window.width = Std.int(value);
	}

	/**
		The height of this window in pixels.

		The dimensions of a window include any system window chrome that is
		displayed. The height of the usable display area inside a window is
		available from the `Stage.stageHeight` property.

		Changing the `height` property of a window is equivalent to changing the
		height through the `bounds` property.

		If the height specified is less than the minimum or greater than the
		maximum allowed height, then the window height is set to the closest
		legal size. The factors that determine the minimum and maximum height
		are the following:

		- The `minSize.y` and `maxSize.y` properties of the NativeWindow object
		- The minimum and maximum operating system limits, which are the values
		of `NativeWindow.systemMinSize.y` and `NativeWindow.systemMaxSize.y`.
		- The maximum height of a window in Adobe AIR, which is 4095 pixels
		(2880 pixels in AIR 1.5 and earlier).

		On Linux, setting the `height` property is an asynchronous operation.

		To detect the completion of the height change, listen for the `resize`
		event, which is dispatched on all platforms.

		Pixel values are rounded to the nearest integer when the height of a
		window is changed.
	**/
	public var height(get, set):Float;

	@:noCompletion private function get_height():Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		#if (lime < "8.1.0")
		if (!__opened)
		{
			return __pendingHeight;
		}
		#end
		return __window.height;
	}

	@:noCompletion private function set_height(value:Float):Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		#if (lime < "8.1.0")
		if (!__opened)
		{
			return __pendingHeight = Std.int(value);
		}
		#end
		return __window.height = Std.int(value);
	}

	/**
		The size and location of this window.

		The dimensions of a window include any system chrome. The dimensions of
		a window's stage are equal to the dimensions of the window, minus the
		size of any system chrome. Changing the width and height of the window
		will change the stage's `stageWidth` and `stageHeight`. The reverse also
		applies; changing the stage dimensions will change the window size.

		A `resize` event is dispatched whenever the width or height of this
		window changes. Likewise, a `move` event is dispatched whenever the
		origin (x,y) of this window changes. On Mac OS and Windows, setting the
		`bounds` property directly will not dispatch a `moving` or `resizing`
		event. However, on Linux the NativeWindow does dispatch a `moving` and
		`resizing` events when you set the `bounds` property.

		Setting the `bounds` property of a window is equivalent to setting its
		`x`, `y`, `width`, and `height` properties. Likewise, setting any of the
		individual dimensions is equivalent to setting the `bounds` property.
		When you set all the dimensions at the same time by using the `bounds`
		property, fewer events are dispatched.

		The order in which the individual dimensions are set is not guaranteed.
		On Linux window managers that do not allow windows to extend off the
		desktop area, a change to an individual property may be blocked even
		though the net affect of applying all the property changes would have
		resulted in a legal window.

		If the width or height specified is less than the minimum or greater
		than the maximum allowed width or height, then the window width or
		height is set to the closest legal size. The factors that determine the
		minimum and maximum width and height are the following:

		- The `minSize` and `maxSize` properties of the NativeWindow object
		- The minimum and maximum operating system limits, which are the values
		of `NativeWindow.systemMinSize` and `NativeWindow.systemMaxSize`.
		- The maximum width and height of a window in Adobe AIR, which are each
		4095 pixels. (In AIR 1.5 and earlier, the maximum width and height of a
		window is 2880 pixels each.)
		- The minimum width and height required by any displayed system chrome.

		Pixel values are rounded to the nearest integer when the position or
		dimensions of a window are changed.
	**/
	public var bounds(get, set):Rectangle;

	@:noCompletion private function get_bounds():Rectangle
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return new Rectangle(__window.x, __window.y, __window.width, __window.height);
	}

	@:noCompletion private function set_bounds(value:Rectangle):Rectangle
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		__window.move(Std.int(value.x), Std.int(value.y));
		__window.resize(Std.int(value.width), Std.int(value.height));
		return new Rectangle(__window.x, __window.y, __window.width, __window.height);
	}

	/**
		The window title.

		The title will appear in the system chrome for the window, if displayed,
		as well as in other system-dependent locations (such as the task bar).
	**/
	public var title(get, set):String;

	@:noCompletion private function get_title():String
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.title;
	}

	@:noCompletion private function set_title(value:String):String
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __window.title = value;
	}

	/**
		Specifies whether this window is visible.

		An invisible window is not displayed on the desktop, but all window
		properties and methods are valid.

		By default, `visible` is set to false. To display a window, set
		`visible` to `true` or call `NativeWindow.activate()`.

		If this window has an owner, the visible state of that owning window
		determines whether this window is displayed. If the owning window is not
		displayed, then any owned windows are not displayed, even if their
		`visible` properties are `true`.

		Note: On Mac OS X, setting `visible` to `false` on a minimized window
		will not remove the window icon from the dock. If a user subsequently
		clicks the dock icon, the window will return to the visible state and be
		displayed on the desktop.
	**/
	public var visible(get, set):Bool;

	@:noCompletion private function get_visible():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		#if (lime < "8.1.0")
		return __opened;
		#else
		return __window.visible;
		#end
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		#if (lime < "8.1.0")
		if (!__opened)
		{
			__opened = true;
			__previousWidth = __pendingWidth;
			__previousHeight = __pendingHeight;
			__window.width = __pendingWidth;
			__window.height = __pendingHeight;
		}
		if (!value)
		{
			throw new IllegalOperationError("Setting NativeWindow visible to false is not supported at this time");
		}
		return __opened;
		#else
		return __window.visible = value;
		#end
	}

	/**
		Reports the system chrome setting used to create this window.

		The values returned by `NativeWindow.systemChrome` will be one of the
		constants defined in the NativeWindowSystemChrome class.

		The system chrome setting cannot be changed after a window is created.
	**/
	public var systemChrome(get, never):NativeWindowSystemChrome;

	@:noCompletion private function get_systemChrome():NativeWindowSystemChrome
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __initOptions.systemChrome;
	}

	/**
		The display state of this window.
	**/
	public var displayState(get, never):NativeWindowDisplayState;

	@:noCompletion private function get_displayState():NativeWindowDisplayState
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		if (__window.minimized)
		{
			return MINIMIZED;
		}
		else if (__window.maximized)
		{
			return MAXIMIZED;
		}
		return NORMAL;
	}

	/**
		Indicates whether this window is the active application window.

		Use the `activate()` method to make a window active.
	**/
	public var active(get, never):Bool;

	@:noCompletion private function get_active():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __active;
	}

	/**
		Indicates whether this window has been closed.

		Accessing the following properties on a closed window will throw an
		illegal operation error:

		- `title`
		- `bounds`
		- `x`, `y`, `width`, `height`
		- `displayState`
		- `visible`

		Likewise, calling the following methods on a closed window will also
		throw an illegal operation error:

		- `minimize()`
		- `maximize()`
		- `restore()`
		- `startResize()`
		- `startMove()`
	**/
	public var closed(get, never):Bool;

	@:noCompletion private function get_closed():Bool
	{
		return __closed;
	}

	/**
		Reports the maximizable setting used to create this window.

		The `maximizable` setting cannot be changed after a window is created.

		**Note:** Some Linux window managers allow windows to be maximized by
		the user even when the `maximizable` property is set to `false`.
	**/
	public var maximizable(get, never):Bool;

	@:noCompletion private function get_maximizable():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __initOptions.maximizable;
	}

	/**
		Reports the minimizable setting used to create this window.

		The `minimizable` setting cannot be changed after a window is created.

		**Note:** Some Linux window managers allow windows to be minimizable by
		the user even when the `minimizable` property is set to `false`.
	**/
	public var minimizable(get, never):Bool;

	@:noCompletion private function get_minimizable():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __initOptions.minimizable;
	}

	/**
		The NativeWindow object that owns this window.

		Window ownership is established when a window is created and cannot be
		changed. To create a window that has an owner, set the owning
		NativeWindow object as the `owner` property of the
		NativeWindowInitOptions object used to create the owned window.

		**Note:** On Linux, some window managers do not display owned windows in
		front of the owning window when the owner is in fullscreen mode.
	**/
	public var owner(get, never):NativeWindow;

	@:noCompletion private function get_owner():NativeWindow
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __initOptions.owner;
	}

	/**
		Reports the window `renderMode` setting used to create this window.

		The value returned by `NativeWindow.renderMode` will be one of the
		constants defined in the NativeWindowRenderMode class.

		The `renderMode` setting cannot be changed after a window is created.
	**/
	public var renderMode(get, never):String;

	@:noCompletion private function get_renderMode():String
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __initOptions.renderMode;
	}

	/**
		Reports the resizable setting used to create this window.

		The `resizable` setting cannot be changed after a window is created.
	**/
	public var resizable(get, never):Bool;

	@:noCompletion private function get_resizable():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __initOptions.resizable;
	}

	/**
		Reports the transparency setting used to create this window.

		The `transparent` property cannot be changed after a window is created
		 Transparency affects both the visual appearance and the mouse behavior
		 of the window. On Windows and Mac OS X, the window will not capture
		 mouse events when the `alpha` value of the pixel is below a certain
		 threshold, which varies between about `.06` and `.01` depending on th
		  operating system. On Linux, the window will capture mouse events above
		  completely transparent areas and therefore will prevent users from
		  accessing other windows and items on the desktop.

		**Note:** Window transparency cannot always be supported. If the user's
		operating system configuration is such that transparency is not
		available, the window will be created without transparency. Areas that
		would have been transparent are composited against black. Use the
		`NativeWindow.supportsTransparency` property to determine whether window
		transparency is supported.
	**/
	public var transparent(get, never):Bool;

	@:noCompletion private function get_transparent():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return false;
	}

	#if (lime >= "8.1.0")
	/**
		The minimum size for this window.

		The size limit is specified as the coordinates of a Point object. The
		point `x` property corresponds to the window width, the `y` property to
		the window height.

		Setting `minSize`, will change the window bounds if the current bounds
		are smaller than the new minimum size.

		The `minSize` restriction is enforced for window resizing operations
		invoked both through ActionScript code and through the operating system.

		Note: The width and height of any displayed system chrome may make it
		impossible to set a window as small as the specified minimum size.

		@see `NativeWindow.maxSize`
		@see `NativeWindow.width`
		@see `NativeWindow.height`
	**/
	public var minSize(get, set):Point;

	@:noCompletion private function get_minSize():Point
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return new Point(__window.minWidth, __window.minHeight);
	}

	@:noCompletion private function set_minSize(value:Point):Point
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		__window.setMinSize(Std.int(value.x), Std.int(value.y));
		return value;
	}
	#end

	#if (lime >= "8.1.0")
	/**
		The maximum size for this window.

		The size limit is specified as the coordinates of a Point object. The
		point `x` property corresponds to the window width, the `y` property to
		the window height.

		The `maxSize` restriction is enforced for window resizing operation
		invoked both through Haxe code and through the operating system.

		Setting `maxSize` will change the window bounds if the current bounds
		are larger than the new maximum size.

		If the width or height specified is greater than the maximum allowed
		width or height, then the window width is set to the closest legal size.
		The factors that determine the minimum and maximum width and height are
		the following:

		- The maximum operating system limit, which is the value
		`NativeWindow.systemMaxSize`.
		- The maximum width and height of a window in Adobe AIR, which is 4095
		pixels for each. (In AIR 1.5 and earlier, the maximum width and height
		of a window is 2880 pixels each.)

		Note: On some operating systems, such as Mac OS X, maximizing a window
		will only enlarge the window to the `maxSize` value even if the
		maximized window will be smaller than the operating system screen. The
		window will still be in the maximized display state.

		@see `NativeWindow.maxSize`
		@see `NativeWindow.width`
		@see `NativeWindow.height`
	**/
	public var maxSize(get, set):Point;

	@:noCompletion private function get_maxSize():Point
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return new Point(__window.maxWidth, __window.maxHeight);
	}

	@:noCompletion private function set_maxSize(value:Point):Point
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		__window.setMaxSize(Std.int(value.x), Std.int(value.y));
		return value;
	}
	#end

	/**
		Activates this window.

		Activating a window will:

		- Make the window visible
		- Bring the window to the front
		- Give the window keyboard and mouse focus

		On Linux, `activate()` is an asynchronous operation.

		The NativeWindow object dispatches an `activate` event on all platforms.
	**/
	public function activate():Void
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		visible = true;
		__window.focus();
	}

	/**
		Closes this window.

		A `close` event is dispatched as soon as the close operation is
		complete. A `closing` event will not be dispatched. If cancellation of
		the close operation should be allowed, manually dispatch a `closing`
		event and check whether any registered listeners cancel the default
		behavior before calling the `close()` method.

		When a window is closed, any windows that it owns are also closed. The
		owned windows do not dispatch `closing` events.

		If display object instances that are currently in the window are not
		referenced elsewhere they will be garbage collected and destroyed,
		except on the initial application window created by AIR. To allow
		display objects on the initial window to be garbage collected, remove
		them from the window stage.

		After being closed, the NativeWindow object is still a valid reference,
		but accessing most properties and methods will throw an illegal
		operation error.

		Closed windows cannot be reopened. If the window is already closed, no
		action is taken and no events are dispatched.

		Note: to hide a window without closing it, set the window's `visible`
		property to `false`.
	**/
	public function close():Void
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		__window.close();
	}

	/**
		Minimizes this window.

		Calling `minimize()` dispatches a `displayStateChange` event, and, if
		applicable, a `move` and a `resize` event. Whereas system chrome will
		dispatch a `displayStateChanging` event that can be canceled when a
		minimize command is initiated by a user, calling `minimize()` directly
		does not. Your minimize logic may manually implement this behavior, if
		desired.

		The `minimize()` method executes asynchronously. To detect th
		completion of the state change, listen for the `displayStateChange`
		event, which is dispatched on all platforms. If the window is already
		minimized, no action is taken and no events are dispatched.

		Any windows owned by this window are hidden when it is minimized. The
		owned windows do not dispatch `displayStateChanging` or
		`displayStateChange` events.

		**Notes:**

		- On Windows, minimizing an invisible window (`visible == false`), will
		make the window visible.
		- Some Linux window managers do not allow utility windows to be
		minimized.
	**/
	public function minimize():Void
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		__window.minimized = true;
	}

	/**
		Maximizes this window.

		Calling `maximize()` method dispatches a `displayStateChange` event,
		and, if applicable, a `move` and a `resize` event. Whereas system chrome
		will dispatch a `displayStateChanging` event that can be canceled when a
		maximize command is initiated by a user, your maximize logic must
		manually implement this behavior, if desired.

		The `maximize()` method executes asynchronously. To detect the
		completion of the state change, listen for the `displayStateChange`
		event. If the window is already maximized, no action is taken and no
		events are dispatched.

		**OS behavior notes:**

		- On operating systems, such as Mac OS X, in which maximizing a window
		does not also prevent resizing, calling `maximize()` will zoom the
		window to fill the screen, but will not prevent subsequent resizing of
		the window. Resizing a zoomed window will also restore the display
		state.
		- On some operating systems, such as Mac OS X, as well as on some Linux
		window managers, maximizing a window will not expand the window beyond
		the width and height specified in the `maxSize` property. On others, the
		window will expand to fill the screen even if the screen is larger than
		the `maxSize`.
		- Some Linux window managers do not allow utility windows to be
		maximized.
	**/
	public function maximize():Void
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		__window.maximized = true;
	}

	/**
		Restores this window from either a minimized or a maximized state.

		Calling `restore()` dispatches a `displayStateChange` event, and, if
		applicable, a `move` and a `resize` event. Whereas system chrome will
		dispatch a `displayStateChanging` event that can be canceled when a
		restore command is initiated by a user, your restore logic must manually
		implement this behavior, if desired.

		If the window is already in the `NativeWindowDisplayState.NORMAL` state,
		no action is taken and no events are dispatched.

		To detect the completion of the state change, listen for the
		`displayStateChange` event, which is dispatched on all platforms.
	**/
	public function restore():Void
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		if (__window.maximized)
		{
			__window.maximized = false;
		}
		if (__window.minimized)
		{
			__window.minimized = false;
		}
	}

	/**
		Returns a list of the NativeWindow objects that are owned by this
		window.

		You cannot change ownership of NativeWindows by adding or removing
		objects from the returned vector. Window ownership cannot be changed
		after a window is created.
	**/
	public function listOwnedWindows():Vector<NativeWindow>
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		// don't allow the original value to be edited externally
		return __ownedWindows.copy();
	}

	@:noCompletion private function window_onFocusIn():Void
	{
		__active = true;
		NativeApplication.nativeApplication.__activeWindow = this;
		dispatchEvent(new Event(Event.ACTIVATE, false, false));
		// TODO: dispatch only when the previously focused window was from
		// a different application
		NativeApplication.nativeApplication.dispatchEvent(new Event(Event.ACTIVATE, false, false));
	}

	@:noCompletion private function window_onFocusOut():Void
	{
		__active = false;
		if (NativeApplication.nativeApplication.__activeWindow == this)
		{
			NativeApplication.nativeApplication.__activeWindow = null;
			// TODO: dispatch only when the next focused window isn't a part of
			// this application
			NativeApplication.nativeApplication.dispatchEvent(new Event(Event.DEACTIVATE, false, false));
		}
		dispatchEvent(new Event(Event.DEACTIVATE, false, false));
	}

	@:noCompletion private function window_onMove(x:Float, y:Float):Void
	{
		var beforeBounds = new Rectangle(__previousX, __previousY, __window.width, __window.height);
		var afterBounds = new Rectangle(__window.x, __window.y, __window.width, __window.height);
		__previousX = __window.x;
		__previousY = __window.y;
		dispatchEvent(new NativeWindowBoundsEvent(NativeWindowBoundsEvent.MOVE, false, false, beforeBounds, afterBounds));
	}

	@:noCompletion private function window_onResize(width:Float, height:Float):Void
	{
		var beforeBounds = new Rectangle(__window.x, __window.y, __previousWidth, __previousHeight);
		var afterBounds = new Rectangle(__window.x, __window.y, __window.width, __window.height);
		__previousWidth = __window.width;
		__previousHeight = __window.height;
		dispatchEvent(new NativeWindowBoundsEvent(NativeWindowBoundsEvent.RESIZE, false, false, beforeBounds, afterBounds));
	}

	@:noCompletion private function window_onMinimize():Void
	{
		var beforeDisplayState = __previousDisplayState;
		var afterDisplayState = NativeWindowDisplayState.MINIMIZED;
		__previousDisplayState = afterDisplayState;
		dispatchEvent(new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, false, false, beforeDisplayState,
			afterDisplayState));
	}

	@:noCompletion private function window_onMaximize():Void
	{
		var beforeDisplayState = __previousDisplayState;
		var afterDisplayState = NativeWindowDisplayState.MAXIMIZED;
		__previousDisplayState = afterDisplayState;
		dispatchEvent(new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, false, false, beforeDisplayState,
			afterDisplayState));
	}

	@:noCompletion private function window_onRestore():Void
	{
		var beforeDisplayState = __previousDisplayState;
		var afterDisplayState = NativeWindowDisplayState.NORMAL;
		__previousDisplayState = afterDisplayState;
		dispatchEvent(new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE, false, false, beforeDisplayState,
			afterDisplayState));
	}

	@:noCompletion private function window_onClose():Void
	{
		// all child windows are closed when their owner is closed
		while (__ownedWindows.length > 0)
		{
			var childWindow = __ownedWindows.pop();
			childWindow.close();
		}
		__closed = true;
		__window.onFocusIn.remove(window_onFocusIn);
		__window.onFocusOut.remove(window_onFocusOut);
		__window.onResize.remove(window_onResize);
		if (__initOptions.owner != null)
		{
			var index = __initOptions.owner.__ownedWindows.indexOf(this);
			if (index != -1)
			{
				__initOptions.owner.__ownedWindows.removeAt(index);
			}
		}
		var index = NativeApplication.nativeApplication.__openedWindows.indexOf(this);
		if (index != -1)
		{
			NativeApplication.nativeApplication.__openedWindows.splice(index, 1);
		}
		dispatchEvent(new Event(Event.CLOSE));
	}
}
#else
#if air
typedef NativeWindow = flash.display.NativeWindow;
#end
#end
