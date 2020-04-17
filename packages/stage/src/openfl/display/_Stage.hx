package openfl.display;

#if lime
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.Gamepad;
import lime.ui.GamepadAxis;
import lime.ui.GamepadButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.MouseWheelMode;
import lime.ui.Touch;
import lime.ui.Window;
import openfl.display3D.Context3D;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.display.Window in OpenFLWindow;
import openfl.events.Event;
import openfl.events.FullScreenEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events.TextEvent;
import openfl.events.TouchEvent;
import openfl.ui.GameInput;
import openfl.ui.GameInputControl;
import openfl.ui.GameInputDevice;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;
import openfl.Lib;
#if !display
#if openfl_gl
import openfl.display._internal.Context3DRenderer;
#end
#if openfl_html5
import openfl.display._internal.CanvasRenderer;
import openfl.display._internal.DOMRenderer;
#else
import openfl.display._internal.CairoRenderer;
#end
#end
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display._internal.CairoRenderer)
@:access(openfl.display._internal.CanvasRenderer)
@:access(openfl.display._internal.Context3DRenderer)
@:access(openfl.display._internal.DOMRenderer)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.InteractiveObject)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.events.MouseEvent)
@:access(openfl.ui.GameInput)
@:access(openfl.ui.GameInputControl)
@:access(openfl.ui.GameInputDevice)
@:noCompletion
class _Stage
{
	private static var gameInputDevices:Map<Gamepad, GameInputDevice> = new Map();

	private var macKeyboard:Bool;
	private var parent:Stage;
	private var primaryTouch:Touch;

	public function new(parent:Stage, window:OpenFLWindow, color:Null<Int> = null)
	{
		this.parent = parent;

		parent.limeApplication = window.application;
		parent.limeWindow = window;
		parent.color = color;

		// TODO: Workaround need to set reference here
		parent._ = cast this;

		parent.__contentsScaleFactor = window.scale;
		parent.__wasFullscreen = window.fullscreen;

		#if mac
		macKeyboard = true;
		#elseif openfl_html5
		macKeyboard = untyped __js__("/AppleWebKit/.test (navigator.userAgent) && /Mobile\\/\\w+/.test (navigator.userAgent) || /Mac/.test (navigator.platform)");
		#end

		parent.__resize();

		if (Lib.current.stage == null)
		{
			parent.addChild(Lib.current);
		}
	}

	public function cancelRender():Void
	{
		parent.limeWindow.onRender.cancel();
	}

