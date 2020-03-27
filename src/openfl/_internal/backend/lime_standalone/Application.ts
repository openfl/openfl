namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
import js.html.DeviceMotionEvent;
import js.html.KeyboardEvent;
import js.Browser;

@: access(openfl._internal.backend.lime_standalone.Window)
class Application extends Module
{
	public static current(default , null): Application;

	public meta: Map<string, String>;
	public modules(default , null): Array<IModule>;
	public onUpdate = new LimeEvent < Int -> Void > ();
	public onCreateWindow = new LimeEvent < Window -> Void > ();
	// public preloader(get, null):Preloader;
	public window(get, null): Window;
	public windows(get, null): Array<Window>;

	protected __backend: ApplicationBackend;
	// protected __preloader:Preloader;
	protected __window: Window;
	protected __windowByID: Map<Int, Window>;
	protected __windows: Array<Window>;

	public constructor()
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

		// __preloader = new Preloader();
		// __preloader.onProgress.add(onPreloadProgress);
		// __preloader.onComplete.add(onPreloadComplete);
	}

	public addModule(module: IModule): void
	{
		module.__registerLimeModule(this);
		modules.push(module);
	}

	public createWindow(attributes: WindowAttributes): Window
	{
		var window = __createWindow(attributes);
		__addWindow(window);
		return window;
	}

	public exec(): number
	{
		Application.current = this;

		return __backend.exec();
	}

	public onGamepadAxisMove(gamepad: Gamepad, axis: GamepadAxis, value: number): void { }

	public onGamepadButtonDown(gamepad: Gamepad, button: GamepadButton): void { }

	public onGamepadButtonUp(gamepad: Gamepad, button: GamepadButton): void { }

	public onGamepadConnect(gamepad: Gamepad): void { }

	public onGamepadDisconnect(gamepad: Gamepad): void { }

	public onJoystickAxisMove(joystick: Joystick, axis: number, value: number): void { }

	public onJoystickButtonDown(joystick: Joystick, button: number): void { }

	public onJoystickButtonUp(joystick: Joystick, button: number): void { }

	public onJoystickConnect(joystick: Joystick): void { }

	public onJoystickDisconnect(joystick: Joystick): void { }

	public onJoystickHatMove(joystick: Joystick, hat: number, position: JoystickHatPosition): void { }

	public onJoystickTrackballMove(joystick: Joystick, trackball: number, x: number, y: number): void { }

	public onKeyDown(keyCode: KeyCode, modifier: KeyModifier): void { }

	public onKeyUp(keyCode: KeyCode, modifier: KeyModifier): void { }

	public onModuleExit(code: number): void { }

	public onMouseDown(x: number, y: number, button: MouseButton): void { }

	public onMouseMove(x: number, y: number): void { }

	public onMouseMoveRelative(x: number, y: number): void { }

	public onMouseUp(x: number, y: number, button: MouseButton): void { }

	public onMouseWheel(deltaX: number, deltaY: number, deltaMode: MouseWheelMode): void { }

	public onPreloadComplete(): void { }

	public onPreloadProgress(loaded: number, total: number): void { }

	public onRenderContextLost(): void { }

	public onRenderContextRestored(context: RenderContext): void { }

	public onTextEdit(text: string, start: number, length: number): void { }

	public onTextInput(text: string): void { }

	public onTouchCancel(touch: Touch): void { }

	public onTouchEnd(touch: Touch): void { }

	public onTouchMove(touch: Touch): void { }

	public onTouchStart(touch: Touch): void { }

	public onWindowActivate(): void { }

	public onWindowClose(): void { }

	public onWindowCreate(): void { }

	public onWindowDeactivate(): void { }

	public onWindowDropFile(file: string): void { }

	public onWindowEnter(): void { }

	public onWindowExpose(): void { }

	public onWindowFocusIn(): void { }

	public onWindowFocusOut(): void { }

	public onWindowFullscreen(): void { }

	public onWindowLeave(): void { }

	public onWindowMove(x: number, y: number): void { }

	public onWindowMinimize(): void { }

	public onWindowResize(width: number, height: number): void { }

	public onWindowRestore(): void { }

	public removeModule(module: IModule): void
	{
		if (module != null)
		{
			module.__unregisterLimeModule(this);
			modules.remove(module);
		}
	}

	public render(context: RenderContext): void { }

	public update(deltaTime: number): void { }

	protected __addWindow(window: Window): void
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

	protected __createWindow(attributes: WindowAttributes): Window
	{
		var window = new Window(this, attributes);
		if (window.id == -1) return null;
		return window;
	}

	protected __registerLimeModule(application: Application): void
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

	protected __removeWindow(window: Window): void
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
				#if!lime_doc_gen
				System.exit(0);
				#end
			}
		}
	}

	protected __onGamepadConnect(gamepad: Gamepad): void
	{
		onGamepadConnect(gamepad);

		gamepad.onAxisMove.add(onGamepadAxisMove.bind(gamepad));
		gamepad.onButtonDown.add(onGamepadButtonDown.bind(gamepad));
		gamepad.onButtonUp.add(onGamepadButtonUp.bind(gamepad));
		gamepad.onDisconnect.add(onGamepadDisconnect.bind(gamepad));
	}

	protected __onJoystickConnect(joystick: Joystick): void
	{
		onJoystickConnect(joystick);

		joystick.onAxisMove.add(onJoystickAxisMove.bind(joystick));
		joystick.onButtonDown.add(onJoystickButtonDown.bind(joystick));
		joystick.onButtonUp.add(onJoystickButtonUp.bind(joystick));
		joystick.onDisconnect.add(onJoystickDisconnect.bind(joystick));
		joystick.onHatMove.add(onJoystickHatMove.bind(joystick));
		joystick.onTrackballMove.add(onJoystickTrackballMove.bind(joystick));
	}

	protected __onModuleExit(code: number): void
	{
		__backend.exit();
	}

	protected __onWindowClose(window: Window): void
	{
		if (this.window == window)
		{
			onWindowClose();
		}

		__removeWindow(window);
	}

	protected __unregisterLimeModule(application: Application): void
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
	// protected inline get_preloader():Preloader
	// {
	// 	return __preloader;
	// }

	protected inline get_window(): Window
	{
		return __window;
	}

	protected inline get_windows(): Array<Window>
	{
		return __windows;
	}
}

