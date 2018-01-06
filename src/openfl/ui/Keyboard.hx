package openfl.ui;


import lime.ui.KeyCode;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


@:final class Keyboard {
	
	
	public static inline var NUMBER_0 = 48;
	public static inline var NUMBER_1 = 49;
	public static inline var NUMBER_2 = 50;
	public static inline var NUMBER_3 = 51;
	public static inline var NUMBER_4 = 52;
	public static inline var NUMBER_5 = 53;
	public static inline var NUMBER_6 = 54;
	public static inline var NUMBER_7 = 55;
	public static inline var NUMBER_8 = 56; 
	public static inline var NUMBER_9 = 57;
	public static inline var A = 65;
	public static inline var B = 66;
	public static inline var C = 67;
	public static inline var D = 68;
	public static inline var E = 69;
	public static inline var F = 70;
	public static inline var G = 71;
	public static inline var H = 72;
	public static inline var I = 73;
	public static inline var J = 74;
	public static inline var K = 75;
	public static inline var L = 76;
	public static inline var M = 77;
	public static inline var N = 78;
	public static inline var O = 79;
	public static inline var P = 80;
	public static inline var Q = 81;
	public static inline var R = 82;
	public static inline var S = 83;
	public static inline var T = 84;
	public static inline var U = 85;
	public static inline var V = 86;
	public static inline var W = 87;
	public static inline var X = 88;
	public static inline var Y = 89;
	public static inline var Z = 90;
	public static inline var NUMPAD_0 = 96;
	public static inline var NUMPAD_1 = 97;
	public static inline var NUMPAD_2 = 98;
	public static inline var NUMPAD_3 = 99;
	public static inline var NUMPAD_4 = 100;
	public static inline var NUMPAD_5 = 101;
	public static inline var NUMPAD_6 = 102;
	public static inline var NUMPAD_7 = 103;
	public static inline var NUMPAD_8 = 104;
	public static inline var NUMPAD_9 = 105;
	public static inline var NUMPAD_MULTIPLY = 106;
	public static inline var NUMPAD_ADD = 107;
	public static inline var NUMPAD_ENTER = 108;
	public static inline var NUMPAD_SUBTRACT = 109;
	public static inline var NUMPAD_DECIMAL = 110;
	public static inline var NUMPAD_DIVIDE = 111;
	public static inline var F1 = 112;
	public static inline var F2 = 113;
	public static inline var F3 = 114;
	public static inline var F4 = 115;
	public static inline var F5 = 116;
	public static inline var F6 = 117;
	public static inline var F7 = 118;
	public static inline var F8 = 119;
	public static inline var F9 = 120;
	public static inline var F10 = 121; //  F10 is used by browser.
	public static inline var F11 = 122;
	public static inline var F12 = 123;
	public static inline var F13 = 124;
	public static inline var F14 = 125;
	public static inline var F15 = 126;
	public static inline var BACKSPACE = 8;
	public static inline var TAB = 9;
	public static inline var ALTERNATE = 18;
	public static inline var ENTER = 13;
	public static inline var COMMAND = 15;
	public static inline var SHIFT = 16;
	public static inline var CONTROL = 17;
	public static inline var BREAK = 19;
	public static inline var CAPS_LOCK = 20;
	public static inline var NUMPAD = 21;
	public static inline var ESCAPE = 27;
	public static inline var SPACE = 32;
	public static inline var PAGE_UP = 33;
	public static inline var PAGE_DOWN = 34;
	public static inline var END = 35;
	public static inline var HOME = 36;
	public static inline var LEFT = 37;
	public static inline var RIGHT = 39;
	public static inline var UP = 38;
	public static inline var DOWN = 40;
	public static inline var INSERT = 45;
	public static inline var DELETE = 46;
	public static inline var NUMLOCK = 144;
	public static inline var SEMICOLON = 186;
	public static inline var EQUAL = 187;
	public static inline var COMMA = 188;
	public static inline var MINUS = 189;
	public static inline var PERIOD = 190;
	public static inline var SLASH = 191;
	public static inline var BACKQUOTE = 192;
	public static inline var LEFTBRACKET = 219;
	public static inline var BACKSLASH = 220;
	public static inline var RIGHTBRACKET = 221;
	public static inline var QUOTE = 222;
	
	public static var capsLock (default, null):Bool;
	public static var numLock (default, null):Bool;
	
	
	public static function isAccessible ():Bool {
		
		// default browser security restrictions are always enforced
		return false;
		
	}
	
	
	private static inline function __convertKeyCode (key:KeyCode):Int {
		
		return switch (key) {
			
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
			//case KeyCode.PLUS: 0x2B;
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
			case KeyCode.NUMPAD_ENTER: Keyboard.NUMPAD_ENTER;
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
			//case KeyCode.POWER: 0x40000066;
			//case KeyCode.NUMPAD_EQUALS: 0x40000067;
			case KeyCode.F13: Keyboard.F13;
			case KeyCode.F14: Keyboard.F14;
			case KeyCode.F15: Keyboard.F15;
			//case KeyCode.F16: 0x4000006B;
			//case KeyCode.F17: 0x4000006C;
			//case KeyCode.F18: 0x4000006D;
			//case KeyCode.F19: 0x4000006E;
			//case KeyCode.F20: 0x4000006F;
			//case KeyCode.F21: 0x40000070;
			//case KeyCode.F22: 0x40000071;
			//case KeyCode.F23: 0x40000072;
			//case KeyCode.F24: 0x40000073;
			//case KeyCode.EXECUTE: 0x40000074;
			//case KeyCode.HELP: 0x40000075;
			//case KeyCode.MENU: 0x40000076;
			//case KeyCode.SELECT: 0x40000077;
			//case KeyCode.STOP: 0x40000078;
			//case KeyCode.AGAIN: 0x40000079;
			//case KeyCode.UNDO: 0x4000007A;
			//case KeyCode.CUT: 0x4000007B;
			//case KeyCode.COPY: 0x4000007C;
			//case KeyCode.PASTE: 0x4000007D;
			//case KeyCode.FIND: 0x4000007E;
			//case KeyCode.MUTE: 0x4000007F;
			//case KeyCode.VOLUME_UP: 0x40000080;
			//case KeyCode.VOLUME_DOWN: 0x40000081;
			//case KeyCode.NUMPAD_COMMA: 0x40000085;
			////case KeyCode.NUMPAD_EQUALS_AS400: 0x40000086;
			//case KeyCode.ALT_ERASE: 0x40000099;
			//case KeyCode.SYSTEM_REQUEST: 0x4000009A;
			//case KeyCode.CANCEL: 0x4000009B;
			//case KeyCode.CLEAR: 0x4000009C;
			//case KeyCode.PRIOR: 0x4000009D;
			case KeyCode.RETURN2: Keyboard.ENTER;
			//case KeyCode.SEPARATOR: 0x4000009F;
			//case KeyCode.OUT: 0x400000A0;
			//case KeyCode.OPER: 0x400000A1;
			//case KeyCode.CLEAR_AGAIN: 0x400000A2;
			//case KeyCode.CRSEL: 0x400000A3;
			//case KeyCode.EXSEL: 0x400000A4;
			//case KeyCode.NUMPAD_00: 0x400000B0;
			//case KeyCode.NUMPAD_000: 0x400000B1;
			//case KeyCode.THOUSAND_SEPARATOR: 0x400000B2;
			//case KeyCode.DECIMAL_SEPARATOR: 0x400000B3;
			//case KeyCode.CURRENCY_UNIT: 0x400000B4;
			//case KeyCode.CURRENCY_SUBUNIT: 0x400000B5;
			//case KeyCode.NUMPAD_LEFT_PARENTHESIS: 0x400000B6;
			//case KeyCode.NUMPAD_RIGHT_PARENTHESIS: 0x400000B7;
			//case KeyCode.NUMPAD_LEFT_BRACE: 0x400000B8;
			//case KeyCode.NUMPAD_RIGHT_BRACE: 0x400000B9;
			//case KeyCode.NUMPAD_TAB: 0x400000BA;
			//case KeyCode.NUMPAD_BACKSPACE: 0x400000BB;
			//case KeyCode.NUMPAD_A: 0x400000BC;
			//case KeyCode.NUMPAD_B: 0x400000BD;
			//case KeyCode.NUMPAD_C: 0x400000BE;
			//case KeyCode.NUMPAD_D: 0x400000BF;
			//case KeyCode.NUMPAD_E: 0x400000C0;
			//case KeyCode.NUMPAD_F: 0x400000C1;
			//case KeyCode.NUMPAD_XOR: 0x400000C2;
			//case KeyCode.NUMPAD_POWER: 0x400000C3;
			//case KeyCode.NUMPAD_PERCENT: 0x400000C4;
			//case KeyCode.NUMPAD_LESS_THAN: 0x400000C5;
			//case KeyCode.NUMPAD_GREATER_THAN: 0x400000C6;
			//case KeyCode.NUMPAD_AMPERSAND: 0x400000C7;
			//case KeyCode.NUMPAD_DOUBLE_AMPERSAND: 0x400000C8;
			//case KeyCode.NUMPAD_VERTICAL_BAR: 0x400000C9;
			//case KeyCode.NUMPAD_DOUBLE_VERTICAL_BAR: 0x400000CA;
			//case KeyCode.NUMPAD_COLON: 0x400000CB;
			//case KeyCode.NUMPAD_HASH: 0x400000CC;
			//case KeyCode.NUMPAD_SPACE: 0x400000CD;
			//case KeyCode.NUMPAD_AT: 0x400000CE;
			//case KeyCode.NUMPAD_EXCLAMATION: 0x400000CF;
			//case KeyCode.NUMPAD_MEM_STORE: 0x400000D0;
			//case KeyCode.NUMPAD_MEM_RECALL: 0x400000D1;
			//case KeyCode.NUMPAD_MEM_CLEAR: 0x400000D2;
			//case KeyCode.NUMPAD_MEM_ADD: 0x400000D3;
			//case KeyCode.NUMPAD_MEM_SUBTRACT: 0x400000D4;
			//case KeyCode.NUMPAD_MEM_MULTIPLY: 0x400000D5;
			//case KeyCode.NUMPAD_MEM_DIVIDE: 0x400000D6;
			//case KeyCode.NUMPAD_PLUS_MINUS: 0x400000D7;
			//case KeyCode.NUMPAD_CLEAR: 0x400000D8;
			//case KeyCode.NUMPAD_CLEAR_ENTRY: 0x400000D9;
			//case KeyCode.NUMPAD_BINARY: 0x400000DA;
			//case KeyCode.NUMPAD_OCTAL: 0x400000DB;
			case KeyCode.NUMPAD_DECIMAL: Keyboard.NUMPAD_DECIMAL;
			//case KeyCode.NUMPAD_HEXADECIMAL: 0x400000DD;
			case KeyCode.LEFT_CTRL: Keyboard.CONTROL;
			case KeyCode.LEFT_SHIFT: Keyboard.SHIFT;
			case KeyCode.LEFT_ALT: Keyboard.ALTERNATE;
			case KeyCode.LEFT_META: Keyboard.COMMAND;
			case KeyCode.RIGHT_CTRL: Keyboard.CONTROL;
			case KeyCode.RIGHT_SHIFT: Keyboard.SHIFT;
			case KeyCode.RIGHT_ALT: Keyboard.ALTERNATE;
			case KeyCode.RIGHT_META: Keyboard.COMMAND;
			//case KeyCode.MODE: 0x40000101;
			//case KeyCode.AUDIO_NEXT: 0x40000102;
			//case KeyCode.AUDIO_PREVIOUS: 0x40000103;
			//case KeyCode.AUDIO_STOP: 0x40000104;
			//case KeyCode.AUDIO_PLAY: 0x40000105;
			//case KeyCode.AUDIO_MUTE: 0x40000106;
			//case KeyCode.MEDIA_SELECT: 0x40000107;
			//case KeyCode.WWW: 0x40000108;
			//case KeyCode.MAIL: 0x40000109;
			//case KeyCode.CALCULATOR: 0x4000010A;
			//case KeyCode.COMPUTER: 0x4000010B;
			//case KeyCode.APP_CONTROL_SEARCH: 0x4000010C;
			//case KeyCode.APP_CONTROL_HOME: 0x4000010D;
			//case KeyCode.APP_CONTROL_BACK: 0x4000010E;
			//case KeyCode.APP_CONTROL_FORWARD: 0x4000010F;
			//case KeyCode.APP_CONTROL_STOP: 0x40000110;
			//case KeyCode.APP_CONTROL_REFRESH: 0x40000111;
			//case KeyCode.APP_CONTROL_BOOKMARKS: 0x40000112;
			//case KeyCode.BRIGHTNESS_DOWN: 0x40000113;
			//case KeyCode.BRIGHTNESS_UP: 0x40000114;
			//case KeyCode.DISPLAY_SWITCH: 0x40000115;
			//case KeyCode.BACKLIGHT_TOGGLE: 0x40000116;
			//case KeyCode.BACKLIGHT_DOWN: 0x40000117;
			//case KeyCode.BACKLIGHT_UP: 0x40000118;
			//case KeyCode.EJECT: 0x40000119;
			//case KeyCode.SLEEP: 0x4000011A;
			default: cast key;
			
		}
		
	}
	
	
	private static function __getCharCode (key:Int, shift:Bool = false):Int {
		
		if (!shift) {
			
			switch (key) {
				
				case Keyboard.BACKSPACE: return 8;
				case Keyboard.TAB: return 9;
				case Keyboard.ENTER: return 13;
				case Keyboard.ESCAPE: return 27;
				case Keyboard.SPACE: return 32;
				case Keyboard.SEMICOLON: return 59;
				case Keyboard.EQUAL: return 61;
				case Keyboard.COMMA: return 44;
				case Keyboard.MINUS: return 45;
				case Keyboard.PERIOD: return 46;
				case Keyboard.SLASH: return 47;
				case Keyboard.BACKQUOTE: return 96;
				case Keyboard.LEFTBRACKET: return 91;
				case Keyboard.BACKSLASH: return 92;
				case Keyboard.RIGHTBRACKET: return 93;
				case Keyboard.QUOTE: return 39;
				
			}
			
			if (key >= Keyboard.NUMBER_0 && key <= Keyboard.NUMBER_9) {
				
				return key - Keyboard.NUMBER_0 + 48;
				
			}
			
			if (key >= Keyboard.A && key <= Keyboard.Z) {
				
				return key - Keyboard.A + 97;
				
			}
			
		} else {
			
			switch (key) {
				
				case Keyboard.NUMBER_0: return 41;
				case Keyboard.NUMBER_1: return 33;
				case Keyboard.NUMBER_2: return 64;
				case Keyboard.NUMBER_3: return 35;
				case Keyboard.NUMBER_4: return 36;
				case Keyboard.NUMBER_5: return 37;
				case Keyboard.NUMBER_6: return 94;
				case Keyboard.NUMBER_7: return 38;
				case Keyboard.NUMBER_8: return 42;
				case Keyboard.NUMBER_9: return 40;
				case Keyboard.SEMICOLON: return 58;
				case Keyboard.EQUAL: return 43;
				case Keyboard.COMMA: return 60;
				case Keyboard.MINUS: return 95;
				case Keyboard.PERIOD: return 62;
				case Keyboard.SLASH: return 63;
				case Keyboard.BACKQUOTE: return 126;
				case Keyboard.LEFTBRACKET: return 123;
				case Keyboard.BACKSLASH: return 124;
				case Keyboard.RIGHTBRACKET: return 125;
				case Keyboard.QUOTE: return 34;
				
			}
			
			if (key >= Keyboard.A && key <= Keyboard.Z) {
				
				return key - Keyboard.A + 65;
				
			}
			
		}
		
		if (key >= Keyboard.NUMPAD_0 && key <= Keyboard.NUMPAD_9) {
			
			return key - Keyboard.NUMPAD_0 + 48;
			
		}
		
		switch (key) {
			
			case Keyboard.NUMPAD_MULTIPLY: return 42;
			case Keyboard.NUMPAD_ADD: return 43;
			case Keyboard.NUMPAD_ENTER: return 44;
			case Keyboard.NUMPAD_DECIMAL: return 45;
			case Keyboard.NUMPAD_DIVIDE: return 46;
			case Keyboard.DELETE: return 127;
			case Keyboard.ENTER: return 13;
			case Keyboard.BACKSPACE: return 8;
			
		}
		
		return 0;
		
	}
	
	
	private static inline function __getKeyLocation (key:KeyCode):KeyLocation {
		
		return switch (key) {
			
			case KeyCode.LEFT_CTRL, KeyCode.LEFT_SHIFT, KeyCode.LEFT_ALT, KeyCode.LEFT_META: KeyLocation.LEFT;
			case KeyCode.RIGHT_CTRL, KeyCode.RIGHT_SHIFT, KeyCode.RIGHT_ALT, KeyCode.RIGHT_META: KeyLocation.RIGHT;
			case KeyCode.NUMPAD_DIVIDE, KeyCode.NUMPAD_MULTIPLY, KeyCode.NUMPAD_MINUS, KeyCode.NUMPAD_PLUS, KeyCode.NUMPAD_ENTER,
				KeyCode.NUMPAD_1, KeyCode.NUMPAD_2, KeyCode.NUMPAD_3, KeyCode.NUMPAD_4, KeyCode.NUMPAD_5, KeyCode.NUMPAD_6,
				KeyCode.NUMPAD_7, KeyCode.NUMPAD_8, KeyCode.NUMPAD_9, KeyCode.NUMPAD_0, KeyCode.NUMPAD_PERIOD, KeyCode.NUMPAD_DECIMAL:
					KeyLocation.NUM_PAD;
			default: KeyLocation.STANDARD;
			
		}
		
	}
	
	
}