	private function convertKeyCode(key:KeyCode):Int
	{
		return switch (key)
		{
			case KeyCode.BACKSPACE: Keyboard.BACKSPACE;
			case KeyCode.TAB: Keyboard.TAB;
			case KeyCode.RETURN: Keyboard.ENTER;
			case KeyCode.ESCAPE: Keyboard.ESCAPE;
			case KeyCode.SPACE: Keyboard.SPACE;
			case KeyCode.EXCLAMATION: Keyboard.NUMBER_1;
			case KeyCode.QUOTE: Keyboard.QUOTE;
			case KeyCode.HASH: Keyboard.NUMBER_3;
			case KeyCode.DOLLAR: Keyboard.NUMBER_4;
			case KeyCode.PERCENT: Keyboard.NUMBER_5;
			case KeyCode.AMPERSAND: Keyboard.NUMBER_7;
			case KeyCode.SINGLE_QUOTE: Keyboard.QUOTE;
			case KeyCode.LEFT_PARENTHESIS: Keyboard.NUMBER_9;
			case KeyCode.RIGHT_PARENTHESIS: Keyboard.NUMBER_0;
			case KeyCode.ASTERISK: Keyboard.NUMBER_8;
			// case KeyCode.PLUS: 0x2B;
			case KeyCode.COMMA: Keyboard.COMMA;
			case KeyCode.MINUS: Keyboard.MINUS;
			case KeyCode.PERIOD: Keyboard.PERIOD;
			case KeyCode.SLASH: Keyboard.SLASH;
			case KeyCode.NUMBER_0: Keyboard.NUMBER_0;
			case KeyCode.NUMBER_1: Keyboard.NUMBER_1;
			case KeyCode.NUMBER_2: Keyboard.NUMBER_2;
			case KeyCode.NUMBER_3: Keyboard.NUMBER_3;
			case KeyCode.NUMBER_4: Keyboard.NUMBER_4;
			case KeyCode.NUMBER_5: Keyboard.NUMBER_5;
			case KeyCode.NUMBER_6: Keyboard.NUMBER_6;
			case KeyCode.NUMBER_7: Keyboard.NUMBER_7;
			case KeyCode.NUMBER_8: Keyboard.NUMBER_8;
			case KeyCode.NUMBER_9: Keyboard.NUMBER_9;
			case KeyCode.COLON: Keyboard.SEMICOLON;
			case KeyCode.SEMICOLON: Keyboard.SEMICOLON;
			case KeyCode.LESS_THAN: 60;
			case KeyCode.EQUALS: Keyboard.EQUAL;
			case KeyCode.GREATER_THAN: Keyboard.PERIOD;
			case KeyCode.QUESTION: Keyboard.SLASH;
			case KeyCode.AT: Keyboard.NUMBER_2;
			case KeyCode.LEFT_BRACKET: Keyboard.LEFTBRACKET;
			case KeyCode.BACKSLASH: Keyboard.BACKSLASH;
			case KeyCode.RIGHT_BRACKET: Keyboard.RIGHTBRACKET;
			case KeyCode.CARET: Keyboard.NUMBER_6;
			case KeyCode.UNDERSCORE: Keyboard.MINUS;
			case KeyCode.GRAVE: Keyboard.BACKQUOTE;
			case KeyCode.A: Keyboard.A;
			case KeyCode.B: Keyboard.B;
			case KeyCode.C: Keyboard.C;
			case KeyCode.D: Keyboard.D;
			case KeyCode.E: Keyboard.E;
			case KeyCode.F: Keyboard.F;
			case KeyCode.G: Keyboard.G;
			case KeyCode.H: Keyboard.H;
			case KeyCode.I: Keyboard.I;
			case KeyCode.J: Keyboard.J;
			case KeyCode.K: Keyboard.K;
			case KeyCode.L: Keyboard.L;
			case KeyCode.M: Keyboard.M;
			case KeyCode.N: Keyboard.N;
			case KeyCode.O: Keyboard.O;
			case KeyCode.P: Keyboard.P;
			case KeyCode.Q: Keyboard.Q;
			case KeyCode.R: Keyboard.R;
			case KeyCode.S: Keyboard.S;
			case KeyCode.T: Keyboard.T;
			case KeyCode.U: Keyboard.U;
			case KeyCode.V: Keyboard.V;
			case KeyCode.W: Keyboard.W;
			case KeyCode.X: Keyboard.X;
			case KeyCode.Y: Keyboard.Y;
			case KeyCode.Z: Keyboard.Z;
			case KeyCode.DELETE: Keyboard.DELETE;
			case KeyCode.CAPS_LOCK: Keyboard.CAPS_LOCK;
			case KeyCode.F1: Keyboard.F1;
			case KeyCode.F2: Keyboard.F2;
			case KeyCode.F3: Keyboard.F3;
			case KeyCode.F4: Keyboard.F4;
			case KeyCode.F5: Keyboard.F5;
			case KeyCode.F6: Keyboard.F6;
			case KeyCode.F7: Keyboard.F7;
			case KeyCode.F8: Keyboard.F8;
			case KeyCode.F9: Keyboard.F9;
			case KeyCode.F10: Keyboard.F10;
			case KeyCode.F11: Keyboard.F11;
			case KeyCode.F12: Keyboard.F12;
			case KeyCode.PRINT_SCREEN: 301;
			case KeyCode.SCROLL_LOCK: 145;
			case KeyCode.PAUSE: Keyboard.BREAK;
			case KeyCode.INSERT: Keyboard.INSERT;
			case KeyCode.HOME: Keyboard.HOME;
			case KeyCode.PAGE_UP: Keyboard.PAGE_UP;
			case KeyCode.END: Keyboard.END;
			case KeyCode.PAGE_DOWN: Keyboard.PAGE_DOWN;
			case KeyCode.RIGHT: Keyboard.RIGHT;
			case KeyCode.LEFT: Keyboard.LEFT;
			case KeyCode.DOWN: Keyboard.DOWN;
			case KeyCode.UP: Keyboard.UP;
			case KeyCode.NUM_LOCK: Keyboard.NUMLOCK;
			case KeyCode.NUMPAD_DIVIDE: Keyboard.NUMPAD_DIVIDE;
			case KeyCode.NUMPAD_MULTIPLY: Keyboard.NUMPAD_MULTIPLY;
			case KeyCode.NUMPAD_MINUS: Keyboard.NUMPAD_SUBTRACT;
			case KeyCode.NUMPAD_PLUS: Keyboard.NUMPAD_ADD;
			case KeyCode.NUMPAD_ENTER: #if openfl_numpad_enter Keyboard.NUMPAD_ENTER #else Keyboard.ENTER #end;
			case KeyCode.NUMPAD_1: Keyboard.NUMPAD_1;
			case KeyCode.NUMPAD_2: Keyboard.NUMPAD_2;
			case KeyCode.NUMPAD_3: Keyboard.NUMPAD_3;
			case KeyCode.NUMPAD_4: Keyboard.NUMPAD_4;
			case KeyCode.NUMPAD_5: Keyboard.NUMPAD_5;
			case KeyCode.NUMPAD_6: Keyboard.NUMPAD_6;
			case KeyCode.NUMPAD_7: Keyboard.NUMPAD_7;
			case KeyCode.NUMPAD_8: Keyboard.NUMPAD_8;
			case KeyCode.NUMPAD_9: Keyboard.NUMPAD_9;
			case KeyCode.NUMPAD_0: Keyboard.NUMPAD_0;
			case KeyCode.NUMPAD_PERIOD: Keyboard.NUMPAD_DECIMAL;
			case KeyCode.APPLICATION: 302;
			// case KeyCode.POWER: 0x40000066;
			// case KeyCode.NUMPAD_EQUALS: 0x40000067;
			case KeyCode.F13: Keyboard.F13;
			case KeyCode.F14: Keyboard.F14;
			case KeyCode.F15: Keyboard.F15;
			// case KeyCode.F16: 0x4000006B;
			// case KeyCode.F17: 0x4000006C;
			// case KeyCode.F18: 0x4000006D;
			// case KeyCode.F19: 0x4000006E;
			// case KeyCode.F20: 0x4000006F;
			// case KeyCode.F21: 0x40000070;
			// case KeyCode.F22: 0x40000071;
			// case KeyCode.F23: 0x40000072;
			// case KeyCode.F24: 0x40000073;
			// case KeyCode.EXECUTE: 0x40000074;
			// case KeyCode.HELP: 0x40000075;
			// case KeyCode.MENU: 0x40000076;
			// case KeyCode.SELECT: 0x40000077;
			// case KeyCode.STOP: 0x40000078;
			// case KeyCode.AGAIN: 0x40000079;
			// case KeyCode.UNDO: 0x4000007A;
			// case KeyCode.CUT: 0x4000007B;
			// case KeyCode.COPY: 0x4000007C;
			// case KeyCode.PASTE: 0x4000007D;
			// case KeyCode.FIND: 0x4000007E;
			// case KeyCode.MUTE: 0x4000007F;
			// case KeyCode.VOLUME_UP: 0x40000080;
			// case KeyCode.VOLUME_DOWN: 0x40000081;
			// case KeyCode.NUMPAD_COMMA: 0x40000085;
			////case KeyCode.NUMPAD_EQUALS_AS400: 0x40000086;
			// case KeyCode.ALT_ERASE: 0x40000099;
			// case KeyCode.SYSTEM_REQUEST: 0x4000009A;
			// case KeyCode.CANCEL: 0x4000009B;
			// case KeyCode.CLEAR: 0x4000009C;
			// case KeyCode.PRIOR: 0x4000009D;
			case KeyCode.RETURN2: Keyboard.ENTER;
			// case KeyCode.SEPARATOR: 0x4000009F;
			// case KeyCode.OUT: 0x400000A0;
			// case KeyCode.OPER: 0x400000A1;
			// case KeyCode.CLEAR_AGAIN: 0x400000A2;
			// case KeyCode.CRSEL: 0x400000A3;
			// case KeyCode.EXSEL: 0x400000A4;
			// case KeyCode.NUMPAD_00: 0x400000B0;
			// case KeyCode.NUMPAD_000: 0x400000B1;
			// case KeyCode.THOUSAND_SEPARATOR: 0x400000B2;
			// case KeyCode.DECIMAL_SEPARATOR: 0x400000B3;
			// case KeyCode.CURRENCY_UNIT: 0x400000B4;
			// case KeyCode.CURRENCY_SUBUNIT: 0x400000B5;
			// case KeyCode.NUMPAD_LEFT_PARENTHESIS: 0x400000B6;
			// case KeyCode.NUMPAD_RIGHT_PARENTHESIS: 0x400000B7;
			// case KeyCode.NUMPAD_LEFT_BRACE: 0x400000B8;
			// case KeyCode.NUMPAD_RIGHT_BRACE: 0x400000B9;
			// case KeyCode.NUMPAD_TAB: 0x400000BA;
			// case KeyCode.NUMPAD_BACKSPACE: 0x400000BB;
			// case KeyCode.NUMPAD_A: 0x400000BC;
			// case KeyCode.NUMPAD_B: 0x400000BD;
			// case KeyCode.NUMPAD_C: 0x400000BE;
			// case KeyCode.NUMPAD_D: 0x400000BF;
			// case KeyCode.NUMPAD_E: 0x400000C0;
			// case KeyCode.NUMPAD_F: 0x400000C1;
			// case KeyCode.NUMPAD_XOR: 0x400000C2;
			// case KeyCode.NUMPAD_POWER: 0x400000C3;
			// case KeyCode.NUMPAD_PERCENT: 0x400000C4;
			// case KeyCode.NUMPAD_LESS_THAN: 0x400000C5;
			// case KeyCode.NUMPAD_GREATER_THAN: 0x400000C6;
			// case KeyCode.NUMPAD_AMPERSAND: 0x400000C7;
			// case KeyCode.NUMPAD_DOUBLE_AMPERSAND: 0x400000C8;
			// case KeyCode.NUMPAD_VERTICAL_BAR: 0x400000C9;
			// case KeyCode.NUMPAD_DOUBLE_VERTICAL_BAR: 0x400000CA;
			// case KeyCode.NUMPAD_COLON: 0x400000CB;
			// case KeyCode.NUMPAD_HASH: 0x400000CC;
			// case KeyCode.NUMPAD_SPACE: 0x400000CD;
			// case KeyCode.NUMPAD_AT: 0x400000CE;
			// case KeyCode.NUMPAD_EXCLAMATION: 0x400000CF;
			// case KeyCode.NUMPAD_MEM_STORE: 0x400000D0;
			// case KeyCode.NUMPAD_MEM_RECALL: 0x400000D1;
			// case KeyCode.NUMPAD_MEM_CLEAR: 0x400000D2;
			// case KeyCode.NUMPAD_MEM_ADD: 0x400000D3;
			// case KeyCode.NUMPAD_MEM_SUBTRACT: 0x400000D4;
			// case KeyCode.NUMPAD_MEM_MULTIPLY: 0x400000D5;
			// case KeyCode.NUMPAD_MEM_DIVIDE: 0x400000D6;
			// case KeyCode.NUMPAD_PLUS_MINUS: 0x400000D7;
			// case KeyCode.NUMPAD_CLEAR: 0x400000D8;
			// case KeyCode.NUMPAD_CLEAR_ENTRY: 0x400000D9;
			// case KeyCode.NUMPAD_BINARY: 0x400000DA;
			// case KeyCode.NUMPAD_OCTAL: 0x400000DB;
			case KeyCode.NUMPAD_DECIMAL: Keyboard.NUMPAD_DECIMAL;
			// case KeyCode.NUMPAD_HEXADECIMAL: 0x400000DD;
			case KeyCode.LEFT_CTRL: Keyboard.CONTROL;
			case KeyCode.LEFT_SHIFT: Keyboard.SHIFT;
			case KeyCode.LEFT_ALT: Keyboard.ALTERNATE;
			case KeyCode.LEFT_META: Keyboard.COMMAND;
			case KeyCode.RIGHT_CTRL: Keyboard.CONTROL;
			case KeyCode.RIGHT_SHIFT: Keyboard.SHIFT;
			case KeyCode.RIGHT_ALT: Keyboard.ALTERNATE;
			case KeyCode.RIGHT_META: Keyboard.COMMAND;
			// case KeyCode.MODE: 0x40000101;
			// case KeyCode.AUDIO_NEXT: 0x40000102;
			// case KeyCode.AUDIO_PREVIOUS: 0x40000103;
			// case KeyCode.AUDIO_STOP: 0x40000104;
			// case KeyCode.AUDIO_PLAY: 0x40000105;
			// case KeyCode.AUDIO_MUTE: 0x40000106;
			// case KeyCode.MEDIA_SELECT: 0x40000107;
			// case KeyCode.WWW: 0x40000108;
			// case KeyCode.MAIL: 0x40000109;
			// case KeyCode.CALCULATOR: 0x4000010A;
			// case KeyCode.COMPUTER: 0x4000010B;
			// case KeyCode.APP_CONTROL_SEARCH: 0x4000010C;
			// case KeyCode.APP_CONTROL_HOME: 0x4000010D;
			// case KeyCode.APP_CONTROL_BACK: 0x4000010E;
			// case KeyCode.APP_CONTROL_FORWARD: 0x4000010F;
			// case KeyCode.APP_CONTROL_STOP: 0x40000110;
			// case KeyCode.APP_CONTROL_REFRESH: 0x40000111;
			// case KeyCode.APP_CONTROL_BOOKMARKS: 0x40000112;
			// case KeyCode.BRIGHTNESS_DOWN: 0x40000113;
			// case KeyCode.BRIGHTNESS_UP: 0x40000114;
			// case KeyCode.DISPLAY_SWITCH: 0x40000115;
			// case KeyCode.BACKLIGHT_TOGGLE: 0x40000116;
			// case KeyCode.BACKLIGHT_DOWN: 0x40000117;
			// case KeyCode.BACKLIGHT_UP: 0x40000118;
			// case KeyCode.EJECT: 0x40000119;
			// case KeyCode.SLEEP: 0x4000011A;
			default: cast key;
		}
	}

