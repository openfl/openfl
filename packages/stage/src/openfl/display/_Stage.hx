package openfl.display;

import haxe.CallStack;
import haxe.ds.ArraySort;
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
import openfl._internal.utils.Log;
import openfl._internal.utils.TouchData;
import openfl.display3D.Context3D;
import openfl.display3D._Context3D;
import openfl.display.BitmapData;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.display.Window in OpenFLWindow;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.events._Event;
import openfl.events.EventDispatcher;
import openfl.events.EventPhase;
import openfl.events.FocusEvent;
import openfl.events.FullScreenEvent;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.events._MouseEvent;
import openfl.events.TextEvent;
import openfl.events.TouchEvent;
import openfl.events._TouchEvent;
import openfl.events.UncaughtErrorEvent;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom._Point;
import openfl.geom.Rectangle;
import openfl.geom.Transform;
import openfl.ui.GameInput;
import openfl.ui._GameInput;
import openfl.ui.GameInputControl;
import openfl.ui._GameInputControl;
import openfl.ui.GameInputDevice;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;
import openfl.ui.Mouse;
import openfl.ui._Mouse;
import openfl.ui.MouseCursor;
import openfl.Lib;
#if openfl_html5
import js.html.Element;
#end
#if hxtelemetry
import openfl.profiler.Telemetry;
#end
#if gl_stats
import openfl.display._internal.stats.Context3DStats;
#end