protected typedef ApplicationBackend = HTML5Application;

@: access(openfl._internal.backend.lime_standalone.HTML5Window)
@: access(openfl._internal.backend.lime_standalone.Application)
@: access(openfl._internal.backend.lime_standalone.Sensor)
@: access(openfl._internal.backend.lime_standalone.Gamepad)
@: access(openfl._internal.backend.lime_standalone.Joystick)
@: access(openfl._internal.backend.lime_standalone.Window)
class HTML5Application
{
	private gameDeviceCache = new Map<Int, GameDeviceData>();
	private accelerometer: Sensor;
	private currentUpdate: number;
	private deltaTime: number;
	private framePeriod: number;
	private lastUpdate: number;
	private nextUpdate: number;
	private parent: Application;
	#if stats
	private stats: Dynamic;
	#end

	public inline new(parent: Application)
	{
		this.parent = parent;

		currentUpdate = 0;
		lastUpdate = 0;
		nextUpdate = 0;
		framePeriod = -1;

		// AudioManager.init();
		accelerometer = Sensor.registerSensor(SensorType.ACCELEROMETER, 0);
	}

	private convertKeyCode(keyCode: number): KeyCode
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

	public exec(): number
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
			if (!CanvasRenderingContext2D.prototype.isPointInStroke)
		{
			CanvasRenderingContext2D.prototype.isPointInStroke = (path, x, y)
		{
				return false;
			};
		}
		if (!CanvasRenderingContext2D.prototype.isPointInPath)
		{
			CanvasRenderingContext2D.prototype.isPointInPath = (path, x, y)
		{
				return false;
			};
		}

		if ('performance' in window == false)
		{
			window.performance = {};
		}

		if ('now' in window.performance == false)
		{
			var offset = Date.now();
			if (performance.timing && performance.timing.navigationStart)
			{
				offset = performance.timing.navigationStart
			}
			window.performance.now = now()
			{
				return Date.now() - offset;
			}
		}

		var lastTime = 0;
		var vendors = ['ms', 'moz', 'webkit', 'o'];
		for (var x = 0; x < vendors.length && !window.requestAnimationFrame; ++x)
		{
			window.requestAnimationFrame = window[vendors[x] + 'RequestAnimationFrame'];
			window.cancelAnimationFrame = window[vendors[x] + 'CancelAnimationFrame'] || window[vendors[x] + 'CancelRequestAnimationFrame'];
		}

		if (!window.requestAnimationFrame)
			window.requestAnimationFrame = (callback, element)
		{
				var currTime = new Date().getTime();
				var timeToCall = Math.max(0, 16 - (currTime - lastTime));
				var id = window.setTimeout(function () { callback(currTime + timeToCall); },
					timeToCall);
				lastTime = currTime + timeToCall;
				return id;
			};

		if (!window.cancelAnimationFrame)
			window.cancelAnimationFrame = (id)
		{
				clearTimeout(id);
			};

		window.requestAnimFrame = window.requestAnimationFrame;
		");

		lastUpdate = Date.now().getTime();

		handleApplicationEvent();

		return 0;
	}

	public exit(): void { }

	private handleApplicationEvent(?__): void
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

	private handleKeyEvent(event: KeyboardEvent): void
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

	private handleSensorEvent(event: DeviceMotionEvent): void
	{
		accelerometer.onUpdate.dispatch(event.accelerationIncludingGravity.x, event.accelerationIncludingGravity.y, event.accelerationIncludingGravity.z);
	}

	private handleWindowEvent(event: js.html.Event): void
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

	private updateGameDevices(): void
	{
		var devices = Joystick.__getDeviceData();
		if (devices == null) return;

		var id, gamepad, joystick, data: Dynamic, cache;

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
				var button: GamepadButton;
				var value: number;

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
	public connected: boolean;
	public id: number;
	public isGamepad: boolean;
	public buttons: Array<Float>;
	public axes: Array<Float>;

	public constructor()
	{
		connected = true;
		buttons = [];
		axes = [];
	}
}
#end