	public function createRenderer():Void
	{
		var window = parent.limeWindow;

		#if !display
		#if openfl_html5
		var pixelRatio = 1;

		if (window.scale > 1)
		{
			// TODO: Does this check work?
			pixelRatio = untyped window.devicePixelRatio || 1;
		}
		#end

		var windowWidth = Std.int(window.width * window.scale);
		var windowHeight = Std.int(window.height * window.scale);

		switch (window.context.type)
		{
			case OPENGL, OPENGLES, WEBGL:
				#if openfl_gl
				#if (!disable_cffi && (!html5 || !canvas))
				parent.context3D = new Context3D(parent);
				parent.context3D.configureBackBuffer(windowWidth, windowHeight, 0, true, true, true);
				parent.context3D.present();
				if (BitmapData.__hardwareRenderer == null)
				{
					BitmapData.__hardwareRenderer = new Context3DRenderer(parent.context3D);
				}
				parent.__renderer = new Context3DRenderer(parent.context3D);
				#end
				#end

			case CANVAS:
				#if openfl_html5
				var renderer = new CanvasRenderer(window.context.canvas2D);
				renderer.pixelRatio = pixelRatio;
				parent.__renderer = renderer;
				#end

			case DOM:
				#if openfl_html5
				var renderer = new DOMRenderer(window.context.dom);
				renderer.pixelRatio = pixelRatio;
				parent.__renderer = renderer;
				#end

			case CAIRO:
				#if (!openfl_html5 && openfl_cairo)
				parent.__renderer = new CairoRenderer(window.context.cairo);
				#end

			default:
		}

		if (parent.__renderer != null)
		{
			parent.__renderer.__allowSmoothing = (parent.quality != LOW);
			parent.__renderer.__worldTransform = parent.__displayMatrix;
			parent.__renderer.__stage = parent;

			parent.__renderer.__resize(windowWidth, windowHeight);

			if (BitmapData.__hardwareRenderer != null)
			{
				BitmapData.__hardwareRenderer.__stage = parent;
				BitmapData.__hardwareRenderer.__worldTransform = parent.__displayMatrix.clone();
				BitmapData.__hardwareRenderer.__resize(windowWidth, windowHeight);
			}
		}
		#end
	}