#if !display
#if openfl_gl
// import openfl.display._Context3DRenderer;
#end
#if openfl_html5
// import openfl.display._internal.CanvasRenderer;
// import openfl.display._internal.DOMRenderer;
#else
// import openfl.display._internal.CairoRenderer;
#end
#end
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Stage extends _DisplayObjectContainer
{
	public static var gameInputDevices:Map<Gamepad, GameInputDevice> = new Map();

	public var align:StageAlign;
	public var allowsFullScreen:Bool;
	public var allowsFullScreenInteractive:Bool;
	public var color(get, set):Null<Int>;
	public var contentsScaleFactor(get, never):Float;
	public var context3D:Context3D;
	public var displayState(get, set):StageDisplayState;
	#if (commonjs || (openfl_html5 && !lime))
	public var element:Element;
	#end
	public var focus(get, set):InteractiveObject;
	public var frameRate(get, set):Float;
	public var fullScreenHeight(get, never):UInt;
	public var fullScreenSourceRect(get, set):Rectangle;
	public var fullScreenWidth(get, never):UInt;
	#if lime
	public var limeApplication:Application;
	public var limeWindow:Window;
	#end
	public var quality(get, set):StageQuality;
	public var scaleMode(get, set):StageScaleMode;
	public var showDefaultContextMenu:Bool;
	public var softKeyboardRect:Rectangle;
	public var stage3Ds:Vector<Stage3D>;
	public var stageFocusRect:Bool;
	public var stageHeight:Int;
	public var stageWidth:Int;

	public var macKeyboard:Bool;
	public var primaryTouch:Touch;
	public var __cacheFocus:InteractiveObject;
	public var __clearBeforeRender:Bool;
	public var __color:Int;
	public var __colorSplit:Array<Float>;
	public var __colorString:String;
	public var __contentsScaleFactor:Float;
	public var __currentTabOrderIndex:Int;
	public var __deltaTime:Int;
	public var __dirty:Bool;
	public var __displayMatrix:Matrix;
	public var __displayRect:Rectangle;
	public var __displayState:StageDisplayState;
	public var __dragBounds:Rectangle;
	public var __dragObject:Sprite;
	public var __dragOffsetX:Float;
	public var __dragOffsetY:Float;
	public var __focus:InteractiveObject;
	public var __forceRender:Bool;
	public var __fullscreen:Bool;
	public var __fullScreenSourceRect:Rectangle;
	public var __invalidated:Bool;
	public var __lastClickTime:Int;
	public var __logicalWidth:Int;
	public var __logicalHeight:Int;
	public var __mouseDownLeft:InteractiveObject;
	public var __mouseDownMiddle:InteractiveObject;
	public var __mouseDownRight:InteractiveObject;
	public var __mouseOutStack:Array<DisplayObject>;
	public var __mouseOverTarget:InteractiveObject;
	public var __mouseX:Float;
	public var __mouseY:Float;
	public var __pendingMouseEvent:Bool;
	public var __pendingMouseX:Int;
	public var __pendingMouseY:Int;
	public var __primaryTouchID:Null<Int>;
	public var __quality:StageQuality;
	public var __renderer:DisplayObjectRenderer;
	public var __rendering:Bool;
	public var __rollOutStack:Array<DisplayObject>;
	public var __scaleMode:StageScaleMode;
	public var __stack:Array<DisplayObject>;
	public var __touchData:Map<Int, TouchData>;
	public var __transparent:Bool;
	public var __wasDirty:Bool;
	public var __wasFullscreen:Bool;

	public function new(stage:Stage,
			#if (commonjs || (openfl_html5 && !lime)) width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
		windowAttributes:Dynamic = null #elseif lime window:Window, color:Null<Int> = null #end)
	{
		this.stage = stage;

		#if hxtelemetry
		_Telemetry.__initialize();
		#end

		super(stage);

		this.name = null;

		__color = 0xFFFFFFFF;
		__colorSplit = [0xFF, 0xFF, 0xFF];
		__colorString = "#FFFFFF";
		__contentsScaleFactor = 1;
		__currentTabOrderIndex = 0;
		__deltaTime = 0;
		__displayState = NORMAL;
		__mouseX = 0;
		__mouseY = 0;
		__lastClickTime = 0;
		__logicalWidth = 0;
		__logicalHeight = 0;
		__displayMatrix = new Matrix();
		__displayRect = new Rectangle();
		__renderDirty = true;

		stage3Ds = new Vector();
		for (i in 0...#if mobile 2 #else 4 #end)
		{
			stage3Ds.push(new Stage3D(this.stage));
		}

		align = StageAlign.TOP_LEFT;
		allowsFullScreen = true;
		allowsFullScreenInteractive = true;
		__quality = StageQuality.HIGH;
		__scaleMode = StageScaleMode.NO_SCALE;
		showDefaultContextMenu = true;
		softKeyboardRect = new Rectangle();
		stageFocusRect = true;

		__clearBeforeRender = true;
		__forceRender = false;
		__stack = [];
		__rollOutStack = [];
		__mouseOutStack = [];
		__touchData = new Map<Int, TouchData>();

		limeApplication = window.application;
		limeWindow = window;
		this.color = color;

		__contentsScaleFactor = window.scale;
		__wasFullscreen = window.fullscreen;

		#if mac
		macKeyboard = true;
		#elseif openfl_html5
		macKeyboard = untyped __js__("/AppleWebKit/.test (navigator.userAgent) && /Mobile\\/\\w+/.test (navigator.userAgent) || /Mac/.test (navigator.platform)");
		#end

		__resize();

		if (Lib.current.stage == null)
		{
			addChild(Lib.current);
		}
	}

	public function convertKeyCode(key:KeyCode):Int
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
		var window = limeWindow;

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
				context3D = new Context3D(this.stage);
				context3D.configureBackBuffer(windowWidth, windowHeight, 0, true, true, true);
				context3D.present();
				// if (BitmapData._.__hardwareRenderer == null)
				// {
				// 	BitmapData._.__hardwareRenderer = new Context3DRenderer(context3D);
				// }
				// __renderer = new Context3DRenderer(context3D);
				#end
				#end

			case CANVAS:
				#if (openfl.renderer_canvas && openfl_html5)
				var renderer = new CanvasRenderer(window.context.canvas2D);
				(renderer._ : _CanvasRenderer).pixelRatio = pixelRatio;
				__renderer = renderer;
				#end

			case DOM:
				#if (openfl.renderer_dom && openfl_html5)
				var renderer = new DOMRenderer(window.context.dom);
				(renderer._ : _DOMRenderer).pixelRatio = pixelRatio;
				__renderer = renderer;
				#end

			case CAIRO:
				#if (!openfl_html5 && openfl_cairo)
				__renderer = new CairoRenderer(window.context.cairo);
				#end

			default:
		}

		if (__renderer != null)
		{
			(__renderer._ : _DisplayObjectRenderer).__allowSmoothing = (quality != LOW);
			(__renderer._ : _DisplayObjectRenderer).__worldTransform = __displayMatrix;
			(__renderer._ : _DisplayObjectRenderer).__stage = this.stage;

			(__renderer._ : _DisplayObjectRenderer).__resize(windowWidth, windowHeight);

			if (_BitmapData.__hardwareRenderer != null)
			{
				_BitmapData.__hardwareRenderer._.__stage = this.stage;
				_BitmapData.__hardwareRenderer._.__worldTransform = __displayMatrix.clone();
				_BitmapData.__hardwareRenderer._.__resize(windowWidth, windowHeight);
			}
		}
		#end
	}

	public function getCharCode(key:Int, shift:Bool = false):Int
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

	public function getGameInputDevice(gamepad:Gamepad):GameInputDevice
	{
		if (gamepad == null) return null;

		if (!gameInputDevices.exists(gamepad))
		{
			var device = new GameInputDevice(gamepad.guid, gamepad.name);
			gameInputDevices.set(gamepad, device);
			_GameInput.__addInputDevice(device);
		}

		return gameInputDevices.get(gamepad);
	}

	public function getKeyLocation(key:KeyCode):KeyLocation
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

	public override function invalidate():Void
	{
		__invalidated = true;

		// TODO: Should this not mark as dirty?
		__renderDirty = true;
	}

	public override function localToGlobal(pos:Point):Point
	{
		return pos.clone();
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

	@SuppressWarnings("checkstyle:Dynamic")
	public function __broadcastEvent(event:Event):Void
	{
		if (_DisplayObject.__broadcastEvents.exists(event.type))
		{
			var dispatchers = _DisplayObject.__broadcastEvents.get(event.type);

			for (dispatcher in dispatchers)
			{
				// TODO: Way to resolve dispatching occurring if object not on stage
				// and there are multiple stage objects running in HTML5?

				if (dispatcher.stage == this.stage || dispatcher.stage == null)
				{
					#if !openfl_disable_handle_error
					try
					{
						(dispatcher._ : _DisplayObject).__dispatch(event);
					}
					catch (e:Dynamic)
					{
						__handleError(e);
					}
					#else
					(dispatcher._ : _DisplayObject).__dispatch(event);
					#end
				}
			}
		}
	}

	@SuppressWarnings(["checkstyle:Dynamic", "checkstyle:LeftCurly"])
	public override function __dispatchEvent(event:Event):Bool
	{
		#if !openfl_disable_handle_error
		try
		{
		#end

			return super.__dispatchEvent(event);

		#if !openfl_disable_handle_error
		}
		catch (e:Dynamic)
		{
			__handleError(e);
			return false;
		}
		#end
	}

	public function __dispatchPendingMouseEvent():Void
	{
		if (__pendingMouseEvent)
		{
			__onMouse(MouseEvent.MOUSE_MOVE, __pendingMouseX, __pendingMouseY, 0);
			__pendingMouseEvent = false;
		}
	}

	@SuppressWarnings(["checkstyle:Dynamic", "checkstyle:LeftCurly"])
	public function __dispatchStack(event:Event, stack:Array<DisplayObject>):Void
	{
		#if !openfl_disable_handle_error
		try
		{
		#end

			var target:DisplayObject;
			var length = stack.length;

			if (length == 0)
			{
				(event._ : _Event).eventPhase = EventPhase.AT_TARGET;
				target = cast event.target;
				(target._ : _InteractiveObject).__dispatch(event);
			}
			else
			{
				(event._ : _Event).eventPhase = EventPhase.CAPTURING_PHASE;
				(event._ : _Event).target = stack[stack.length - 1];

				for (i in 0...length - 1)
				{
					(stack[i]._ : _DisplayObject).__dispatch(event);

					if ((event._ : _Event).__isCanceled)
					{
						return;
					}
				}

					(event._ : _Event).eventPhase = EventPhase.AT_TARGET;
				target = cast event.target;
				(target._ : _InteractiveObject).__dispatch(event);

				if ((event._ : _Event).__isCanceled)
				{
					return;
				}

				if (event.bubbles)
				{
					(event._ : _Event).eventPhase = EventPhase.BUBBLING_PHASE;
					var i = length - 2;

					while (i >= 0)
					{
						(stack[i]._ : _DisplayObject).__dispatch(event);

						if ((event._ : _Event).__isCanceled)
						{
							return;
						}

						i--;
					}
				}
			}

		#if !openfl_disable_handle_error
		}
		catch (e:Dynamic)
		{
			__handleError(e);
		}
		#end
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public function __dispatchTarget(target:EventDispatcher, event:Event):Bool
	{
		#if !openfl_disable_handle_error
		try
		{
			return (target._ : _InteractiveObject).__dispatchEvent(event);
		}
		catch (e:Dynamic)
		{
			__handleError(e);
			return false;
		}
		#else
		return (target._ : _InteractiveObject).__dispatchEvent(event);
		#end
	}

	public function __drag(mouse:Point):Void
	{
		var parent = __dragObject.parent;
		if (parent != null)
		{
			__getWorldTransform()._.__transformInversePoint(mouse);
		}

		var x = mouse.x + __dragOffsetX;
		var y = mouse.y + __dragOffsetY;

		if (__dragBounds != null)
		{
			if (x < __dragBounds.x)
			{
				x = __dragBounds.x;
			}
			else if (x > __dragBounds.right)
			{
				x = __dragBounds.right;
			}

			if (y < __dragBounds.y)
			{
				y = __dragBounds.y;
			}
			else if (y > __dragBounds.bottom)
			{
				y = __dragBounds.bottom;
			}
		}

		__dragObject.x = x;
		__dragObject.y = y;
	}

	public override function __getInteractive(stack:Array<DisplayObject>):Bool
	{
		if (stack != null)
		{
			stack.push(this.stage);
		}

		return true;
	}

	public override function __globalToLocal(global:Point, local:Point):Point
	{
		if (global != local)
		{
			local.copyFrom(global);
		}

		return local;
	}

	@SuppressWarnings("checkstyle:Dynamic")
	public function __handleError(e:Dynamic):Void
	{
		var event = new UncaughtErrorEvent(UncaughtErrorEvent.UNCAUGHT_ERROR, true, true, e);

		try
		{
			(Lib.current._ : _DisplayObject).__loaderInfo.uncaughtErrorEvents.dispatchEvent(event);
		}
		catch (e:Dynamic) {}

		if (!(event._ : _Event).__preventDefault)
		{
			#if mobile
			Log.println(CallStack.toString(CallStack.exceptionStack()));
			Log.println(Std.string(e));
			#end

			#if (cpp && !cppia)
			untyped __cpp__("throw e");
			#elseif neko
			neko.Lib.rethrow(e);
			#elseif js
			try
			{
				#if (haxe >= "4.1.0")
				var exc = e;
				#else
				var exc = @:privateAccess haxe.CallStack.lastException;
				#end
				if (exc != null && Reflect.hasField(exc, "stack") && exc.stack != null && exc.stack != "")
				{
					untyped __js__("console.log")(exc.stack);
					e.stack = exc.stack;
				}
				else
				{
					var msg = CallStack.toString(CallStack.callStack());
					untyped __js__("console.log")(msg);
				}
			}
			catch (e2:Dynamic) {}
			untyped __js__("throw e");
			#elseif cs
			throw e;
			// cs.Lib.rethrow (e);
			#elseif hl
			hl.Api.rethrow(e);
			#else
			throw e;
			#end
		}
	}

	public function __onKey(event:KeyboardEvent):Bool
	{
		__dispatchPendingMouseEvent();

		_MouseEvent.__altKey = event.altKey;
		#if !openfl_doc_gen
		_MouseEvent.__commandKey = event.commandKey;
		#end
		_MouseEvent.__ctrlKey = event.ctrlKey;
		_MouseEvent.__shiftKey = event.shiftKey;

		var preventDefault = false;
		var stack = new Array<DisplayObject>();

		if (__focus == null)
		{
			__getInteractive(stack);
		}
		else
		{
			(__focus._ : _DisplayObject).__getInteractive(stack);
		}

		if (stack.length > 0)
		{
			// Flash Player events are not cancelable, should we make only some events (like APP_CONTROL_BACK) cancelable?

			stack.reverse();
			__dispatchStack(event, stack);

			if ((event._ : _Event).__preventDefault)
			{
				preventDefault = true;
			}
			else
			{
				if (event.type == KeyboardEvent.KEY_DOWN && event.keyCode == Keyboard.TAB)
				{
					var tabStack = new Array<InteractiveObject>();

					__tabTest(tabStack);

					var nextIndex = -1;
					var nextObject:InteractiveObject = null;
					var nextOffset = event.shiftKey ? -1 : 1;

					if (tabStack.length > 1)
					{
						ArraySort.sort(tabStack, function(a, b)
						{
							return a.tabIndex - b.tabIndex;
						});

						if (tabStack[tabStack.length - 1].tabIndex == -1)
						{
							// all tabIndices are equal to -1
							if (focus != null) nextIndex = 0;
							else
								nextIndex = __currentTabOrderIndex;
						}
						else
						{
							var i = 0;
							while (i < tabStack.length)
							{
								if (tabStack[i].tabIndex > -1)
								{
									if (i > 0) tabStack.splice(0, i);
									break;
								}

								i++;
							}

							if (focus != null)
							{
								var index = tabStack.indexOf(focus);

								if (index < 0) nextIndex = 0;
								else
									nextIndex = index + nextOffset;
							}
							else
							{
								nextIndex = __currentTabOrderIndex;
							}
						}
					}
					else if (tabStack.length == 1)
					{
						nextObject = tabStack[0];

						if (focus == nextObject) nextObject = null;
					}

					if (tabStack.length == 1 || tabStack.length == 0 && focus != null)
					{
						nextIndex = 0;
					}
					else if (tabStack.length > 1)
					{
						if (nextIndex < 0) nextIndex += tabStack.length;

						nextIndex %= tabStack.length;
						nextObject = tabStack[nextIndex];

						if (nextObject == focus)
						{
							nextIndex += nextOffset;

							if (nextIndex < 0) nextIndex += tabStack.length;

							nextIndex %= tabStack.length;
							nextObject = tabStack[nextIndex];
						}
					}

					var focusEvent = null;

					if (focus != null)
					{
						focusEvent = new FocusEvent(FocusEvent.KEY_FOCUS_CHANGE, true, true, nextObject, event.shiftKey, 0);

						stack = [];

						(focus._ : _DisplayObject).__getInteractive(stack);
						stack.reverse();

						__dispatchStack(focusEvent, stack);
					}

					if (focusEvent == null || !focusEvent.isDefaultPrevented())
					{
						__currentTabOrderIndex = nextIndex;
						if (nextObject != null) focus = nextObject;

						// TODO: handle border around focus
					}
				}

				// TODO: handle arrow keys changing the focus
			}
		}

		return preventDefault;
	}

	public function __onMouse(type:String, x:Float, y:Float, button:Int):Void
	{
		if (button > 2) return;

		var targetPoint = _Point.__pool.get();
		targetPoint.setTo(x, y);
		__displayMatrix._.__transformInversePoint(targetPoint);

		__mouseX = targetPoint.x;
		__mouseY = targetPoint.y;

		var stack = [];
		var target:InteractiveObject = null;

		if (__hitTest(__mouseX, __mouseY, true, stack, true, this.stage))
		{
			target = cast stack[stack.length - 1];
		}
		else
		{
			target = this.stage;
			stack = [this.stage];
		}

		if (target == null) target = this.stage;

		var clickType = null;

		switch (type)
		{
			case MouseEvent.MOUSE_DOWN:
				if ((target._ : _InteractiveObject).__allowMouseFocus())
				{
					if (focus != null)
					{
						var focusEvent = new FocusEvent(FocusEvent.MOUSE_FOCUS_CHANGE, true, true, target, false, 0);

						__dispatchStack(focusEvent, stack);

						if (!focusEvent.isDefaultPrevented())
						{
							focus = target;
						}
					}
					else
					{
						focus = target;
					}
				}
				else
				{
					focus = null;
				}

				__mouseDownLeft = target;
				_MouseEvent.__buttonDown = true;

			case MouseEvent.MIDDLE_MOUSE_DOWN:
				__mouseDownMiddle = target;

			case MouseEvent.RIGHT_MOUSE_DOWN:
				__mouseDownRight = target;

			case MouseEvent.MOUSE_UP:
				if (__mouseDownLeft != null)
				{
					_MouseEvent.__buttonDown = false;

					if (__mouseDownLeft == target)
					{
						clickType = MouseEvent.CLICK;
					}
					else
					{
						var event:MouseEvent = null;

						#if openfl_pool_events
						event = _MouseEvent.__pool.get(MouseEvent.RELEASE_OUTSIDE, __mouseX, __mouseY, new Point(__mouseX, __mouseY), this.stage);
						#else
						event = _MouseEvent.__create(MouseEvent.RELEASE_OUTSIDE, 1, __mouseX, __mouseY, new Point(__mouseX, __mouseY), this.stage);
						#end

						__mouseDownLeft.dispatchEvent(event);

						#if openfl_pool_events
						_MouseEvent.__pool.release(event);
						#end
					}

					__mouseDownLeft = null;
				}

			case MouseEvent.MIDDLE_MOUSE_UP:
				if (__mouseDownMiddle == target)
				{
					clickType = MouseEvent.MIDDLE_CLICK;
				}

				__mouseDownMiddle = null;

			case MouseEvent.RIGHT_MOUSE_UP:
				if (__mouseDownRight == target)
				{
					clickType = MouseEvent.RIGHT_CLICK;
				}

				__mouseDownRight = null;

			default:
		}

		var localPoint = _Point.__pool.get();
		var event:MouseEvent = null;

		#if openfl_pool_events
		event = _MouseEvent.__pool.get(type, __mouseX, __mouseY, (target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), target);
		#else
		event = _MouseEvent.__create(type, button, __mouseX, __mouseY, (target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), target);
		#end

		__dispatchStack(event, stack);

		#if openfl_pool_events
		_MouseEvent.__pool.release(event);
		#end

		if (clickType != null)
		{
			#if openfl_pool_events
			event = _MouseEvent.__pool.get(clickType, __mouseX, __mouseY, (target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), target);
			#else
			event = _MouseEvent.__create(clickType, button, __mouseX, __mouseY, (target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint),
				target);
			#end

			__dispatchStack(event, stack);

			#if openfl_pool_events
			_MouseEvent.__pool.release(event);
			#end

			if (type == MouseEvent.MOUSE_UP && cast(target, openfl.display.InteractiveObject).doubleClickEnabled)
			{
				var currentTime = Lib.getTimer();
				if (currentTime - __lastClickTime < 500)
				{
					#if openfl_pool_events
					event = _MouseEvent.__pool.get(MouseEvent.DOUBLE_CLICK, __mouseX, __mouseY,
						(target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), target);
					#else
					event = _MouseEvent.__create(MouseEvent.DOUBLE_CLICK, button, __mouseX, __mouseY,
						(target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), target);
					#end

					__dispatchStack(event, stack);

					#if openfl_pool_events
					_MouseEvent.__pool.release(event);
					#end

					__lastClickTime = 0;
				}
				else
				{
					__lastClickTime = currentTime;
				}
			}
		}

		if (_Mouse.__cursor == MouseCursor.AUTO && !_Mouse.__hidden)
		{
			var cursor = null;

			if (__mouseDownLeft != null)
			{
				cursor = (__mouseDownLeft._ : _DisplayObject).__getCursor();
			}
			else
			{
				for (target in stack)
				{
					cursor = (target._ : _InteractiveObject).__getCursor();

					if (cursor != null)
					{
						_Mouse.__setStageCursor(this.stage, cursor);
					}
				}
			}

			if (cursor == null)
			{
				_Mouse.__setStageCursor(this.stage, ARROW);
			}
		}

		var event;

		if (target != __mouseOverTarget)
		{
			if (__mouseOverTarget != null)
			{
				#if openfl_pool_events
				event = _MouseEvent.__pool.get(MouseEvent.MOUSE_OUT, __mouseX, __mouseY,
					(__mouseOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast __mouseOverTarget);
				#else
				event = _MouseEvent.__create(MouseEvent.MOUSE_OUT, button, __mouseX, __mouseY,
					(__mouseOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast __mouseOverTarget);
				#end

				__dispatchStack(event, __mouseOutStack);

				#if openfl_pool_events
				_MouseEvent.__pool.release(event);
				#end
			}
		}

		var item, i = 0;
		while (i < __rollOutStack.length)
		{
			item = __rollOutStack[i];
			if (stack.indexOf(item) == -1)
			{
				__rollOutStack.remove(item);

				#if openfl_pool_events
				event = _MouseEvent.__pool.get(MouseEvent.ROLL_OUT, __mouseX, __mouseY,
					(__mouseOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast __mouseOverTarget);
				#else
				event = _MouseEvent.__create(MouseEvent.ROLL_OUT, button, __mouseX, __mouseY,
					(__mouseOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast __mouseOverTarget);
				#end
				(event._ : _Event).bubbles = false;

				__dispatchTarget(item, event);

				#if openfl_pool_events
				_MouseEvent.__pool.release(event);
				#end
			}
			else
			{
				i++;
			}
		}

		for (item in stack)
		{
			if (__rollOutStack.indexOf(item) == -1 && __mouseOverTarget != null)
			{
				if (item.hasEventListener(MouseEvent.ROLL_OVER))
				{
					#if openfl_pool_events
					event = _MouseEvent.__pool.get(MouseEvent.ROLL_OVER, __mouseX, __mouseY,
						(__mouseOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast item);
					#else
					event = _MouseEvent.__create(MouseEvent.ROLL_OVER, button, __mouseX, __mouseY,
						(__mouseOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast item);
					#end
					(event._ : _Event).bubbles = false;

					__dispatchTarget(item, event);

					#if openfl_pool_events
					_MouseEvent.__pool.release(event);
					#end
				}

				if (item.hasEventListener(MouseEvent.ROLL_OUT) || item.hasEventListener(MouseEvent.ROLL_OVER))
				{
					__rollOutStack.push(item);
				}
			}
		}

		if (target != __mouseOverTarget)
		{
			if (target != null)
			{
				#if openfl_pool_events
				event = _MouseEvent.__pool.get(MouseEvent.MOUSE_OVER, __mouseX, __mouseY,
					(target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), cast target);
				#else
				event = _MouseEvent.__create(MouseEvent.MOUSE_OVER, button, __mouseX, __mouseY,
					(target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), cast target);
				#end

				__dispatchStack(event, stack);

				#if openfl_pool_events
				_MouseEvent.__pool.release(event);
				#end
			}

			__mouseOverTarget = target;
			__mouseOutStack = stack;
		}

		if (__dragObject != null)
		{
			__drag(targetPoint);

			var dropTarget = null;

			if (__mouseOverTarget == __dragObject)
			{
				var cacheMouseEnabled = __dragObject.mouseEnabled;
				var cacheMouseChildren = __dragObject.mouseChildren;

				__dragObject.mouseEnabled = false;
				__dragObject.mouseChildren = false;

				var stack = [];

				if (__hitTest(__mouseX, __mouseY, true, stack, true, this.stage))
				{
					dropTarget = stack[stack.length - 1];
				}

				__dragObject.mouseEnabled = cacheMouseEnabled;
				__dragObject.mouseChildren = cacheMouseChildren;
			}
			else if (__mouseOverTarget != this.stage)
			{
				dropTarget = __mouseOverTarget;
			}

				(__dragObject._ : _Sprite).dropTarget = dropTarget;
		}

		_Point.__pool.release(targetPoint);
		_Point.__pool.release(localPoint);
	}

	public function __onMouseWheel(deltaX:Float, deltaY:Float):Bool
	{
		// TODO: Support delta modes

		var x = __mouseX;
		var y = __mouseY;

		var stack = [];
		var target:InteractiveObject = null;

		if (__hitTest(__mouseX, __mouseY, true, stack, true, this.stage))
		{
			target = cast stack[stack.length - 1];
		}
		else
		{
			target = this.stage;
			stack = [this.stage];
		}

		if (target == null) target = this.stage;
		var targetPoint = _Point.__pool.get();
		targetPoint.setTo(x, y);
		__displayMatrix._.__transformInversePoint(targetPoint);
		var delta = Std.int(deltaY);

		var event = _MouseEvent.__create(MouseEvent.MOUSE_WHEEL, 0, __mouseX, __mouseY,
			(target._ : _InteractiveObject).__globalToLocal(targetPoint, targetPoint), target, delta);
		(event._ : _Event).cancelable = true;
		__dispatchStack(event, stack);

		_Point.__pool.release(targetPoint);

		return event.isDefaultPrevented();
	}

	public function __onTouch(type:String, id:Int, x:Int, y:Int, pressure:Float, isPrimaryTouchPoint:Bool):Void
	{
		var targetPoint = _Point.__pool.get();
		targetPoint.setTo(x, y);
		__displayMatrix._.__transformInversePoint(targetPoint);

		var touchX = targetPoint.x;
		var touchY = targetPoint.y;

		var stack = [];
		var target:InteractiveObject = null;

		if (__hitTest(touchX, touchY, false, stack, true, this.stage))
		{
			target = cast stack[stack.length - 1];
		}
		else
		{
			target = this.stage;
			stack = [this.stage];
		}

		if (target == null) target = this.stage;

		var touchData:TouchData = null;

		if (__touchData.exists(id))
		{
			touchData = __touchData.get(id);
		}
		else
		{
			touchData = TouchData.__pool.get();
			touchData.reset();
			__touchData.set(id, touchData);
		}

		var touchType = null;
		var releaseTouchData:Bool = false;

		switch (type)
		{
			case TouchEvent.TOUCH_BEGIN:
				touchData.touchDownTarget = target;

			case TouchEvent.TOUCH_END:
				if (touchData.touchDownTarget == target)
				{
					touchType = TouchEvent.TOUCH_TAP;
				}

				touchData.touchDownTarget = null;
				releaseTouchData = true;

			default:
		}

		var localPoint = _Point.__pool.get();
		var touchEvent = _TouchEvent.__create(type, null, touchX, touchY, (target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint),
			cast target);
		touchEvent.touchPointID = id;
		touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
		touchEvent.pressure = pressure;

		__dispatchStack(touchEvent, stack);

		if (touchType != null)
		{
			touchEvent = _TouchEvent.__create(touchType, null, touchX, touchY, (target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint),
				cast target);
			touchEvent.touchPointID = id;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.pressure = pressure;

			__dispatchStack(touchEvent, stack);
		}

		var touchOverTarget = touchData.touchOverTarget;

		if (target != touchOverTarget && touchOverTarget != null)
		{
			touchEvent = _TouchEvent.__create(TouchEvent.TOUCH_OUT, null, touchX, touchY,
				(touchOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast touchOverTarget);
			touchEvent.touchPointID = id;
			touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
			touchEvent.pressure = pressure;

			__dispatchTarget(touchOverTarget, touchEvent);
		}

		var touchOutStack = touchData.rollOutStack;
		var item, i = 0;
		while (i < touchOutStack.length)
		{
			item = touchOutStack[i];
			if (stack.indexOf(item) == -1)
			{
				touchOutStack.remove(item);

				touchEvent = _TouchEvent.__create(TouchEvent.TOUCH_ROLL_OUT, null, touchX, touchY,
					(touchOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast touchOverTarget);
				touchEvent.touchPointID = id;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				(touchEvent._ : _Event).bubbles = false;
				touchEvent.pressure = pressure;

				__dispatchTarget(item, touchEvent);
			}
			else
			{
				i++;
			}
		}

		for (item in stack)
		{
			if (touchOutStack.indexOf(item) == -1)
			{
				if (item.hasEventListener(TouchEvent.TOUCH_ROLL_OVER))
				{
					touchEvent = _TouchEvent.__create(TouchEvent.TOUCH_ROLL_OVER, null, touchX, touchY,
						(touchOverTarget._ : _DisplayObject).__globalToLocal(targetPoint, localPoint), cast item);
					touchEvent.touchPointID = id;
					touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
					(touchEvent._ : _Event).bubbles = false;
					touchEvent.pressure = pressure;

					__dispatchTarget(item, touchEvent);
				}

				if (item.hasEventListener(TouchEvent.TOUCH_ROLL_OUT))
				{
					touchOutStack.push(item);
				}
			}
		}

		if (target != touchOverTarget)
		{
			if (target != null)
			{
				touchEvent = _TouchEvent.__create(TouchEvent.TOUCH_OVER, null, touchX, touchY,
					(target._ : _InteractiveObject).__globalToLocal(targetPoint, localPoint), cast target);
				touchEvent.touchPointID = id;
				touchEvent.isPrimaryTouchPoint = isPrimaryTouchPoint;
				(touchEvent._ : _Event).bubbles = true;
				touchEvent.pressure = pressure;

				__dispatchTarget(target, touchEvent);
			}

			touchData.touchOverTarget = target;
		}

		_Point.__pool.release(targetPoint);
		_Point.__pool.release(localPoint);

		if (releaseTouchData)
		{
			__touchData.remove(id);
			touchData.reset();
			TouchData.__pool.release(touchData);
		}
	}

	public function __render():Void
	{
		if (__rendering) return;
		__rendering = true;

		#if hxtelemetry
		Telemetry._.__advanceFrame();
		#end

		#if gl_stats
		Context3DStats.resetDrawCalls();
		#end

		var event = null;

		#if openfl_pool_events
		event = Event._.__pool.get(Event.ENTER_FRAME);

		__broadcastEvent(event);

		Event._.__pool.release(event);
		event = Event._.__pool.get(Event.FRAME_CONSTRUCTED);

		__broadcastEvent(event);

		Event._.__pool.release(event);
		event = Event._.__pool.get(Event.EXIT_FRAME);

		__broadcastEvent(event);

		Event._.__pool.release(event);
		#else
		__broadcastEvent(new Event(Event.ENTER_FRAME));
		__broadcastEvent(new Event(Event.FRAME_CONSTRUCTED));
		__broadcastEvent(new Event(Event.EXIT_FRAME));
		#end

		__renderable = true;
		if (__renderer != null)
		{
			(__renderer._ : _DisplayObjectRenderer).__enterFrame(this.stage, __deltaTime);
		}
		__deltaTime = 0;

		var shouldRender = #if !openfl_disable_display_render (__renderer != null #if !openfl_always_render && (__renderDirty || __forceRender) #end) #else false #end;
		var shouldUpdate = shouldRender || __transformDirty;

		if (__invalidated && shouldRender)
		{
			__invalidated = false;

			#if openfl_pool_events
			event = Event._.__pool.get(Event.RENDER);
			#else
			event = new Event(Event.RENDER);
			#end

			__broadcastEvent(event);

			#if openfl_pool_events
			Event._.__pool.release(event);
			#end
		}

		#if hxtelemetry
		var stack = Telemetry._.__unwindStack();
		Telemetry._.__startTiming(TelemetryCommandName.RENDER);
		#end

		if (_DisplayObject.__supportDOM)
		{
			if (shouldUpdate || __wasDirty)
			{
				// If we were dirty last time, we need at least one more
				// update in order to clear "changed" properties
				__update(false, true);
				__wasDirty = shouldUpdate;
			}
		}
		else if (shouldUpdate)
		{
			__update(false, true);
		}

		#if (lime || openfl_html5)
		if (__renderer != null)
		{
			if (context3D != null)
			{
				for (stage3D in stage3Ds)
				{
					(context3D._ : _Context3D).__renderStage3D(stage3D);
				}

				#if !openfl_disable_display_render
				if ((context3D._ : _Context3D).__present) shouldRender = true;
				#end
			}

			if (shouldRender)
			{
				if (context3D == null)
				{
					(__renderer._ : _DisplayObjectRenderer).__clear();
				}

					(__renderer._ : _DisplayObjectRenderer).__render(this.stage);
			}
			else if (context3D == null)
			{
				limeWindow.onRender.cancel();
			}

			if (context3D != null)
			{
				if (!(context3D._ : _Context3D).__present)
				{
					limeWindow.onRender.cancel();
				}
				else
				{
					if (!(__renderer._ : _DisplayObjectRenderer).__cleared)
					{
						(__renderer._ : _DisplayObjectRenderer).__clear();
					}

						(context3D._ : _Context3D).__present = false;
					(context3D._ : _Context3D).__cleared = false;
				}

					(context3D._ : _Context3D).__bitmapDataPool.cleanup();
			}

				(__renderer._ : _DisplayObjectRenderer).__cleared = false;

			// TODO: Run once for multi-stage application
			_BitmapData.__pool.cleanup();
		}
		#end

		#if hxtelemetry
		Telemetry._.__endTiming(TelemetryCommandName.RENDER);
		Telemetry._.__rewindStack(stack);
		#end

		__rendering = false;
	}

	public function __resize():Void
	{
		var cacheWidth = stageWidth;
		var cacheHeight = stageHeight;

		var windowWidth = Std.int(limeWindow.width * limeWindow.scale);
		var windowHeight = Std.int(limeWindow.height * limeWindow.scale);

		#if openfl_html5
		__logicalWidth = windowWidth;
		__logicalHeight = windowHeight;
		#end

		__displayMatrix.identity();

		if (fullScreenSourceRect != null && limeWindow.fullscreen)
		{
			stageWidth = Std.int(fullScreenSourceRect.width);
			stageHeight = Std.int(fullScreenSourceRect.height);

			var displayScaleX = windowWidth / stageWidth;
			var displayScaleY = windowHeight / stageHeight;

			__displayMatrix.translate(-fullScreenSourceRect.x, -fullScreenSourceRect.y);
			__displayMatrix.scale(displayScaleX, displayScaleY);

			__displayRect.setTo(fullScreenSourceRect.left, fullScreenSourceRect.right, fullScreenSourceRect.top, fullScreenSourceRect.bottom);
		}
		else
		{
			if (__logicalWidth == 0 && __logicalHeight == 0)
			{
				stageWidth = windowWidth;
				stageHeight = windowHeight;
			}
			else
			{
				stageWidth = __logicalWidth;
				stageHeight = __logicalHeight;

				var scaleX = windowWidth / stageWidth;
				var scaleY = windowHeight / stageHeight;
				var targetScale = Math.min(scaleX, scaleY);

				var offsetX = Math.round((windowWidth - (stageWidth * targetScale)) / 2);
				var offsetY = Math.round((windowHeight - (stageHeight * targetScale)) / 2);

				__displayMatrix.scale(targetScale, targetScale);
				__displayMatrix.translate(offsetX, offsetY);
			}

			__displayRect.setTo(0, 0, stageWidth, stageHeight);
		}

		if (context3D != null)
		{
			context3D.configureBackBuffer(windowWidth, windowHeight, 0, true, true, true);
		}

		for (stage3D in stage3Ds)
		{
			(stage3D._ : _Stage3D).__resize(windowWidth, windowHeight);
		}

		if (__renderer != null)
		{
			(__renderer._ : _DisplayObjectRenderer).__resize(windowWidth, windowHeight);
		}

		if (stageWidth != cacheWidth || stageHeight != cacheHeight)
		{
			__renderDirty = true;
			__setTransformDirty();

			var event:Event = null;

			#if openfl_pool_events
			event = Event._.__pool.get(Event.RESIZE);
			#else
			event = new Event(Event.RESIZE);
			#end

			__dispatchEvent(event);

			#if openfl_pool_events
			Event._.__pool.release(event);
			#end
		}
	}

	public function __setLogicalSize(width:Int, height:Int):Void
	{
		__logicalWidth = width;
		__logicalHeight = height;

		__resize();
	}

	public function __startDrag(sprite:Sprite, lockCenter:Bool, bounds:Rectangle):Void
	{
		if (bounds == null)
		{
			__dragBounds = null;
		}
		else
		{
			__dragBounds = new Rectangle();

			var right = bounds.right;
			var bottom = bounds.bottom;
			__dragBounds.x = right < bounds.x ? right : bounds.x;
			__dragBounds.y = bottom < bounds.y ? bottom : bounds.y;
			__dragBounds.width = Math.abs(bounds.width);
			__dragBounds.height = Math.abs(bounds.height);
		}

		__dragObject = sprite;

		if (__dragObject != null)
		{
			if (lockCenter)
			{
				__dragOffsetX = 0;
				__dragOffsetY = 0;
			}
			else
			{
				var mouse = _Point.__pool.get();
				mouse.setTo(mouseX, mouseY);
				var parent = __dragObject.parent;

				if (parent != null)
				{
					__getWorldTransform()._.__transformInversePoint(mouse);
				}

				__dragOffsetX = __dragObject.x - mouse.x;
				__dragOffsetY = __dragObject.y - mouse.y;
				_Point.__pool.release(mouse);
			}
		}
	}

	public function __stopDrag(sprite:Sprite):Void
	{
		__dragBounds = null;
		__dragObject = null;
	}

	// Event Handlers

	public function application_onCreateWindow(window:Window):Void
	{
		if (limeWindow != window) return;

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

	public function application_onExit(code:Int):Void
	{
		if (limeWindow != null)
		{
			var event:Event = null;

			#if openfl_pool_events
			event = Event._.__pool.get(Event.DEACTIVATE);
			#else
			event = new Event(Event.DEACTIVATE);
			#end

			__broadcastEvent(event);

			#if openfl_pool_events
			Event._.__pool.release(event);
			#end
		}
	}

	public function application_onUpdate(deltaTime:Int):Void
	{
		__deltaTime = deltaTime;
		__dispatchPendingMouseEvent();
	}

	public function gamepad_onAxisMove(gamepad:Gamepad, axis:GamepadAxis, value:Float):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device._.__axis.exists(axis))
			{
				var control = new GameInputControl(device, "AXIS_" + axis, -1, 1);
				device._.__axis.set(axis, control);
				device._.__controls.push(control);
			}

			var control = device._.__axis.get(axis);
			(control._ : _GameInputControl).value = value;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	public function gamepad_onButtonDown(gamepad:Gamepad, button:GamepadButton):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device._.__button.exists(button))
			{
				var control = new GameInputControl(device, "BUTTON_" + button, 0, 1);
				device._.__button.set(button, control);
				device._.__controls.push(control);
			}

			var control = device._.__button.get(button);
			(control._ : _GameInputControl).value = 1;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	public function gamepad_onButtonUp(gamepad:Gamepad, button:GamepadButton):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		if (device.enabled)
		{
			if (!device._.__button.exists(button))
			{
				var control = new GameInputControl(device, "BUTTON_" + button, 0, 1);
				device._.__button.set(button, control);
				device._.__controls.push(control);
			}

			var control = device._.__button.get(button);
			(control._ : _GameInputControl).value = 0;
			control.dispatchEvent(new Event(Event.CHANGE));
		}
	}

	public function gamepad_onConnect(gamepad:Gamepad):Void
	{
		var device = getGameInputDevice(gamepad);
		if (device == null) return;

		// GameInput._.__dispatchEvent(new GameInputEvent(GameInputEvent.DEVICE_ADDED, true, false, device));

		gamepad.onAxisMove.add(gamepad_onAxisMove.bind(gamepad));
		gamepad.onButtonDown.add(gamepad_onButtonDown.bind(gamepad));
		gamepad.onButtonUp.add(gamepad_onButtonUp.bind(gamepad));
		gamepad.onDisconnect.add(gamepad_onDisconnect.bind(gamepad));
	}

	public function gamepad_onDisconnect(gamepad:Gamepad):Void
	{
		var device = gameInputDevices.get(gamepad);

		if (device != null)
		{
			if (gameInputDevices.exists(gamepad))
			{
				var device = gameInputDevices.get(gamepad);
				gameInputDevices.remove(gamepad);
				_GameInput.__removeInputDevice(device);
			}
		}
	}

	public function touch_onCancel(touch:Touch):Void
	{
		// TODO: Should we handle this differently?

		var oldPrimaryTouch = primaryTouch;
		if (primaryTouch == touch)
		{
			primaryTouch = null;
		}

		__onTouch(TouchEvent.TOUCH_END, touch.id, Math.round(touch.x * limeWindow.width), Math.round(touch.y * limeWindow.width), touch.pressure,
			touch == oldPrimaryTouch);
	}

	public function touch_onMove(touch:Touch):Void
	{
		__onTouch(TouchEvent.TOUCH_MOVE, touch.id, Math.round(touch.x * limeWindow.width), Math.round(touch.y * limeWindow.width), touch.pressure,
			touch == primaryTouch);
	}

	public function touch_onEnd(touch:Touch):Void
	{
		var oldPrimaryTouch = primaryTouch;
		if (primaryTouch == touch)
		{
			primaryTouch = null;
		}

		__onTouch(TouchEvent.TOUCH_END, touch.id, Math.round(touch.x * limeWindow.width), Math.round(touch.y * limeWindow.width), touch.pressure,
			touch == oldPrimaryTouch);
	}

	public function touch_onStart(touch:Touch):Void
	{
		if (primaryTouch == null)
		{
			primaryTouch = touch;
		}

		__onTouch(TouchEvent.TOUCH_BEGIN, touch.id, Math.round(touch.x * limeWindow.width), Math.round(touch.y * limeWindow.width), touch.pressure,
			touch == primaryTouch);
	}

	public function window_onActivate(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		// __broadcastEvent (new Event (Event.ACTIVATE));
	}

	public function window_onClose(window:Window):Void
	{
		if (limeWindow == window)
		{
			limeWindow = null;
		}

		primaryTouch = null;

		var event:Event = null;

		#if openfl_pool_events
		event = Event._.__pool.get(Event.DEACTIVATE);
		#else
		event = new Event(Event.DEACTIVATE);
		#end

		__broadcastEvent(event);

		#if openfl_pool_events
		Event._.__pool.release(event);
		#end
	}

	public function window_onCreate(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		if (window.context != null)
		{
			createRenderer();
		}
	}

	public function window_onDeactivate(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		// __primaryTouch = null;
		// __broadcastEvent (new Event (Event.DEACTIVATE));
	}

	public function window_onDropFile(window:Window, file:String):Void {}

	public function window_onEnter(window:Window):Void
	{
		// if (limeWindow == null || limeWindow != window) return;
	}

	public function window_onExpose(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		__renderDirty = true;
	}

	public function window_onFocusIn(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		#if !desktop
		// TODO: Is this needed?
		__renderDirty = true;
		#end

		var event:Event = null;

		#if openfl_pool_events
		event = Event._.__pool.get(Event.ACTIVATE);
		#else
		event = new Event(Event.ACTIVATE);
		#end

		__broadcastEvent(event);

		#if openfl_pool_events
		Event._.__pool.release(event);
		#end

		#if !desktop
		focus = __cacheFocus;
		#end
	}

	public function window_onFocusOut(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		primaryTouch = null;

		var event:Event = null;

		#if openfl_pool_events
		event = Event._.__pool.get(Event.DEACTIVATE);
		#else
		event = new Event(Event.DEACTIVATE);
		#end

		__broadcastEvent(event);

		#if openfl_pool_events
		Event._.__pool.release(event);
		#end

		var currentFocus = focus;
		focus = null;
		__cacheFocus = currentFocus;

		_MouseEvent.__altKey = false;
		_MouseEvent.__commandKey = false;
		_MouseEvent.__ctrlKey = false;
		_MouseEvent.__shiftKey = false;
	}

	public function window_onFullscreen(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		__resize();

		if (!__wasFullscreen)
		{
			__wasFullscreen = true;
			if (__displayState == NORMAL) __displayState = FULL_SCREEN_INTERACTIVE;
			__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, true, true));
		}
	}

	public function window_onKeyDown(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		var keyLocation = getKeyLocation(keyCode);
		var keyCode = convertKeyCode(keyCode);
		var charCode = getCharCode(keyCode, modifier.shiftKey);

		var event = new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, charCode, keyCode, keyLocation,
			macKeyboard ? (modifier.ctrlKey || modifier.metaKey) : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

		if (__onKey(event))
		{
			window.onKeyDown.cancel();
		}
	}

	public function window_onKeyUp(window:Window, keyCode:KeyCode, modifier:KeyModifier):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		var keyLocation = getKeyLocation(keyCode);
		var keyCode = convertKeyCode(keyCode);
		var charCode = getCharCode(keyCode, modifier.shiftKey);

		var event = new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, charCode, keyCode, keyLocation,
			macKeyboard ? (modifier.ctrlKey || modifier.metaKey) : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

		if (__onKey(event))
		{
			window.onKeyUp.cancel();
		}
	}

	public function window_onLeave(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window || _MouseEvent.__buttonDown) return;

		__dispatchPendingMouseEvent();

		var event:Event = null;

		#if openfl_pool_events
		event = Event._.__pool.get(Event.MOUSE_LEAVE);
		#else
		event = new Event(Event.MOUSE_LEAVE);
		#end

		__dispatchEvent(event);

		#if openfl_pool_events
		Event._.__pool.release(event);
		#end
	}

	public function window_onMinimize(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		// __primaryTouch = null;
		// __broadcastEvent (new Event (Event.DEACTIVATE));
	}

	public function window_onMouseDown(window:Window, x:Float, y:Float, button:Int):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		__dispatchPendingMouseEvent();

		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_DOWN;
			case 2: MouseEvent.RIGHT_MOUSE_DOWN;
			default: MouseEvent.MOUSE_DOWN;
		}

		__onMouse(type, Std.int(x * window.scale), Std.int(y * window.scale), button);

		if (!showDefaultContextMenu && button == 2)
		{
			window.onMouseDown.cancel();
		}
	}

	public function window_onMouseMove(window:Window, x:Float, y:Float):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		#if openfl_always_dispatch_mouse_events
		__onMouse(MouseEvent.MOUSE_MOVE, Std.int(x * window.scale), Std.int(y * window.scale), 0);
		#else
		__pendingMouseEvent = true;
		__pendingMouseX = Std.int(x * window.scale);
		__pendingMouseY = Std.int(y * window.scale);
		#end
	}

	public function window_onMouseMoveRelative(window:Window, x:Float, y:Float):Void
	{
		// if (limeWindow == null || limeWindow != window) return;
	}

	public function window_onMouseUp(window:Window, x:Float, y:Float, button:Int):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		__dispatchPendingMouseEvent();

		var type = switch (button)
		{
			case 1: MouseEvent.MIDDLE_MOUSE_UP;
			case 2: MouseEvent.RIGHT_MOUSE_UP;
			default: MouseEvent.MOUSE_UP;
		}

		__onMouse(type, Std.int(x * window.scale), Std.int(y * window.scale), button);

		if (!showDefaultContextMenu && button == 2)
		{
			window.onMouseUp.cancel();
		}
	}

	public function window_onMouseWheel(window:Window, deltaX:Float, deltaY:Float, deltaMode:MouseWheelMode):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		__dispatchPendingMouseEvent();
		var preventDefault = false;

		if (deltaMode == PIXELS)
		{
			preventDefault = __onMouseWheel(Std.int(deltaX * window.scale), Std.int(deltaY * window.scale));
		}
		else
		{
			preventDefault = __onMouseWheel(Std.int(deltaX), Std.int(deltaY));
		}

		if (preventDefault)
		{
			window.onMouseWheel.cancel();
		}
	}

	public function window_onMove(window:Window, x:Float, y:Float):Void
	{
		// if (limeWindow == null || limeWindow != window) return;
	}

	public function window_onRender(context:RenderContext):Void
	{
		#if (openfl_cairo && !display)
		if (__renderer != null && (__renderer._ : _DisplayObjectRenderer).__type == CAIRO)
		{
			// var renderer:CairoRenderer = cast __renderer;
			// renderer.cairo = context.cairo;
		}
		#end

		__render();
	}

	public function window_onRenderContextLost():Void
	{
		__renderer = null;
		context3D = null;

		for (stage3D in stage3Ds)
		{
			(stage3D._ : _Stage3D).__lostContext();
		}
	}

	public function window_onRenderContextRestored(context:RenderContext):Void
	{
		createRenderer();

		for (stage3D in stage3Ds)
		{
			(stage3D._ : _Stage3D).__restoreContext();
		}
	}

	public function window_onResize(window:Window, width:Int, height:Int):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		__resize();

		#if android
		// workaround for newer behavior
		__forceRender = true;
		Lib.setTimeout(function()
		{
			__forceRender = false;
		}, 500);
		#end

		if (__wasFullscreen && !window.fullscreen)
		{
			__wasFullscreen = false;
			__displayState = NORMAL;
			__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
		}
	}

	public function window_onRestore(window:Window):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		if (__wasFullscreen && !window.fullscreen)
		{
			__wasFullscreen = false;
			__displayState = NORMAL;
			__dispatchEvent(new FullScreenEvent(FullScreenEvent.FULL_SCREEN, false, false, false, true));
		}
	}

	public function window_onTextEdit(window:Window, text:String, start:Int, length:Int):Void
	{
		// if (limeWindow == null || limeWindow != window) return;
	}

	public function window_onTextInput(window:Window, text:String):Void
	{
		if (limeWindow == null || limeWindow != window) return;

		var stack = new Array<DisplayObject>();

		if (__focus == null)
		{
			__getInteractive(stack);
		}
		else
		{
			(__focus._ : _DisplayObject).__getInteractive(stack);
		}

		var event = new TextEvent(TextEvent.TEXT_INPUT, true, true, text);
		if (stack.length > 0)
		{
			stack.reverse();
			__dispatchStack(event, stack);
		}
		else
		{
			__dispatchEvent(event);
		}

		if (event.isDefaultPrevented())
		{
			window.onTextInput.cancel();
		}
	}

	// Get & Set Methods
	private function get_color():Null<Int>
	{
		return __color;
	}

	private function set_color(value:Null<Int>):Null<Int>
	{
		if (value == null)
		{
			__transparent = true;
			value = 0x000000;
		}
		else
		{
			__transparent = false;
		}

		if (__color != value)
		{
			var r = (value & 0xFF0000) >>> 16;
			var g = (value & 0x00FF00) >>> 8;
			var b = (value & 0x0000FF);

			__colorSplit[0] = r / 0xFF;
			__colorSplit[1] = g / 0xFF;
			__colorSplit[2] = b / 0xFF;
			__colorString = "#" + StringTools.hex(value & 0xFFFFFF, 6);
			__renderDirty = true;
			__color = (0xFF << 24) | (value & 0xFFFFFF);
		}

		return value;
	}

	private function get_contentsScaleFactor():Float
	{
		return __contentsScaleFactor;
	}

	private function get_displayState():StageDisplayState
	{
		return __displayState;
	}

	private function set_displayState(value:StageDisplayState):StageDisplayState
	{
		if (limeWindow != null)
		{
			switch (value)
			{
				case NORMAL:
					if (limeWindow.fullscreen)
					{
						limeWindow.fullscreen = false;
					}

				default:
					if (!limeWindow.fullscreen)
					{
						limeWindow.fullscreen = true;
					}
			}
		}
		return __displayState = value;
	}

	private function get_focus():InteractiveObject
	{
		return __focus;
	}

	private function set_focus(value:InteractiveObject):InteractiveObject
	{
		if (value != __focus)
		{
			var oldFocus = __focus;
			__focus = value;
			__cacheFocus = value;

			if (oldFocus != null)
			{
				var event = new FocusEvent(FocusEvent.FOCUS_OUT, true, false, value, false, 0);
				var stack = new Array<DisplayObject>();
				(oldFocus._ : _DisplayObject).__getInteractive(stack);
				stack.reverse();
				__dispatchStack(event, stack);
			}

			if (value != null)
			{
				var event = new FocusEvent(FocusEvent.FOCUS_IN, true, false, oldFocus, false, 0);
				var stack = new Array<DisplayObject>();
				(value._ : _DisplayObject).__getInteractive(stack);
				stack.reverse();
				__dispatchStack(event, stack);
			}
		}

		return value;
	}

	private function get_frameRate():Float
	{
		if (limeWindow != null)
		{
			return limeWindow.frameRate;
		}

		return 0;
	}

	private function set_frameRate(value:Float):Float
	{
		if (limeWindow != null)
		{
			limeWindow.frameRate = value;
		}
		return value;
	}

	private function get_fullScreenHeight():UInt
	{
		return Math.ceil(limeWindow.display.currentMode.height * limeWindow.scale);
	}

	private function get_fullScreenSourceRect():Rectangle
	{
		return __fullScreenSourceRect == null ? null : __fullScreenSourceRect.clone();
	}

	private function set_fullScreenSourceRect(value:Rectangle):Rectangle
	{
		if (value == null)
		{
			if (__fullScreenSourceRect != null)
			{
				__fullScreenSourceRect = null;
				__resize();
			}
		}
		else if (!value.equals(__fullScreenSourceRect))
		{
			__fullScreenSourceRect = value.clone();
			__resize();
		}

		return value;
	}

	private function get_fullScreenWidth():UInt
	{
		return Math.ceil(limeWindow.display.currentMode.width * limeWindow.scale);
	}

	public override function set_height(value:Float):Float
	{
		return this.height;
	}

	public override function get_mouseX():Float
	{
		return __mouseX;
	}

	public override function get_mouseY():Float
	{
		return __mouseY;
	}

	private function get_quality():StageQuality
	{
		return __quality;
	}

	private function set_quality(value:StageQuality):StageQuality
	{
		__quality = value;

		if (__renderer != null)
		{
			(__renderer._ : _DisplayObjectRenderer).__allowSmoothing = (quality != LOW);
		}

		return value;
	}

	public override function set_rotation(value:Float):Float
	{
		return 0;
	}

	private function get_scaleMode():StageScaleMode
	{
		return __scaleMode;
	}

	private function set_scaleMode(value:StageScaleMode):StageScaleMode
	{
		// TODO

		return __scaleMode = value;
	}

	public override function set_scaleX(value:Float):Float
	{
		return 0;
	}

	public override function set_scaleY(value:Float):Float
	{
		return 0;
	}

	public override function get_tabEnabled():Bool
	{
		return false;
	}

	public override function set_tabEnabled(value:Bool):Bool
	{
		throw new IllegalOperationError("Error: The Stage class does not implement this property or method.");
	}

	public override function get_tabIndex():Int
	{
		return -1;
	}

	public override function set_tabIndex(value:Int):Int
	{
		throw new IllegalOperationError("Error: The Stage class does not implement this property or method.");
	}

	public override function set_transform(value:Transform):Transform
	{
		return this.transform;
	}

	public override function set_width(value:Float):Float
	{
		return this.width;
	}

	public override function set_x(value:Float):Float
	{
		return 0;
	}

	public override function set_y(value:Float):Float
	{
		return 0;
	}
}
