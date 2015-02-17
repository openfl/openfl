package openfl.ui; #if !flash #if !lime_legacy


/**
 * The Keyboard class is used to build an interface that can be controlled by
 * a user with a standard keyboard. You can use the methods and properties of
 * the Keyboard class without using a constructor. The properties of the
 * Keyboard class are constants representing the keys that are most commonly
 * used to control games.
 */
class Keyboard {
	
	
	/**
	 * Constant associated with the key code value for the 0 key(48).
	 */
	public static inline var NUMBER_0 = 48;
	
	/**
	 * Constant associated with the key code value for the 1 key(49).
	 */
	public static inline var NUMBER_1 = 49;
	
	/**
	 * Constant associated with the key code value for the 2 key(50).
	 */
	public static inline var NUMBER_2 = 50;
	
	/**
	 * Constant associated with the key code value for the 3 key(51).
	 */
	public static inline var NUMBER_3 = 51;
	
	/**
	 * Constant associated with the key code value for the 4 key(52).
	 */
	public static inline var NUMBER_4 = 52;
	
	/**
	 * Constant associated with the key code value for the 5 key(53).
	 */
	public static inline var NUMBER_5 = 53;
	
	/**
	 * Constant associated with the key code value for the 6 key(54).
	 */
	public static inline var NUMBER_6 = 54;
	
	/**
	 * Constant associated with the key code value for the 7 key(55).
	 */
	public static inline var NUMBER_7 = 55;
	
	/**
	 * Constant associated with the key code value for the 8 key(56).
	 */
	public static inline var NUMBER_8 = 56; 
	
	/**
	 * Constant associated with the key code value for the 9 key(57).
	 */
	public static inline var NUMBER_9 = 57;
	
	/**
	 * Constant associated with the key code value for the A key(65).
	 */
	public static inline var A = 65;
	
	/**
	 * Constant associated with the key code value for the B key(66).
	 */
	public static inline var B = 66;
	
	/**
	 * Constant associated with the key code value for the C key(67).
	 */
	public static inline var C = 67;
	
	/**
	 * Constant associated with the key code value for the D key(68).
	 */
	public static inline var D = 68;
	
	/**
	 * Constant associated with the key code value for the E key(69).
	 */
	public static inline var E = 69;
	
	/**
	 * Constant associated with the key code value for the F key(70).
	 */
	public static inline var F = 70;
	
	/**
	 * Constant associated with the key code value for the G key(71).
	 */
	public static inline var G = 71;
	
	/**
	 * Constant associated with the key code value for the H key(72).
	 */
	public static inline var H = 72;
	
	/**
	 * Constant associated with the key code value for the I key(73).
	 */
	public static inline var I = 73;
	
	/**
	 * Constant associated with the key code value for the J key(74).
	 */
	public static inline var J = 74;
	
	/**
	 * Constant associated with the key code value for the K key(75).
	 */
	public static inline var K = 75;
	
	/**
	 * Constant associated with the key code value for the L key(76).
	 */
	public static inline var L = 76;
	
	/**
	 * Constant associated with the key code value for the M key(77).
	 */
	public static inline var M = 77;
	
	/**
	 * Constant associated with the key code value for the N key(78).
	 */
	public static inline var N = 78;
	
	/**
	 * Constant associated with the key code value for the O key(79).
	 */
	public static inline var O = 79;
	
	/**
	 * Constant associated with the key code value for the P key(80).
	 */
	public static inline var P = 80;
	
	/**
	 * Constant associated with the key code value for the Q key(81).
	 */
	public static inline var Q = 81;
	
	/**
	 * Constant associated with the key code value for the R key(82).
	 */
	public static inline var R = 82;
	
	/**
	 * Constant associated with the key code value for the S key(83).
	 */
	public static inline var S = 83;
	
	/**
	 * Constant associated with the key code value for the T key(84).
	 */
	public static inline var T = 84;
	
	/**
	 * Constant associated with the key code value for the U key(85).
	 */
	public static inline var U = 85;
	
	/**
	 * Constant associated with the key code value for the V key(85).
	 */
	public static inline var V = 86;
	
	/**
	 * Constant associated with the key code value for the W key(87).
	 */
	public static inline var W = 87;
	
	/**
	 * Constant associated with the key code value for the X key(88).
	 */
	public static inline var X = 88;
	