	private function getCharCode(key:Int, shift:Bool = false):Int
	{
		if (!shift)
		{
			switch (key)
			{
				case Keyboard.BACKSPACE:
					return 8;
				case Keyboard.TAB:
					return 9;
				case Keyboard.ENTER:
					return 13;
				case Keyboard.ESCAPE:
					return 27;
				case Keyboard.SPACE:
					return 32;
				case Keyboard.SEMICOLON:
					return 59;
				case Keyboard.EQUAL:
					return 61;
				case Keyboard.COMMA:
					return 44;
				case Keyboard.MINUS:
					return 45;
				case Keyboard.PERIOD:
					return 46;
				case Keyboard.SLASH:
					return 47;
				case Keyboard.BACKQUOTE:
					return 96;
				case Keyboard.LEFTBRACKET:
					return 91;
				case Keyboard.BACKSLASH:
					return 92;
				case Keyboard.RIGHTBRACKET:
					return 93;
				case Keyboard.QUOTE:
					return 39;
			}

			if (key >= Keyboard.NUMBER_0 && key <= Keyboard.NUMBER_9)
			{
				return key - Keyboard.NUMBER_0 + 48;
			}

			if (key >= Keyboard.A && key <= Keyboard.Z)
			{
				return key - Keyboard.A + 97;
			}
		}
		else
		{
			switch (key)
			{
				case Keyboard.NUMBER_0:
					return 41;
				case Keyboard.NUMBER_1:
					return 33;
				case Keyboard.NUMBER_2:
					return 64;
				case Keyboard.NUMBER_3:
					return 35;
				case Keyboard.NUMBER_4:
					return 36;
				case Keyboard.NUMBER_5:
					return 37;
				case Keyboard.NUMBER_6:
					return 94;
				case Keyboard.NUMBER_7:
					return 38;
				case Keyboard.NUMBER_8:
					return 42;
				case Keyboard.NUMBER_9:
					return 40;
				case Keyboard.SEMICOLON:
					return 58;
				case Keyboard.EQUAL:
					return 43;
				case Keyboard.COMMA:
					return 60;
				case Keyboard.MINUS:
					return 95;
				case Keyboard.PERIOD:
					return 62;
				case Keyboard.SLASH:
					return 63;
				case Keyboard.BACKQUOTE:
					return 126;
				case Keyboard.LEFTBRACKET:
					return 123;
				case Keyboard.BACKSLASH:
					return 124;
				case Keyboard.RIGHTBRACKET:
					return 125;
				case Keyboard.QUOTE:
					return 34;
			}

			if (key >= Keyboard.A && key <= Keyboard.Z)
			{
				return key - Keyboard.A + 65;
			}
		}

		if (key >= Keyboard.NUMPAD_0 && key <= Keyboard.NUMPAD_9)
		{
			return key - Keyboard.NUMPAD_0 + 48;
		}

		switch (key)
		{
			case Keyboard.NUMPAD_MULTIPLY:
				return 42;
			case Keyboard.NUMPAD_ADD:
				return 43;
			case Keyboard.NUMPAD_ENTER:
				return 44;
			case Keyboard.NUMPAD_DECIMAL:
				return 45;
			case Keyboard.NUMPAD_DIVIDE:
				return 46;
			case Keyboard.DELETE:
				return 127;
			case Keyboard.ENTER:
				return 13;
			case Keyboard.BACKSPACE:
				return 8;
		}

		return 0;
	}

