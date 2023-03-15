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

/**
**/
@:access(openfl.desktop.NativeApplication)
@:access(openfl.display.NativeWindowInitOptions)
@:access(openfl.display.Stage)
@:access(lime.ui.Window)
class NativeWindow extends EventDispatcher
{
	private static final ERROR_CLOSED = "Cannot perform operation on closed window.";

	/**
	**/
	public static var isSupported(get, never):Bool;

	@:noCompletion private static function get_isSupported():Bool
	{
		return true;
	}

	/**
	**/
	public static var supportsMenu(get, never):Bool;

	@:noCompletion private static function get_supportsMenu():Bool
	{
		return false;
	}

	/**
	**/
	public static var supportsTransparency(get, never):Bool;

	@:noCompletion private static function get_supportsTransparency():Bool
	{
		return false;
	}

	@:noCompletion private var __initOptions:NativeWindowInitOptions;
	@:noCompletion private var __window:Window;
	@:noCompletion private var __opened:Bool = false;
	@:noCompletion private var __closed:Bool = false;
	@:noCompletion private var __pendingWidth:Int = 400;
	@:noCompletion private var __pendingHeight:Int = 228;
	@:noCompletion private var __previousX:Int;
	@:noCompletion private var __previousY:Int;
	@:noCompletion private var __previousWidth:Int;
	@:noCompletion private var __previousHeight:Int;
	@:noCompletion private var __previousDisplayState:NativeWindowDisplayState;
	@:noCompletion private var __active:Bool = false;
	@:noCompletion private var __ownedWindows:Vector<NativeWindow> = new Vector();

	/**
	**/
	public function new(initOptions:NativeWindowInitOptions)
	{
		super();
		__initOptions = initOptions;
		if (__initOptions.__window != null)
		{
			__window = __initOptions.__window;
			__opened = true;
			__pendingWidth = __window.width;
			__pendingHeight = __window.height;
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
				minimized: false,
				maximized: false,
				fullscreen: false,
				frameRate: app.window.stage.frameRate,
				borderless: false,
				width: 0,
				height: 0
			});
			if (__initOptions.owner != null)
			{
				__initOptions.owner.__ownedWindows.push(this);
			}
		}
		__previousX = __window.x;
		__previousY = __window.y;
		__previousWidth = __pendingWidth;
		__previousHeight = __pendingHeight;
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
	**/
	public var width(get, set):Float;

	@:noCompletion private function get_width():Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		if (!__opened)
		{
			return __pendingWidth;
		}
		return __window.width;
	}

	@:noCompletion private function set_width(value:Float):Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		if (!__opened)
		{
			return __pendingWidth = Std.int(value);
		}
		return __window.width = Std.int(value);
	}

	/**
	**/
	public var height(get, set):Float;

	@:noCompletion private function get_height():Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		if (!__opened)
		{
			return __pendingHeight;
		}
		return __window.height;
	}

	@:noCompletion private function set_height(value:Float):Float
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		if (!__opened)
		{
			return __pendingHeight = Std.int(value);
		}
		return __window.height = Std.int(value);
	}

	/**
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
	**/
	public var visible(get, set):Bool;

	@:noCompletion private function get_visible():Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
		return __opened;
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		if (__closed)
		{
			throw new Error(ERROR_CLOSED, 3200);
		}
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
	}

	/**
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
	**/
	public var closed(get, never):Bool;

	@:noCompletion private function get_closed():Bool
	{
		return __closed;
	}

	/**
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

	/**
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