	/**
	 * Constant associated with the key code value for the Y key(89).
	 */
	public static inline var Y = 89;
	
	/**
	 * Constant associated with the key code value for the Z key(90).
	 */
	public static inline var Z = 90;
	
	/**
	 * Constant associated with the key code value for the number 0 key on the
	 * number pad(96).
	 */
	public static inline var NUMPAD_0 = 96;
	
	/**
	 * Constant associated with the key code value for the number 1 key on the
	 * number pad(97).
	 */
	public static inline var NUMPAD_1 = 97;
	
	/**
	 * Constant associated with the key code value for the number 2 key on the
	 * number pad(98).
	 */
	public static inline var NUMPAD_2 = 98;
	
	/**
	 * Constant associated with the key code value for the number 3 key on the
	 * number pad(99).
	 */
	public static inline var NUMPAD_3 = 99;
	
	/**
	 * Constant associated with the key code value for the number 4 key on the
	 * number pad(100).
	 */
	public static inline var NUMPAD_4 = 100;
	
	/**
	 * Constant associated with the key code value for the number 5 key on the
	 * number pad(101).
	 */
	public static inline var NUMPAD_5 = 101;
	
	/**
	 * Constant associated with the key code value for the number 6 key on the
	 * number pad(102).
	 */
	public static inline var NUMPAD_6 = 102;
	
	/**
	 * Constant associated with the key code value for the number 7 key on the
	 * number pad(103).
	 */
	public static inline var NUMPAD_7 = 103;
	
	/**
	 * Constant associated with the key code value for the number 8 key on the
	 * number pad(104).
	 */
	public static inline var NUMPAD_8 = 104;
	
	/**
	 * Constant associated with the key code value for the number 9 key on the
	 * number pad(105).
	 */
	public static inline var NUMPAD_9 = 105;
	
	/**
	 * Constant associated with the key code value for the multiplication key on
	 * the number pad(106).
	 */
	public static inline var NUMPAD_MULTIPLY = 106;
	
	/**
	 * Constant associated with the key code value for the addition key on the
	 * number pad(107).
	 */
	public static inline var NUMPAD_ADD = 107;
	
	/**
	 * Constant associated with the key code value for the Enter key on the
	 * number pad(108).
	 */
	public static inline var NUMPAD_ENTER = 108;
	
	/**
	 * Constant associated with the key code value for the subtraction key on the
	 * number pad(109).
	 */
	public static inline var NUMPAD_SUBTRACT = 109;
	
	/**
	 * Constant associated with the key code value for the decimal key on the
	 * number pad(110).
	 */
	public static inline var NUMPAD_DECIMAL = 110;
	
	/**
	 * Constant associated with the key code value for the division key on the
	 * number pad(111).
	 */
	public static inline var NUMPAD_DIVIDE = 111;
	
	/**
	 * Constant associated with the key code value for the F1 key(112).
	 */
	public static inline var F1 = 112;
	
	/**
	 * Constant associated with the key code value for the F2 key(113).
	 */
	public static inline var F2 = 113;
	
	/**
	 * Constant associated with the key code value for the F3 key(114).
	 */
	public static inline var F3 = 114;
	
	/**
	 * Constant associated with the key code value for the F4 key(115).
	 */
	public static inline var F4 = 115;
	
	/**
	 * Constant associated with the key code value for the F5 key(116).
	 */
	public static inline var F5 = 116;
	
	/**
	 * Constant associated with the key code value for the F6 key(117).
	 */
	public static inline var F6 = 117;
	
	/**
	 * Constant associated with the key code value for the F7 key(118).
	 */
	public static inline var F7 = 118;
	
	/**
	 * Constant associated with the key code value for the F8 key(119).
	 */
	public static inline var F8 = 119;
	
	/**
	 * Constant associated with the key code value for the F9 key(120).
	 */
	public static inline var F9 = 120;
	
	/**
	 * Constant associated with the key code value for the F10 key(121).
	 */
	public static inline var F10 = 121; //  F10 is used by browser.
	
	/**
	 * Constant associated with the key code value for the F11 key(122).
	 */
	public static inline var F11 = 122;
	
	/**
	 * Constant associated with the key code value for the F12 key(123).
	 */
	public static inline var F12 = 123;
	
	/**
	 * Constant associated with the key code value for the F13 key(124).
	 */
	public static inline var F13 = 124;
	
