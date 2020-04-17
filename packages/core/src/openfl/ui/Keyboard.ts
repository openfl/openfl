/**
		The Keyboard class is used to build an interface that can be controlled by
		a user with a standard keyboard. You can use the methods and properties of
		the Keyboard class without using a constructor. The properties of the
		Keyboard class are constants representing the keys that are most commonly
		used to control games.
	**/
export default class Keyboard
{
	/**
		Constant associated with the key code value for the 0 key(48).
	**/
	public static readonly NUMBER_0: number = 48;

	/**
		Constant associated with the key code value for the 1 key(49).
	**/
	public static readonly NUMBER_1: number = 49;

	/**
		Constant associated with the key code value for the 2 key(50).
	**/
	public static readonly NUMBER_2: number = 50;

	/**
		Constant associated with the key code value for the 3 key(51).
	**/
	public static readonly NUMBER_3: number = 51;

	/**
		Constant associated with the key code value for the 4 key(52).
	**/
	public static readonly NUMBER_4: number = 52;

	/**
		Constant associated with the key code value for the 5 key(53).
	**/
	public static readonly NUMBER_5: number = 53;

	/**
		Constant associated with the key code value for the 6 key(54).
	**/
	public static readonly NUMBER_6: number = 54;

	/**
		Constant associated with the key code value for the 7 key(55).
	**/
	public static readonly NUMBER_7: number = 55;

	/**
		Constant associated with the key code value for the 8 key(56).
	**/
	public static readonly NUMBER_8: number = 56;

	/**
		Constant associated with the key code value for the 9 key(57).
	**/
	public static readonly NUMBER_9: number = 57;

	/**
		Constant associated with the key code value for the A key(65).
	**/
	public static readonly A: number = 65;

	/**
		Constant associated with the key code value for the B key(66).
	**/
	public static readonly B: number = 66;

	/**
		Constant associated with the key code value for the C key(67).
	**/
	public static readonly C: number = 67;

	/**
		Constant associated with the key code value for the D key(68).
	**/
	public static readonly D: number = 68;

	/**
		Constant associated with the key code value for the E key(69).
	**/
	public static readonly E: number = 69;

	/**
		Constant associated with the key code value for the F key(70).
	**/
	public static readonly F: number = 70;

	/**
		Constant associated with the key code value for the G key(71).
	**/
	public static readonly G: number = 71;

	/**
		Constant associated with the key code value for the H key(72).
	**/
	public static readonly H: number = 72;

	/**
		Constant associated with the key code value for the I key(73).
	**/
	public static readonly I: number = 73;

	/**
		Constant associated with the key code value for the J key(74).
	**/
	public static readonly J: number = 74;

	/**
		Constant associated with the key code value for the K key(75).
	**/
	public static readonly K: number = 75;

	/**
		Constant associated with the key code value for the L key(76).
	**/
	public static readonly L: number = 76;

	/**
		Constant associated with the key code value for the M key(77).
	**/
	public static readonly M: number = 77;

	/**
		Constant associated with the key code value for the N key(78).
	**/
	public static readonly N: number = 78;

	/**
		Constant associated with the key code value for the O key(79).
	**/
	public static readonly O: number = 79;

	/**
		Constant associated with the key code value for the P key(80).
	**/
	public static readonly P: number = 80;

	/**
		Constant associated with the key code value for the Q key(81).
	**/
	public static readonly Q: number = 81;

	/**
		Constant associated with the key code value for the R key(82).
	**/
	public static readonly R: number = 82;

	/**
		Constant associated with the key code value for the S key(83).
	**/
	public static readonly S: number = 83;

	/**
		Constant associated with the key code value for the T key(84).
	**/
	public static readonly T: number = 84;

	/**
		Constant associated with the key code value for the U key(85).
	**/
	public static readonly U: number = 85;

	/**
		Constant associated with the key code value for the V key(85).
	**/
	public static readonly V: number = 86;

	/**
		Constant associated with the key code value for the W key(87).
	**/
	public static readonly W: number = 87;

	/**
		Constant associated with the key code value for the X key(88).
	**/
	public static readonly X: number = 88;

	/**
		Constant associated with the key code value for the Y key(89).
	**/
	public static readonly Y: number = 89;

	/**
		Constant associated with the key code value for the Z key(90).
	**/
	public static readonly Z: number = 90;

	/**
		Constant associated with the key code value for the number 0 key on the
		number pad(96).
	**/
	public static readonly NUMPAD_0: number = 96;