	public function getFrameRate():Float
	{
		if (parent.limeWindow != null)
		{
			return parent.limeWindow.frameRate;
		}

		return 0;
	}

	public function getFullScreenHeight():UInt
	{
		return Math.ceil(parent.limeWindow.display.currentMode.height * parent.limeWindow.scale);
	}

	public function getFullScreenWidth():UInt
	{
		return Math.ceil(parent.limeWindow.display.currentMode.width * parent.limeWindow.scale);
	}

	private function getGameInputDevice(gamepad:Gamepad):GameInputDevice
	{
		if (gamepad == null) return null;

		if (!gameInputDevices.exists(gamepad))
		{
			var device = new GameInputDevice(gamepad.guid, gamepad.name);
			gameInputDevices.set(gamepad, device);
			GameInput.__addInputDevice(device);
		}

		return gameInputDevices.get(gamepad);
	}

	private function getKeyLocation(key:KeyCode):KeyLocation
	{
		return switch (key)
		{
			case KeyCode.LEFT_CTRL, KeyCode.LEFT_SHIFT, KeyCode.LEFT_ALT, KeyCode.LEFT_META: KeyLocation.LEFT;
			case KeyCode.RIGHT_CTRL, KeyCode.RIGHT_SHIFT, KeyCode.RIGHT_ALT, KeyCode.RIGHT_META: KeyLocation.RIGHT;
			case KeyCode.NUMPAD_DIVIDE, KeyCode.NUMPAD_MULTIPLY, KeyCode.NUMPAD_MINUS, KeyCode.NUMPAD_PLUS, KeyCode.NUMPAD_ENTER, KeyCode.NUMPAD_1,
				KeyCode.NUMPAD_2, KeyCode.NUMPAD_3, KeyCode.NUMPAD_4, KeyCode.NUMPAD_5, KeyCode.NUMPAD_6, KeyCode.NUMPAD_7, KeyCode.NUMPAD_8,
				KeyCode.NUMPAD_9, KeyCode.NUMPAD_0, KeyCode.NUMPAD_PERIOD, KeyCode.NUMPAD_DECIMAL:
				KeyLocation.NUM_PAD;
			default: KeyLocation.STANDARD;
		}
	}