	/**
	 * Constant associated with the key code value for the F14 key(125).
	 */
	public static inline var F14 = 125;
	
	/**
	 * Constant associated with the key code value for the F15 key(126).
	 */
	public static inline var F15 = 126;
	
	/**
	 * Constant associated with the key code value for the Backspace key(8).
	 */
	public static inline var BACKSPACE = 8;
	
	/**
	 * Constant associated with the key code value for the Tab key(9).
	 */
	public static inline var TAB = 9;
	
	/**
	 * Constant associated with the key code value for the Alternate(Option) key
	 * (18).
	 */
	public static inline var ALTERNATE = 18;
	
	/**
	 * Constant associated with the key code value for the Enter key(13).
	 */
	public static inline var ENTER = 13;
	
	/**
	 * Constant associated with the Mac command key(15). This constant is
	 * currently only used for setting menu key equivalents.
	 */
	public static inline var COMMAND = 15;
	
	/**
	 * Constant associated with the key code value for the Shift key(16).
	 */
	public static inline var SHIFT = 16;
	
	/**
	 * Constant associated with the key code value for the Control key(17).
	 */
	public static inline var CONTROL = 17;
	
	/**
	 * Constant associated with the key code value for the Caps Lock key(20).
	 */
	public static inline var CAPS_LOCK = 20;
	
	/**
	 * Constant associated with the pseudo-key code for the the number pad(21).
	 * Use to set numpad modifier on key equivalents
	 */
	public static inline var NUMPAD = 21;
	
	/**
	 * Constant associated with the key code value for the Escape key(27).
	 */
	public static inline var ESCAPE = 27;
	
	/**
	 * Constant associated with the key code value for the Spacebar(32).
	 */
	public static inline var SPACE = 32;
	
	/**
	 * Constant associated with the key code value for the Page Up key(33).
	 */
	public static inline var PAGE_UP = 33;
	
	/**
	 * Constant associated with the key code value for the Page Down key(34).
	 */
	public static inline var PAGE_DOWN = 34;
	
	/**
	 * Constant associated with the key code value for the End key(35).
	 */
	public static inline var END = 35;
	
	/**
	 * Constant associated with the key code value for the Home key(36).
	 */
	public static inline var HOME = 36;
	
	/**
	 * Constant associated with the key code value for the Left Arrow key(37).
	 */
	public static inline var LEFT = 37;
	
	/**
	 * Constant associated with the key code value for the Right Arrow key(39).
	 */
	public static inline var RIGHT = 39;
	
	/**
	 * Constant associated with the key code value for the Up Arrow key(38).
	 */
	public static inline var UP = 38;
	
	/**
	 * Constant associated with the key code value for the Down Arrow key(40).
	 */
	public static inline var DOWN = 40;
	
	/**
	 * Constant associated with the key code value for the Insert key(45).
	 */
	public static inline var INSERT = 45;
	
	/**
	 * Constant associated with the key code value for the Delete key(46).
	 */
	public static inline var DELETE = 46;
	public static inline var NUMLOCK = 144;
	public static inline var BREAK = 19;
	
	/**
	 * Constant associated with the key code value for the ; key(186).
	 */
	public static inline var SEMICOLON = 186;
	
	/**
	 * Constant associated with the key code value for the = key(187).
	 */
	public static inline var EQUAL = 187;
	
	/**
	 * Constant associated with the key code value for the , key(188).
	 */
	public static inline var COMMA = 188;
	
	/**
	 * Constant associated with the key code value for the - key(189).
	 */
	public static inline var MINUS = 189;
	
	/**
	 * Constant associated with the key code value for the . key(190).
	 */
	public static inline var PERIOD = 190;
	
	/**
	 * Constant associated with the key code value for the / key(191).
	 */
	public static inline var SLASH = 191;
	
	/**
	 * Constant associated with the key code value for the ` key(192).
	 */
	public static inline var BACKQUOTE = 192;
	
	/**
	 * Constant associated with the key code value for the [ key(219).
	 */
	public static inline var LEFTBRACKET = 219;
	
	/**
	 * Constant associated with the key code value for the \ key(220).
	 */
	public static inline var BACKSLASH = 220;
	
	/**
	 * Constant associated with the key code value for the ] key(221).
	 */
	public static inline var RIGHTBRACKET = 221;
	
