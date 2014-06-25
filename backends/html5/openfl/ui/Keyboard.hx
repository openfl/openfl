package openfl.ui;


class Keyboard {
	
	
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
	public static inline var BREAK = 19;
	
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
	
	// Mozilla keyCodes
	// reference: https://developer.mozilla.org/en/DOM/Event/UIEvent/KeyEvent
	public static inline var DOM_VK_CANCEL = 3;
	public static inline var DOM_VK_HELP = 6;
	public static inline var DOM_VK_BACK_SPACE = 8;
	public static inline var DOM_VK_TAB = 9;
	public static inline var DOM_VK_CLEAR = 12;
	public static inline var DOM_VK_RETURN = 13;
	public static inline var DOM_VK_ENTER = 14;
	public static inline var DOM_VK_SHIFT = 16;
	public static inline var DOM_VK_CONTROL = 17;
	public static inline var DOM_VK_ALT = 18;
	public static inline var DOM_VK_PAUSE = 19;
	public static inline var DOM_VK_CAPS_LOCK = 20;
	public static inline var DOM_VK_ESCAPE = 27;
	public static inline var DOM_VK_SPACE = 32;
	public static inline var DOM_VK_PAGE_UP = 33;
	public static inline var DOM_VK_PAGE_DOWN = 34;
	public static inline var DOM_VK_END = 35;
	public static inline var DOM_VK_HOME = 36;
	public static inline var DOM_VK_LEFT = 37;
	public static inline var DOM_VK_UP = 38;
	public static inline var DOM_VK_RIGHT = 39;
	public static inline var DOM_VK_DOWN = 40;
	public static inline var DOM_VK_PRINTSCREEN = 44;
	public static inline var DOM_VK_INSERT = 45;
	public static inline var DOM_VK_DELETE = 46;
	public static inline var DOM_VK_0 = 48;
	public static inline var DOM_VK_1 = 49;
	public static inline var DOM_VK_2 = 50;
	public static inline var DOM_VK_3 = 51;
	public static inline var DOM_VK_4 = 52;
	public static inline var DOM_VK_5 = 53;
	public static inline var DOM_VK_6 = 54;
	public static inline var DOM_VK_7 = 55;
	public static inline var DOM_VK_8 = 56;
	public static inline var DOM_VK_9 = 57;
	public static inline var DOM_VK_SEMICOLON = 59;
	public static inline var DOM_VK_EQUALS = 61;
	public static inline var DOM_VK_A = 65;
	public static inline var DOM_VK_B = 66;
	public static inline var DOM_VK_C = 67;
	public static inline var DOM_VK_D = 68;
	public static inline var DOM_VK_E = 69;
	public static inline var DOM_VK_F = 70;
	public static inline var DOM_VK_G = 71;
	public static inline var DOM_VK_H = 72;
	public static inline var DOM_VK_I = 73;
	public static inline var DOM_VK_J = 74;
	public static inline var DOM_VK_K = 75;
	public static inline var DOM_VK_L = 76;
	public static inline var DOM_VK_M = 77;
	public static inline var DOM_VK_N = 78;
	public static inline var DOM_VK_O = 79;
	public static inline var DOM_VK_P = 80;
	public static inline var DOM_VK_Q = 81;
	public static inline var DOM_VK_R = 82;
	public static inline var DOM_VK_S = 83;
	public static inline var DOM_VK_T = 84;
	public static inline var DOM_VK_U = 85;
	public static inline var DOM_VK_V = 86;
	public static inline var DOM_VK_W = 87;
	public static inline var DOM_VK_X = 88;
	public static inline var DOM_VK_Y = 89;
	public static inline var DOM_VK_Z = 90;
	public static inline var DOM_VK_CONTEXT_MENU = 93;
	public static inline var DOM_VK_NUMPAD0 = 96;
	public static inline var DOM_VK_NUMPAD1 = 97;
	public static inline var DOM_VK_NUMPAD2 = 98;
	public static inline var DOM_VK_NUMPAD3 = 99;
	public static inline var DOM_VK_NUMPAD4 = 100;
	public static inline var DOM_VK_NUMPAD5 = 101;
	public static inline var DOM_VK_NUMPAD6 = 102;
	public static inline var DOM_VK_NUMPAD7 = 103;
	public static inline var DOM_VK_NUMPAD8 = 104;
	public static inline var DOM_VK_NUMPAD9 = 105;
	public static inline var DOM_VK_MULTIPLY = 106;
	public static inline var DOM_VK_ADD = 107;
	public static inline var DOM_VK_SEPARATOR = 108;
	public static inline var DOM_VK_SUBTRACT = 109;
	public static inline var DOM_VK_DECIMAL = 110;
	public static inline var DOM_VK_DIVIDE = 111;
	public static inline var DOM_VK_F1 = 112;
	public static inline var DOM_VK_F2 = 113;
	public static inline var DOM_VK_F3 = 114;
	public static inline var DOM_VK_F4 = 115;
	public static inline var DOM_VK_F5 = 116;
	public static inline var DOM_VK_F6 = 117;
	public static inline var DOM_VK_F7 = 118;
	public static inline var DOM_VK_F8 = 119;
	public static inline var DOM_VK_F9 = 120;
	public static inline var DOM_VK_F10 = 121;
	public static inline var DOM_VK_F11 = 122;
	public static inline var DOM_VK_F12 = 123;
	public static inline var DOM_VK_F13 = 124;
	public static inline var DOM_VK_F14 = 125;
	public static inline var DOM_VK_F15 = 126;
	public static inline var DOM_VK_F16 = 127;
	public static inline var DOM_VK_F17 = 128;
	public static inline var DOM_VK_F18 = 129;
	public static inline var DOM_VK_F19 = 130;
	public static inline var DOM_VK_F20 = 131;
	public static inline var DOM_VK_F21 = 132;
	public static inline var DOM_VK_F22 = 133;
	public static inline var DOM_VK_F23 = 134;
	public static inline var DOM_VK_F24 = 135;
	public static inline var DOM_VK_NUM_LOCK = 144;
	public static inline var DOM_VK_SCROLL_LOCK = 145;
	public static inline var DOM_VK_COMMA = 188;
	public static inline var DOM_VK_PERIOD = 190;
	public static inline var DOM_VK_SLASH = 191;
	public static inline var DOM_VK_BACK_QUOTE = 192;
	public static inline var DOM_VK_OPEN_BRACKET = 219;
	public static inline var DOM_VK_BACK_SLASH = 220;
	public static inline var DOM_VK_CLOSE_BRACKET = 221;
	public static inline var DOM_VK_QUOTE = 222;
	public static inline var DOM_VK_META = 224;
	
