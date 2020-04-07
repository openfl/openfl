package openfl.text;

/**
	The StageText class is used to present the user with a native text input field.

	This class enables mobile applications to gather user input using native text input controls on mobile devices. Input controls on mobile devices often have extensive user interfaces and supporting behaviors that don't exist on the desktop. For example, many mobile devices support text input features like the following:

	* auto-complete
	* auto-correct
	* touch-based text selection
	* customizable soft keyboards

	The underlying operating system (or a component library bundled with the operating system) draws native text input fields. Native text input fields provide an experience that is familiar to anyone who has used other applications on the same device. However, because the operating system draws the text input fields instead of the player, you cannot use embedded fonts.

	_AIR profile support_: This feature is supported on iOS and Android platforms. StageText uses native text input fields on Android and iOS mobile devices. On other platforms, StageText uses the Flash Runtime TextField.

	When native inputs are used, StageText objects are not display objects and you cannot add them to the Flash display list. Instead, you display a StageText object by attaching it directly to a stage using the `stage` property. The StageText instance attached to a stage is displayed on top of any Flash display objects. You control the size and position of the rendering area with the `viewPort` property. There is no way to control depth ordering of different StageText objects. Overlapping two instances is not recommended.

	When a StageText object has focus, it has the first opportunity to handle keyboard input. The stage to which the StageText object is attached does not dispatch any keyboard input events.

	Because the StageText class wraps a different native control on every platform, its features are supported to varying degrees by each platform. Where features are supported, they may behave differently between platforms. When you attempt to use a particular feature on a particular platform, it is best to test the behavior. Only on desktop platforms where native controls are not used is StageText behavior similar to Flash Runtime text behavior.

	StageText on Apple TV takes focus by default. To manage focus between different objects in your application keep a note of below points:

		To override default focus from StageText, or to assign focus to any other display object use stage.focus
		To assign focus to StageText, use stageText.assignFocus()
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class StageText
{
	/**
		Controls how a device applies auto capitalization to user input. Valid values are defined as constants in the AutoCapitalize class:

		* "none"
		* "word"
		* "sentence"
		* "all"

		This property is only a hint to the underlying platform, because not all devices and operating systems support this functionality.

		**Note**: If you enable `autoCapitalize` while text is being edited or otherwise in focus, the updated behavior isn't applied until focus is released and reestablished.

		The default value is `AutoCapitalize.NONE`.
	**/
	public var autoCapitalize:AutoCapitalize = NONE;

	/**
		Indicates whether a device auto-corrects user input for spelling or punctuation mistakes.

		This property is only a hint to the underlying platform, because not all devices and operating systems support this functionality.

		**Note**: If you enable `autoCorrect` while text is being edited or otherwise in focus, the updated behavior isn't applied until focus is released and reestablished.

		The default value is `false`.
	**/
	public var autoCorrect:Bool;

	/**
		The mode of clearButton for the current StageText Object. There are four modes associated with this property:

		* To show clearButton while editing: `StageTextClearButtonMode.WHILE_EDITING`
		* To never show clearButton: `StageTextClearButtonMode.NEVER`
		* To always show clearButton: `StageTextClearButtonMode.ALWAYS`
		* To show clearButton unless editing: `StageTextClearButtonMode.UNLESS_EDITING`

		By default, clearButtonMode property is set as `StageTextClearButtonMode.WHILE_EDITING`.

		**Note**: This property is supported for iOS only.
	**/
	public var clearButtonMode:StageTextClearButtonMode;

	/**
		Specifies text color. You specify text color as a number containing three 8-bit RGB components. The first component represents red, the second represents green, and the third component represents blue. For example, 0xFF0000 specifies red, 0x00FF00 specifies green, and 0x0000FF specifies blue. The default text color is black (0x000000).

		The default value is 0x000000.
	**/
	public var color:UInt;

	/**
		Indicates whether the text field is a password text field. If `true`, the text field hides input characters using a substitute character (for example, an asterisk).

		**Note**: If you enable displayAsPassword while text is being edited or otherwise in focus, the updated behavior isn't applied until focus is released and reestablished.

		**Important**: On iOS, a multiline stage text object does not display substitute characters even when the value of this property is `true`.

		The default value is `false`.
	**/
	public var displayAsPassword:Bool;

	/**
		Indicates whether the user can edit the text field.

		The default value is `true`.
	**/
	public var editable:Bool = true;

	/**
		Indicates the name of the current font family. A value of `null` indicates the system default. To enumerate the available fonts, use `flash.text.Font.enumerateFonts()`. If the font family is unknown, the default font family is used.

		The default value is `null`.
	**/
	public var fontFamily:String;

	/**
		Specifies the font posture, using constants defined in the FontPosture class.

		The default value is `FontPosture.NORMAL`.
	**/
	public var fontPosture:FontPosture;

	/**
		The size in pixels for the current font family.

		The default value is `12`.
	**/
	public var fontSize:Int = 12;

	/**
		Specifies the font weight, using constants defined in the FontWeight class.

		The default value is `FontWeight.NORMAL`.
	**/
	public var fontWeight:FontWeight = NORMAL;

	/**
		Indicates the locale of the text. StageText uses the standard locale identifiers. For example "en", "en_US" and "en-US" are all English; "ja" is Japanese. See iso639-2 code list for a list of locale codes.

		The default value is `en`.
	**/
	public var locale:String = "en";

	/**
		Indicates the maximum number of characters that a user can enter into the text field. A script can insert more text than `maxChars` allows. If `maxChars` equals zero, a user can enter an unlimited amount of text into the text field.

		The default value is 0.
	**/
	public var maxChars:Int = 0;

	/**
		Indicates whether the StageText object can display more than one line of text. Read-only. This value matches that of the `multiline` property in the StageTextInitOptions object used during construction.
	**/
	public var multiline(default, null):Bool;

	/**
		Restricts the set of characters that a user can enter into the text field. The system scans the `restrict` string from left to right.

		The value of `restrict` specifies the following text input restriction rules:

			If the value is `null`, a user can enter any character.
			If the value is an empty string, a user cannot enter any characters.
			If the value is a string of characters, a user can enter only the characters in the string.
			If the value includes a caret (^), a user cannot enter any characters that follow the caret.
			The value can specify a range of allowable input characters by using the hyphen (-) character.
			The value can use the \u escape sequence to construct a `restrict` string.

		**Special Characters:**

		Use a backslash to enter a caret (^) or dash (-) character verbatim. The accepted backslash sequences are \-, \^ and \\. The backslash must be an actual character in the string. When you specify a backslash in ActionScript, use a double backslash.

		**Examples of `restrict` property settings:**

		The following example allows a user to enter only the dash (-) and caret (^) characters:

				`my_txt.restrict = "\\-\\^";`


		The following example allows a user to enter only uppercase characters, spaces, and numbers:

				`my_txt.restrict = "A-Z 0-9";`


		The following example excludes only lowercase letters:

				`my_txt.restrict = "^a-z";`


		The following example allows a user to enter only uppercase letters, but excludes the uppercase letter Q:

				`my_txt.restrict = "A-Z^Q";`


		The following example allows a user to enter only the characters from ASCII 32 (space) to ASCII 126 (tilde).

				`my_txt.restrict = "\u0020-\u007E";`


		**Note**: Restrictions apply only to user input; a script can insert any characters into the text field.

		The default value is `null`.
	**/
	public var restrict:String;

	/**
		Indicates the label on the Return key for devices that feature a soft keyboard. The available values are constants defined in the `ReturnKeyLabel` class:

		* "default"
		* "done"
		* "go"
		* "next"
		* "search"

		This property is only a hint to the underlying platform, because not all devices and operating systems support these values. This property has no affect on devices that do not feature a soft keyboard.

		The default value is `ReturnKeyLabel.DEFAULT`.
	**/
	public var returnKeyLabel:ReturnKeyLabel = DEFAULT;

	/**
		The zero-based character index value of the last character in the current selection. For example, the first character is 0, the second character is 1, and so on.

		If no text is selected, this method returns the insertion point. If the StageText instance does not have focus, this method returns -1.

		On iOS, this property is not supported for for non-multiline StageText objects and returns -1.
	**/
	public var selectionActiveIndex(default, null):Int = -1;

	/**
		The zero-based character index value of the first character in the current selection. For example, the first character is 0, the second character is 1, and so on.

		If no text is selected, this method returns the insertion point. If the StageText instance does not have focus, this method returns -1.

		On iOS, this property is not supported for for non-multiline StageText objects and returns -1.
	**/
	public var selectionAnchorIndex(default, null):Int = -1;

	/**
		Controls the appearance of the soft keyboard.

		Devices with soft keyboards can customize the keyboard's buttons to match the type of input expected. For example, if numeric input is expected, a device can use `SoftKeyboardType.NUMBER` to display only numbers on the soft keyboard. Valid values are defined as constants in the SoftKeyboardType class:

		* "default"
		* "punctuation"
		* "url"
		* "number"
		* "contact"
		* "email"
		* "phone"
		* "decimalpad"

		These values serve as hints, to help a device display the best keyboard for the current operation.

		The default value is `SoftKeyboardType.DEFAULT`.
	**/
	public var softKeyboardType:SoftKeyboardType = DEFAULT;

	/**
		The stage on which this StageText object is displayed.

		Set stage to `null` to hide this StageText object.

		The default value is `null`.
	**/
	public var stage:Stage;

	/**
		The current text in the text field. The carriage return character (`'\r'`, ASCII 13) separates lines of text. Text contained in this property is unformatted (it has no formatting tags).

		The default value is `null`.
	**/
	public var text:String;

	/**
		Indicates the paragraph alignment. Valid values are defined as constants in the TextFormatAlign class:

		* "left"
		* "center"
		* "right"
		* "justify"
		* "start"
		* "end"

		Not all platforms support every `textAlign` value. For unsupported `textAlign` values, platforms use the default value (`TextFormatAlign.START`).

		The default value is `TextFormatAlign.START`.
	**/
	public var textAlign:TextFormatAlign = START;

	/**
		The area on the stage in which the StageText object is displayed. The default is the zero rect.
	**/
	public var viewPort:Rectangle = new Rectangle();

	/**
		Indicates whether the StageText object is visible. StageText objects that are not visible are disabled.
	**/
	public var visible:Bool;

	/**
		Creates a StageText object.

		The StageText object is invisible until it is attached to a stage and until the `viewPort` property is set.

		@param	initOptions
	**/
	public function new(initOptions:StageTextInitOptions = null)
	{
		// dispatches CHANGE, COMPLETE, FOCUS_IN, FOCUS_OUT, KEY_DOWN, KEY_UP
		// SOFT_KEYBOARD_ACTIVATE, SOFT_KEYBOARD_ACTIVATING, SOFT_KEYBOARD_DEACTIVATE
	}

	/**
		Assigns focus to the StageText object. For non-editable objects, `assignFocus()` does nothing.
	**/
	public function assignFocus():Void {}

	/**
		Disposes of the StageText object.

		Calling `dispose()` is optional. If you do not maintain a reference to this StageText instance, it is eligible for garbage collection. Calling `dispose()` can make garbage collection occur sooner, or occur at a more convenient time.
	**/
	public function dispose():Void {}

	/**
		Draws the StageText's view port to a bitmap.

		Capture the bitmap and set the stage to null to display the content above the StageText object.

		The bitmap is typically the same width and height as the viewport. Starting with AIR 15.0, when the player is on HiDPI displays, the bitmap's width and height can optionally be `contentsScaleFactor` times the width and height of the viewport. For instance, on a Mac Retina Display, `contentsScaleFactor` is 2, because the pixel resolution of the stage is doubled, so the bitmap can correspondingly be twice the size of the viewport.

		If you call this method before the `Event.COMPLETE` event, the method could draw the view port incorrectly.

		@param	bitmap	The BitmapData object on which to draw the visible portion of the StageText's view port.
	**/
	public function drawViewPortToBitmapData(bitmap:BitmapData):Void {}

	/**
		Selects the text specified by the index values of the first and last characters. You specify the first and last characters of the selection in the `anchorIndex` and `activeIndex` parameters. If both parameter values are the same, this method sets the insertion point.

		On iOS, for non-multiline StageText objects, this function is not supported and always returns -1. If you call this method selecting the complete text string, the selection is visible. However, if you call this method selecting a subset of the text string, the selection is not visible.

		For some devices or operating systems, the selection is only visible when the StageText object has focus.

		@param	anchorIndex	The zero-based index value of the first character in the selection (the first character's index value is 0).
		@param	activeIndex	The zero-based index value of the last character in the selection.
	**/
	public function selectRange(anchorIndex:Int, activeIndex:Int):void {}
}