	/**
	 * Constant associated with the key code value for the ' key(222).
	 */
	public static inline var QUOTE = 222;
	
	// Mozilla keyCodes
	// reference: https://developer.mozilla.org/en/DOM/Event/UIEvent/KeyEvent
	private static inline var DOM_VK_CANCEL = 3;
	private static inline var DOM_VK_HELP = 6;
	private static inline var DOM_VK_BACK_SPACE = 8;
	private static inline var DOM_VK_TAB = 9;
	private static inline var DOM_VK_CLEAR = 12;
	private static inline var DOM_VK_RETURN = 13;
	private static inline var DOM_VK_ENTER = 14;
	private static inline var DOM_VK_SHIFT = 16;
	private static inline var DOM_VK_CONTROL = 17;
	private static inline var DOM_VK_ALT = 18;
	private static inline var DOM_VK_PAUSE = 19;
	private static inline var DOM_VK_CAPS_LOCK = 20;
	private static inline var DOM_VK_ESCAPE = 27;
	private static inline var DOM_VK_SPACE = 32;
	private static inline var DOM_VK_PAGE_UP = 33;
	private static inline var DOM_VK_PAGE_DOWN = 34;
	private static inline var DOM_VK_END = 35;
	private static inline var DOM_VK_HOME = 36;
	private static inline var DOM_VK_LEFT = 37;
	private static inline var DOM_VK_UP = 38;
	private static inline var DOM_VK_RIGHT = 39;
	private static inline var DOM_VK_DOWN = 40;
	private static inline var DOM_VK_PRINTSCREEN = 44;
	private static inline var DOM_VK_INSERT = 45;
	private static inline var DOM_VK_DELETE = 46;
	private static inline var DOM_VK_0 = 48;
	private static inline var DOM_VK_1 = 49;
	private static inline var DOM_VK_2 = 50;
	private static inline var DOM_VK_3 = 51;
	private static inline var DOM_VK_4 = 52;
	private static inline var DOM_VK_5 = 53;
	private static inline var DOM_VK_6 = 54;
	private static inline var DOM_VK_7 = 55;
	private static inline var DOM_VK_8 = 56;
	private static inline var DOM_VK_9 = 57;
	private static inline var DOM_VK_SEMICOLON = 59;
	private static inline var DOM_VK_EQUALS = 61;
	private static inline var DOM_VK_A = 65;
	private static inline var DOM_VK_B = 66;
	private static inline var DOM_VK_C = 67;
	private static inline var DOM_VK_D = 68;
	private static inline var DOM_VK_E = 69;
	private static inline var DOM_VK_F = 70;
	private static inline var DOM_VK_G = 71;
	private static inline var DOM_VK_H = 72;
	private static inline var DOM_VK_I = 73;
	private static inline var DOM_VK_J = 74;
	private static inline var DOM_VK_K = 75;
	private static inline var DOM_VK_L = 76;
	private static inline var DOM_VK_M = 77;
	private static inline var DOM_VK_N = 78;
	private static inline var DOM_VK_O = 79;
	private static inline var DOM_VK_P = 80;
	private static inline var DOM_VK_Q = 81;
	private static inline var DOM_VK_R = 82;
	private static inline var DOM_VK_S = 83;
	private static inline var DOM_VK_T = 84;
	private static inline var DOM_VK_U = 85;
	private static inline var DOM_VK_V = 86;
	private static inline var DOM_VK_W = 87;
	private static inline var DOM_VK_X = 88;
	private static inline var DOM_VK_Y = 89;
	private static inline var DOM_VK_Z = 90;
	private static inline var DOM_VK_CONTEXT_MENU = 93;
	private static inline var DOM_VK_NUMPAD0 = 96;
	private static inline var DOM_VK_NUMPAD1 = 97;
	private static inline var DOM_VK_NUMPAD2 = 98;
	private static inline var DOM_VK_NUMPAD3 = 99;
	private static inline var DOM_VK_NUMPAD4 = 100;
	private static inline var DOM_VK_NUMPAD5 = 101;
	private static inline var DOM_VK_NUMPAD6 = 102;
	private static inline var DOM_VK_NUMPAD7 = 103;
	private static inline var DOM_VK_NUMPAD8 = 104;
	private static inline var DOM_VK_NUMPAD9 = 105;
	private static inline var DOM_VK_MULTIPLY = 106;
	private static inline var DOM_VK_ADD = 107;
	private static inline var DOM_VK_SEPARATOR = 108;
	private static inline var DOM_VK_SUBTRACT = 109;
	private static inline var DOM_VK_DECIMAL = 110;
	private static inline var DOM_VK_DIVIDE = 111;
	private static inline var DOM_VK_F1 = 112;
	private static inline var DOM_VK_F2 = 113;
	private static inline var DOM_VK_F3 = 114;
	private static inline var DOM_VK_F4 = 115;
	private static inline var DOM_VK_F5 = 116;
	private static inline var DOM_VK_F6 = 117;
	private static inline var DOM_VK_F7 = 118;
	private static inline var DOM_VK_F8 = 119;
	private static inline var DOM_VK_F9 = 120;
	private static inline var DOM_VK_F10 = 121;
	private static inline var DOM_VK_F11 = 122;
	private static inline var DOM_VK_F12 = 123;
	private static inline var DOM_VK_F13 = 124;
	private static inline var DOM_VK_F14 = 125;
	private static inline var DOM_VK_F15 = 126;
	private static inline var DOM_VK_F16 = 127;
	private static inline var DOM_VK_F17 = 128;
	private static inline var DOM_VK_F18 = 129;
	private static inline var DOM_VK_F19 = 130;
	private static inline var DOM_VK_F20 = 131;
	private static inline var DOM_VK_F21 = 132;
	private static inline var DOM_VK_F22 = 133;
	private static inline var DOM_VK_F23 = 134;
	private static inline var DOM_VK_F24 = 135;
	private static inline var DOM_VK_NUM_LOCK = 144;
	private static inline var DOM_VK_SCROLL_LOCK = 145;
	private static inline var DOM_VK_COMMA = 188;
	private static inline var DOM_VK_PERIOD = 190;
	private static inline var DOM_VK_SLASH = 191;
	private static inline var DOM_VK_BACK_QUOTE = 192;
	private static inline var DOM_VK_OPEN_BRACKET = 219;
	private static inline var DOM_VK_BACK_SLASH = 220;
	private static inline var DOM_VK_CLOSE_BRACKET = 221;
	private static inline var DOM_VK_QUOTE = 222;
	private static inline var DOM_VK_META = 224;
	