	public function getWindowFullscreen():Bool
	{
		return parent.limeWindow.fullscreen;
	}

	public function getWindowHeight():Int
	{
		return Std.int(parent.limeWindow.height * parent.limeWindow.scale);
	}

	public function getWindowWidth():Int
	{
		return Std.int(parent.limeWindow.width * parent.limeWindow.scale);
	}

	public function registerLimeModule(application:Application):Void
	{
		application.onCreateWindow.add(application_onCreateWindow);
		application.onUpdate.add(application_onUpdate);
		application.onExit.add(application_onExit, false, 0);

		for (gamepad in Gamepad.devices)
		{
			gamepad_onConnect(gamepad);
		}

		Gamepad.onConnect.add(gamepad_onConnect);
		Touch.onStart.add(touch_onStart);
		Touch.onMove.add(touch_onMove);
		Touch.onEnd.add(touch_onEnd);
		Touch.onCancel.add(touch_onCancel);
	}

	public function setDisplayState(value:StageDisplayState):Void
	{
		if (parent.limeWindow != null)
		{
			switch (value)
			{
				case NORMAL:
					if (parent.limeWindow.fullscreen)
					{
						parent.limeWindow.fullscreen = false;
					}

				default:
					if (!parent.limeWindow.fullscreen)
					{
						parent.limeWindow.fullscreen = true;
					}
			}
		}
	}

	public function setFrameRate(value:Float):Void
	{
		if (parent.limeWindow != null)
		{
			parent.limeWindow.frameRate = value;
		}
	}

	public function unregisterLimeModule(application:Application):Void
	{
		application.onCreateWindow.remove(application_onCreateWindow);
		application.onUpdate.remove(application_onUpdate);
		application.onExit.remove(application_onExit);

		Gamepad.onConnect.remove(gamepad_onConnect);
		Touch.onStart.remove(touch_onStart);
		Touch.onMove.remove(touch_onMove);
		Touch.onEnd.remove(touch_onEnd);
		Touch.onCancel.remove(touch_onCancel);
	}

	// Event Handlers
	private function application_onCreateWindow(window:Window):Void
	{
		if (parent.limeWindow != window) return;

		window.onActivate.add(window_onActivate.bind(window));
		window.onClose.add(window_onClose.bind(window), false, -9000);
		window.onDeactivate.add(window_onDeactivate.bind(window));
		window.onDropFile.add(window_onDropFile.bind(window));
		window.onEnter.add(window_onEnter.bind(window));
		window.onExpose.add(window_onExpose.bind(window));
		window.onFocusIn.add(window_onFocusIn.bind(window));
		window.onFocusOut.add(window_onFocusOut.bind(window));
		window.onFullscreen.add(window_onFullscreen.bind(window));
		window.onKeyDown.add(window_onKeyDown.bind(window));
		window.onKeyUp.add(window_onKeyUp.bind(window));
		window.onLeave.add(window_onLeave.bind(window));
		window.onMinimize.add(window_onMinimize.bind(window));
		window.onMouseDown.add(window_onMouseDown.bind(window));
		window.onMouseMove.add(window_onMouseMove.bind(window));
		window.onMouseMoveRelative.add(window_onMouseMoveRelative.bind(window));
		window.onMouseUp.add(window_onMouseUp.bind(window));
		window.onMouseWheel.add(window_onMouseWheel.bind(window));
		window.onMove.add(window_onMove.bind(window));
		window.onRender.add(window_onRender);
		window.onRenderContextLost.add(window_onRenderContextLost);
		window.onRenderContextRestored.add(window_onRenderContextRestored);
		window.onResize.add(window_onResize.bind(window));
		window.onRestore.add(window_onRestore.bind(window));
		window.onTextEdit.add(window_onTextEdit.bind(window));
		window.onTextInput.add(window_onTextInput.bind(window));

		window_onCreate(window);
	}

	private function application_onExit(code:Int):Void
	{
		if (parent.limeWindow != null)
		{
			var event:Event = null;

			#if openfl_pool_events
			event = Event.__pool.get(Event.DEACTIVATE);
			#else
			event = new Event(Event.DEACTIVATE);
			#end

			parent.__broadcastEvent(event);

			#if openfl_pool_events
			Event.__pool.release(event);
			#end
		}
	}

	private function application_onUpdate(deltaTime:Int):Void
	{
		parent.__deltaTime = deltaTime;
		parent.__dispatchPendingMouseEvent();
	}