	/**
		Constant associated with the key code value for the number 1 key on the
		number pad(97).
	**/
	public static readonly NUMPAD_1: number = 97;

	/**
		Constant associated with the key code value for the number 2 key on the
		number pad(98).
	**/
	public static readonly NUMPAD_2: number = 98;

	/**
		Constant associated with the key code value for the number 3 key on the
		number pad(99).
	**/
	public static readonly NUMPAD_3: number = 99;

	/**
		Constant associated with the key code value for the number 4 key on the
		number pad(100).
	**/
	public static readonly NUMPAD_4: number = 100;

	/**
		Constant associated with the key code value for the number 5 key on the
		number pad(101).
	**/
	public static readonly NUMPAD_5: number = 101;

	/**
		Constant associated with the key code value for the number 6 key on the
		number pad(102).
	**/
	public static readonly NUMPAD_6: number = 102;

	/**
		Constant associated with the key code value for the number 7 key on the
		number pad(103).
	**/
	public static readonly NUMPAD_7: number = 103;

	/**
		Constant associated with the key code value for the number 8 key on the
		number pad(104).
	**/
	public static readonly NUMPAD_8: number = 104;

	/**
		Constant associated with the key code value for the number 9 key on the
		number pad(105).
	**/
	public static readonly NUMPAD_9: number = 105;

	/**
		Constant associated with the key code value for the multiplication key on
		the number pad(106).
	**/
	public static readonly NUMPAD_MULTIPLY: number = 106;

	/**
		Constant associated with the key code value for the addition key on the
		number pad(107).
	**/
	public static readonly NUMPAD_ADD: number = 107;

	/**
		Constant associated with the key code value for the Enter key on the
		number pad(108).
	**/
	public static readonly NUMPAD_ENTER: number = 108;

	/**
		Constant associated with the key code value for the subtraction key on the
		number pad(109).
	**/
	public static readonly NUMPAD_SUBTRACT: number = 109;

	/**
		Constant associated with the key code value for the decimal key on the
		number pad(110).
	**/
	public static readonly NUMPAD_DECIMAL: number = 110;

	/**
		Constant associated with the key code value for the division key on the
		number pad(111).
	**/
	public static readonly NUMPAD_DIVIDE: number = 111;

	/**
		Constant associated with the key code value for the F1 key(112).
	**/
	public static readonly F1: number = 112;

	/**
		Constant associated with the key code value for the F2 key(113).
	**/
	public static readonly F2: number = 113;

	/**
		Constant associated with the key code value for the F3 key(114).
	**/
	public static readonly F3: number = 114;

	/**
		Constant associated with the key code value for the F4 key(115).
	**/
	public static readonly F4: number = 115;

	/**
		Constant associated with the key code value for the F5 key(116).
	**/
	public static readonly F5: number = 116;

	/**
		Constant associated with the key code value for the F6 key(117).
	**/
	public static readonly F6: number = 117;

	/**
		Constant associated with the key code value for the F7 key(118).
	**/
	public static readonly F7: number = 118;

	/**
		Constant associated with the key code value for the F8 key(119).
	**/
	public static readonly F8: number = 119;

	/**
		Constant associated with the key code value for the F9 key(120).
	**/
	public static readonly F9: number = 120;

	/**
		Constant associated with the key code value for the F10 key(121).
	**/
	public static readonly F10: number = 121; //  F10 is used by browser.

	/**
		Constant associated with the key code value for the F11 key(122).
	**/
	public static readonly F11: number = 122;

	/**
		Constant associated with the key code value for the F12 key(123).
	**/
	public static readonly F12: number = 123;

	/**
		Constant associated with the key code value for the F13 key(124).
	**/
	public static readonly F13: number = 124;

	/**
		Constant associated with the key code value for the F14 key(125).
	**/
	public static readonly F14: number = 125;

	/**
		Constant associated with the key code value for the F15 key(126).
	**/
	public static readonly F15: number = 126;

	/**
		Constant associated with the key code value for the Backspace key(8).
	**/
	public static readonly BACKSPACE: number = 8;

	/**
		Constant associated with the key code value for the Tab key(9).
	**/
	public static readonly TAB: number = 9;

	/**
		Constant associated with the key code value for the Alternate(Option) key
		(18).
	**/
	public static readonly ALTERNATE: number = 18;

	/**
		Constant associated with the key code value for the Enter key(13).
	**/
	public static readonly ENTER: number = 13;

