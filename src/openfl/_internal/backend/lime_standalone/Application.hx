package openfl._internal.backend.lime_standalone;

import lime.graphics.RenderContext;
import lime.system.System;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.JoystickHatPosition;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseButton;
import lime.ui.MouseWheelMode;
import lime.ui.Touch;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import lime.utils.Preloader;

/**
	The Application class forms the foundation for most Lime projects.
	It is common to extend this class in a main class. It is then possible
	to override "on" functions in the class in order to handle standard events
	that are relevant.
**/
@:access(lime.ui.Window)
#if !lime_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Application extends Module
{
	/**
		The current Application instance that is executing
	**/
	public static var current(default, null):Application;

	/**
		Meta-data values for the application, such as a version or a package name
	**/
	public var meta:Map<String, String>;

	/**
		A list of currently attached Module instances
	**/
	public var modules(default, null):Array<IModule>;

	/**
		Update events are dispatched each frame (usually just before rendering)
	**/
	public var onUpdate = new Event<Int->Void>();

	/**
		Dispatched when a new window has been created by this application
	**/
	public var onCreateWindow = new Event<Window->Void>();

	/**
		The Preloader for the current Application
	**/
	public var preloader(get, null):Preloader;

	/**
		The Window associated with this Application, or the first Window
		if there are multiple Windows active
	**/
	public var window(get, null):Window;

	/**
		A list of active Window instances associated with this Application
	**/
	public var windows(get, null):Array<Window>;

	@:noCompletion private var __backend:ApplicationBackend;
	@:noCompletion private var __preloader:Preloader;
	@:noCompletion private var __window:Window;
	@:noCompletion private var __windowByID:Map<Int, Window>;
	@:noCompletion private var __windows:Array<Window>;

	private static function __init__()
	{
		var init = ApplicationBackend;
		#if commonjs
		var p = untyped Application.prototype;
		untyped Object.defineProperties(p, {
			"preloader": {get: p.get_preloader},
			"window": {get: p.get_window},
			"windows": {get: p.get_windows}
		});
		#end
	}

	/**
		Creates a new Application instance
	**/
	public function new()
	{
		super();

		if (Application.current == null)
		{
			Application.current = this;
		}

		meta = new Map();
		modules = new Array();
		__windowByID = new Map();
		__windows = new Array();

		__backend = new ApplicationBackend(this);

		__registerLimeModule(this);

		__preloader = new Preloader();
		__preloader.onProgress.add(onPreloadProgress);
		__preloader.onComplete.add(onPreloadComplete);
	}

	/**
		Adds a new module to the Application
		@param	module	A module to add
	**/
	public function addModule(module:IModule):Void
	{
		module.__registerLimeModule(this);
		modules.push(module);
	}

	/**
		Creates a new Window and adds it to the Application
		@param	attributes	A set of parameters to initialize the window
	**/
	public function createWindow(attributes:WindowAttributes):Window
	{
		var window = __createWindow(attributes);
		__addWindow(window);
		return window;
	}

	/**
		Execute the Application. On native platforms, this method
		blocks until the application is finished running. On other
		platforms, it will return immediately
		@return	An exit code, 0 if there was no error
	**/
	public function exec():Int
	{
		Application.current = this;

		return __backend.exec();
	}

	/**
		Called when a gamepad axis move event is fired
		@param	gamepad	The current gamepad
		@param	axis	The axis that was moved
		@param	value	The axis value (between 0 and 1)
	**/
	public function onGamepadAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void {}

	/**
		Called when a gamepad button down event is fired
		@param	gamepad	The current gamepad
		@param	button	The button that was pressed
	**/
	public function onGamepadButtonDown(gamepad:Gamepad, button:GamepadButton):Void {}

	/**
		Called when a gamepad button up event is fired
		@param	gamepad	The current gamepad
		@param	button	The button that was released
	**/
	public function onGamepadButtonUp(gamepad:Gamepad, button:GamepadButton):Void {}

	/**
		Called when a gamepad is connected
		@param	gamepad	The gamepad that was connected
	**/
	public function onGamepadConnect(gamepad:Gamepad):Void {}

	/**
		Called when a gamepad is disconnected
		@param	gamepad	The gamepad that was disconnected
	**/
	public function onGamepadDisconnect(gamepad:Gamepad):Void {}

	/**
		Called when a joystick axis move event is fired
		@param	joystick	The current joystick
		@param	axis	The axis that was moved
		@param	value	The axis value (between 0 and 1)
	**/
	public function onJoystickAxisMove(joystick:Joystick, axis:Int, value:Float):Void {}

	/**
		Called when a joystick button down event is fired
		@param	joystick	The current joystick
		@param	button	The button that was pressed
	**/
	public function onJoystickButtonDown(joystick:Joystick, button:Int):Void {}

	/**
		Called when a joystick button up event is fired
		@param	joystick	The current joystick
		@param	button	The button that was released
	**/
	public function onJoystickButtonUp(joystick:Joystick, button:Int):Void {}

	/**
		Called when a joystick is connected
		@param	joystick	The joystick that was connected
	**/
	public function onJoystickConnect(joystick:Joystick):Void {}

	/**
		Called when a joystick is disconnected
		@param	joystick	The joystick that was disconnected
	**/
	public function onJoystickDisconnect(joystick:Joystick):Void {}

	/**
		Called when a joystick hat move event is fired
		@param	joystick	The current joystick
		@param	hat	The hat that was moved
		@param	position	The current hat position
	**/
	public function onJoystickHatMove(joystick:Joystick, hat:Int, position:JoystickHatPosition):Void {}

	/**
		Called when a joystick axis move event is fired
		@param	joystick	The current joystick
		@param	trackball	The trackball that was moved
		@param	x	The x movement of the trackball (between 0 and 1)
		@param	y	The y movement of the trackball (between 0 and 1)
	**/
	public function onJoystickTrackballMove(joystick:Joystick, trackball:Int, x:Float, y:Float):Void {}

	/**
		Called when a key down event is fired on the primary window
		@param	keyCode	The code of the key that was pressed
		@param	modifier	The modifier of the key that was pressed
	**/
	public function onKeyDown(keyCode:KeyCode, modifier:KeyModifier):Void {}

	/**
		Called when a key up event is fired on the primary window
		@param	keyCode	The code of the key that was released
		@param	modifier	The modifier of the key that was released
	**/
	public function onKeyUp(keyCode:KeyCode, modifier:KeyModifier):Void {}

	/**
		Called when the module is exiting
	**/
	public function onModuleExit(code:Int):Void {}

	/**
		Called when a mouse down event is fired on the primary window
		@param	x	The current x coordinate of the mouse
		@param	y	The current y coordinate of the mouse
		@param	button	The ID of the mouse button that was pressed
	**/
	public function onMouseDown(x:Float, y:Float, button:MouseButton):Void {}

	/**
		Called when a mouse move event is fired on the primary window
		@param	x	The current x coordinate of the mouse
		@param	y	The current y coordinate of the mouse
	**/
	public function onMouseMove(x:Float, y:Float):Void {}

	/**
		Called when a mouse move relative event is fired on the primary window
		@param	x	The x movement of the mouse
		@param	y	The y movement of the mouse
	**/
	public function onMouseMoveRelative(x:Float, y:Float):Void {}

	/**
		Called when a mouse up event is fired on the primary window
		@param	x	The current x coordinate of the mouse
		@param	y	The current y coordinate of the mouse
		@param	button	The ID of the button that was released
	**/
	public function onMouseUp(x:Float, y:Float, button:MouseButton):Void {}

	/**
		Called when a mouse wheel event is fired on the primary window
		@param	deltaX	The amount of horizontal scrolling (if applicable)
		@param	deltaY	The amount of vertical scrolling (if applicable)
		@param	deltaMode	The units of measurement used
	**/
	public function onMouseWheel(deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void {}

	/**
		Called when a preload complete event is fired
	**/
	public function onPreloadComplete():Void {}

	/**
		Called when a preload progress event is fired
		@param	loaded	The number of items that are loaded
		@param	total	The total number of items will be loaded
	**/
	public function onPreloadProgress(loaded:Int, total:Int):Void {}

	/**
		Called when a render context is lost on the primary window
	**/
	public function onRenderContextLost():Void {}

	/**
		Called when a render context is restored on the primary window
		@param	context	The render context relevant to the event
	**/
	public function onRenderContextRestored(context:RenderContext):Void {}

	/**
		Called when a text edit event is fired on the primary window
		@param	text	The current replacement text
		@param	start	The starting index for the edit
		@param	length	The length of the edit
	**/
	public function onTextEdit(text:String, start:Int, length:Int):Void {}

	/**
		Called when a text input event is fired on the primary window
		@param	text	The current input text
	**/
	public function onTextInput(text:String):Void {}

	/**
		Called when a touch cancel event is fired
		@param	touch	The current touch object
	**/
	public function onTouchCancel(touch:Touch):Void {}

	/**
		Called when a touch end event is fired
		@param	touch	The current touch object
	**/
	public function onTouchEnd(touch:Touch):Void {}

	/**
		Called when a touch move event is fired
		@param	touch	The current touch object
	**/
	public function onTouchMove(touch:Touch):Void {}

	/**
		Called when a touch start event is fired
		@param	touch	The current touch object
	**/
	public function onTouchStart(touch:Touch):Void {}

	/**
		Called when a window activate event is fired on the primary window
	**/
	public function onWindowActivate():Void {}

	/**
		Called when a window close event is fired on the primary window
	**/
	public function onWindowClose():Void {}

	/**
		Called when the primary window is created
	**/
	public function onWindowCreate():Void {}

	/**
		Called when a window deactivate event is fired on the primary window
	**/
	public function onWindowDeactivate():Void {}

	/**
		Called when a window drop file event is fired on the primary window
	**/
	public function onWindowDropFile(file:String):Void {}

	/**
		Called when a window enter event is fired on the primary window
	**/
	public function onWindowEnter():Void {}

	/**
		Called when a window expose event is fired on the primary window
	**/
	public function onWindowExpose():Void {}

	/**
		Called when a window focus in event is fired on the primary window
	**/
	public function onWindowFocusIn():Void {}

	/**
		Called when a window focus out event is fired on the primary window
	**/
	public function onWindowFocusOut():Void {}

	/**
		Called when the primary window enters fullscreen
	**/
	public function onWindowFullscreen():Void {}

	/**
		Called when a window leave event is fired on the primary window
	**/
	public function onWindowLeave():Void {}

	/**
		Called when a window move event is fired on the primary window
		@param	x	The x position of the window in desktop coordinates
		@param	y	The y position of the window in desktop coordinates
	**/
	public function onWindowMove(x:Float, y:Float):Void {}

	/**
		Called when the primary window is minimized
	**/
	public function onWindowMinimize():Void {}

	/**
		Called when a window resize event is fired on the primary window
		@param	width	The width of the window
		@param	height	The height of the window
	**/
	public function onWindowResize(width:Int, height:Int):Void {}

	/**
		Called when the primary window is restored from being minimized or fullscreen
	**/
	public function onWindowRestore():Void {}

	/**
		Removes a module from the Application
		@param	module	A module to remove
	**/
	public function removeModule(module:IModule):Void
	{
		if (module != null)
		{
			module.__unregisterLimeModule(this);
			modules.remove(module);
		}
	}

	/**
		Called when a render event is fired on the primary window
		@param	context	The render context ready to be rendered
	**/
	public function render(context:RenderContext):Void {}

	/**
		Called when an update event is fired on the primary window
		@param	deltaTime	The amount of time in milliseconds that has elapsed since the last update
	**/
	public function update(deltaTime:Int):Void {}

	@:noCompletion private function __addWindow(window:Window):Void
	{
		if (window != null)
		{
			__windows.push(window);
			__windowByID.set(window.id, window);

			window.onClose.add(__onWindowClose.bind(window), false, -10000);

			if (__window == null)
			{
				__window = window;

				window.onActivate.add(onWindowActivate);
				window.onRenderContextLost.add(onRenderContextLost);
				window.onRenderContextRestored.add(onRenderContextRestored);
				window.onDeactivate.add(onWindowDeactivate);
				window.onDropFile.add(onWindowDropFile);
				window.onEnter.add(onWindowEnter);
				window.onExpose.add(onWindowExpose);
				window.onFocusIn.add(onWindowFocusIn);
				window.onFocusOut.add(onWindowFocusOut);
				window.onFullscreen.add(onWindowFullscreen);
				window.onKeyDown.add(onKeyDown);
				window.onKeyUp.add(onKeyUp);
				window.onLeave.add(onWindowLeave);
				window.onMinimize.add(onWindowMinimize);
				window.onMouseDown.add(onMouseDown);
				window.onMouseMove.add(onMouseMove);
				window.onMouseMoveRelative.add(onMouseMoveRelative);
				window.onMouseUp.add(onMouseUp);
				window.onMouseWheel.add(onMouseWheel);
				window.onMove.add(onWindowMove);
				window.onRender.add(render);
				window.onResize.add(onWindowResize);
				window.onRestore.add(onWindowRestore);
				window.onTextEdit.add(onTextEdit);
				window.onTextInput.add(onTextInput);

				onWindowCreate();
			}

			onCreateWindow.dispatch(window);
		}
	}

	@:noCompletion private function __createWindow(attributes:WindowAttributes):Window
	{
		var window = new Window(this, attributes);
		if (window.id == -1) return null;
		return window;
	}

	@:noCompletion private override function __registerLimeModule(application:Application):Void
	{
		application.onUpdate.add(update);
		application.onExit.add(onModuleExit, false, 0);
		application.onExit.add(__onModuleExit, false, 0);

		for (gamepad in Gamepad.devices)
		{
			__onGamepadConnect(gamepad);
		}

		Gamepad.onConnect.add(__onGamepadConnect);

		for (joystick in Joystick.devices)
		{
			__onJoystickConnect(joystick);
		}

		Joystick.onConnect.add(__onJoystickConnect);

		Touch.onCancel.add(onTouchCancel);
		Touch.onStart.add(onTouchStart);
		Touch.onMove.add(onTouchMove);
		Touch.onEnd.add(onTouchEnd);
	}

	@:noCompletion private function __removeWindow(window:Window):Void
	{
		if (window != null && __windowByID.exists(window.id))
		{
			if (__window == window)
			{
				__window = null;
			}

			__windows.remove(window);
			__windowByID.remove(window.id);
			window.close();

			if (__windows.length == 0)
			{
				#if !lime_doc_gen
				System.exit(0);
				#end
			}
		}
	}

	@:noCompletion private function __onGamepadConnect(gamepad:Gamepad):Void
	{
		onGamepadConnect(gamepad);

		gamepad.onAxisMove.add(onGamepadAxisMove.bind(gamepad));
		gamepad.onButtonDown.add(onGamepadButtonDown.bind(gamepad));
		gamepad.onButtonUp.add(onGamepadButtonUp.bind(gamepad));
		gamepad.onDisconnect.add(onGamepadDisconnect.bind(gamepad));
	}

	@:noCompletion private function __onJoystickConnect(joystick:Joystick):Void
	{
		onJoystickConnect(joystick);

		joystick.onAxisMove.add(onJoystickAxisMove.bind(joystick));
		joystick.onButtonDown.add(onJoystickButtonDown.bind(joystick));
		joystick.onButtonUp.add(onJoystickButtonUp.bind(joystick));
		joystick.onDisconnect.add(onJoystickDisconnect.bind(joystick));
		joystick.onHatMove.add(onJoystickHatMove.bind(joystick));
		joystick.onTrackballMove.add(onJoystickTrackballMove.bind(joystick));
	}

	@:noCompletion private function __onModuleExit(code:Int):Void
	{
		__backend.exit();
	}

	@:noCompletion private function __onWindowClose(window:Window):Void
	{
		if (this.window == window)
		{
			onWindowClose();
		}

		__removeWindow(window);
	}

	@:noCompletion private override function __unregisterLimeModule(application:Application):Void
	{
		application.onUpdate.remove(update);
		application.onExit.remove(__onModuleExit);
		application.onExit.remove(onModuleExit);

		Gamepad.onConnect.remove(__onGamepadConnect);
		Joystick.onConnect.remove(__onJoystickConnect);
		Touch.onCancel.remove(onTouchCancel);
		Touch.onStart.remove(onTouchStart);
		Touch.onMove.remove(onTouchMove);
		Touch.onEnd.remove(onTouchEnd);

		onModuleExit(0);
	}

	// Get & Set Methods
	@:noCompletion private inline function get_preloader():Preloader
	{
		return __preloader;
	}

	@:noCompletion private inline function get_window():Window
	{
		return __window;
	}

	@:noCompletion private inline function get_windows():Array<Window>
	{
		return __windows;
	}
}

#if kha
@:noCompletion private typedef ApplicationBackend = lime._internal.backend.kha.KhaApplication;
#elseif air
@:noCompletion private typedef ApplicationBackend = lime._internal.backend.air.AIRApplication;
#elseif flash
@:noCompletion private typedef ApplicationBackend = lime._internal.backend.flash.FlashApplication;
#elseif (js && html5)
@:noCompletion private typedef ApplicationBackend = lime._internal.backend.html5.HTML5Application;
#else
@:noCompletion private typedef ApplicationBackend = lime._internal.backend.native.NativeApplication;
#end

package lime._internal.backend.html5;

import js.html.DeviceMotionEvent;
import js.html.KeyboardEvent;
import js.Browser;
import lime.app.Application;
import lime.media.AudioManager;
import lime.system.Sensor;
import lime.system.SensorType;
import lime.ui.GamepadAxis;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Gamepad;
import lime.ui.GamepadButton;
import lime.ui.Joystick;
import lime.ui.Window;

@:access(lime._internal.backend.html5.HTML5Window)
@:access(lime.app.Application)
@:access(lime.system.Sensor)
@:access(lime.ui.Gamepad)
@:access(lime.ui.Joystick)
@:access(lime.ui.Window)
class HTML5Application
{
	private var gameDeviceCache = new Map<Int, GameDeviceData>();
	private var accelerometer:Sensor;
	private var currentUpdate:Float;
	private var deltaTime:Float;
	private var framePeriod:Float;
	private var lastUpdate:Float;
	private var nextUpdate:Float;
	private var parent:Application;
	#if stats
	private var stats:Dynamic;
	#end

	public inline function new(parent:Application)
	{
		this.parent = parent;

		currentUpdate = 0;
		lastUpdate = 0;
		nextUpdate = 0;
		framePeriod = -1;

		AudioManager.init();
		accelerometer = Sensor.registerSensor(SensorType.ACCELEROMETER, 0);
	}

	private function convertKeyCode(keyCode:Int):KeyCode
	{
		if (keyCode >= 65 && keyCode <= 90)
		{
			return keyCode + 32;
		}

		switch (keyCode)
		{
			case 12:
				return KeyCode.CLEAR;
			case 16:
				return KeyCode.LEFT_SHIFT;
			case 17:
				return KeyCode.LEFT_CTRL;
			case 18:
				return KeyCode.LEFT_ALT;
			case 19:
				return KeyCode.PAUSE;
			case 20:
				return KeyCode.CAPS_LOCK;
			case 33:
				return KeyCode.PAGE_UP;
			case 34:
				return KeyCode.PAGE_DOWN;
			case 35:
				return KeyCode.END;
			case 36:
				return KeyCode.HOME;
			case 37:
				return KeyCode.LEFT;
			case 38:
				return KeyCode.UP;
			case 39:
				return KeyCode.RIGHT;
			case 40:
				return KeyCode.DOWN;
			case 41:
				return KeyCode.SELECT;
			case 43:
				return KeyCode.EXECUTE;
			case 44:
				return KeyCode.PRINT_SCREEN;
			case 45:
				return KeyCode.INSERT;
			case 46:
				return KeyCode.DELETE;
			case 91:
				return KeyCode.LEFT_META;
			case 92:
				return KeyCode.RIGHT_META;
			case 93:
				return KeyCode.RIGHT_META; // this maybe should be APPLICATION if on Windows
			case 95:
				return KeyCode.SLEEP;
			case 96:
				return KeyCode.NUMPAD_0;
			case 97:
				return KeyCode.NUMPAD_1;
			case 98:
				return KeyCode.NUMPAD_2;
			case 99:
				return KeyCode.NUMPAD_3;
			case 100:
				return KeyCode.NUMPAD_4;
			case 101:
				return KeyCode.NUMPAD_5;
			case 102:
				return KeyCode.NUMPAD_6;
			case 103:
				return KeyCode.NUMPAD_7;
			case 104:
				return KeyCode.NUMPAD_8;
			case 105:
				return KeyCode.NUMPAD_9;
			case 106:
				return KeyCode.NUMPAD_MULTIPLY;
			case 107:
				return KeyCode.NUMPAD_PLUS;
			case 108:
				return KeyCode.NUMPAD_PERIOD;
			case 109:
				return KeyCode.NUMPAD_MINUS;
			case 110:
				return KeyCode.NUMPAD_PERIOD;
			case 111:
				return KeyCode.NUMPAD_DIVIDE;
			case 112:
				return KeyCode.F1;
			case 113:
				return KeyCode.F2;
			case 114:
				return KeyCode.F3;
			case 115:
				return KeyCode.F4;
			case 116:
				return KeyCode.F5;
			case 117:
				return KeyCode.F6;
			case 118:
				return KeyCode.F7;
			case 119:
				return KeyCode.F8;
			case 120:
				return KeyCode.F9;
			case 121:
				return KeyCode.F10;
			case 122:
				return KeyCode.F11;
			case 123:
				return KeyCode.F12;
			case 124:
				return KeyCode.F13;
			case 125:
				return KeyCode.F14;
			case 126:
				return KeyCode.F15;
			case 127:
				return KeyCode.F16;
			case 128:
				return KeyCode.F17;
			case 129:
				return KeyCode.F18;
			case 130:
				return KeyCode.F19;
			case 131:
				return KeyCode.F20;
			case 132:
				return KeyCode.F21;
			case 133:
				return KeyCode.F22;
			case 134:
				return KeyCode.F23;
			case 135:
				return KeyCode.F24;
			case 144:
				return KeyCode.NUM_LOCK;
			case 145:
				return KeyCode.SCROLL_LOCK;
			case 160:
				return KeyCode.CARET;
			case 161:
				return KeyCode.EXCLAMATION;
			case 163:
				return KeyCode.HASH;
			case 164:
				return KeyCode.DOLLAR;
			case 166:
				return KeyCode.APP_CONTROL_BACK;
			case 167:
				return KeyCode.APP_CONTROL_FORWARD;
			case 168:
				return KeyCode.APP_CONTROL_REFRESH;
			case 169:
				return KeyCode.RIGHT_PARENTHESIS; // is this correct?
			case 170:
				return KeyCode.ASTERISK;
			case 171:
				return KeyCode.GRAVE;
			case 172:
				return KeyCode.HOME;
			case 173:
				return KeyCode.MINUS; // or mute/unmute?
			case 174:
				return KeyCode.VOLUME_DOWN;
			case 175:
				return KeyCode.VOLUME_UP;
			case 176:
				return KeyCode.AUDIO_NEXT;
			case 177:
				return KeyCode.AUDIO_PREVIOUS;
			case 178:
				return KeyCode.AUDIO_STOP;
			case 179:
				return KeyCode.AUDIO_PLAY;
			case 180:
				return KeyCode.MAIL;
			case 181:
				return KeyCode.AUDIO_MUTE;
			case 182:
				return KeyCode.VOLUME_DOWN;
			case 183:
				return KeyCode.VOLUME_UP;
			case 186:
				return KeyCode.SEMICOLON; // or ñ?
			case 187:
				return KeyCode.EQUALS;
			case 188:
				return KeyCode.COMMA;
			case 189:
				return KeyCode.MINUS;
			case 190:
				return KeyCode.PERIOD;
			case 191:
				return KeyCode.SLASH;
			case 192:
				return KeyCode.GRAVE;
			case 193:
				return KeyCode.QUESTION;
			case 194:
				return KeyCode.NUMPAD_PERIOD;
			case 219:
				return KeyCode.LEFT_BRACKET;
			case 220:
				return KeyCode.BACKSLASH;
			case 221:
				return KeyCode.RIGHT_BRACKET;
			case 222:
				return KeyCode.SINGLE_QUOTE;
			case 223:
				return KeyCode.GRAVE;
			case 224:
				return KeyCode.LEFT_META;
			case 226:
				return KeyCode.BACKSLASH;
		}

		return keyCode;
	}

	public function exec():Int
	{
		Browser.window.addEventListener("keydown", handleKeyEvent, false);
		Browser.window.addEventListener("keyup", handleKeyEvent, false);
		Browser.window.addEventListener("focus", handleWindowEvent, false);
		Browser.window.addEventListener("blur", handleWindowEvent, false);
		Browser.window.addEventListener("resize", handleWindowEvent, false);
		Browser.window.addEventListener("beforeunload", handleWindowEvent, false);
		Browser.window.addEventListener("devicemotion", handleSensorEvent, false);

		#if stats
		stats = untyped __js__("new Stats ()");
		stats.domElement.style.position = "absolute";
		stats.domElement.style.top = "0px";
		Browser.document.body.appendChild(stats.domElement);
		#end

		untyped __js__("
			if (!CanvasRenderingContext2D.prototype.isPointInStroke) {
				CanvasRenderingContext2D.prototype.isPointInStroke = function (path, x, y) {
					return false;
				};
			}
			if (!CanvasRenderingContext2D.prototype.isPointInPath) {
				CanvasRenderingContext2D.prototype.isPointInPath = function (path, x, y) {
					return false;
				};
			}

			if ('performance' in window == false) {
				window.performance = {};
			}

			if ('now' in window.performance == false) {
				var offset = Date.now();
				if (performance.timing && performance.timing.navigationStart) {
					offset = performance.timing.navigationStart
				}
				window.performance.now = function now() {
					return Date.now() - offset;
				}
			}

			var lastTime = 0;
			var vendors = ['ms', 'moz', 'webkit', 'o'];
			for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x) {
				window.requestAnimationFrame = window[vendors[x]+'RequestAnimationFrame'];
				window.cancelAnimationFrame = window[vendors[x]+'CancelAnimationFrame'] || window[vendors[x]+'CancelRequestAnimationFrame'];
			}

			if (!window.requestAnimationFrame)
				window.requestAnimationFrame = function(callback, element) {
					var currTime = new Date().getTime();
					var timeToCall = Math.max(0, 16 - (currTime - lastTime));
					var id = window.setTimeout(function() { callback(currTime + timeToCall); },
					  timeToCall);
					lastTime = currTime + timeToCall;
					return id;
				};

			if (!window.cancelAnimationFrame)
				window.cancelAnimationFrame = function(id) {
					clearTimeout(id);
				};

			window.requestAnimFrame = window.requestAnimationFrame;
		");

		lastUpdate = Date.now().getTime();

		handleApplicationEvent();

		return 0;
	}

	public function exit():Void {}

	private function handleApplicationEvent(?__):Void
	{
		// TODO: Support independent window frame rates

		for (window in parent.__windows)
		{
			window.__backend.updateSize();
		}

		updateGameDevices();

		currentUpdate = Date.now().getTime();

		if (currentUpdate >= nextUpdate)
		{
			#if stats
			stats.begin();
			#end

			deltaTime = currentUpdate - lastUpdate;

			for (window in parent.__windows)
			{
				parent.onUpdate.dispatch(Std.int(deltaTime));
				if (window.context != null) window.onRender.dispatch(window.context);
			}

			#if stats
			stats.end();
			#end

			if (framePeriod < 0)
			{
				nextUpdate = currentUpdate;
			}
			else
			{
				nextUpdate = currentUpdate - (currentUpdate % framePeriod) + framePeriod;
			}

			lastUpdate = currentUpdate;
		}

		Browser.window.requestAnimationFrame(cast handleApplicationEvent);
	}

	private function handleKeyEvent(event:KeyboardEvent):Void
	{
		if (parent.window != null)
		{
			// space and arrow keys

			// switch (event.keyCode) {

			// 	case 32, 37, 38, 39, 40: event.preventDefault ();

			// }

			// TODO: Use event.key instead where supported

			var keyCode = cast convertKeyCode(event.keyCode != null ? event.keyCode : event.which);
			var modifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

			if (event.type == "keydown")
			{
				parent.window.onKeyDown.dispatch(keyCode, modifier);

				if (parent.window.onKeyDown.canceled && event.cancelable)
				{
					event.preventDefault();
				}
			}
			else
			{
				parent.window.onKeyUp.dispatch(keyCode, modifier);

				if (parent.window.onKeyUp.canceled && event.cancelable)
				{
					event.preventDefault();
				}
			}
		}
	}

	private function handleSensorEvent(event:DeviceMotionEvent):Void
	{
		accelerometer.onUpdate.dispatch(event.accelerationIncludingGravity.x, event.accelerationIncludingGravity.y, event.accelerationIncludingGravity.z);
	}

	private function handleWindowEvent(event:js.html.Event):Void
	{
		if (parent.window != null)
		{
			switch (event.type)
			{
				case "focus":
					parent.window.onFocusIn.dispatch();
					parent.window.onActivate.dispatch();

				case "blur":
					parent.window.onFocusOut.dispatch();
					parent.window.onDeactivate.dispatch();

				case "resize":
					parent.window.__backend.handleResizeEvent(event);

				case "beforeunload":
					// Mobile Chrome dispatches 'beforeunload' after device sleep,
					// but returns later without reloading the page. This triggers
					// a window.onClose(), without us creating the window again.
					//
					// For now, let focus in/out and activate/deactivate trigger
					// on blur and focus, and do not dispatch a closed window event
					// since it may actually never close.

					// if (!event.defaultPrevented) {

					// 		parent.window.onClose.dispatch ();

					// 		if (parent.window != null && parent.window.onClose.canceled && event.cancelable) {

					// 			event.preventDefault ();

					// 		}

					// 	}
			}
		}
	}

	private function updateGameDevices():Void
	{
		var devices = Joystick.__getDeviceData();
		if (devices == null) return;

		var id, gamepad, joystick, data:Dynamic, cache;

		for (i in 0...devices.length)
		{
			id = i;
			data = devices[id];

			if (data == null) continue;

			if (!gameDeviceCache.exists(id))
			{
				cache = new GameDeviceData();
				cache.id = id;
				cache.connected = data.connected;

				for (i in 0...data.buttons.length)
				{
					cache.buttons.push(data.buttons[i].value);
				}

				for (i in 0...data.axes.length)
				{
					cache.axes.push(data.axes[i]);
				}

				if (data.mapping == "standard")
				{
					cache.isGamepad = true;
				}

				gameDeviceCache.set(id, cache);

				if (data.connected)
				{
					Joystick.__connect(id);

					if (cache.isGamepad)
					{
						Gamepad.__connect(id);
					}
				}
			}

			cache = gameDeviceCache.get(id);

			joystick = Joystick.devices.get(id);
			gamepad = Gamepad.devices.get(id);

			if (data.connected)
			{
				var button:GamepadButton;
				var value:Float;

				for (i in 0...data.buttons.length)
				{
					value = data.buttons[i].value;

					if (value != cache.buttons[i])
					{
						if (i == 6)
						{
							joystick.onAxisMove.dispatch(data.axes.length, value);
							if (gamepad != null) gamepad.onAxisMove.dispatch(GamepadAxis.TRIGGER_LEFT, value);
						}
						else if (i == 7)
						{
							joystick.onAxisMove.dispatch(data.axes.length + 1, value);
							if (gamepad != null) gamepad.onAxisMove.dispatch(GamepadAxis.TRIGGER_RIGHT, value);
						}
						else
						{
							if (value > 0)
							{
								joystick.onButtonDown.dispatch(i);
							}
							else
							{
								joystick.onButtonUp.dispatch(i);
							}

							if (gamepad != null)
							{
								button = switch (i)
								{
									case 0: GamepadButton.A;
									case 1: GamepadButton.B;
									case 2: GamepadButton.X;
									case 3: GamepadButton.Y;
									case 4: GamepadButton.LEFT_SHOULDER;
									case 5: GamepadButton.RIGHT_SHOULDER;
									case 8: GamepadButton.BACK;
									case 9: GamepadButton.START;
									case 10: GamepadButton.LEFT_STICK;
									case 11: GamepadButton.RIGHT_STICK;
									case 12: GamepadButton.DPAD_UP;
									case 13: GamepadButton.DPAD_DOWN;
									case 14: GamepadButton.DPAD_LEFT;
									case 15: GamepadButton.DPAD_RIGHT;
									case 16: GamepadButton.GUIDE;
									default: continue;
								}

								if (value > 0)
								{
									gamepad.onButtonDown.dispatch(button);
								}
								else
								{
									gamepad.onButtonUp.dispatch(button);
								}
							}
						}

						cache.buttons[i] = value;
					}
				}

				for (i in 0...data.axes.length)
				{
					if (data.axes[i] != cache.axes[i])
					{
						joystick.onAxisMove.dispatch(i, data.axes[i]);
						if (gamepad != null) gamepad.onAxisMove.dispatch(i, data.axes[i]);
						cache.axes[i] = data.axes[i];
					}
				}
			}
			else if (cache.connected)
			{
				cache.connected = false;

				Joystick.__disconnect(id);
				Gamepad.__disconnect(id);
			}
		}
	}
}

class GameDeviceData
{
	public var connected:Bool;
	public var id:Int;
	public var isGamepad:Bool;
	public var buttons:Array<Float>;
	public var axes:Array<Float>;

	public function new()
	{
		connected = true;
		buttons = [];
		axes = [];
	}
}