	public static inline var DOM_VK_KANA = 21;
	public static inline var DOM_VK_HANGUL = 21;
	public static inline var DOM_VK_JUNJA = 23;
	public static inline var DOM_VK_FINAL = 24;
	public static inline var DOM_VK_HANJA = 25;
	public static inline var DOM_VK_KANJI = 25;
	public static inline var DOM_VK_CONVERT = 28;
	public static inline var DOM_VK_NONCONVERT = 29;
	public static inline var DOM_VK_ACEPT = 30;
	public static inline var DOM_VK_MODECHANGE = 31;
	public static inline var DOM_VK_SELECT = 41;
	public static inline var DOM_VK_PRINT = 42;
	public static inline var DOM_VK_EXECUTE = 43;
	public static inline var DOM_VK_SLEEP = 95;
	
	public static var capsLock (default, null):Bool;
	public static var numLock (default, null):Bool;
	
	
	public static function isAccessible ():Bool {
		
		// default browser security restrictions are always enforced
		return false;
		
	}
	
	
	public static function __convertMozillaCode (code:Int):Int {
		
		switch (code) {
			
			case DOM_VK_BACK_SPACE: return BACKSPACE;
			case DOM_VK_TAB: return TAB;
			case DOM_VK_RETURN: return ENTER;
			case DOM_VK_ENTER: return ENTER;
			case DOM_VK_SHIFT: return SHIFT;
			case DOM_VK_CONTROL: return CONTROL;
			case DOM_VK_CAPS_LOCK: return CAPS_LOCK;
			case DOM_VK_ESCAPE: return ESCAPE;
			case DOM_VK_SPACE: return SPACE;
			case DOM_VK_PAGE_UP: return PAGE_UP;
			case DOM_VK_PAGE_DOWN: return PAGE_DOWN;
			case DOM_VK_END: return END;
			case DOM_VK_HOME: return HOME;
			case DOM_VK_LEFT: return LEFT;
			case DOM_VK_RIGHT: return RIGHT;
			case DOM_VK_UP: return UP;
			case DOM_VK_DOWN: return DOWN;
			case DOM_VK_INSERT: return INSERT;
			case DOM_VK_DELETE: return DELETE;
			case DOM_VK_NUM_LOCK: return NUMLOCK;
			default: return code;
			
		}
		
	}

