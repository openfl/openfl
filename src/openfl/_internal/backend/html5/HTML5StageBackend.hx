package openfl._internal.backend.html5;

#if openfl_html5
import js.html.DeviceMotionEvent in JSDeviceMotionEvent;
import js.html.Event in JSEvent;
import js.html.KeyboardEvent in JSKeyboardEvent;
import js.Browser;
import openfl._internal.backend.lime_standalone.KeyCode;
import openfl._internal.backend.lime_standalone.KeyModifier;
import openfl.display.DisplayObject;
import openfl.display.LoaderInfo;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.display.Stage;
import openfl.display.StageDisplayState;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;
import openfl.ui.KeyLocation;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.LoaderInfo)
@:access(openfl.display.Stage)
class HTML5StageBackend
{
	private var currentUpdate:Float;
	private var framePeriod:Int;
	private var lastUpdate:Float;
	private var macKeyboard:Bool;
	private var nextUpdate:Float;
	private var parent:Stage;

	public function new(parent:Stage, width:Dynamic = 0, height:Dynamic = 0, color:Null<Int> = null, documentClass:Class<Dynamic> = null,
			windowAttributes:Dynamic = null)
	{
		this.parent = parent;

		if (Lib.current == null)
		{
			Lib.current = new MovieClip();
		}

		if (Lib.current.__loaderInfo == null)
		{
			Lib.current.__loaderInfo = LoaderInfo.create(null);
			Lib.current.__loaderInfo.content = Lib.current;
		}

		// TODO: Workaround need to set reference here
		parent.__backend = this;

		var resizable = (width == 0 && width == 0);
		parent.element = Browser.document.createElement("div");

		if (resizable)
		{
			parent.element.style.width = "100%";
			parent.element.style.height = "100%";
		}

		macKeyboard = untyped __js__("/AppleWebKit/.test (navigator.userAgent) && /Mobile\\/\\w+/.test (navigator.userAgent) || /Mac/.test (navigator.platform)");

		currentUpdate = 0;
		lastUpdate = 0;
		nextUpdate = 0;
		framePeriod = -1;

		// TODO: Application, Gamepad, Mouse, Touch events

		Browser.window.addEventListener("keydown", window_onKeyDown, false);
		Browser.window.addEventListener("keyup", window_onKeyUp, false);
		Browser.window.addEventListener("focus", window_onFocus, false);
		Browser.window.addEventListener("blur", window_onBlur, false);
		Browser.window.addEventListener("resize", window_onResize, false);
		Browser.window.addEventListener("beforeunload", window_onBeforeUnload, false);
		Browser.window.addEventListener("devicemotion", window_onDeviceMotion, false);

		// #if stats
		// __stats = untyped __js__("new Stats ()");
		// __stats.domElement.style.position = "absolute";
		// __stats.domElement.style.top = "0px";
		// Browser.document.body.appendChild(__stats.domElement);
		// #end

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

		parent.color = color;

		parent.__contentsScaleFactor = 1;
		parent.__wasFullscreen = false;

		parent.__resize();

		if (Lib.current.stage == null)
		{
			parent.addChild(Lib.current);
		}

		if (documentClass != null)
		{
			DisplayObject.__initStage = parent;
			var sprite:Sprite = cast Type.createInstance(documentClass, []);
			// addChild (sprite); // done by init stage
			sprite.dispatchEvent(new Event(Event.ADDED_TO_STAGE, false, false));
		}

		window_onRequestAnimationFrame();
	}

	public function cancelRender():Void
	{
		// window.onRender.cancel();
	}

