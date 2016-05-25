package openfl.ui; #if (display || !flash)


/**
 * The Keyboard class is used to build an interface that can be controlled by
 * a user with a standard keyboard. You can use the methods and properties of
 * the Keyboard class without using a constructor. The properties of the
 * Keyboard class are constants representing the keys that are most commonly
 * used to control games.
 */
@:final extern class Keyboard {
	
	// TODO: Add additional Flash values
	
	
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
	
	public static inline var BREAK = 19;
	
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
	
	#if air
	public static inline var NEXT = 0x0100000E;
	public static inline var BACK = 0x01000016;
	public static inline var SEARCH = 0x0100001F;
	public static inline var MENU = 0x01000012;
	#end
	
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
	public static function isAccessible ():Bool;
	
	
}


#else
typedef Keyboard = flash.ui.Keyboard;
#end