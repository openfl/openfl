package openfl.ui; #if (!openfl_legacy || lime_hybrid)


import lime.ui.KeyCode;


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
			
			case BACKSPACE: Keyboard.BACKSPACE;
			case TAB: Keyboard.TAB;
			case RETURN: Keyboard.ENTER;
			case ESCAPE: Keyboard.ESCAPE;
			case SPACE: Keyboard.SPACE;
			case EXCLAMATION: Keyboard.NUMBER_1;
			case QUOTE: Keyboard.QUOTE;
			case HASH: Keyboard.NUMBER_3;
			case DOLLAR: Keyboard.NUMBER_4;
			case PERCENT: Keyboard.NUMBER_5;
			case AMPERSAND: Keyboard.NUMBER_7;
			case SINGLE_QUOTE: Keyboard.QUOTE;
			case LEFT_PARENTHESIS: Keyboard.NUMBER_9;
			case RIGHT_PARENTHESIS: Keyboard.NUMBER_0;
			case ASTERISK: Keyboard.NUMBER_8;
			//case PLUS: 0x2B;
			case COMMA: Keyboard.COMMA;
			case MINUS: Keyboard.MINUS;
			case PERIOD: Keyboard.PERIOD;
			case SLASH: Keyboard.SLASH;
			case NUMBER_0: Keyboard.NUMBER_0;
			case NUMBER_1: Keyboard.NUMBER_1;
			case NUMBER_2: Keyboard.NUMBER_2;
			case NUMBER_3: Keyboard.NUMBER_3;
			case NUMBER_4: Keyboard.NUMBER_4;
			case NUMBER_5: Keyboard.NUMBER_5;
			case NUMBER_6: Keyboard.NUMBER_6;
			case NUMBER_7: Keyboard.NUMBER_7;
			case NUMBER_8: Keyboard.NUMBER_8;
			case NUMBER_9: Keyboard.NUMBER_9;
			case COLON: Keyboard.SEMICOLON;
			case SEMICOLON: Keyboard.SEMICOLON;
			case LESS_THAN: 60;
			case EQUALS: Keyboard.EQUAL;
			case GREATER_THAN: Keyboard.PERIOD;
			case QUESTION: Keyboard.SLASH;
			case AT: Keyboard.NUMBER_2;
			case LEFT_BRACKET: Keyboard.LEFTBRACKET;
			case BACKSLASH: Keyboard.BACKSLASH;
			case RIGHT_BRACKET: Keyboard.RIGHTBRACKET;
			case CARET: Keyboard.NUMBER_6;
			case UNDERSCORE: Keyboard.MINUS;
			case GRAVE: Keyboard.BACKQUOTE;
			case A: Keyboard.A;
			case B: Keyboard.B;
			case C: Keyboard.C;
			case D: Keyboard.D;
			case E: Keyboard.E;
			case F: Keyboard.F;
			case G: Keyboard.G;
			case H: Keyboard.H;
			case I: Keyboard.I;
			case J: Keyboard.J;
			case K: Keyboard.K;
			case L: Keyboard.L;
			case M: Keyboard.M;
			case N: Keyboard.N;
			case O: Keyboard.O;
			case P: Keyboard.P;
			case Q: Keyboard.Q;
			case R: Keyboard.R;
			case S: Keyboard.S;
			case T: Keyboard.T;
			case U: Keyboard.U;
			case V: Keyboard.V;
			case W: Keyboard.W;
			case X: Keyboard.X;
			case Y: Keyboard.Y;
			case Z: Keyboard.Z;
			case DELETE: Keyboard.DELETE;
			case CAPS_LOCK: Keyboard.CAPS_LOCK;
			case F1: Keyboard.F1;
			case F2: Keyboard.F2;
			case F3: Keyboard.F3;
			case F4: Keyboard.F4;
			case F5: Keyboard.F5;
			case F6: Keyboard.F6;
			case F7: Keyboard.F7;
			case F8: Keyboard.F8;
			case F9: Keyboard.F9;
			case F10: Keyboard.F10;
			case F11: Keyboard.F11;
			case F12: Keyboard.F12;
			case PRINT_SCREEN: 301;
			case SCROLL_LOCK: 145;
			case PAUSE: Keyboard.BREAK;
			case INSERT: Keyboard.INSERT;
			case HOME: Keyboard.HOME;
			case PAGE_UP: Keyboard.PAGE_UP;
			case END: Keyboard.END;
			case PAGE_DOWN: Keyboard.PAGE_DOWN;
			case RIGHT: Keyboard.RIGHT;
			case LEFT: Keyboard.LEFT;
			case DOWN: Keyboard.DOWN;
			case UP: Keyboard.UP;
			case NUM_LOCK: Keyboard.NUMLOCK;
			case NUMPAD_DIVIDE: Keyboard.NUMPAD_DIVIDE;
			case NUMPAD_MULTIPLY: Keyboard.NUMPAD_MULTIPLY;
			case NUMPAD_MINUS: Keyboard.NUMPAD_SUBTRACT;
			case NUMPAD_PLUS: Keyboard.NUMPAD_ADD;
			case NUMPAD_ENTER: Keyboard.NUMPAD_ENTER;
			case NUMPAD_1: Keyboard.NUMPAD_1;
			case NUMPAD_2: Keyboard.NUMPAD_2;
			case NUMPAD_3: Keyboard.NUMPAD_3;
			case NUMPAD_4: Keyboard.NUMPAD_4;
			case NUMPAD_5: Keyboard.NUMPAD_5;
			case NUMPAD_6: Keyboard.NUMPAD_6;
			case NUMPAD_7: Keyboard.NUMPAD_7;
			case NUMPAD_8: Keyboard.NUMPAD_8;
			case NUMPAD_9: Keyboard.NUMPAD_9;
			case NUMPAD_0: Keyboard.NUMPAD_0;
			case NUMPAD_PERIOD: Keyboard.NUMPAD_DECIMAL;
			case APPLICATION: 302;
			//case POWER: 0x40000066;
			//case NUMPAD_EQUALS: 0x40000067;
			case F13: Keyboard.F13;
			case F14: Keyboard.F14;
			case F15: Keyboard.F15;
			//case F16: 0x4000006B;
			//case F17: 0x4000006C;
			//case F18: 0x4000006D;
			//case F19: 0x4000006E;
			//case F20: 0x4000006F;
			//case F21: 0x40000070;
			//case F22: 0x40000071;
			//case F23: 0x40000072;
			//case F24: 0x40000073;
			//case EXECUTE: 0x40000074;
			//case HELP: 0x40000075;
			//case MENU: 0x40000076;
			//case SELECT: 0x40000077;
			//case STOP: 0x40000078;
			//case AGAIN: 0x40000079;
			//case UNDO: 0x4000007A;
			//case CUT: 0x4000007B;
			//case COPY: 0x4000007C;
			//case PASTE: 0x4000007D;
			//case FIND: 0x4000007E;
			//case MUTE: 0x4000007F;
			//case VOLUME_UP: 0x40000080;
			//case VOLUME_DOWN: 0x40000081;
			//case NUMPAD_COMMA: 0x40000085;
			////case NUMPAD_EQUALS_AS400: 0x40000086;
			//case ALT_ERASE: 0x40000099;
			//case SYSTEM_REQUEST: 0x4000009A;
			//case CANCEL: 0x4000009B;
			//case CLEAR: 0x4000009C;
			//case PRIOR: 0x4000009D;
			case RETURN2: Keyboard.ENTER;
			//case SEPARATOR: 0x4000009F;
			//case OUT: 0x400000A0;
			//case OPER: 0x400000A1;
			//case CLEAR_AGAIN: 0x400000A2;
			//case CRSEL: 0x400000A3;
			//case EXSEL: 0x400000A4;
			//case NUMPAD_00: 0x400000B0;
			//case NUMPAD_000: 0x400000B1;
			//case THOUSAND_SEPARATOR: 0x400000B2;
			//case DECIMAL_SEPARATOR: 0x400000B3;
			//case CURRENCY_UNIT: 0x400000B4;
			//case CURRENCY_SUBUNIT: 0x400000B5;
			//case NUMPAD_LEFT_PARENTHESIS: 0x400000B6;
			//case NUMPAD_RIGHT_PARENTHESIS: 0x400000B7;
			//case NUMPAD_LEFT_BRACE: 0x400000B8;
			//case NUMPAD_RIGHT_BRACE: 0x400000B9;
			//case NUMPAD_TAB: 0x400000BA;
			//case NUMPAD_BACKSPACE: 0x400000BB;
			//case NUMPAD_A: 0x400000BC;
			//case NUMPAD_B: 0x400000BD;
			//case NUMPAD_C: 0x400000BE;
			//case NUMPAD_D: 0x400000BF;
			//case NUMPAD_E: 0x400000C0;
			//case NUMPAD_F: 0x400000C1;
			//case NUMPAD_XOR: 0x400000C2;
			//case NUMPAD_POWER: 0x400000C3;
			//case NUMPAD_PERCENT: 0x400000C4;
			//case NUMPAD_LESS_THAN: 0x400000C5;
			//case NUMPAD_GREATER_THAN: 0x400000C6;
			//case NUMPAD_AMPERSAND: 0x400000C7;
			//case NUMPAD_DOUBLE_AMPERSAND: 0x400000C8;
			//case NUMPAD_VERTICAL_BAR: 0x400000C9;
			//case NUMPAD_DOUBLE_VERTICAL_BAR: 0x400000CA;
			//case NUMPAD_COLON: 0x400000CB;
			//case NUMPAD_HASH: 0x400000CC;
			//case NUMPAD_SPACE: 0x400000CD;
			//case NUMPAD_AT: 0x400000CE;
			//case NUMPAD_EXCLAMATION: 0x400000CF;
			//case NUMPAD_MEM_STORE: 0x400000D0;
			//case NUMPAD_MEM_RECALL: 0x400000D1;
			//case NUMPAD_MEM_CLEAR: 0x400000D2;
			//case NUMPAD_MEM_ADD: 0x400000D3;
			//case NUMPAD_MEM_SUBTRACT: 0x400000D4;
			//case NUMPAD_MEM_MULTIPLY: 0x400000D5;
			//case NUMPAD_MEM_DIVIDE: 0x400000D6;
			//case NUMPAD_PLUS_MINUS: 0x400000D7;
			//case NUMPAD_CLEAR: 0x400000D8;
			//case NUMPAD_CLEAR_ENTRY: 0x400000D9;
			//case NUMPAD_BINARY: 0x400000DA;
			//case NUMPAD_OCTAL: 0x400000DB;
			case NUMPAD_DECIMAL: Keyboard.NUMPAD_DECIMAL;
			//case NUMPAD_HEXADECIMAL: 0x400000DD;
			case LEFT_CTRL: Keyboard.CONTROL;
			case LEFT_SHIFT: Keyboard.SHIFT;
			case LEFT_ALT: Keyboard.ALTERNATE;
			case LEFT_META: Keyboard.COMMAND;
			case RIGHT_CTRL: Keyboard.CONTROL;
			case RIGHT_SHIFT: Keyboard.SHIFT;
			case RIGHT_ALT: Keyboard.ALTERNATE;
			case RIGHT_META: Keyboard.COMMAND;
			//case MODE: 0x40000101;
			//case AUDIO_NEXT: 0x40000102;
			//case AUDIO_PREVIOUS: 0x40000103;
			//case AUDIO_STOP: 0x40000104;
			//case AUDIO_PLAY: 0x40000105;
			//case AUDIO_MUTE: 0x40000106;
			//case MEDIA_SELECT: 0x40000107;
			//case WWW: 0x40000108;
			//case MAIL: 0x40000109;
			//case CALCULATOR: 0x4000010A;
			//case COMPUTER: 0x4000010B;
			//case APP_CONTROL_SEARCH: 0x4000010C;
			//case APP_CONTROL_HOME: 0x4000010D;
			//case APP_CONTROL_BACK: 0x4000010E;
			//case APP_CONTROL_FORWARD: 0x4000010F;
			//case APP_CONTROL_STOP: 0x40000110;
			//case APP_CONTROL_REFRESH: 0x40000111;
			//case APP_CONTROL_BOOKMARKS: 0x40000112;
			//case BRIGHTNESS_DOWN: 0x40000113;
			//case BRIGHTNESS_UP: 0x40000114;
			//case DISPLAY_SWITCH: 0x40000115;
			//case BACKLIGHT_TOGGLE: 0x40000116;
			//case BACKLIGHT_DOWN: 0x40000117;
			//case BACKLIGHT_UP: 0x40000118;
			//case EJECT: 0x40000119;
			//case SLEEP: 0x4000011A;
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
			
			case LEFT_CTRL, LEFT_SHIFT, LEFT_ALT, LEFT_META: KeyLocation.LEFT;
			case RIGHT_CTRL, RIGHT_SHIFT, RIGHT_ALT, RIGHT_META: KeyLocation.RIGHT;
			case NUMPAD_DIVIDE, NUMPAD_MULTIPLY, NUMPAD_MINUS, NUMPAD_PLUS, NUMPAD_ENTER, NUMPAD_1, NUMPAD_2, NUMPAD_3, NUMPAD_4, NUMPAD_5, NUMPAD_6, NUMPAD_7, NUMPAD_8, NUMPAD_9, NUMPAD_0, NUMPAD_PERIOD, NUMPAD_DECIMAL: KeyLocation.NUM_PAD;
			default: KeyLocation.STANDARD;
			
		}
		
	}
	
	
}


#else
typedef Keyboard = openfl._legacy.ui.Keyboard;
#end