	private static inline var DOM_VK_KANA = 21;
	private static inline var DOM_VK_HANGUL = 21;
	private static inline var DOM_VK_JUNJA = 23;
	private static inline var DOM_VK_FINAL = 24;
	private static inline var DOM_VK_HANJA = 25;
	private static inline var DOM_VK_KANJI = 25;
	private static inline var DOM_VK_CONVERT = 28;
	private static inline var DOM_VK_NONCONVERT = 29;
	private static inline var DOM_VK_ACEPT = 30;
	private static inline var DOM_VK_MODECHANGE = 31;
	private static inline var DOM_VK_SELECT = 41;
	private static inline var DOM_VK_PRINT = 42;
	private static inline var DOM_VK_EXECUTE = 43;
	private static inline var DOM_VK_SLEEP = 95;
	
	
	/**
	 * Specifies whether the Caps Lock key is activated(<code>true</code>) or
	 * not(<code>false</code>).
	 */
	public static var capsLock (default, null):Bool;
	
	/**
	 * Specifies whether the Num Lock key is activated(<code>true</code>) or not
	 * (<code>false</code>).
	 */
	public static var numLock (default, null):Bool;
	
	
	/**
	 * Specifies whether the last key pressed is accessible by other SWF files.
	 * By default, security restrictions prevent code from a SWF file in one
	 * domain from accessing a keystroke generated from a SWF file in another
	 * domain.
	 * 
	 * @return The value <code>true</code> if the last key pressed can be
	 *         accessed. If access is not permitted, this method returns
	 *         <code>false</code>.
	 */
	public static function isAccessible ():Bool {
		
		// default browser security restrictions are always enforced
		return false;
		
	}
	
	
	@:noCompletion public static function __convertMozillaCode (code:Int):Int {
		
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
	
	
	@:noCompletion public static function __convertWebkitCode (code:String):Int {
		
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


#else
typedef Keyboard = openfl._v2.ui.Keyboard;
#end
#else
typedef Keyboard = flash.ui.Keyboard;
#end