	static public function __getCharCode(keyCode : Int, shift:Bool) : Int
	{
	    if (!shift)
	    {
	        switch(keyCode)
	        {
			case A: return "a".charCodeAt(0);
			case B: return "b".charCodeAt(0);
			case C: return "c".charCodeAt(0);
			case D: return "d".charCodeAt(0);
			case E: return "e".charCodeAt(0);
			case F: return "f".charCodeAt(0);
			case G: return "g".charCodeAt(0);
			case H: return "h".charCodeAt(0);
			case I: return "i".charCodeAt(0);
			case J: return "j".charCodeAt(0);
			case K: return "k".charCodeAt(0);
			case L: return "l".charCodeAt(0);
			case M: return "m".charCodeAt(0);
			case N: return "n".charCodeAt(0);
			case O: return "o".charCodeAt(0);
			case P: return "p".charCodeAt(0);
			case Q: return "q".charCodeAt(0);
			case R: return "r".charCodeAt(0);
			case S: return "s".charCodeAt(0);
			case T: return "t".charCodeAt(0);
			case U: return "u".charCodeAt(0);
			case V: return "v".charCodeAt(0);
			case W: return "w".charCodeAt(0);
			case X: return "x".charCodeAt(0);
			case Y: return "y".charCodeAt(0);
			case Z: return "z".charCodeAt(0);

			case NUMBER_0: return "0".charCodeAt(0);
			case NUMBER_1: return "1".charCodeAt(0);
			case NUMBER_2: return "2".charCodeAt(0);
			case NUMBER_3: return "3".charCodeAt(0);
			case NUMBER_4: return "4".charCodeAt(0);
			case NUMBER_5: return "5".charCodeAt(0);
			case NUMBER_6: return "6".charCodeAt(0);
			case NUMBER_7: return "7".charCodeAt(0);
			case NUMBER_8: return "8".charCodeAt(0);
			case NUMBER_9: return "9".charCodeAt(0);

			case 192: return "`".charCodeAt(0);
			case 189: return "-".charCodeAt(0);
			case 187: return "=".charCodeAt(0);
			case 219: return "[".charCodeAt(0);
			case 221: return "]".charCodeAt(0);
			case 186: return ";".charCodeAt(0);
			case 222: return "'".charCodeAt(0);
			case 188: return ",".charCodeAt(0);
			case 190: return ".".charCodeAt(0);
			case 191: return "/".charCodeAt(0);
			case 220: return "\\".charCodeAt(0);
                
		    }
		}
		else
		{
			switch(keyCode)
			{
				case A: return "A".charCodeAt(0);
				case B: return "B".charCodeAt(0);
				case C: return "C".charCodeAt(0);
				case D: return "D".charCodeAt(0);
				case E: return "E".charCodeAt(0);
				case F: return "F".charCodeAt(0);
				case G: return "G".charCodeAt(0);
				case H: return "H".charCodeAt(0);
				case I: return "I".charCodeAt(0);
				case J: return "J".charCodeAt(0);
				case K: return "K".charCodeAt(0);
				case L: return "L".charCodeAt(0);
				case M: return "M".charCodeAt(0);
				case N: return "N".charCodeAt(0);
				case O: return "O".charCodeAt(0);
				case P: return "P".charCodeAt(0);
				case Q: return "Q".charCodeAt(0);
				case R: return "R".charCodeAt(0);
				case S: return "S".charCodeAt(0);
				case T: return "T".charCodeAt(0);
				case U: return "U".charCodeAt(0);
				case V: return "V".charCodeAt(0);
				case W: return "W".charCodeAt(0);
				case X: return "X".charCodeAt(0);
				case Y: return "Y".charCodeAt(0);
				case Z: return "Z".charCodeAt(0);

				case NUMBER_0: return ")".charCodeAt(0);
				case NUMBER_1: return "!".charCodeAt(0);
				case NUMBER_2: return "@".charCodeAt(0);
				case NUMBER_3: return "#".charCodeAt(0);
				case NUMBER_4: return "$".charCodeAt(0);
				case NUMBER_5: return "%".charCodeAt(0);
				case NUMBER_6: return "^".charCodeAt(0);
				case NUMBER_7: return "&".charCodeAt(0);
				case NUMBER_8: return "*".charCodeAt(0);
				case NUMBER_9: return "(".charCodeAt(0);

				case 192: return "~".charCodeAt(0);
				case 189: return "_".charCodeAt(0);
				case 187: return "+".charCodeAt(0);
				case 219: return "{".charCodeAt(0);
				case 221: return "}".charCodeAt(0);
				case 186: return ":".charCodeAt(0);
				case 222: return "\"".charCodeAt(0);
				case 188: return "<".charCodeAt(0);
				case 190: return ">".charCodeAt(0);
				case 191: return "?".charCodeAt(0);
				case 220: return "|".charCodeAt(0);
		    }        
		}
		
		#if debug
			trace("jeashGetCharCode: unknown code: "+ keyCode);
		#end
		
		return keyCode;
	}
	
	public static function __convertWebkitCode (code:String):Int {
		
		switch (code.toLowerCase ()) {
			
			case "backspace": return BACKSPACE;
			case "tab": return TAB;
			case "enter": return ENTER;
			case "shift": return SHIFT;
			case "control": return CONTROL;
			case "capslock": return CAPS_LOCK;
			case "escape": return ESCAPE;
			case "space": return SPACE;
			case "pageup": return PAGE_UP;
			case "pagedown": return PAGE_DOWN;
			case "end": return END;
			case "home": return HOME;
			case "left": return LEFT;
			case "right": return RIGHT;
			case "up": return UP;
			case "down": return DOWN;
			case "insert": return INSERT;
			case "delete": return DELETE;
			case "numlock": return NUMLOCK;
			case "break": return BREAK;
			
		}
		
		if (code.indexOf ("U+") == 0) {
			
			return Std.parseInt ('0x' + code.substr (3));
			
		}
		
		throw "Unrecognized key code: " + code;
		
		return 0;
		
	}
	
	
}
