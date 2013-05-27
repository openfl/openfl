package flash.ui;
#if (flash || display)


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
	@:require(flash10_1) static var A : Int;

	/**
	 * Constant associated with the key code value for the Alternate(Option) key
	 * (18).
	 */
	@:require(flash10_1) static var ALTERNATE : Int;

	/**
	 * Select the audio mode
	 */
	#if !display
	@:require(flash10_2) static var AUDIO : Int;
	#end

	/**
	 * Constant associated with the key code value for the B key(66).
	 */
	@:require(flash10_1) static var B : Int;

	/**
	 * Return to previous page in application
	 */
	#if !display
	@:require(flash10_2) static var BACK : Int;
	#end

	/**
	 * Constant associated with the key code value for the ` key(192).
	 */
	@:require(flash10_1) static var BACKQUOTE : Int;

	/**
	 * Constant associated with the key code value for the \ key(220).
	 */
	@:require(flash10_1) static var BACKSLASH : Int;

	/**
	 * Constant associated with the key code value for the Backspace key(8).
	 */
	static var BACKSPACE : Int;

	/**
	 * Blue function key button
	 */
	#if !display
	@:require(flash10_2) static var BLUE : Int;
	#end

	/**
	 * Constant associated with the key code value for the C key(67).
	 */
	@:require(flash10_1) static var C : Int;

	/**
	 * Constant associated with the key code value for the Caps Lock key(20).
	 */
	static var CAPS_LOCK : Int;

	/**
	 * Channel down
	 */
	#if !display
	@:require(flash10_2) static var CHANNEL_DOWN : Int;
	#end

	/**
	 * Channel up
	 */
	#if !display
	@:require(flash10_2) static var CHANNEL_UP : Int;
	#end

	/**
	 * Constant associated with the key code value for the , key(188).
	 */
	@:require(flash10_1) static var COMMA : Int;

	/**
	 * Constant associated with the Mac command key(15). This constant is
	 * currently only used for setting menu key equivalents.
	 */
	@:require(flash10_1) static var COMMAND : Int;

	/**
	 * Constant associated with the key code value for the Control key(17).
	 */
	static var CONTROL : Int;

	/**
	 * An array containing all the defined key name constants.
	 */
	#if !display
	@:require(flash10_1) static var CharCodeStrings : Array<Dynamic>;
	#end

	/**
	 * Constant associated with the key code value for the D key(68).
	 */
	@:require(flash10_1) static var D : Int;

	/**
	 * Constant associated with the key code value for the Delete key(46).
	 */
	static var DELETE : Int;

	/**
	 * Constant associated with the key code value for the Down Arrow key(40).
	 */
	static var DOWN : Int;

	/**
	 * Engage DVR application mode
	 */
	#if !display
	@:require(flash10_2) static var DVR : Int;
	#end

	/**
	 * Constant associated with the key code value for the E key(69).
	 */
	@:require(flash10_1) static var E : Int;

	/**
	 * Constant associated with the key code value for the End key(35).
	 */
	static var END : Int;

	/**
	 * Constant associated with the key code value for the Enter key(13).
	 */
	static var ENTER : Int;

	/**
	 * Constant associated with the key code value for the = key(187).
	 */
	@:require(flash10_1) static var EQUAL : Int;

	/**
	 * Constant associated with the key code value for the Escape key(27).
	 */
	static var ESCAPE : Int;

	/**
	 * Exits current application mode
	 */
	#if !display
	@:require(flash10_2) static var EXIT : Int;
	#end

	/**
	 * Constant associated with the key code value for the F key(70).
	 */
	@:require(flash10_1) static var F : Int;

	/**
	 * Constant associated with the key code value for the F1 key(112).
	 */
	static var F1 : Int;

	/**
	 * Constant associated with the key code value for the F10 key(121).
	 */
	static var F10 : Int;

	/**
	 * Constant associated with the key code value for the F11 key(122).
	 */
	static var F11 : Int;

	/**
	 * Constant associated with the key code value for the F12 key(123).
	 */
	static var F12 : Int;

	/**
	 * Constant associated with the key code value for the F13 key(124).
	 */
	static var F13 : Int;

	/**
	 * Constant associated with the key code value for the F14 key(125).
	 */
	static var F14 : Int;

	/**
	 * Constant associated with the key code value for the F15 key(126).
	 */
	static var F15 : Int;

	/**
	 * Constant associated with the key code value for the F2 key(113).
	 */
	static var F2 : Int;

	/**
	 * Constant associated with the key code value for the F3 key(114).
	 */
	static var F3 : Int;

	/**
	 * Constant associated with the key code value for the F4 key(115).
	 */
	static var F4 : Int;

	/**
	 * Constant associated with the key code value for the F5 key(116).
	 */
	static var F5 : Int;

	/**
	 * Constant associated with the key code value for the F6 key(117).
	 */
	static var F6 : Int;

	/**
	 * Constant associated with the key code value for the F7 key(118).
	 */
	static var F7 : Int;

	/**
	 * Constant associated with the key code value for the F8 key(119).
	 */
	static var F8 : Int;

	/**
	 * Constant associated with the key code value for the F9 key(120).
	 */
	static var F9 : Int;

	/**
	 * Engage fast-forward transport mode
	 */
	#if !display
	@:require(flash10_2) static var FAST_FORWARD : Int;
	#end

	/**
	 * Constant associated with the key code value for the G key(71).
	 */
	@:require(flash10_1) static var G : Int;

	/**
	 * Green function key button
	 */
	#if !display
	@:require(flash10_2) static var GREEN : Int;
	#end

	/**
	 * Engage program guide
	 */
	#if !display
	@:require(flash10_2) static var GUIDE : Int;
	#end

	/**
	 * Constant associated with the key code value for the H key(72).
	 */
	@:require(flash10_1) static var H : Int;

	/**
	 * Engage help application or context-sensitive help
	 */
	#if !display
	@:require(flash10_2) static var HELP : Int;
	#end

	/**
	 * Constant associated with the key code value for the Home key(36).
	 */
	static var HOME : Int;

	/**
	 * Constant associated with the key code value for the I key(73).
	 */
	@:require(flash10_1) static var I : Int;

	/**
	 * Info button
	 */
	#if !display
	@:require(flash10_2) static var INFO : Int;
	#end

	/**
	 * Cycle input
	 */
	#if !display
	@:require(flash10_2) static var INPUT : Int;
	#end

	/**
	 * Constant associated with the key code value for the Insert key(45).
	 */
	static var INSERT : Int;

	/**
	 * Constant associated with the key code value for the J key(74).
	 */
	@:require(flash10_1) static var J : Int;

	/**
	 * Constant associated with the key code value for the K key(75).
	 */
	@:require(flash10_1) static var K : Int;
	
	#if !display
	/**
	 * The Begin key
	 */
	@:require(flash10_1) static var KEYNAME_BEGIN : String;

	/**
	 * The Break key
	 */
	@:require(flash10_1) static var KEYNAME_BREAK : String;

	/**
	 * The Clear Display key
	 */
	@:require(flash10_1) static var KEYNAME_CLEARDISPLAY : String;

	/**
	 * The Clear Line key
	 */
	@:require(flash10_1) static var KEYNAME_CLEARLINE : String;

	/**
	 * The Delete key
	 */
	@:require(flash10_1) static var KEYNAME_DELETE : String;

	/**
	 * The Delete Character key
	 */
	@:require(flash10_1) static var KEYNAME_DELETECHAR : String;

	/**
	 * The Delete Line key
	 */
	@:require(flash10_1) static var KEYNAME_DELETELINE : String;

	/**
	 * The down arrow
	 */
	@:require(flash10_1) static var KEYNAME_DOWNARROW : String;

	/**
	 * The End key
	 */
	@:require(flash10_1) static var KEYNAME_END : String;

	/**
	 * The Execute key
	 */
	@:require(flash10_1) static var KEYNAME_EXECUTE : String;

	/**
	 * The F1 key
	 */
	@:require(flash10_1) static var KEYNAME_F1 : String;

	/**
	 * The F10 key
	 */
	@:require(flash10_1) static var KEYNAME_F10 : String;

	/**
	 * The F11 key
	 */
	@:require(flash10_1) static var KEYNAME_F11 : String;

	/**
	 * The F12 key
	 */
	@:require(flash10_1) static var KEYNAME_F12 : String;

	/**
	 * The F13 key
	 */
	@:require(flash10_1) static var KEYNAME_F13 : String;

	/**
	 * The F14 key
	 */
	@:require(flash10_1) static var KEYNAME_F14 : String;

	/**
	 * The F15 key
	 */
	@:require(flash10_1) static var KEYNAME_F15 : String;

	/**
	 * The F16 key
	 */
	@:require(flash10_1) static var KEYNAME_F16 : String;

	/**
	 * The F17 key
	 */
	@:require(flash10_1) static var KEYNAME_F17 : String;

	/**
	 * The F18 key
	 */
	@:require(flash10_1) static var KEYNAME_F18 : String;

	/**
	 * The F19 key
	 */
	@:require(flash10_1) static var KEYNAME_F19 : String;

	/**
	 * The F2 key
	 */
	@:require(flash10_1) static var KEYNAME_F2 : String;

	/**
	 * The F20 key
	 */
	@:require(flash10_1) static var KEYNAME_F20 : String;

	/**
	 * The F21 key
	 */
	@:require(flash10_1) static var KEYNAME_F21 : String;

	/**
	 * The F22 key
	 */
	@:require(flash10_1) static var KEYNAME_F22 : String;

	/**
	 * The F23 key
	 */
	@:require(flash10_1) static var KEYNAME_F23 : String;

	/**
	 * The F24 key
	 */
	@:require(flash10_1) static var KEYNAME_F24 : String;

	/**
	 * The F25 key
	 */
	@:require(flash10_1) static var KEYNAME_F25 : String;

	/**
	 * The F26 key
	 */
	@:require(flash10_1) static var KEYNAME_F26 : String;

	/**
	 * The F27 key
	 */
	@:require(flash10_1) static var KEYNAME_F27 : String;

	/**
	 * The F28 key
	 */
	@:require(flash10_1) static var KEYNAME_F28 : String;

	/**
	 * The F29 key
	 */
	@:require(flash10_1) static var KEYNAME_F29 : String;

	/**
	 * The F3 key
	 */
	@:require(flash10_1) static var KEYNAME_F3 : String;

	/**
	 * The F30 key
	 */
	@:require(flash10_1) static var KEYNAME_F30 : String;

	/**
	 * The F31 key
	 */
	@:require(flash10_1) static var KEYNAME_F31 : String;

	/**
	 * The F32 key
	 */
	@:require(flash10_1) static var KEYNAME_F32 : String;

	/**
	 * The F33 key
	 */
	@:require(flash10_1) static var KEYNAME_F33 : String;

	/**
	 * The F34 key
	 */
	@:require(flash10_1) static var KEYNAME_F34 : String;

	/**
	 * The F35 key
	 */
	@:require(flash10_1) static var KEYNAME_F35 : String;

	/**
	 * The F4 key
	 */
	@:require(flash10_1) static var KEYNAME_F4 : String;

	/**
	 * The F5 key
	 */
	@:require(flash10_1) static var KEYNAME_F5 : String;

	/**
	 * The F6 key
	 */
	@:require(flash10_1) static var KEYNAME_F6 : String;

	/**
	 * The F7 key
	 */
	@:require(flash10_1) static var KEYNAME_F7 : String;

	/**
	 * The F8 key
	 */
	@:require(flash10_1) static var KEYNAME_F8 : String;

	/**
	 * The F9 key
	 */
	@:require(flash10_1) static var KEYNAME_F9 : String;

	/**
	 * The Find key
	 */
	@:require(flash10_1) static var KEYNAME_FIND : String;

	/**
	 * The Help key
	 */
	@:require(flash10_1) static var KEYNAME_HELP : String;

	/**
	 * The Home key
	 */
	@:require(flash10_1) static var KEYNAME_HOME : String;

	/**
	 * The Insert key
	 */
	@:require(flash10_1) static var KEYNAME_INSERT : String;

	/**
	 * The Insert Character key
	 */
	@:require(flash10_1) static var KEYNAME_INSERTCHAR : String;

	/**
	 * The Insert Line key
	 */
	@:require(flash10_1) static var KEYNAME_INSERTLINE : String;

	/**
	 * The left arrow
	 */
	@:require(flash10_1) static var KEYNAME_LEFTARROW : String;

	/**
	 * The Menu key
	 */
	@:require(flash10_1) static var KEYNAME_MENU : String;

	/**
	 * The Mode Switch key
	 */
	@:require(flash10_1) static var KEYNAME_MODESWITCH : String;

	/**
	 * The Next key
	 */
	@:require(flash10_1) static var KEYNAME_NEXT : String;

	/**
	 * The Page Down key
	 */
	@:require(flash10_1) static var KEYNAME_PAGEDOWN : String;

	/**
	 * The Page Up key
	 */
	@:require(flash10_1) static var KEYNAME_PAGEUP : String;

	/**
	 * The Pause key
	 */
	@:require(flash10_1) static var KEYNAME_PAUSE : String;

	/**
	 * The Previous key
	 */
	@:require(flash10_1) static var KEYNAME_PREV : String;

	/**
	 * The Print key
	 */
	@:require(flash10_1) static var KEYNAME_PRINT : String;

	/**
	 * The Print Screen
	 */
	@:require(flash10_1) static var KEYNAME_PRINTSCREEN : String;

	/**
	 * The Redo key
	 */
	@:require(flash10_1) static var KEYNAME_REDO : String;

	/**
	 * The Reset key
	 */
	@:require(flash10_1) static var KEYNAME_RESET : String;

	/**
	 * The right arrow
	 */
	@:require(flash10_1) static var KEYNAME_RIGHTARROW : String;

	/**
	 * The Scroll Lock key
	 */
	@:require(flash10_1) static var KEYNAME_SCROLLLOCK : String;

	/**
	 * The Select key
	 */
	@:require(flash10_1) static var KEYNAME_SELECT : String;

	/**
	 * The Stop key
	 */
	@:require(flash10_1) static var KEYNAME_STOP : String;

	/**
	 * The System Request key
	 */
	@:require(flash10_1) static var KEYNAME_SYSREQ : String;

	/**
	 * The System key
	 */
	@:require(flash10_1) static var KEYNAME_SYSTEM : String;

	/**
	 * The Undo key
	 */
	@:require(flash10_1) static var KEYNAME_UNDO : String;

	/**
	 * The up arrow
	 */
	@:require(flash10_1) static var KEYNAME_UPARROW : String;

	/**
	 * The User key
	 */
	@:require(flash10_1) static var KEYNAME_USER : String;
	#end

	/**
	 * Constant associated with the key code value for the L key(76).
	 */
	@:require(flash10_1) static var L : Int;

	/**
	 * Watch last channel or show watched
	 */
	#if !display
	@:require(flash10_2) static var LAST : Int;
	#end

	/**
	 * Constant associated with the key code value for the Left Arrow key(37).
	 */
	static var LEFT : Int;

	/**
	 * Constant associated with the key code value for the [ key(219).
	 */
	@:require(flash10_1) static var LEFTBRACKET : Int;

	/**
	 * Return to live [position in broadcast]
	 */
	#if !display
	@:require(flash10_2) static var LIVE : Int;
	#end

	/**
	 * Constant associated with the key code value for the M key(77).
	 */
	@:require(flash10_1) static var M : Int;

	/**
	 * Engage "Master Shell" e.g. TiVo or other vendor button
	 */
	#if !display
	@:require(flash10_2) static var MASTER_SHELL : Int;
	#end

	/**
	 * Engage menu
	 */
	#if !display
	@:require(flash10_2) static var MENU : Int;
	#end

	/**
	 * Constant associated with the key code value for the - key(189).
	 */
	@:require(flash10_1) static var MINUS : Int;

	/**
	 * Constant associated with the key code value for the N key(78).
	 */
	@:require(flash10_1) static var N : Int;

	/**
	 * Skip to next track or chapter
	 */
	#if !display
	@:require(flash10_2) static var NEXT : Int;
	#end

	/**
	 * Constant associated with the key code value for the 0 key(48).
	 */
	@:require(flash10_1) static var NUMBER_0 : Int;

	/**
	 * Constant associated with the key code value for the 1 key(49).
	 */
	@:require(flash10_1) static var NUMBER_1 : Int;

	/**
	 * Constant associated with the key code value for the 2 key(50).
	 */
	@:require(flash10_1) static var NUMBER_2 : Int;

	/**
	 * Constant associated with the key code value for the 3 key(51).
	 */
	@:require(flash10_1) static var NUMBER_3 : Int;

	/**
	 * Constant associated with the key code value for the 4 key(52).
	 */
	@:require(flash10_1) static var NUMBER_4 : Int;

	/**
	 * Constant associated with the key code value for the 5 key(53).
	 */
	@:require(flash10_1) static var NUMBER_5 : Int;

	/**
	 * Constant associated with the key code value for the 6 key(54).
	 */
	@:require(flash10_1) static var NUMBER_6 : Int;

	/**
	 * Constant associated with the key code value for the 7 key(55).
	 */
	@:require(flash10_1) static var NUMBER_7 : Int;

	/**
	 * Constant associated with the key code value for the 8 key(56).
	 */
	@:require(flash10_1) static var NUMBER_8 : Int;

	/**
	 * Constant associated with the key code value for the 9 key(57).
	 */
	@:require(flash10_1) static var NUMBER_9 : Int;

	/**
	 * Constant associated with the pseudo-key code for the the number pad(21).
	 * Use to set numpad modifier on key equivalents
	 */
	@:require(flash10_1) static var NUMPAD : Int;

	/**
	 * Constant associated with the key code value for the number 0 key on the
	 * number pad(96).
	 */
	static var NUMPAD_0 : Int;

	/**
	 * Constant associated with the key code value for the number 1 key on the
	 * number pad(97).
	 */
	static var NUMPAD_1 : Int;

	/**
	 * Constant associated with the key code value for the number 2 key on the
	 * number pad(98).
	 */
	static var NUMPAD_2 : Int;

	/**
	 * Constant associated with the key code value for the number 3 key on the
	 * number pad(99).
	 */
	static var NUMPAD_3 : Int;

	/**
	 * Constant associated with the key code value for the number 4 key on the
	 * number pad(100).
	 */
	static var NUMPAD_4 : Int;

	/**
	 * Constant associated with the key code value for the number 5 key on the
	 * number pad(101).
	 */
	static var NUMPAD_5 : Int;

	/**
	 * Constant associated with the key code value for the number 6 key on the
	 * number pad(102).
	 */
	static var NUMPAD_6 : Int;

	/**
	 * Constant associated with the key code value for the number 7 key on the
	 * number pad(103).
	 */
	static var NUMPAD_7 : Int;

	/**
	 * Constant associated with the key code value for the number 8 key on the
	 * number pad(104).
	 */
	static var NUMPAD_8 : Int;

	/**
	 * Constant associated with the key code value for the number 9 key on the
	 * number pad(105).
	 */
	static var NUMPAD_9 : Int;

	/**
	 * Constant associated with the key code value for the addition key on the
	 * number pad(107).
	 */
	static var NUMPAD_ADD : Int;

	/**
	 * Constant associated with the key code value for the decimal key on the
	 * number pad(110).
	 */
	static var NUMPAD_DECIMAL : Int;

	/**
	 * Constant associated with the key code value for the division key on the
	 * number pad(111).
	 */
	static var NUMPAD_DIVIDE : Int;

	/**
	 * Constant associated with the key code value for the Enter key on the
	 * number pad(108).
	 */
	static var NUMPAD_ENTER : Int;

	/**
	 * Constant associated with the key code value for the multiplication key on
	 * the number pad(106).
	 */
	static var NUMPAD_MULTIPLY : Int;

	/**
	 * Constant associated with the key code value for the subtraction key on the
	 * number pad(109).
	 */
	static var NUMPAD_SUBTRACT : Int;

	/**
	 * Constant associated with the key code value for the O key(79).
	 */
	@:require(flash10_1) static var O : Int;

	/**
	 * Constant associated with the key code value for the P key(80).
	 */
	@:require(flash10_1) static var P : Int;

	/**
	 * Constant associated with the key code value for the Page Down key(34).
	 */
	static var PAGE_DOWN : Int;

	/**
	 * Constant associated with the key code value for the Page Up key(33).
	 */
	static var PAGE_UP : Int;

	/**
	 * Engage pause transport mode
	 */
	#if !display
	@:require(flash10_2) static var PAUSE : Int;
	#end

	/**
	 * Constant associated with the key code value for the . key(190).
	 */
	@:require(flash10_1) static var PERIOD : Int;

	#if !display
	/**
	 * Engage play transport mode
	 */
	@:require(flash10_2) static var PLAY : Int;

	/**
	 * Skip to previous track or chapter
	 */
	@:require(flash10_2) static var PREVIOUS : Int;
	#end

	/**
	 * Constant associated with the key code value for the Q key(81).
	 */
	@:require(flash10_1) static var Q : Int;

	/**
	 * Constant associated with the key code value for the ' key(222).
	 */
	@:require(flash10_1) static var QUOTE : Int;

	/**
	 * Constant associated with the key code value for the R key(82).
	 */
	@:require(flash10_1) static var R : Int;

	#if !display
	/**
	 * Record item or engage record transport mode
	 */
	@:require(flash10_2) static var RECORD : Int;

	/**
	 * Red function key button
	 */
	@:require(flash10_2) static var RED : Int;

	/**
	 * Engage rewind transport mode
	 */
	@:require(flash10_2) static var REWIND : Int;
	#end

	/**
	 * Constant associated with the key code value for the Right Arrow key(39).
	 */
	static var RIGHT : Int;

	/**
	 * Constant associated with the key code value for the ] key(221).
	 */
	@:require(flash10_1) static var RIGHTBRACKET : Int;

	/**
	 * Constant associated with the key code value for the S key(83).
	 */
	@:require(flash10_1) static var S : Int;

	/**
	 * Search button
	 */
	#if !display
	@:require(flash10_2) static var SEARCH : Int;
	#end

	/**
	 * Constant associated with the key code value for the ; key(186).
	 */
	@:require(flash10_1) static var SEMICOLON : Int;

	/**
	 * Engage setup application or menu
	 */
	@:require(flash10_2) static var SETUP : Int;

	/**
	 * Constant associated with the key code value for the Shift key(16).
	 */
	static var SHIFT : Int;

	#if !display
	/**
	 * Quick skip backward(usually 7-10 seconds)
	 */
	@:require(flash10_2) static var SKIP_BACKWARD : Int;

	/**
	 * Quick skip ahead(usually 30 seconds)
	 */
	@:require(flash10_2) static var SKIP_FORWARD : Int;
	#end

	/**
	 * Constant associated with the key code value for the / key(191).
	 */
	@:require(flash10_1) static var SLASH : Int;

	/**
	 * Constant associated with the key code value for the Spacebar(32).
	 */
	static var SPACE : Int;
	
	#if !display
	/**
	 * Engage stop transport mode
	 */
	@:require(flash10_2) static var STOP : Int;

	/**
	 * The OS X Unicode Begin constant
	 */
	@:require(flash10_1) static var STRING_BEGIN : String;

	/**
	 * The OS X Unicode Break constant
	 */
	@:require(flash10_1) static var STRING_BREAK : String;

	/**
	 * The OS X Unicode Clear Display constant
	 */
	@:require(flash10_1) static var STRING_CLEARDISPLAY : String;

	/**
	 * The OS X Unicode Clear Line constant
	 */
	@:require(flash10_1) static var STRING_CLEARLINE : String;

	/**
	 * The OS X Unicode Delete constant
	 */
	@:require(flash10_1) static var STRING_DELETE : String;

	/**
	 * The OS X Unicode Delete Character constant
	 */
	@:require(flash10_1) static var STRING_DELETECHAR : String;

	/**
	 * The OS X Unicode Delete Line constant
	 */
	@:require(flash10_1) static var STRING_DELETELINE : String;

	/**
	 * The OS X Unicode down arrow constant
	 */
	@:require(flash10_1) static var STRING_DOWNARROW : String;

	/**
	 * The OS X Unicode End constant
	 */
	@:require(flash10_1) static var STRING_END : String;

	/**
	 * The OS X Unicode Execute constant
	 */
	@:require(flash10_1) static var STRING_EXECUTE : String;

	/**
	 * The OS X Unicode F1 constant
	 */
	@:require(flash10_1) static var STRING_F1 : String;

	/**
	 * The OS X Unicode F10 constant
	 */
	@:require(flash10_1) static var STRING_F10 : String;

	/**
	 * The OS X Unicode F11 constant
	 */
	@:require(flash10_1) static var STRING_F11 : String;

	/**
	 * The OS X Unicode F12 constant
	 */
	@:require(flash10_1) static var STRING_F12 : String;

	/**
	 * The OS X Unicode F13 constant
	 */
	@:require(flash10_1) static var STRING_F13 : String;

	/**
	 * The OS X Unicode F14 constant
	 */
	@:require(flash10_1) static var STRING_F14 : String;

	/**
	 * The OS X Unicode F15 constant
	 */
	@:require(flash10_1) static var STRING_F15 : String;

	/**
	 * The OS X Unicode F16 constant
	 */
	@:require(flash10_1) static var STRING_F16 : String;

	/**
	 * The OS X Unicode F17 constant
	 */
	@:require(flash10_1) static var STRING_F17 : String;

	/**
	 * The OS X Unicode F18 constant
	 */
	@:require(flash10_1) static var STRING_F18 : String;

	/**
	 * The OS X Unicode F19 constant
	 */
	@:require(flash10_1) static var STRING_F19 : String;

	/**
	 * The OS X Unicode F2 constant
	 */
	@:require(flash10_1) static var STRING_F2 : String;

	/**
	 * The OS X Unicode F20 constant
	 */
	@:require(flash10_1) static var STRING_F20 : String;

	/**
	 * The OS X Unicode F21 constant
	 */
	@:require(flash10_1) static var STRING_F21 : String;

	/**
	 * The OS X Unicode F22 constant
	 */
	@:require(flash10_1) static var STRING_F22 : String;

	/**
	 * The OS X Unicode F23 constant
	 */
	@:require(flash10_1) static var STRING_F23 : String;

	/**
	 * The OS X Unicode F24 constant
	 */
	@:require(flash10_1) static var STRING_F24 : String;

	/**
	 * The OS X Unicode F25 constant
	 */
	@:require(flash10_1) static var STRING_F25 : String;

	/**
	 * The OS X Unicode F26 constant
	 */
	@:require(flash10_1) static var STRING_F26 : String;

	/**
	 * The OS X Unicode F27 constant
	 */
	@:require(flash10_1) static var STRING_F27 : String;

	/**
	 * The OS X Unicode F28 constant
	 */
	@:require(flash10_1) static var STRING_F28 : String;

	/**
	 * The OS X Unicode F29 constant
	 */
	@:require(flash10_1) static var STRING_F29 : String;

	/**
	 * The OS X Unicode F3 constant
	 */
	@:require(flash10_1) static var STRING_F3 : String;

	/**
	 * The OS X Unicode F30 constant
	 */
	@:require(flash10_1) static var STRING_F30 : String;

	/**
	 * The OS X Unicode F31 constant
	 */
	@:require(flash10_1) static var STRING_F31 : String;

	/**
	 * The OS X Unicode F32 constant
	 */
	@:require(flash10_1) static var STRING_F32 : String;

	/**
	 * The OS X Unicode F33 constant
	 */
	@:require(flash10_1) static var STRING_F33 : String;

	/**
	 * The OS X Unicode F34 constant
	 */
	@:require(flash10_1) static var STRING_F34 : String;

	/**
	 * The OS X Unicode F35 constant
	 */
	@:require(flash10_1) static var STRING_F35 : String;

	/**
	 * The OS X Unicode F4 constant
	 */
	@:require(flash10_1) static var STRING_F4 : String;

	/**
	 * The OS X Unicode F5 constant
	 */
	@:require(flash10_1) static var STRING_F5 : String;

	/**
	 * The OS X Unicode F6 constant
	 */
	@:require(flash10_1) static var STRING_F6 : String;

	/**
	 * The OS X Unicode F7 constant
	 */
	@:require(flash10_1) static var STRING_F7 : String;

	/**
	 * The OS X Unicode F8 constant
	 */
	@:require(flash10_1) static var STRING_F8 : String;

	/**
	 * The OS X Unicode F9 constant
	 */
	@:require(flash10_1) static var STRING_F9 : String;

	/**
	 * The OS X Unicode Find constant
	 */
	@:require(flash10_1) static var STRING_FIND : String;

	/**
	 * The OS X Unicode Help constant
	 */
	@:require(flash10_1) static var STRING_HELP : String;

	/**
	 * The OS X Unicode Home constant
	 */
	@:require(flash10_1) static var STRING_HOME : String;

	/**
	 * The OS X Unicode Insert constant
	 */
	@:require(flash10_1) static var STRING_INSERT : String;

	/**
	 * The OS X Unicode Insert Character constant
	 */
	@:require(flash10_1) static var STRING_INSERTCHAR : String;

	/**
	 * The OS X Unicode Insert Line constant
	 */
	@:require(flash10_1) static var STRING_INSERTLINE : String;

	/**
	 * The OS X Unicode left arrow constant
	 */
	@:require(flash10_1) static var STRING_LEFTARROW : String;

	/**
	 * The OS X Unicode Menu constant
	 */
	@:require(flash10_1) static var STRING_MENU : String;

	/**
	 * The OS X Unicode Mode Switch constant
	 */
	@:require(flash10_1) static var STRING_MODESWITCH : String;

	/**
	 * The OS X Unicode Next constant
	 */
	@:require(flash10_1) static var STRING_NEXT : String;

	/**
	 * The OS X Unicode Page Down constant
	 */
	@:require(flash10_1) static var STRING_PAGEDOWN : String;

	/**
	 * The OS X Unicode Page Up constant
	 */
	@:require(flash10_1) static var STRING_PAGEUP : String;

	/**
	 * The OS X Unicode Pause constant
	 */
	@:require(flash10_1) static var STRING_PAUSE : String;

	/**
	 * The OS X Unicode Previous constant
	 */
	@:require(flash10_1) static var STRING_PREV : String;

	/**
	 * The OS X Unicode Print constant
	 */
	@:require(flash10_1) static var STRING_PRINT : String;

	/**
	 * The OS X Unicode Print Screen constant
	 */
	@:require(flash10_1) static var STRING_PRINTSCREEN : String;

	/**
	 * The OS X Unicode Redo constant
	 */
	@:require(flash10_1) static var STRING_REDO : String;

	/**
	 * The OS X Unicode Reset constant
	 */
	@:require(flash10_1) static var STRING_RESET : String;

	/**
	 * The OS X Unicode right arrow constant
	 */
	@:require(flash10_1) static var STRING_RIGHTARROW : String;

	/**
	 * The OS X Unicode Scroll Lock constant
	 */
	@:require(flash10_1) static var STRING_SCROLLLOCK : String;

	/**
	 * The OS X Unicode Select constant
	 */
	@:require(flash10_1) static var STRING_SELECT : String;

	/**
	 * The OS X Unicode Stop constant
	 */
	@:require(flash10_1) static var STRING_STOP : String;

	/**
	 * The OS X Unicode System Request constant
	 */
	@:require(flash10_1) static var STRING_SYSREQ : String;

	/**
	 * The OS X Unicode System constant
	 */
	@:require(flash10_1) static var STRING_SYSTEM : String;

	/**
	 * The OS X Unicode Undo constant
	 */
	@:require(flash10_1) static var STRING_UNDO : String;

	/**
	 * The OS X Unicode up arrow constant
	 */
	@:require(flash10_1) static var STRING_UPARROW : String;

	/**
	 * The OS X Unicode User constant
	 */
	@:require(flash10_1) static var STRING_USER : String;

	/**
	 * Toggle subtitles
	 */
	@:require(flash10_2) static var SUBTITLE : Int;
	#end

	/**
	 * Constant associated with the key code value for the T key(84).
	 */
	@:require(flash10_1) static var T : Int;

	/**
	 * Constant associated with the key code value for the Tab key(9).
	 */
	static var TAB : Int;

	/**
	 * Constant associated with the key code value for the U key(85).
	 */
	@:require(flash10_1) static var U : Int;

	/**
	 * Constant associated with the key code value for the Up Arrow key(38).
	 */
	static var UP : Int;

	/**
	 * Constant associated with the key code value for the V key(86).
	 */
	@:require(flash10_1) static var V : Int;

	/**
	 * Engage video-on-demand
	 */
	#if !display
	@:require(flash10_2) static var VOD : Int;
	#end

	/**
	 * Constant associated with the key code value for the W key(87).
	 */
	@:require(flash10_1) static var W : Int;

	/**
	 * Constant associated with the key code value for the X key(88).
	 */
	@:require(flash10_1) static var X : Int;

	/**
	 * Constant associated with the key code value for the Y key(89).
	 */
	@:require(flash10_1) static var Y : Int;

	/**
	 * Yellow function key button
	 */
	#if !display
	@:require(flash10_2) static var YELLOW : Int;
	#end

	/**
	 * Constant associated with the key code value for the Z key(90).
	 */
	@:require(flash10_1) static var Z : Int;

	#if !display
	/**
	 * Specifies whether the Caps Lock key is activated(<code>true</code>) or
	 * not(<code>false</code>).
	 */
	static var capsLock(default,null) : Bool;

	/**
	 * Indicates whether the computer or device provides a virtual keyboard. If
	 * the current environment provides a virtual keyboard, this value is
	 * <code>true</code>.
	 */
	@:require(flash10_1) static var hasVirtualKeyboard(default,null) : Bool;

	/**
	 * Specifies whether the Num Lock key is activated(<code>true</code>) or not
	 * (<code>false</code>).
	 */
	static var numLock(default,null) : Bool;

	/**
	 * Indicates the type of physical keyboard provided by the computer or
	 * device, if any.
	 *
	 * <p>Use the constants defined in the KeyboardType class to test the values
	 * reported by this property.</p>
	 *
	 * <p><b>Note:</b> If a computer or device has both an alphanumeric keyboard
	 * and a 12-button keypad, this property only reports the presence of the
	 * alphanumeric keyboard.</p>
	 */
	@:require(flash10_1) static var physicalKeyboardType(default,null) : KeyboardType;

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
	static function isAccessible() : Bool;
	#end
	
}


#end
