/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.ui;
#if display


/**
 * The Keyboard class is used to build an interface that can be controlled by
 * a user with a standard keyboard. You can use the methods and properties of
 * the Keyboard class without using a constructor. The properties of the
 * Keyboard class are constants representing the keys that are most commonly
 * used to control games.
 */
extern class Keyboard {

	/**
	 * Constant associated with the key code value for the A key(65).
	 */
	@:require(flash10_1) static var A : UInt;

	/**
	 * Constant associated with the key code value for the Alternate(Option) key
	 * (18).
	 */
	@:require(flash10_1) static var ALTERNATE : UInt;

	/**
	 * Constant associated with the key code value for the B key(66).
	 */
	@:require(flash10_1) static var B : UInt;

	/**
	 * Constant associated with the key code value for the ` key(192).
	 */
	@:require(flash10_1) static var BACKQUOTE : UInt;

	/**
	 * Constant associated with the key code value for the \ key(220).
	 */
	@:require(flash10_1) static var BACKSLASH : UInt;

	/**
	 * Constant associated with the key code value for the Backspace key(8).
	 */
	static var BACKSPACE : UInt;

	/**
	 * Constant associated with the key code value for the C key(67).
	 */
	@:require(flash10_1) static var C : UInt;

	/**
	 * Constant associated with the key code value for the Caps Lock key(20).
	 */
	static var CAPS_LOCK : UInt;

	/**
	 * Constant associated with the key code value for the , key(188).
	 */
	@:require(flash10_1) static var COMMA : UInt;

	/**
	 * Constant associated with the Mac command key(15). This constant is
	 * currently only used for setting menu key equivalents.
	 */
	@:require(flash10_1) static var COMMAND : UInt;

	/**
	 * Constant associated with the key code value for the Control key(17).
	 */
	static var CONTROL : UInt;

	/**
	 * Constant associated with the key code value for the D key(68).
	 */
	@:require(flash10_1) static var D : UInt;

	/**
	 * Constant associated with the key code value for the Delete key(46).
	 */
	static var DELETE : UInt;

	/**
	 * Constant associated with the key code value for the Down Arrow key(40).
	 */
	static var DOWN : UInt;

	/**
	 * Constant associated with the key code value for the E key(69).
	 */
	@:require(flash10_1) static var E : UInt;

	/**
	 * Constant associated with the key code value for the End key(35).
	 */
	static var END : UInt;

	/**
	 * Constant associated with the key code value for the Enter key(13).
	 */
	static var ENTER : UInt;

	/**
	 * Constant associated with the key code value for the = key(187).
	 */
	@:require(flash10_1) static var EQUAL : UInt;

	/**
	 * Constant associated with the key code value for the Escape key(27).
	 */
	static var ESCAPE : UInt;

	/**
	 * Constant associated with the key code value for the F key(70).
	 */
	@:require(flash10_1) static var F : UInt;

	/**
	 * Constant associated with the key code value for the F1 key(112).
	 */
	static var F1 : UInt;

	/**
	 * Constant associated with the key code value for the F10 key(121).
	 */
	static var F10 : UInt;

	/**
	 * Constant associated with the key code value for the F11 key(122).
	 */
	static var F11 : UInt;

	/**
	 * Constant associated with the key code value for the F12 key(123).
	 */
	static var F12 : UInt;

	/**
	 * Constant associated with the key code value for the F13 key(124).
	 */
	static var F13 : UInt;

	/**
	 * Constant associated with the key code value for the F14 key(125).
	 */
	static var F14 : UInt;

	/**
	 * Constant associated with the key code value for the F15 key(126).
	 */
	static var F15 : UInt;

	/**
	 * Constant associated with the key code value for the F2 key(113).
	 */
	static var F2 : UInt;

	/**
	 * Constant associated with the key code value for the F3 key(114).
	 */
	static var F3 : UInt;

	/**
	 * Constant associated with the key code value for the F4 key(115).
	 */
	static var F4 : UInt;

	/**
	 * Constant associated with the key code value for the F5 key(116).
	 */
	static var F5 : UInt;

	/**
	 * Constant associated with the key code value for the F6 key(117).
	 */
	static var F6 : UInt;

	/**
	 * Constant associated with the key code value for the F7 key(118).
	 */
	static var F7 : UInt;

	/**
	 * Constant associated with the key code value for the F8 key(119).
	 */
	static var F8 : UInt;

	/**
	 * Constant associated with the key code value for the F9 key(120).
	 */
	static var F9 : UInt;

	/**
	 * Constant associated with the key code value for the G key(71).
	 */
	@:require(flash10_1) static var G : UInt;

	/**
	 * Constant associated with the key code value for the H key(72).
	 */
	@:require(flash10_1) static var H : UInt;

	/**
	 * Constant associated with the key code value for the Home key(36).
	 */
	static var HOME : UInt;

	/**
	 * Constant associated with the key code value for the I key(73).
	 */
	@:require(flash10_1) static var I : UInt;

	/**
	 * Constant associated with the key code value for the Insert key(45).
	 */
	static var INSERT : UInt;

	/**
	 * Constant associated with the key code value for the J key(74).
	 */
	@:require(flash10_1) static var J : UInt;

	/**
	 * Constant associated with the key code value for the K key(75).
	 */
	@:require(flash10_1) static var K : UInt;
	
	/**
	 * Constant associated with the key code value for the L key(76).
	 */
	@:require(flash10_1) static var L : UInt;

	/**
	 * Constant associated with the key code value for the Left Arrow key(37).
	 */
	static var LEFT : UInt;

	/**
	 * Constant associated with the key code value for the [ key(219).
	 */
	@:require(flash10_1) static var LEFTBRACKET : UInt;

	/**
	 * Constant associated with the key code value for the M key(77).
	 */
	@:require(flash10_1) static var M : UInt;

	/**
	 * Constant associated with the key code value for the - key(189).
	 */
	@:require(flash10_1) static var MINUS : UInt;

	/**
	 * Constant associated with the key code value for the N key(78).
	 */
	@:require(flash10_1) static var N : UInt;

	/**
	 * Constant associated with the key code value for the 0 key(48).
	 */
	@:require(flash10_1) static var NUMBER_0 : UInt;

	/**
	 * Constant associated with the key code value for the 1 key(49).
	 */
	@:require(flash10_1) static var NUMBER_1 : UInt;

	/**
	 * Constant associated with the key code value for the 2 key(50).
	 */
	@:require(flash10_1) static var NUMBER_2 : UInt;

	/**
	 * Constant associated with the key code value for the 3 key(51).
	 */
	@:require(flash10_1) static var NUMBER_3 : UInt;

	/**
	 * Constant associated with the key code value for the 4 key(52).
	 */
	@:require(flash10_1) static var NUMBER_4 : UInt;

	/**
	 * Constant associated with the key code value for the 5 key(53).
	 */
	@:require(flash10_1) static var NUMBER_5 : UInt;

	/**
	 * Constant associated with the key code value for the 6 key(54).
	 */
	@:require(flash10_1) static var NUMBER_6 : UInt;

	/**
	 * Constant associated with the key code value for the 7 key(55).
	 */
	@:require(flash10_1) static var NUMBER_7 : UInt;

	/**
	 * Constant associated with the key code value for the 8 key(56).
	 */
	@:require(flash10_1) static var NUMBER_8 : UInt;

	/**
	 * Constant associated with the key code value for the 9 key(57).
	 */
	@:require(flash10_1) static var NUMBER_9 : UInt;

	/**
	 * Constant associated with the pseudo-key code for the the number pad(21).
	 * Use to set numpad modifier on key equivalents
	 */
	@:require(flash10_1) static var NUMPAD : UInt;

	/**
	 * Constant associated with the key code value for the number 0 key on the
	 * number pad(96).
	 */
	static var NUMPAD_0 : UInt;

	/**
	 * Constant associated with the key code value for the number 1 key on the
	 * number pad(97).
	 */
	static var NUMPAD_1 : UInt;

	/**
	 * Constant associated with the key code value for the number 2 key on the
	 * number pad(98).
	 */
	static var NUMPAD_2 : UInt;

	/**
	 * Constant associated with the key code value for the number 3 key on the
	 * number pad(99).
	 */
	static var NUMPAD_3 : UInt;

	/**
	 * Constant associated with the key code value for the number 4 key on the
	 * number pad(100).
	 */
	static var NUMPAD_4 : UInt;

	/**
	 * Constant associated with the key code value for the number 5 key on the
	 * number pad(101).
	 */
	static var NUMPAD_5 : UInt;

	/**
	 * Constant associated with the key code value for the number 6 key on the
	 * number pad(102).
	 */
	static var NUMPAD_6 : UInt;

	/**
	 * Constant associated with the key code value for the number 7 key on the
	 * number pad(103).
	 */
	static var NUMPAD_7 : UInt;

	/**
	 * Constant associated with the key code value for the number 8 key on the
	 * number pad(104).
	 */
	static var NUMPAD_8 : UInt;

	/**
	 * Constant associated with the key code value for the number 9 key on the
	 * number pad(105).
	 */
	static var NUMPAD_9 : UInt;

	/**
	 * Constant associated with the key code value for the addition key on the
	 * number pad(107).
	 */
	static var NUMPAD_ADD : UInt;

	/**
	 * Constant associated with the key code value for the decimal key on the
	 * number pad(110).
	 */
	static var NUMPAD_DECIMAL : UInt;

	/**
	 * Constant associated with the key code value for the division key on the
	 * number pad(111).
	 */
	static var NUMPAD_DIVIDE : UInt;

	/**
	 * Constant associated with the key code value for the Enter key on the
	 * number pad(108).
	 */
	static var NUMPAD_ENTER : UInt;

	/**
	 * Constant associated with the key code value for the multiplication key on
	 * the number pad(106).
	 */
	static var NUMPAD_MULTIPLY : UInt;

	/**
	 * Constant associated with the key code value for the subtraction key on the
	 * number pad(109).
	 */
	static var NUMPAD_SUBTRACT : UInt;

	/**
	 * Constant associated with the key code value for the O key(79).
	 */
	@:require(flash10_1) static var O : UInt;

	/**
	 * Constant associated with the key code value for the P key(80).
	 */
	@:require(flash10_1) static var P : UInt;

	/**
	 * Constant associated with the key code value for the Page Down key(34).
	 */
	static var PAGE_DOWN : UInt;

	/**
	 * Constant associated with the key code value for the Page Up key(33).
	 */
	static var PAGE_UP : UInt;

	/**
	 * Constant associated with the key code value for the . key(190).
	 */
	@:require(flash10_1) static var PERIOD : UInt;

	/**
	 * Constant associated with the key code value for the Q key(81).
	 */
	@:require(flash10_1) static var Q : UInt;

	/**
	 * Constant associated with the key code value for the ' key(222).
	 */
	@:require(flash10_1) static var QUOTE : UInt;

	/**
	 * Constant associated with the key code value for the R key(82).
	 */
	@:require(flash10_1) static var R : UInt;

	/**
	 * Constant associated with the key code value for the Right Arrow key(39).
	 */
	static var RIGHT : UInt;

	/**
	 * Constant associated with the key code value for the ] key(221).
	 */
	@:require(flash10_1) static var RIGHTBRACKET : UInt;

	/**
	 * Constant associated with the key code value for the S key(83).
	 */
	@:require(flash10_1) static var S : UInt;

	/**
	 * Constant associated with the key code value for the ; key(186).
	 */
	@:require(flash10_1) static var SEMICOLON : UInt;

	/**
	 * Engage setup application or menu
	 */
	@:require(flash10_2) static var SETUP : UInt;

	/**
	 * Constant associated with the key code value for the Shift key(16).
	 */
	static var SHIFT : UInt;

	/**
	 * Constant associated with the key code value for the / key(191).
	 */
	@:require(flash10_1) static var SLASH : UInt;

	/**
	 * Constant associated with the key code value for the Spacebar(32).
	 */
	static var SPACE : UInt;
	
	/**
	 * Constant associated with the key code value for the T key(84).
	 */
	@:require(flash10_1) static var T : UInt;

	/**
	 * Constant associated with the key code value for the Tab key(9).
	 */
	static var TAB : UInt;

	/**
	 * Constant associated with the key code value for the U key(85).
	 */
	@:require(flash10_1) static var U : UInt;

	/**
	 * Constant associated with the key code value for the Up Arrow key(38).
	 */
	static var UP : UInt;

	/**
	 * Constant associated with the key code value for the V key(86).
	 */
	@:require(flash10_1) static var V : UInt;

	/**
	 * Constant associated with the key code value for the W key(87).
	 */
	@:require(flash10_1) static var W : UInt;

	/**
	 * Constant associated with the key code value for the X key(88).
	 */
	@:require(flash10_1) static var X : UInt;

	/**
	 * Constant associated with the key code value for the Y key(89).
	 */
	@:require(flash10_1) static var Y : UInt;

	/**
	 * Constant associated with the key code value for the Z key(90).
	 */
	@:require(flash10_1) static var Z : UInt;
}


#end