	/**
		Constant associated with the Mac command key(15). This constant is
		currently only used for setting menu key equivalents.
	**/
	public static readonly COMMAND: number = 15;

	/**
		Constant associated with the key code value for the Shift key(16).
	**/
	public static readonly SHIFT: number = 16;

	/**
		Constant associated with the key code value for the Control key(17).
	**/
	public static readonly CONTROL: number = 17;

	/** @hidden */
	public static readonly BREAK: number = 19;

	/**
		Constant associated with the key code value for the Caps Lock key(20).
	**/
	public static readonly CAPS_LOCK: number = 20;

	/**
		Constant associated with the pseudo-key code for the the number pad(21).
		Use to set numpad modifier on key equivalents
	**/
	public static readonly NUMPAD: number = 21;

	/**
		Constant associated with the key code value for the Escape key(27).
	**/
	public static readonly ESCAPE: number = 27;

	/**
		Constant associated with the key code value for the Spacebar(32).
	**/
	public static readonly SPACE: number = 32;

	/**
		Constant associated with the key code value for the Page Up key(33).
	**/
	public static readonly PAGE_UP: number = 33;

	/**
		Constant associated with the key code value for the Page Down key(34).
	**/
	public static readonly PAGE_DOWN: number = 34;

	/**
		Constant associated with the key code value for the End key(35).
	**/
	public static readonly END: number = 35;

	/**
		Constant associated with the key code value for the Home key(36).
	**/
	public static readonly HOME: number = 36;

	/**
		Constant associated with the key code value for the Left Arrow key(37).
	**/
	public static readonly LEFT: number = 37;

	/**
		Constant associated with the key code value for the Right Arrow key(39).
	**/
	public static readonly RIGHT: number = 39;

	/**
		Constant associated with the key code value for the Up Arrow key(38).
	**/
	public static readonly UP: number = 38;

	/**
		Constant associated with the key code value for the Down Arrow key(40).
	**/
	public static readonly DOWN: number = 40;

	/**
		Constant associated with the key code value for the Insert key(45).
	**/
	public static readonly INSERT: number = 45;

	/**
		Constant associated with the key code value for the Delete key(46).
	**/
	public static readonly DELETE: number = 46;

	/** @hidden */
	public static readonly NUMLOCK: number = 144;

	/**
		Constant associated with the key code value for the ; key(186).
	**/
	public static readonly SEMICOLON: number = 186;

	/**
		Constant associated with the key code value for the:Int = key(187).
	**/
	public static readonly EQUAL: number = 187;

	/**
		Constant associated with the key code value for the , key(188).
	**/
	public static readonly COMMA: number = 188;

	/**
		Constant associated with the key code value for the - key(189).
	**/
	public static readonly MINUS: number = 189;

	/**
		Constant associated with the key code value for the . key(190).
	**/
	public static readonly PERIOD: number = 190;

	/**
		Constant associated with the key code value for the / key(191).
	**/
	public static readonly SLASH: number = 191;

	/**
		Constant associated with the key code value for the ` key(192).
	**/
	public static readonly BACKQUOTE: number = 192;

	/**
		Constant associated with the key code value for the [ key(219).
	**/
	public static readonly LEFTBRACKET: number = 219;

	/**
		Constant associated with the key code value for the \ key(220).
	**/
	public static readonly BACKSLASH: number = 220;

	/**
		Constant associated with the key code value for the ] key(221).
	**/
	public static readonly RIGHTBRACKET: number = 221;

	/**
		Constant associated with the key code value for the ' key(222).
	**/
	public static readonly QUOTE: number = 222;

	/**
		Specifies whether the last key pressed is accessible by other SWF files.
		By default, security restrictions prevent code from a SWF file in one
		domain from accessing a keystroke generated from a SWF file in another
		domain.

		@return The value `true` if the last key pressed can be
				accessed. If access is not permitted, this method returns
				`false`.
	**/
	public static isAccessible(): boolean
	{
		// default browser security restrictions are always enforced
		return false;
	}

	protected static __capsLock: boolean;
	protected static __numLock: boolean;

	// Get & Set Methods

	/**
		Specifies whether the Caps Lock key is activated(`true`) or
		not(`false`).
	**/
	public static get capsLock(): boolean
	{
		return Keyboard.__capsLock;
	}

	/**
		Specifies whether the Num Lock key is activated(`true`) or not
		(`false`).
	**/
	public static numLock(): boolean
	{
		return Keyboard.__numLock;
	}
}