	private function convertBrowserKeyCode(keyCode:Int):KeyCode
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
		return 30;
		// return window.frameRate;
	}

	public function getFullScreenHeight():UInt
	{
		// return Math.ceil(window.display.currentMode.height * window.scale);
		return 0;
	}

	public function getFullScreenWidth():UInt
	{
		// return Math.ceil(window.display.currentMode.width * window.scale);
		return 0;
	}

	private function getKeyLocation(key:KeyCode):KeyLocation
	{
		return switch (key)
		{
			case KeyCode.LEFT_CTRL, KeyCode.LEFT_SHIFT, KeyCode.LEFT_ALT, KeyCode.LEFT_META: KeyLocation.LEFT;
			case KeyCode.RIGHT_CTRL, KeyCode.RIGHT_SHIFT, KeyCode.RIGHT_ALT, KeyCode.RIGHT_META: KeyLocation.RIGHT;
			case KeyCode.NUMPAD_DIVIDE, KeyCode.NUMPAD_MULTIPLY, KeyCode.NUMPAD_MINUS, KeyCode.NUMPAD_PLUS, KeyCode.NUMPAD_ENTER, KeyCode.NUMPAD_1,
				KeyCode.NUMPAD_2, KeyCode.NUMPAD_3, KeyCode.NUMPAD_4, KeyCode.NUMPAD_5, KeyCode.NUMPAD_6, KeyCode.NUMPAD_7, KeyCode.NUMPAD_8, KeyCode.NUMPAD_9,
				KeyCode.NUMPAD_0, KeyCode.NUMPAD_PERIOD, KeyCode.NUMPAD_DECIMAL:
				KeyLocation.NUM_PAD;
			default: KeyLocation.STANDARD;
		}
	}

	public function getWindowFullscreen():Bool
	{
		// return window.fullscreen;
		return false;
	}

	public function getWindowHeight():Int
	{
		// return Std.int(window.height * window.scale);
		return parent.stageHeight;
	}

	public function getWindowWidth():Int
	{
		// return Std.int(window.width * window.scale);
		return parent.stageWidth;
	}

	public function setFrameRate(value:Float):Void
	{
		// window.frameRate = value;
	}

	public function setDisplayState(value:StageDisplayState):Void
	{
		// if (parent.limeWindow != null)
		// {
		// 	switch (value)
		// 	{
		// 		case NORMAL:
		// 			if (parent.limeWindow.fullscreen)
		// 			{
		// 				parent.limeWindow.fullscreen = false;
		// 			}

		// 		default:
		// 			if (!parent.limeWindow.fullscreen)
		// 			{
		// 				parent.limeWindow.fullscreen = true;
		// 			}
		// 	}
		// }
	}

	// Event Handlers
	private function window_onBeforeUnload(event:JSEvent):Void {}

	private function window_onBlur(event:JSEvent):Void {}

	private function window_onDeviceMotion(event:JSDeviceMotionEvent):Void {}

	private function window_onFocus(event:JSEvent):Void {}

	private function window_onKeyDown(event:JSKeyboardEvent):Void
	{
		// TODO: Remove intermediate KeyCode/KeyModifier type?
		var keyCode = convertBrowserKeyCode(event.keyCode != null ? event.keyCode : event.which);
		var modifier:KeyModifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

		var keyLocation = getKeyLocation(keyCode);
		var keyCode = convertKeyCode(keyCode);
		var charCode = getCharCode(keyCode, modifier.shiftKey);

		var event = new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, charCode, keyCode, keyLocation,
			macKeyboard ? (modifier.ctrlKey || modifier.metaKey) : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

		if (parent.__onKey(event) && event.cancelable)
		{
			event.preventDefault();
		}
	}

	private function window_onKeyUp(event:JSKeyboardEvent):Void
	{
		// TODO: Remove intermediate KeyCode/KeyModifier type?
		var keyCode = convertBrowserKeyCode(event.keyCode != null ? event.keyCode : event.which);
		var modifier:KeyModifier = (event.shiftKey ? (KeyModifier.SHIFT) : 0) | (event.ctrlKey ? (KeyModifier.CTRL) : 0) | (event.altKey ? (KeyModifier.ALT) : 0) | (event.metaKey ? (KeyModifier.META) : 0);

		var keyLocation = getKeyLocation(keyCode);
		var keyCode = convertKeyCode(keyCode);
		var charCode = getCharCode(keyCode, modifier.shiftKey);

		var event = new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, charCode, keyCode, keyLocation,
			macKeyboard ? (modifier.ctrlKey || modifier.metaKey) : modifier.ctrlKey, modifier.altKey, modifier.shiftKey, modifier.ctrlKey, modifier.metaKey);

		if (parent.__onKey(event) && event.cancelable)
		{
			event.preventDefault();
		}
	}

	private function window_onRequestAnimationFrame(?__):Void
	{
		// for (window in parent.__windows)
		// {
		// 	window.__backend.updateSize();
		// }

		// updateGameDevices();

		currentUpdate = Date.now().getTime();

		if (currentUpdate >= nextUpdate)
		{
			// #if stats
			// stats.begin();
			// #end

			parent.__deltaTime = Std.int(currentUpdate - lastUpdate);
			parent.__dispatchPendingMouseEvent();
			parent.__render();

			// #if stats
			// stats.end();
			// #end

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

		Browser.window.requestAnimationFrame(cast window_onRequestAnimationFrame);
	}

	private function window_onResize(event:JSEvent):Void {}
}
#end