	private function gamepad_onAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device.__axis.exists(axis))
			{
				var control = new GameInputControl(device, "AXIS_" + axis, -1, 1);
				device.__axis.set(axis, control);
				device.__controls.push(control);
			}

			var control = device.__axis.get(axis);
			control.value = value;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	private function gamepad_onButtonDown(gamepad:Gamepad, button:GamepadButton):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device.__button.exists(button))
			{
				var control = new GameInputControl(device, "BUTTON_" + button, 0, 1);
				device.__button.set(button, control);
				device.__controls.push(control);
			}

			var control = device.__button.get(button);
			control.value = 1;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	private function gamepad_onButtonUp(gamepad:Gamepad, button:GamepadButton):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device.__button.exists(button))
			{
				var control = new GameInputControl(device, "BUTTON_" + button, 0, 1);
				device.__button.set(button, control);
				device.__controls.push(control);
			}

			var control = device.__button.get(button);
			control.value = 0;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	private function gamepad_onConnect(gamepad:Gamepad):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		// GameInput.__dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));

		gamepad.onAxisMove.add(gamepad_onAxisMove.bind(gamepad));
		gamepad.onButtonDown.add(gamepad_onButtonDown.bind(gamepad));
		gamepad.onButtonUp.add(gamepad_onButtonUp.bind(gamepad));
		gamepad.onDisconnect.add(gamepad_onDisconnect.bind(gamepad));
	}

	private function gamepad_onDisconnect(gamepad:Gamepad):Void
	{
		var device = gameInputDevices.get(gamepad);

		if (device != null)
		{
			if (gameInputDevices.exists(gamepad))
			{
				var device = gameInputDevices.get(gamepad);
				gameInputDevices.remove(gamepad);
				GameInput.__removeInputDevice(device);
			}
		}
	}

	private function touch_onCancel(touch:Touch):Void
	{
		// TODO: Should we handle this differently?

		var oldPrimaryTouch = primaryTouch;
		if (primaryTouch == touch)
		{
			primaryTouch = null;
		}

		parent.__onTouch(TouchEvent.TOUCH_END, touch.id, Math.round(touch.x * parent.limeWindow.width), Math.round(touch.y * parent.limeWindow.width),
			touch.pressure, touch == oldPrimaryTouch);
	}

	private function touch_onMove(touch:Touch):Void
	{
		parent.__onTouch(TouchEvent.TOUCH_MOVE, touch.id, Math.round(touch.x * parent.limeWindow.width), Math.round(touch.y * parent.limeWindow.width),
			touch.pressure, touch == primaryTouch);
	}

	private function touch_onEnd(touch:Touch):Void
	{
		var oldPrimaryTouch = primaryTouch;
		if (primaryTouch == touch)
		{
			primaryTouch = null;
		}

		parent.__onTouch(TouchEvent.TOUCH_END, touch.id, Math.round(touch.x * parent.limeWindow.width), Math.round(touch.y * parent.limeWindow.width),
			touch.pressure, touch == oldPrimaryTouch);
	}

	private function touch_onStart(touch:Touch):Void
	{
		if (primaryTouch == null)
		{
			primaryTouch = touch;
		}

		parent.__onTouch(TouchEvent.TOUCH_BEGIN, touch.id, Math.round(touch.x * parent.limeWindow.width), Math.round(touch.y * parent.limeWindow.width),
			touch.pressure, touch == primaryTouch);
	}

	private function window_onActivate(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		// __broadcastEvent (new Event (Event.ACTIVATE));
	}

	private function window_onClose(window:Window):Void
	{
		if (parent.limeWindow == window)
		{
			parent.limeWindow = null;
		}

		primaryTouch = null;

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.DEACTIVATE);
		#else
		event = new Event(Event.DEACTIVATE);
		#end

		parent.__broadcastEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}

	private function window_onCreate(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		if (window.context != null)
		{
			createRenderer();
		}
	}

	private function window_onDeactivate(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		// __primaryTouch = null;
		// __broadcastEvent (new Event (Event.DEACTIVATE));
	}

	private function window_onDropFile(window:Window, file:String):Void {}

	private function window_onEnter(window:Window):Void
	{
		// if (parent.limeWindow == null || parent.limeWindow != window) return;
	}

	private function window_onExpose(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		parent.__renderDirty = true;
	}

	private function window_onFocusIn(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		#if !desktop
		// TODO: Is this needed?
		parent.__renderDirty = true;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.ACTIVATE);
		#else
		event = new Event(Event.ACTIVATE);
		#end

		parent.__broadcastEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end

		#if !desktop
		parent.focus = parent.__cacheFocus;
		#end
	}

	private function window_onFocusOut(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		primaryTouch = null;

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.DEACTIVATE);
		#else
		event = new Event(Event.DEACTIVATE);
		#end

		parent.__broadcastEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end

		var currentFocus = parent.focus;
		parent.focus = null;
		parent.__cacheFocus = currentFocus;

		MouseEvent.__altKey = false;
		MouseEvent.__commandKey = false;
		MouseEvent.__ctrlKey = false;
		MouseEvent.__shiftKey = false;
	}

	private function window_onFullscreen(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		parent.__resize();

		if (!parent.__wasFullscreen)
		{
			parent.__wasFullscreen = true;
			if (parent.__displayState == NORMAL) parent.__displayState = FULL_SCREEN_INTERACTIVE;
			parent.__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, true, true));
		}
	}

	private function window_onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		var keyLocation = getKeyLocation(keyCode);
		var keyCode = convertKeyCode(keyCode);
		var charCode = getCharCode(keyCode, modifier.shiftKey);

		var event = new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, charCode, keyCode, keyLocation,
			macKeyboard ? (modifier.ctrlKey || modifier.metaKey) : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

		if (parent.__onKey(event))
		{
			window.onKeyDown.cancel();
		}
	}

	private function window_onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		var keyLocation = getKeyLocation(keyCode);
		var keyCode = convertKeyCode(keyCode);
		var charCode = getCharCode(keyCode, modifier.shiftKey);

		var event = new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, charCode, keyCode, keyLocation,
			macKeyboard ? (modifier.ctrlKey || modifier.metaKey) : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

		if (parent.__onKey(event))
		{
			window.onKeyUp.cancel();
		}
	}

	private function window_onLeave(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window || MouseEvent.__buttonDown) return;

		parent.__dispatchPendingMouseEvent();

		var event:Event = null;

		#if openfl_pool_events
		event = Event.__pool.get(Event.MOUSE_LEAVE);
		#else
		event = new Event(Event.MOUSE_LEAVE);
		#end

		parent.__dispatchEvent(event);

		#if openfl_pool_events
		Event.__pool.release(event);
		#end
	}

	private function window_onMinimize(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		// __primaryTouch = null;
		// __broadcastEvent (new Event (Event.DEACTIVATE));
	}

	private function window_onMouseDown(window:Window, x:Float, y:Float, button:Int):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		parent.__dispatchPendingMouseEvent();

		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
		}

		parent.__onMouse(type, Std.int(x * window.scale), Std.int(y * window.scale), button);

		if (!parent.showDefaultContextMenu && button == 2)
		{
			window.onMouseDown.cancel();
		}
	}

	private function window_onMouseMove(window:Window, x:Float, y:Float):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		#if openfl_always_dispatch_mouse_events
		parent.__onMouse(MouseEvent.MOUSE_MOVE, Std.int(x * window.scale), Std.int(y * window.scale), 0);
		#else
		parent.__pendingMouseEvent = true;
		parent.__pendingMouseX = Std.int(x * window.scale);
		parent.__pendingMouseY = Std.int(y * window.scale);
		#end
	}

	private function window_onMouseMoveRelative(window:Window, x:Float, y:Float):Void
	{
		// if (parent.limeWindow == null || parent.limeWindow != window) return;
	}

	private function window_onMouseUp(window:Window, x:Float, y:Float, button:Int):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		parent.__dispatchPendingMouseEvent();

		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
		}

		parent.__onMouse(type, Std.int(x * window.scale), Std.int(y * window.scale), button);

		if (!parent.showDefaultContextMenu && button == 2)
		{
			window.onMouseUp.cancel();
		}
	}

	private function window_onMouseWheel(window:Window, deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		parent.__dispatchPendingMouseEvent();
		var preventDefault = false;

		if (deltaMode == PIXELS)
		{
			preventDefault = parent.__onMouseWheel(Std.int(deltaX * window.scale), Std.int(deltaY * window.scale));
		}
		else
		{
			preventDefault = parent.__onMouseWheel(Std.int(deltaX), Std.int(deltaY));
		}

		if (preventDefault)
		{
			window.onMouseWheel.cancel();
		}
	}

	private function window_onMove(window:Window, x:Float, y:Float):Void
	{
		// if (parent.limeWindow == null || parent.limeWindow != window) return;
	}

	private function window_onRender(context:RenderContext):Void
	{
		#if (openfl_cairo && !display)
		if (parent.__renderer != null && parent.__renderer.__type == CAIRO)
		{
			var renderer:CairoRenderer = cast parent.__renderer;
			renderer.cairo = context.cairo;
		}
		#end

		parent.__render();
	}

	private function window_onRenderContextLost():Void
	{
		parent.__renderer = null;
		parent.context3D = null;

		for (stage3D in parent.stage3Ds)
		{
			stage3D.__lostContext();
		}
	}

	private function window_onRenderContextRestored(context:RenderContext):Void
	{
		createRenderer();

		for (stage3D in parent.stage3Ds)
		{
			stage3D.__restoreContext();
		}
	}

	private function window_onResize(window:Window, width:Int, height:Int):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		parent.__resize();

		#if android
		// workaround for newer behavior
		parent.__forceRender = true;
		Lib.setTimeout(function()
		{
			parent.__forceRender = false;
		}, 500);
		#end

		if (parent.__wasFullscreen && !window.fullscreen)
		{
			parent.__wasFullscreen = false;
			parent.__displayState = NORMAL;
			parent.__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
		}
	}

	private function window_onRestore(window:Window):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		if (parent.__wasFullscreen && !window.fullscreen)
		{
			parent.__wasFullscreen = false;
			parent.__displayState = NORMAL;
			parent.__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
		}
	}

	private function window_onTextEdit(window:Window, text:String, start:Int, length:Int):Void
	{
		// if (parent.limeWindow == null || parent.limeWindow != window) return;
	}

	private function window_onTextInput(window:Window, text:String):Void
	{
		if (parent.limeWindow == null || parent.limeWindow != window) return;

		var stack = new Array<DisplayObject>();

		if (parent.__focus == null)
		{
			parent.__getInteractive(stack);
		}
		else
		{
			parent.__focus.__getInteractive(stack);
		}

		var event = new TextEvent(TextEvent.TEXT_INPUT, true, true, text);
		if (stack.length > 0)
		{
			stack.reverse();
			parent.__dispatchStack(event, stack);
		}
		else
		{
			parent.__dispatchEvent(event);
		}

		if (event.isDefaultPrevented())
		{
			window.onTextInput.cancel();
		}
	}
}
#end
