package openfl.ui;

#if !flash
#if lime
import lime.ui.KeyCode;
#end

/**
	The Keyboard class is used to build an interface that can be controlled by
	a user with a standard keyboard. You can use the methods and properties of
	the Keyboard class without using a constructor. The properties of the
	Keyboard class are constants representing the keys that are most commonly
	used to control games.

	@see [Capturing keyboard input](https://books.openfl.org/openfl-developers-guide/keyboard-input/capturing-keyboard-input.html)
	@see `openfl.events.KeyboardEvent`
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Keyboard
{
	/**
		Constant associated with the key code value for the 0 key(48).
	**/
	public static inline var NUMBER_0:Int = 48;

	/**
		Constant associated with the key code value for the 1 key(49).
	**/
	public static inline var NUMBER_1:Int = 49;

	/**
		Constant associated with the key code value for the 2 key(50).
	**/
	public static inline var NUMBER_2:Int = 50;

	/**
		Constant associated with the key code value for the 3 key(51).
	**/
	public static inline var NUMBER_3:Int = 51;

	/**
		Constant associated with the key code value for the 4 key(52).
	**/
	public static inline var NUMBER_4:Int = 52;

	/**
		Constant associated with the key code value for the 5 key(53).
	**/
	public static inline var NUMBER_5:Int = 53;

	/**
		Constant associated with the key code value for the 6 key(54).
	**/
	public static inline var NUMBER_6:Int = 54;

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
		Constant associated with the key code value for the Alternate (Option) key
		(18).
	**/
	public static inline var ALTERNATE:Int = 18;

	/**
		Constant associated with the key code value for the Enter key(13).
	**/
	public static inline var ENTER:Int = 13;

	/**
		Constant associated with the Mac command key (15). This constant is
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

	/**
		Constant associated with the key code value for the red function key
		button on a remote control or similar input device (0x01000000).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var RED:Int = 0x01000000;

	/**
		Constant associated with the key code value for the green function key
		button on a remote control or similar input device (0x01000001).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var GREEN:Int = 0x01000001;

	/**
		Constant associated with the key code value for the yellow function
		key button on a remote control or similar input device (0x01000002).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var YELLOW:Int = 0x01000002;

	/**
		Constant associated with the key code value for the blue function key
		button on a remote control or similar input device (0x01000003).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var BLUE:Int = 0x01000003;

	/**
		Constant associated with the key code value for the channel up button
		on a remote control or similar input device (0x01000004).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var CHANNEL_UP:Int = 0x01000004;

	/**
		Constant associated with the key code value for the channel down
		button on a remote control or similar input device (0x01000005).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var CHANNEL_DOWN:Int = 0x01000005;

	/**
		Constant associated with the key code value for the button for
		recording or engaging record transport mode on a remote control or
		similar input device (0x01000006).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var RECORD:Int = 0x01000006;

	/**
		Constant associated with the key code value for the button for
		engaging play transport mode on a remote control or similar input
		device (0x01000007).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var PLAY:Int = 0x01000007;

	/**
		Constant associated with the key code value for the button for
		engaging pause transport mode on a remote control or similar input
		device (0x01000008).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var PAUSE:Int = 0x01000008;

	/**
		Constant associated with the key code value for the button for
		engaging stop transport mode on a remote control or similar input
		device (0x01000009).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var STOP:Int = 0x01000009;

	/**
		Constant associated with the key code value for the button for
		engaging fast-forward transport mode on a remote control or similar
		input device (0x0100000A).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var FAST_FORWARD:Int = 0x0100000A;

	/**
		Constant associated with the key code value for the button for
		engaging rewind transport mode on a remote control or similar input
		device (0x0100000B).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var REWIND:Int = 0x0100000B;

	/**
		Constant associated with the key code value for the button for
		engaging quick skip ahead on a remote control or similar input device
		(0x0100000C).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var SKIP_FORWARD:Int = 0x0100000C;

	/**
		Constant associated with the key code value for the button for
		engaging quick skip backward on a remote control or similar input
		device (0x0100000D).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var SKIP_BACKWARD:Int = 0x0100000D;

	/**
		Constant associated with the key code value for the button for
		engaging next track transport mode on a remote control or similar
		input device (0x0100000E).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var NEXT:Int = 0x0100000E;

	/**
		Constant associated with the key code value for the button for
		engaging previous track transport mode on a remote control or similar
		input device (0x0100000F).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var PREVIOUS:Int = 0x0100000F;

	/**
		Constant associated with the key code value for the button for
		returning to live on a remote control or similar input device
		(0x01000010).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var LIVE:Int = 0x01000010;

	/**
		Constant associated with the key code value for the button for
		watching the last channel or show watched on a remote control or
		similar input device (0x01000011).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var LAST:Int = 0x01000011;

	/**
		Constant associated with the key code value for the button for
		engaging the menu on a remote control or similar input device
		(0x01000012).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var MENU:Int = 0x01000012;

	/**
		Constant associated with the key code value for the info button on a
		remote control or similar input device (0x01000013).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var INFO:Int = 0x01000013;

	/**
		Constant associated with the key code value for the button for
		engaging the program guide on a remote control or similar input device
		(0x01000014).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var GUIDE:Int = 0x01000014;

	/**
		Constant associated with the key code value for the button for exiting
		the current application mode on a remote control or similar input
		device (0x01000015).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var EXIT:Int = 0x01000015;

	/**
		Constant associated with the key code value for the button for
		returning to the previous page in the application on a remote control
		or similar input device (0x01000016).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var BACK:Int = 0x01000016;

	/**
		Constant associated with the key code value for the button for
		selecting the audio mode on a remote control or similar input device
		(0x01000017).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var AUDIO:Int = 0x01000017;

	/**
		Constant associated with the key code value for the button for
		toggling subtitles on a remote control or similar input device
		(0x01000018).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var SUBTITLE:Int = 0x01000018;

	/**
		Constant associated with the key code value for the button for
		engaging DVR application mode on a remote control or similar input
		device (0x01000019).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var DVR:Int = 0x01000019;

	/**
		Constant associated with the key code value for the button for
		engaging video on demand on a remote control or similar input device
		(0x0100001A).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var VOD:Int = 0x0100001A;

	/**
		Constant associated with the key code value for the button for cycling
		inputs on a remote control or similar input device (0x0100001B).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var INPUT:Int = 0x0100001B;

	/**
		Constant associated with the key code value for the button for
		engaging the setup application or menu on a remote control or similar
		input device (0x0100001C).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var SETUP:Int = 0x0100001C;

	/**
		Constant associated with the key code value for the button for
		engaging the help application or context-sensitive help on a remote
		control or similar input device (0x0100001D).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var HELP:Int = 0x0100001D;

	/**
		Constant associated with the key code value for the button for
		engaging the "Master Shell" (for example, a vendor-specific button) on
		a remote control or similar input device (0x0100001E).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var MASTER_SHELL:Int = 0x0100001E;

	/**
		Constant associated with the key code value for the button for
		initiating a search on a remote control or similar input device
		(0x0100001F).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var SEARCH:Int = 0x0100001F;

	/**
		Constant associated with the key code value for the button for
		engaging play/pause on a remote control or similar input device
		(0x01000020).

		OpenFL does not currently report this key code from native input
		events.
	**/
	public static inline var PLAY_PAUSE:Int = 0x01000020;

	/**
		The name of the F1 key (`"F1"`).
	**/
	public static inline var KEYNAME_F1:String = "F1";

	/**
		The name of the F2 key (`"F2"`).
	**/
	public static inline var KEYNAME_F2:String = "F2";

	/**
		The name of the F3 key (`"F3"`).
	**/
	public static inline var KEYNAME_F3:String = "F3";

	/**
		The name of the F4 key (`"F4"`).
	**/
	public static inline var KEYNAME_F4:String = "F4";

	/**
		The name of the F5 key (`"F5"`).
	**/
	public static inline var KEYNAME_F5:String = "F5";

	/**
		The name of the F6 key (`"F6"`).
	**/
	public static inline var KEYNAME_F6:String = "F6";

	/**
		The name of the F7 key (`"F7"`).
	**/
	public static inline var KEYNAME_F7:String = "F7";

	/**
		The name of the F8 key (`"F8"`).
	**/
	public static inline var KEYNAME_F8:String = "F8";

	/**
		The name of the F9 key (`"F9"`).
	**/
	public static inline var KEYNAME_F9:String = "F9";

	/**
		The name of the F10 key (`"F10"`).
	**/
	public static inline var KEYNAME_F10:String = "F10";

	/**
		The name of the F11 key (`"F11"`).
	**/
	public static inline var KEYNAME_F11:String = "F11";

	/**
		The name of the F12 key (`"F12"`).
	**/
	public static inline var KEYNAME_F12:String = "F12";

	/**
		The name of the F13 key (`"F13"`).
	**/
	public static inline var KEYNAME_F13:String = "F13";

	/**
		The name of the F14 key (`"F14"`).
	**/
	public static inline var KEYNAME_F14:String = "F14";

	/**
		The name of the F15 key (`"F15"`).
	**/
	public static inline var KEYNAME_F15:String = "F15";

	/**
		The name of the F16 key (`"F16"`).
	**/
	public static inline var KEYNAME_F16:String = "F16";

	/**
		The name of the F17 key (`"F17"`).
	**/
	public static inline var KEYNAME_F17:String = "F17";

	/**
		The name of the F18 key (`"F18"`).
	**/
	public static inline var KEYNAME_F18:String = "F18";

	/**
		The name of the F19 key (`"F19"`).
	**/
	public static inline var KEYNAME_F19:String = "F19";

	/**
		The name of the F20 key (`"F20"`).
	**/
	public static inline var KEYNAME_F20:String = "F20";

	/**
		The name of the F21 key (`"F21"`).
	**/
	public static inline var KEYNAME_F21:String = "F21";

	/**
		The name of the F22 key (`"F22"`).
	**/
	public static inline var KEYNAME_F22:String = "F22";

	/**
		The name of the F23 key (`"F23"`).
	**/
	public static inline var KEYNAME_F23:String = "F23";

	/**
		The name of the F24 key (`"F24"`).
	**/
	public static inline var KEYNAME_F24:String = "F24";

	/**
		The name of the F25 key (`"F25"`).
	**/
	public static inline var KEYNAME_F25:String = "F25";

	/**
		The name of the F26 key (`"F26"`).
	**/
	public static inline var KEYNAME_F26:String = "F26";

	/**
		The name of the F27 key (`"F27"`).
	**/
	public static inline var KEYNAME_F27:String = "F27";

	/**
		The name of the F28 key (`"F28"`).
	**/
	public static inline var KEYNAME_F28:String = "F28";

	/**
		The name of the F29 key (`"F29"`).
	**/
	public static inline var KEYNAME_F29:String = "F29";

	/**
		The name of the F30 key (`"F30"`).
	**/
	public static inline var KEYNAME_F30:String = "F30";

	/**
		The name of the F31 key (`"F31"`).
	**/
	public static inline var KEYNAME_F31:String = "F31";

	/**
		The name of the F32 key (`"F32"`).
	**/
	public static inline var KEYNAME_F32:String = "F32";

	/**
		The name of the F33 key (`"F33"`).
	**/
	public static inline var KEYNAME_F33:String = "F33";

	/**
		The name of the F34 key (`"F34"`).
	**/
	public static inline var KEYNAME_F34:String = "F34";

	/**
		The name of the F35 key (`"F35"`).
	**/
	public static inline var KEYNAME_F35:String = "F35";

	/**
		The name of the Begin key (`"Begin"`).
	**/
	public static inline var KEYNAME_BEGIN:String = "Begin";

	/**
		The name of the Break key (`"Break"`).
	**/
	public static inline var KEYNAME_BREAK:String = "Break";

	/**
		The name of the Clear Display key (`"ClrDsp"`).
	**/
	public static inline var KEYNAME_CLEARDISPLAY:String = "ClrDsp";

	/**
		The name of the Clear Line key (`"ClrLn"`).
	**/
	public static inline var KEYNAME_CLEARLINE:String = "ClrLn";

	/**
		The name of the Delete key (`"Delete"`).
	**/
	public static inline var KEYNAME_DELETE:String = "Delete";

	/**
		The name of the Delete Character key (`"DelChr"`).
	**/
	public static inline var KEYNAME_DELETECHAR:String = "DelChr";

	/**
		The name of the Delete Line key (`"DelLn"`).
	**/
	public static inline var KEYNAME_DELETELINE:String = "DelLn";

	/**
		The name of the Down Arrow key (`"Down"`).
	**/
	public static inline var KEYNAME_DOWNARROW:String = "Down";

	/**
		The name of the End key (`"End"`).
	**/
	public static inline var KEYNAME_END:String = "End";

	/**
		The name of the Execute key (`"Exec"`).
	**/
	public static inline var KEYNAME_EXECUTE:String = "Exec";

	/**
		The name of the Find key (`"Find"`).
	**/
	public static inline var KEYNAME_FIND:String = "Find";

	/**
		The name of the Help key (`"Help"`).
	**/
	public static inline var KEYNAME_HELP:String = "Help";

	/**
		The name of the Home key (`"Home"`).
	**/
	public static inline var KEYNAME_HOME:String = "Home";

	/**
		The name of the Insert key (`"Insert"`).
	**/
	public static inline var KEYNAME_INSERT:String = "Insert";

	/**
		The name of the Insert Character key (`"InsChr"`).
	**/
	public static inline var KEYNAME_INSERTCHAR:String = "InsChr";

	/**
		The name of the Insert Line key (`"InsLn"`).
	**/
	public static inline var KEYNAME_INSERTLINE:String = "InsLn";

	/**
		The name of the Left Arrow key (`"Left"`).
	**/
	public static inline var KEYNAME_LEFTARROW:String = "Left";

	/**
		The name of the Menu key (`"Menu"`).
	**/
	public static inline var KEYNAME_MENU:String = "Menu";

	/**
		The name of the Mode Switch key (`"ModeSw"`).
	**/
	public static inline var KEYNAME_MODESWITCH:String = "ModeSw";

	/**
		The name of the Next key (`"Next"`).
	**/
	public static inline var KEYNAME_NEXT:String = "Next";

	/**
		The name of the Page Down key (`"PgDn"`).
	**/
	public static inline var KEYNAME_PAGEDOWN:String = "PgDn";

	/**
		The name of the Page Up key (`"PgUp"`).
	**/
	public static inline var KEYNAME_PAGEUP:String = "PgUp";

	/**
		The name of the Pause key (`"Pause"`).
	**/
	public static inline var KEYNAME_PAUSE:String = "Pause";

	/**
		The name of the Play/Pause key (`"PlayPause"`).
	**/
	public static inline var KEYNAME_PLAYPAUSE:String = "PlayPause";

	/**
		The name of the Previous key (`"Prev"`).
	**/
	public static inline var KEYNAME_PREV:String = "Prev";

	/**
		The name of the Print key (`"Print"`).
	**/
	public static inline var KEYNAME_PRINT:String = "Print";

	/**
		The name of the Print Screen key (`"PrntScrn"`).
	**/
	public static inline var KEYNAME_PRINTSCREEN:String = "PrntScrn";

	/**
		The name of the Redo key (`"Redo"`).
	**/
	public static inline var KEYNAME_REDO:String = "Redo";

	/**
		The name of the Reset key (`"Reset"`).
	**/
	public static inline var KEYNAME_RESET:String = "Reset";

	/**
		The name of the Right Arrow key (`"Right"`).
	**/
	public static inline var KEYNAME_RIGHTARROW:String = "Right";

	/**
		The name of the Scroll Lock key (`"ScrlLck"`).
	**/
	public static inline var KEYNAME_SCROLLLOCK:String = "ScrlLck";

	/**
		The name of the Select key (`"Select"`).
	**/
	public static inline var KEYNAME_SELECT:String = "Select";

	/**
		The name of the Stop key (`"Stop"`).
	**/
	public static inline var KEYNAME_STOP:String = "Stop";

	/**
		The name of the System Request key (`"SysReq"`).
	**/
	public static inline var KEYNAME_SYSREQ:String = "SysReq";

	/**
		The name of the System key (`"Sys"`).
	**/
	public static inline var KEYNAME_SYSTEM:String = "Sys";

	/**
		The name of the Undo key (`"Undo"`).
	**/
	public static inline var KEYNAME_UNDO:String = "Undo";

	/**
		The name of the Up Arrow key (`"Up"`).
	**/
	public static inline var KEYNAME_UPARROW:String = "Up";

	/**
		The name of the User key (`"User"`).
	**/
	public static inline var KEYNAME_USER:String = "User";

	/**
		The Unicode value that macOS uses for the Up Arrow function key
		(U+F700).
	**/
	public static var STRING_UPARROW(default, never):String = String.fromCharCode(0xF700);

	/**
		The Unicode value that macOS uses for the Down Arrow function key
		(U+F701).
	**/
	public static var STRING_DOWNARROW(default, never):String = String.fromCharCode(0xF701);

	/**
		The Unicode value that macOS uses for the Left Arrow function key
		(U+F702).
	**/
	public static var STRING_LEFTARROW(default, never):String = String.fromCharCode(0xF702);

	/**
		The Unicode value that macOS uses for the Right Arrow function key
		(U+F703).
	**/
	public static var STRING_RIGHTARROW(default, never):String = String.fromCharCode(0xF703);

	/**
		The Unicode value that macOS uses for the F1 function key (U+F704).
	**/
	public static var STRING_F1(default, never):String = String.fromCharCode(0xF704);

	/**
		The Unicode value that macOS uses for the F2 function key (U+F705).
	**/
	public static var STRING_F2(default, never):String = String.fromCharCode(0xF705);

	/**
		The Unicode value that macOS uses for the F3 function key (U+F706).
	**/
	public static var STRING_F3(default, never):String = String.fromCharCode(0xF706);

	/**
		The Unicode value that macOS uses for the F4 function key (U+F707).
	**/
	public static var STRING_F4(default, never):String = String.fromCharCode(0xF707);

	/**
		The Unicode value that macOS uses for the F5 function key (U+F708).
	**/
	public static var STRING_F5(default, never):String = String.fromCharCode(0xF708);

	/**
		The Unicode value that macOS uses for the F6 function key (U+F709).
	**/
	public static var STRING_F6(default, never):String = String.fromCharCode(0xF709);

	/**
		The Unicode value that macOS uses for the F7 function key (U+F70A).
	**/
	public static var STRING_F7(default, never):String = String.fromCharCode(0xF70A);

	/**
		The Unicode value that macOS uses for the F8 function key (U+F70B).
	**/
	public static var STRING_F8(default, never):String = String.fromCharCode(0xF70B);

	/**
		The Unicode value that macOS uses for the F9 function key (U+F70C).
	**/
	public static var STRING_F9(default, never):String = String.fromCharCode(0xF70C);

	/**
		The Unicode value that macOS uses for the F10 function key (U+F70D).
	**/
	public static var STRING_F10(default, never):String = String.fromCharCode(0xF70D);

	/**
		The Unicode value that macOS uses for the F11 function key (U+F70E).
	**/
	public static var STRING_F11(default, never):String = String.fromCharCode(0xF70E);

	/**
		The Unicode value that macOS uses for the F12 function key (U+F70F).
	**/
	public static var STRING_F12(default, never):String = String.fromCharCode(0xF70F);

	/**
		The Unicode value that macOS uses for the F13 function key (U+F710).
	**/
	public static var STRING_F13(default, never):String = String.fromCharCode(0xF710);

	/**
		The Unicode value that macOS uses for the F14 function key (U+F711).
	**/
	public static var STRING_F14(default, never):String = String.fromCharCode(0xF711);

	/**
		The Unicode value that macOS uses for the F15 function key (U+F712).
	**/
	public static var STRING_F15(default, never):String = String.fromCharCode(0xF712);

	/**
		The Unicode value that macOS uses for the F16 function key (U+F713).
	**/
	public static var STRING_F16(default, never):String = String.fromCharCode(0xF713);

	/**
		The Unicode value that macOS uses for the F17 function key (U+F714).
	**/
	public static var STRING_F17(default, never):String = String.fromCharCode(0xF714);

	/**
		The Unicode value that macOS uses for the F18 function key (U+F715).
	**/
	public static var STRING_F18(default, never):String = String.fromCharCode(0xF715);

	/**
		The Unicode value that macOS uses for the F19 function key (U+F716).
	**/
	public static var STRING_F19(default, never):String = String.fromCharCode(0xF716);

	/**
		The Unicode value that macOS uses for the F20 function key (U+F717).
	**/
	public static var STRING_F20(default, never):String = String.fromCharCode(0xF717);

	/**
		The Unicode value that macOS uses for the F21 function key (U+F718).
	**/
	public static var STRING_F21(default, never):String = String.fromCharCode(0xF718);

	/**
		The Unicode value that macOS uses for the F22 function key (U+F719).
	**/
	public static var STRING_F22(default, never):String = String.fromCharCode(0xF719);

	/**
		The Unicode value that macOS uses for the F23 function key (U+F71A).
	**/
	public static var STRING_F23(default, never):String = String.fromCharCode(0xF71A);

	/**
		The Unicode value that macOS uses for the F24 function key (U+F71B).
	**/
	public static var STRING_F24(default, never):String = String.fromCharCode(0xF71B);

	/**
		The Unicode value that macOS uses for the F25 function key (U+F71C).
	**/
	public static var STRING_F25(default, never):String = String.fromCharCode(0xF71C);

	/**
		The Unicode value that macOS uses for the F26 function key (U+F71D).
	**/
	public static var STRING_F26(default, never):String = String.fromCharCode(0xF71D);

	/**
		The Unicode value that macOS uses for the F27 function key (U+F71E).
	**/
	public static var STRING_F27(default, never):String = String.fromCharCode(0xF71E);

	/**
		The Unicode value that macOS uses for the F28 function key (U+F71F).
	**/
	public static var STRING_F28(default, never):String = String.fromCharCode(0xF71F);

	/**
		The Unicode value that macOS uses for the F29 function key (U+F720).
	**/
	public static var STRING_F29(default, never):String = String.fromCharCode(0xF720);

	/**
		The Unicode value that macOS uses for the F30 function key (U+F721).
	**/
	public static var STRING_F30(default, never):String = String.fromCharCode(0xF721);

	/**
		The Unicode value that macOS uses for the F31 function key (U+F722).
	**/
	public static var STRING_F31(default, never):String = String.fromCharCode(0xF722);

	/**
		The Unicode value that macOS uses for the F32 function key (U+F723).
	**/
	public static var STRING_F32(default, never):String = String.fromCharCode(0xF723);

	/**
		The Unicode value that macOS uses for the F33 function key (U+F724).
	**/
	public static var STRING_F33(default, never):String = String.fromCharCode(0xF724);

	/**
		The Unicode value that macOS uses for the F34 function key (U+F725).
	**/
	public static var STRING_F34(default, never):String = String.fromCharCode(0xF725);

	/**
		The Unicode value that macOS uses for the F35 function key (U+F726).
	**/
	public static var STRING_F35(default, never):String = String.fromCharCode(0xF726);

	/**
		The Unicode value that macOS uses for the Insert function key
		(U+F727).
	**/
	public static var STRING_INSERT(default, never):String = String.fromCharCode(0xF727);

	/**
		The Unicode value that macOS uses for the Delete function key
		(U+F728).
	**/
	public static var STRING_DELETE(default, never):String = String.fromCharCode(0xF728);

	/**
		The Unicode value that macOS uses for the Home function key (U+F729).
	**/
	public static var STRING_HOME(default, never):String = String.fromCharCode(0xF729);

	/**
		The Unicode value that macOS uses for the Begin function key (U+F72A).
	**/
	public static var STRING_BEGIN(default, never):String = String.fromCharCode(0xF72A);

	/**
		The Unicode value that macOS uses for the End function key (U+F72B).
	**/
	public static var STRING_END(default, never):String = String.fromCharCode(0xF72B);

	/**
		The Unicode value that macOS uses for the Page Up function key
		(U+F72C).
	**/
	public static var STRING_PAGEUP(default, never):String = String.fromCharCode(0xF72C);

	/**
		The Unicode value that macOS uses for the Page Down function key
		(U+F72D).
	**/
	public static var STRING_PAGEDOWN(default, never):String = String.fromCharCode(0xF72D);

	/**
		The Unicode value that macOS uses for the Print Screen function key
		(U+F72E).
	**/
	public static var STRING_PRINTSCREEN(default, never):String = String.fromCharCode(0xF72E);

	/**
		The Unicode value that macOS uses for the Scroll Lock function key
		(U+F72F).
	**/
	public static var STRING_SCROLLLOCK(default, never):String = String.fromCharCode(0xF72F);

	/**
		The Unicode value that macOS uses for the Pause function key (U+F730).
	**/
	public static var STRING_PAUSE(default, never):String = String.fromCharCode(0xF730);

	/**
		The Unicode value that macOS uses for the System Request function key
		(U+F731).
	**/
	public static var STRING_SYSREQ(default, never):String = String.fromCharCode(0xF731);

	/**
		The Unicode value that macOS uses for the Break function key (U+F732).
	**/
	public static var STRING_BREAK(default, never):String = String.fromCharCode(0xF732);

	/**
		The Unicode value that macOS uses for the Reset function key (U+F733).
	**/
	public static var STRING_RESET(default, never):String = String.fromCharCode(0xF733);

	/**
		The Unicode value that macOS uses for the Stop function key (U+F734).
	**/
	public static var STRING_STOP(default, never):String = String.fromCharCode(0xF734);

	/**
		The Unicode value that macOS uses for the Menu function key (U+F735).
	**/
	public static var STRING_MENU(default, never):String = String.fromCharCode(0xF735);

	/**
		The Unicode value that macOS uses for the User function key (U+F736).
	**/
	public static var STRING_USER(default, never):String = String.fromCharCode(0xF736);

	/**
		The Unicode value that macOS uses for the System function key
		(U+F737).
	**/
	public static var STRING_SYSTEM(default, never):String = String.fromCharCode(0xF737);

	/**
		The Unicode value that macOS uses for the Print function key (U+F738).
	**/
	public static var STRING_PRINT(default, never):String = String.fromCharCode(0xF738);

	/**
		The Unicode value that macOS uses for the Clear Line function key
		(U+F739).
	**/
	public static var STRING_CLEARLINE(default, never):String = String.fromCharCode(0xF739);

	/**
		The Unicode value that macOS uses for the Clear Display function key
		(U+F73A).
	**/
	public static var STRING_CLEARDISPLAY(default, never):String = String.fromCharCode(0xF73A);

	/**
		The Unicode value that macOS uses for the Insert Line function key
		(U+F73B).
	**/
	public static var STRING_INSERTLINE(default, never):String = String.fromCharCode(0xF73B);

	/**
		The Unicode value that macOS uses for the Delete Line function key
		(U+F73C).
	**/
	public static var STRING_DELETELINE(default, never):String = String.fromCharCode(0xF73C);

	/**
		The Unicode value that macOS uses for the Insert Character function
		key (U+F73D).
	**/
	public static var STRING_INSERTCHAR(default, never):String = String.fromCharCode(0xF73D);

	/**
		The Unicode value that macOS uses for the Delete Character function
		key (U+F73E).
	**/
	public static var STRING_DELETECHAR(default, never):String = String.fromCharCode(0xF73E);

	/**
		The Unicode value that macOS uses for the Previous function key
		(U+F73F).
	**/
	public static var STRING_PREV(default, never):String = String.fromCharCode(0xF73F);

	/**
		The Unicode value that macOS uses for the Next function key (U+F740).
	**/
	public static var STRING_NEXT(default, never):String = String.fromCharCode(0xF740);

	/**
		The Unicode value that macOS uses for the Select function key
		(U+F741).
	**/
	public static var STRING_SELECT(default, never):String = String.fromCharCode(0xF741);

	/**
		The Unicode value that macOS uses for the Execute function key
		(U+F742).
	**/
	public static var STRING_EXECUTE(default, never):String = String.fromCharCode(0xF742);

	/**
		The Unicode value that macOS uses for the Undo function key (U+F743).
	**/
	public static var STRING_UNDO(default, never):String = String.fromCharCode(0xF743);

	/**
		The Unicode value that macOS uses for the Redo function key (U+F744).
	**/
	public static var STRING_REDO(default, never):String = String.fromCharCode(0xF744);

	/**
		The Unicode value that macOS uses for the Find function key (U+F745).
	**/
	public static var STRING_FIND(default, never):String = String.fromCharCode(0xF745);

	/**
		The Unicode value that macOS uses for the Help function key (U+F746).
	**/
	public static var STRING_HELP(default, never):String = String.fromCharCode(0xF746);

	/**
		The Unicode value that macOS uses for the Mode Switch function key
		(U+F747).
	**/
	public static var STRING_MODESWITCH(default, never):String = String.fromCharCode(0xF747);

	/**
		Specifies whether the Caps Lock key is activated (`true`) or
		not (`false`).
	**/
	public static var capsLock(default, null):Bool;

	/**
		Specifies whether the Num Lock key is activated (`true`) or not
		(`false`).
	**/
	public static var numLock(default, null):Bool;

	/**
		Indicates whether the computer or device provides a virtual keyboard.
		If the current environment provides a virtual keyboard, this value is
		`true`.

		In OpenFL, this is `true` on iOS and Android, and on HTML5 when the
		browser reports touch support.
	**/
	public static var hasVirtualKeyboard(get, never):Bool;

	/**
		Indicates the type of physical keyboard provided by the computer or
		device, if any.

		Use the constants in the KeyboardType class to test the values reported
		by this property.

		In OpenFL, this is `KeyboardType.NONE` on iOS and Android, and
		`KeyboardType.ALPHANUMERIC` everywhere else. A hardware keyboard
		attached to a mobile device is not detected.
	**/
	public static var physicalKeyboardType(get, never):KeyboardType;

	/**
		Specifies whether the last key pressed is accessible by other SWF files.
		By default, security restrictions prevent code from a SWF file in one
		domain from accessing a keystroke generated from a SWF file in another
		domain.

		@return The value `true` if the last key pressed can be
				accessed. If access is not permitted, this method returns
				`false`.
	**/
	public static function isAccessible():Bool
	{
		// default browser security restrictions are always enforced
		return false;
	}

	// Get & Set Methods
	@:noCompletion private static function get_hasVirtualKeyboard():Bool
	{
		#if mobile
		return true;
		#elseif (js && html5)
		var navigator:Dynamic = js.Browser.navigator;
		return navigator.maxTouchPoints != null && navigator.maxTouchPoints > 0;
		#else
		return false;
		#end
	}

	@:noCompletion private static function get_physicalKeyboardType():KeyboardType
	{
		#if mobile
		return KeyboardType.NONE;
		#else
		return KeyboardType.ALPHANUMERIC;
		#end
	}

	#if lime
	@:noCompletion private static inline function __convertKeyCode(key:KeyCode):Int
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
			// Windows VK_F16–VK_F24 (keep values in 0–255 Flash keyCode range)
			case KeyCode.F16: 0x7F;
			case KeyCode.F17: 0x80;
			case KeyCode.F18: 0x81;
			case KeyCode.F19: 0x82;
			case KeyCode.F20: 0x83;
			case KeyCode.F21: 0x84;
			case KeyCode.F22: 0x85;
			case KeyCode.F23: 0x86;
			case KeyCode.F24: 0x87;
			// case KeyCode.EXECUTE: 0x40000074;
			case KeyCode.HELP: 0x2F; // VK_HELP
			// case KeyCode.MENU: 0x40000076;
			case KeyCode.SELECT: 0x29; // VK_SELECT
			// case KeyCode.STOP: 0x40000078;
			// case KeyCode.AGAIN: 0x40000079;
			// case KeyCode.UNDO: 0x4000007A;
			// case KeyCode.CUT: 0x4000007B;
			// case KeyCode.COPY: 0x4000007C;
			// case KeyCode.PASTE: 0x4000007D;
			// case KeyCode.FIND: 0x4000007E;
			// Media / volume: Windows VK_* (also what desktop AIR reports)
			case KeyCode.MUTE: 0xAD; // VK_VOLUME_MUTE
			case KeyCode.VOLUME_UP: 0xAF; // VK_VOLUME_UP
			case KeyCode.VOLUME_DOWN: 0xAE; // VK_VOLUME_DOWN
			// case KeyCode.NUMPAD_COMMA: 0x40000085;
			////case KeyCode.NUMPAD_EQUALS_AS400: 0x40000086;
			// case KeyCode.ALT_ERASE: 0x40000099;
			case KeyCode.SYSTEM_REQUEST: 0x2C; // VK_SNAPSHOT
			// case KeyCode.CANCEL: 0x4000009B;
			case KeyCode.CLEAR: 0x0C; // VK_CLEAR
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
			case KeyCode.AUDIO_NEXT: 0xB0; // VK_MEDIA_NEXT_TRACK
			case KeyCode.AUDIO_PREVIOUS: 0xB1; // VK_MEDIA_PREV_TRACK
			case KeyCode.AUDIO_STOP: 0xB2; // VK_MEDIA_STOP
			case KeyCode.AUDIO_PLAY: 0xB3; // VK_MEDIA_PLAY_PAUSE
			case KeyCode.AUDIO_MUTE: 0xAD; // VK_VOLUME_MUTE
			case KeyCode.MEDIA_SELECT: 0xB5; // VK_LAUNCH_MEDIA_SELECT
			case KeyCode.WWW: 0xAC; // VK_BROWSER_HOME (closest)
			case KeyCode.MAIL: 0xB4; // VK_LAUNCH_MAIL
			// case KeyCode.CALCULATOR: 0x4000010A;
			// case KeyCode.COMPUTER: 0x4000010B;
			case KeyCode.APP_CONTROL_SEARCH: 0xAA; // VK_BROWSER_SEARCH
			case KeyCode.APP_CONTROL_HOME: 0xAC; // VK_BROWSER_HOME
			case KeyCode.APP_CONTROL_BACK: 0xA6; // VK_BROWSER_BACK
			case KeyCode.APP_CONTROL_FORWARD: 0xA7; // VK_BROWSER_FORWARD
			case KeyCode.APP_CONTROL_STOP: 0xA9; // VK_BROWSER_STOP
			case KeyCode.APP_CONTROL_REFRESH: 0xA8; // VK_BROWSER_REFRESH
			case KeyCode.APP_CONTROL_BOOKMARKS: 0xAB; // VK_BROWSER_FAVORITES
			// case KeyCode.BRIGHTNESS_DOWN: 0x40000113;
			// case KeyCode.BRIGHTNESS_UP: 0x40000114;
			// case KeyCode.DISPLAY_SWITCH: 0x40000115;
			// case KeyCode.BACKLIGHT_TOGGLE: 0x40000116;
			// case KeyCode.BACKLIGHT_DOWN: 0x40000117;
			// case KeyCode.BACKLIGHT_UP: 0x40000118;
			// case KeyCode.EJECT: 0x40000119;
			case KeyCode.SLEEP: 0x5F; // VK_SLEEP
			default:
				// SDL keycodes use bit 30 (0x40000000). Passing them through as
				// KeyboardEvent.keyCode is not Flash-compatible and can make
				// Flash-style key tables (e.g. Vector length 256) allocate ~1 GiB.
				var code:Int = cast key;
				if ((code & 0x40000000) != 0) return 0;
				// keys of non-ASCII layouts have the code of their character (339 for œ), but a
				// Flash keyCode, a virtual-key code, is below 256
				if (code > 0xFF) return 0;
				return code;
		}
	}
	#end

	@:noCompletion private static function __getCharCode(key:Int, shift:Bool = false, capsLock:Bool = false):Int
	{
		var effectiveShift = shift;

		if (key >= Keyboard.A && key <= Keyboard.Z)
		{
			effectiveShift = shift != capsLock; // XOR only for letters
		}

		if (!effectiveShift)
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

	#if lime
	@:noCompletion private static inline function __getKeyLocation(key:KeyCode):KeyLocation
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
	#end
}
#else
typedef Keyboard = flash.ui.Keyboard;
#end
