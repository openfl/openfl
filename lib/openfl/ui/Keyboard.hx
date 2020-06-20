package openfl.ui;

#if (display || !flash)
/**
	The Keyboard class is used to build an interface that can be controlled by
	a user with a standard keyboard. You can use the methods and properties of
	the Keyboard class without using a constructor. The properties of the
	Keyboard class are constants representing the keys that are most commonly
	used to control games.
**/
@:jsRequire("openfl/ui/Keyboard", "default")
@:final extern class Keyboard
{
	// TODO: Add additional Flash values

	/**
		Constant associated with the key code value for the 0 key(48).
	**/
	public static inline var NUMBER_0 = 48;

	/**
		Constant associated with the key code value for the 1 key(49).
	**/
	public static inline var NUMBER_1 = 49;

	/**
		Constant associated with the key code value for the 2 key(50).
	**/
	public static inline var NUMBER_2 = 50;

	/**
		Constant associated with the key code value for the 3 key(51).
	**/
	public static inline var NUMBER_3 = 51;

	/**
		Constant associated with the key code value for the 4 key(52).
	**/
	public static inline var NUMBER_4 = 52;

	/**
		Constant associated with the key code value for the 5 key(53).
	**/
	public static inline var NUMBER_5 = 53;

	/**
		Constant associated with the key code value for the 5 key(53).
	**/
	public static inline var NUMBER_6 = 54;

	/**
		Constant associated with the key code value for the 7 key(55).
	**/
	public static inline var NUMBER_7:Int = 55;

	/**
		Constant associated with the key code value for the 8 key(56).
	**/
	public static inline var NUMBER_8:Int = 56;

	/**
		Constant associated with the key code value for the 9 key(57).
	**/
	public static inline var NUMBER_9:Int = 57;

	/**
		Constant associated with the key code value for the A key(65).
	**/
	public static inline var A:Int = 65;

	/**
		Constant associated with the key code value for the B key(66).
	**/
	public static inline var B:Int = 66;

	/**
		Constant associated with the key code value for the C key(67).
	**/
	public static inline var C:Int = 67;

	/**
		Constant associated with the key code value for the D key(68).
	**/
	public static inline var D:Int = 68;

	/**
		Constant associated with the key code value for the E key(69).
	**/
	public static inline var E:Int = 69;

	/**
		Constant associated with the key code value for the F key(70).
	**/
	public static inline var F:Int = 70;

	/**
		Constant associated with the key code value for the G key(71).
	**/
	public static inline var G:Int = 71;

	/**
		Constant associated with the key code value for the H key(72).
	**/
	public static inline var H:Int = 72;

	/**
		Constant associated with the key code value for the I key(73).
	**/
	public static inline var I:Int = 73;

	/**
		Constant associated with the key code value for the J key(74).
	**/
	public static inline var J:Int = 74;

	/**
		Constant associated with the key code value for the K key(75).
	**/
	public static inline var K:Int = 75;

	/**
		Constant associated with the key code value for the L key(76).
	**/
	public static inline var L:Int = 76;

	/**
		Constant associated with the key code value for the M key(77).
	**/
	public static inline var M:Int = 77;

	/**
		Constant associated with the key code value for the N key(78).
	**/
	public static inline var N:Int = 78;

	/**
		Constant associated with the key code value for the O key(79).
	**/
	public static inline var O:Int = 79;

	/**
		Constant associated with the key code value for the P key(80).
	**/
	public static inline var P:Int = 80;

	/**
		Constant associated with the key code value for the Q key(81).
	**/
	public static inline var Q:Int = 81;

	/**
		Constant associated with the key code value for the R key(82).
	**/
	public static inline var R:Int = 82;

	/**
		Constant associated with the key code value for the S key(83).
	**/
	public static inline var S:Int = 83;

	/**
		Constant associated with the key code value for the T key(84).
	**/
	public static inline var T:Int = 84;

	/**
		Constant associated with the key code value for the U key(85).
	**/
	public static inline var U:Int = 85;

	/**
		Constant associated with the key code value for the V key(85).
	**/
	public static inline var V:Int = 86;

	/**
		Constant associated with the key code value for the W key(87).
	**/
	public static inline var W:Int = 87;

	/**
		Constant associated with the key code value for the X key(88).
	**/
	public static inline var X:Int = 88;

	/**
		Constant associated with the key code value for the Y key(89).
	**/
	public static inline var Y:Int = 89;

	/**
		Constant associated with the key code value for the Z key(90).
	**/
	public static inline var Z:Int = 90;

	/**
		Constant associated with the key code value for the number 0 key on the
		number pad(96).
	**/
	public static inline var NUMPAD_0:Int = 96;

	/**
		Constant associated with the key code value for the number 1 key on the
		number pad(97).
	**/
	public static inline var NUMPAD_1:Int = 97;

	/**
		Constant associated with the key code value for the number 2 key on the
		number pad(98).
	**/
	public static inline var NUMPAD_2:Int = 98;

	/**
		Constant associated with the key code value for the number 3 key on the
		number pad(99).
	**/
	public static inline var NUMPAD_3:Int = 99;

	/**
		Constant associated with the key code value for the number 4 key on the
		number pad(100).
	**/
	public static inline var NUMPAD_4:Int = 100;

	/**
		Constant associated with the key code value for the number 5 key on the
		number pad(101).
	**/
	public static inline var NUMPAD_5:Int = 101;

	/**
		Constant associated with the key code value for the number 6 key on the
		number pad(102).
	**/
	public static inline var NUMPAD_6:Int = 102;

	/**
		Constant associated with the key code value for the number 7 key on the
		number pad(103).
	**/
	public static inline var NUMPAD_7:Int = 103;

	/**
		Constant associated with the key code value for the number 8 key on the
		number pad(104).
	**/
	public static inline var NUMPAD_8:Int = 104;

	/**
		Constant associated with the key code value for the number 9 key on the
		number pad(105).
	**/
	public static inline var NUMPAD_9:Int = 105;

	/**
		Constant associated with the key code value for the multiplication key on
		the number pad(106).
	**/
	public static inline var NUMPAD_MULTIPLY:Int = 106;

	/**
		Constant associated with the key code value for the addition key on the
		number pad(107).
	**/
	public static inline var NUMPAD_ADD:Int = 107;

	/**
		Constant associated with the key code value for the Enter key on the
		number pad(108).
	**/
	public static inline var NUMPAD_ENTER:Int = 108;

	/**
		Constant associated with the key code value for the subtraction key on the
		number pad(109).
	**/
	public static inline var NUMPAD_SUBTRACT:Int = 109;

	/**
		Constant associated with the key code value for the decimal key on the
		number pad(110).
	**/
	public static inline var NUMPAD_DECIMAL:Int = 110;

	/**
		Constant associated with the key code value for the division key on the
		number pad(111).
	**/
	public static inline var NUMPAD_DIVIDE:Int = 111;

	/**
		Constant associated with the key code value for the F1 key(112).
	**/
	public static inline var F1:Int = 112;

	/**
		Constant associated with the key code value for the F2 key(113).
	**/
	public static inline var F2:Int = 113;

	/**
		Constant associated with the key code value for the F3 key(114).
	**/
	public static inline var F3:Int = 114;

	/**
		Constant associated with the key code value for the F4 key(115).
	**/
	public static inline var F4:Int = 115;

	/**
		Constant associated with the key code value for the F5 key(116).
	**/
	public static inline var F5:Int = 116;

	/**
		Constant associated with the key code value for the F6 key(117).
	**/
	public static inline var F6:Int = 117;

	/**
		Constant associated with the key code value for the F7 key(118).
	**/
	public static inline var F7:Int = 118;

	/**
		Constant associated with the key code value for the F8 key(119).
	**/
	public static inline var F8:Int = 119;

	/**
		Constant associated with the key code value for the F9 key(120).
	**/
	public static inline var F9:Int = 120;

	/**
		Constant associated with the key code value for the F10 key(121).
	**/
	public static inline var F10:Int = 121; //  F10 is used by browser.

	/**
		Constant associated with the key code value for the F11 key(122).
	**/
	public static inline var F11:Int = 122;

	/**
		Constant associated with the key code value for the F12 key(123).
	**/
	public static inline var F12:Int = 123;

	/**
		Constant associated with the key code value for the F13 key(124).
	**/
	public static inline var F13:Int = 124;

	/**
		Constant associated with the key code value for the F14 key(125).
	**/
	public static inline var F14:Int = 125;

	/**
		Constant associated with the key code value for the F15 key(126).
	**/
	public static inline var F15:Int = 126;

	/**
		Constant associated with the key code value for the Backspace key(8).
	**/
	public static inline var BACKSPACE:Int = 8;

	/**
		Constant associated with the key code value for the Tab key(9).
	**/
	public static inline var TAB:Int = 9;

	/**
		Constant associated with the key code value for the Alternate(Option) key
		(18).
	**/
	public static inline var ALTERNATE:Int = 18;

	/**
		Constant associated with the key code value for the Enter key(13).
	**/
	public static inline var ENTER:Int = 13;

	/**
		Constant associated with the Mac command key(15). This constant is
		currently only used for setting menu key equivalents.
	**/
	public static inline var COMMAND:Int = 15;

	/**
		Constant associated with the key code value for the Shift key(16).
	**/
	public static inline var SHIFT:Int = 16;

	/**
		Constant associated with the key code value for the Control key(17).
	**/
	public static inline var CONTROL:Int = 17;

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:noCompletion @:dox(hide) public static inline var BREAK:Int = 19;

	/**
		Constant associated with the key code value for the Caps Lock key(20).
	**/
	public static inline var CAPS_LOCK:Int = 20;

	/**
		Constant associated with the pseudo-key code for the the number pad(21).
		Use to set numpad modifier on key equivalents
	**/
	public static inline var NUMPAD:Int = 21;

	/**
		Constant associated with the key code value for the Escape key(27).
	**/
	public static inline var ESCAPE:Int = 27;

	/**
		Constant associated with the key code value for the Spacebar(32).
	**/
	public static inline var SPACE:Int = 32;

	/**
		Constant associated with the key code value for the Page Up key(33).
	**/
	public static inline var PAGE_UP:Int = 33;

	/**
		Constant associated with the key code value for the Page Down key(34).
	**/
	public static inline var PAGE_DOWN:Int = 34;

	/**
		Constant associated with the key code value for the End key(35).
	**/
	public static inline var END:Int = 35;

	/**
		Constant associated with the key code value for the Home key(36).
	**/
	public static inline var HOME:Int = 36;

	/**
		Constant associated with the key code value for the Left Arrow key(37).
	**/
	public static inline var LEFT:Int = 37;

	/**
		Constant associated with the key code value for the Right Arrow key(39).
	**/
	public static inline var RIGHT:Int = 39;

	/**
		Constant associated with the key code value for the Up Arrow key(38).
	**/
	public static inline var UP:Int = 38;

	/**
		Constant associated with the key code value for the Down Arrow key(40).
	**/
	public static inline var DOWN:Int = 40;

	/**
		Constant associated with the key code value for the Insert key(45).
	**/
	public static inline var INSERT:Int = 45;

	/**
		Constant associated with the key code value for the Delete key(46).
	**/
	public static inline var DELETE:Int = 46;

	@SuppressWarnings("checkstyle:FieldDocComment")
	@:noCompletion @:dox(hide) public static inline var NUMLOCK:Int = 144;

	/**
		Constant associated with the key code value for the ; key(186).
	**/
	public static inline var SEMICOLON:Int = 186;

	/**
		Constant associated with the key code value for the:Int = key(187).
	**/
	public static inline var EQUAL:Int = 187;

	/**
		Constant associated with the key code value for the , key(188).
	**/
	public static inline var COMMA:Int = 188;

	/**
		Constant associated with the key code value for the - key(189).
	**/
	public static inline var MINUS:Int = 189;

	/**
		Constant associated with the key code value for the . key(190).
	**/
	public static inline var PERIOD:Int = 190;

	/**
		Constant associated with the key code value for the / key(191).
	**/
	public static inline var SLASH:Int = 191;

	/**
		Constant associated with the key code value for the ` key(192).
	**/
	public static inline var BACKQUOTE:Int = 192;

	/**
		Constant associated with the key code value for the [ key(219).
	**/
	public static inline var LEFTBRACKET:Int = 219;

	/**
		Constant associated with the key code value for the \ key(220).
	**/
	public static inline var BACKSLASH:Int = 220;

	/**
		Constant associated with the key code value for the ] key(221).
	**/
	public static inline var RIGHTBRACKET:Int = 221;

	/**
		Constant associated with the key code value for the ' key(222).
	**/
	public static inline var QUOTE:Int = 222;

	#if air
	public static inline var NEXT = 0x0100000E;
	public static inline var BACK = 0x01000016;
	public static inline var SEARCH = 0x0100001F;
	public static inline var MENU = 0x01000012;
	#end

	/**
		Specifies whether the Caps Lock key is activated(`true`) or
		not(`false`).
	**/
	public static var capsLock(default, null):Bool;

	/**
		Specifies whether the Num Lock key is activated(`true`) or not
		(`false`).
	**/
	public static var numLock(default, null):Bool;

	/**
		Specifies whether the last key pressed is accessible by other SWF files.
		By default, security restrictions prevent code from a SWF file in one
		domain from accessing a keystroke generated from a SWF file in another
		domain.

		@return The value `true` if the last key pressed can be
				accessed. If access is not permitted, this method returns
				`false`.
	**/
	public static function isAccessible():Bool;
}
#else
typedef Keyboard = flash.ui.Keyboard;
#end
