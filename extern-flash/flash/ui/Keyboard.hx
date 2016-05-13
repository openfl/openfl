package flash.ui; #if (!display && flash)


@:final extern class Keyboard {
	
	
	// TODO: Add additional Flash values
	
	
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
	
	#if air
	public static inline var NEXT = 0x0100000E;
	public static inline var BACK = 0x01000016;
	public static inline var SEARCH = 0x0100001F;
	public static inline var MENU = 0x01000012;
	#end
	
	public static var capsLock (default, null):Bool;
	public static var numLock (default, null):Bool;
	public static function isAccessible ():Bool;
	
	
}


#else
typedef Keyboard = openfl.ui.Keyboard;
#end