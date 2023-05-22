package openfl.text;

#if (!flash && sys)
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.events.FocusEvent;
import openfl.events.KeyboardEvent;
import openfl.errors.ArgumentError;
import openfl.errors.Error;
import openfl.errors.RangeError;
import openfl.geom.Rectangle;
import openfl.text.engine.FontPosture;
import openfl.text.engine.FontWeight;

/**
	The StageText class is used to present the user with a native text input
	field.

	This class enables mobile applications to gather user input using native
	text input controls on mobile devices. Input controls on mobile devices
	often have extensive user interfaces and supporting behaviors that don't
	exist on the desktop. For example, many mobile devices support text input
	features like the following:

	- auto-complete
	- auto-correct
	- touch-based text selection
	- customizable soft keyboards

	The underlying operating system (or a component library bundled with the
	operating system) draws native text input fields. Native text input fields
	provide an experience that is familiar to anyone who has used other
	applications on the same device. However, because the operating system draws
	the text input fields instead of the player,
	_you cannot use embedded fonts._

	_OpenFL target support:_ On all platforms, except AIR, StageText uses the
	runtime TextField.

	_Adobe AIR profile support:_ This feature is supported on iOS and Android
	platforms. StageText uses native text input fields on Android and iOS mobile
	devices. On other platforms, StageText uses the Flash Runtime TextField.

	When native inputs are used, StageText objects are not display objects and
	you cannot add them to the Flash display list. Instead, you display a
	StageText object by attaching it directly to a stage using the `stage`
	property. The StageText instance attached to a stage is displayed on top of
	any OpenFL display objects. You control the size and position of the
	rendering area with the `viewPort` property. There is no way to control
	depth ordering of different StageText objects. Overlapping two instances is
	not recommended.

	When a StageText object has focus, it has the first opportunity to handle
	keyboard input. The stage to which the StageText object is attached does not
	dispatch any keyboard input events.

	Because the StageText class wraps a different native control on every
	platform, its features are supported to varying degrees by each platform.
	Where features are supported, they may behave differently between platforms.
	When you attempt to use a particular feature on a particular platform, it is
	best to test the behavior. Only on desktop platforms where native controls
	are not used is StageText behavior similar to runtime TextField behavior.

	StageText on Apple TV takes focus by default. To manage focus between
	different objects in your application keep a note of below points:

	- To override default focus from StageText, or to assign focus to any other
	display object use `stage.focus`.
	- To assign focus to StageText, use `stageText.assignFocus()`.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class StageText extends EventDispatcher
{
	@:noCompletion private var __textField:TextField;
	@:noCompletion private var __initOptions:StageTextInitOptions;
	@:noCompletion private var __complete:Bool = false;
	@:noCompletion private var __viewPort:Rectangle = new Rectangle();
	@:noCompletion private var __textAlign:TextFormatAlign = START;
	@:noCompletion private var __textFormat:TextFormat;

	/**
		Controls how a device applies auto capitalization to user input. Valid
		values are defined as constants in the AutoCapitalize class:

		- `"none"`
		- `"word"`
		- `"sentence"`
		- `"all"`

		This property is only a hint to the underlying platform, because not all
		devices and operating systems support this functionality.

		**Note:** If you enable autoCapitalize while text is being edited or
		otherwise in focus, the updated behavior isn't applied until focus is
		released and reestablished.
	**/
	public var autoCapitalize:AutoCapitalize = NONE;

	/**
		Indicates whether a device auto-corrects user input for spelling or
		punctuation mistakes.

		This property is only a hint to the underlying platform, because not all
		devices and operating systems support this functionality.

		**Note:** If you enable autoCorrect while text is being edited or
		otherwise in focus, the updated behavior isn't applied until focus is
		released and reestablished.
	**/
	public var autoCorrect:Bool = false;

	/**
		The mode of the clear button for the current StageText object. There are
		four modes associated with this property:

		- To show the clear button while editing: `StageTextClearButtonMode.WHILE_EDITING`
		- To never show the clear button: `StageTextClearButtonMode.NEVER`
		- To always show the clear button: `StageTextClearButtonMode.ALWAYS`
		- To show the clear button unless editing: `StageTextClearButtonMode.UNLESS_EDITING`

		**Note:** This property is supported for iOS only.
	**/
	public var clearButtonMode:StageTextClearButtonMode = WHILE_EDITING;

	/**
		Specifies text color. You specify text color as a number containing
		three 8-bit RGB components. The first component represents red, the
		second represents green, and the third component represents blue. For
		example, `0xFF0000` specifies red, `0x00FF00` specifies green, and
		`0x0000FF` specifies blue. The default text color is black
		(`0x000000`).
	**/
	public var color(get, set):UInt;

	@:noCompletion private function get_color():UInt
	{
		return __textFormat.color;
	}

	@:noCompletion private function set_color(value:UInt):UInt
	{
		if (__textFormat.color == value)
		{
			return __textFormat.color;
		}
		__textFormat.color = value;
		__textField.defaultTextFormat = __textFormat;
		__textField.setTextFormat(__textFormat);
		return __textFormat.color;
	}

	/**
		Indicates whether the text field is a password text field. If `true`,
		the text field hides input characters using a substitute character (for
		example, an asterisk).

		Note: If you enable `displayAsPassword` while text is being edited or
		otherwise in focus, the updated behavior isn't applied until focus is
		released and reestablished.

		Important: On iOS, a multiline stage text object does not display
		substitute characters even when the value of this property is `true`.
	**/
	public var displayAsPassword(get, set):Bool;

	@:noCompletion private function get_displayAsPassword():Bool
	{
		return __textField.displayAsPassword;
	}

	@:noCompletion private function set_displayAsPassword(value:Bool):Bool
	{
		return __textField.displayAsPassword = value;
	}

	/**
		Indicates whether the user can edit the text field.
	**/
	public var editable(get, set):Bool;

	@:noCompletion private function get_editable():Bool
	{
		return __textField.type == INPUT;
	}

	@:noCompletion private function set_editable(value:Bool):Bool
	{
		__textField.type = value ? INPUT : DYNAMIC;
		return __textField.type == INPUT;
	}

	/**
		Indicates the name of the current font family. A value of null indicate
		the system default. To enumerate the available fonts, use
		`openfl.text.Font.enumerateFonts()`. If the font family is unknown, the
		default font family is used.
	**/
	public var fontFamily(get, set):String;

	@:noCompletion private function get_fontFamily():String
	{
		return __textFormat.font;
	}

	@:noCompletion private function set_fontFamily(value:String):String
	{
		if (fontFamily == value)
		{
			return fontFamily;
		}
		__textFormat.font = value;
		__textField.defaultTextFormat = __textFormat;
		__textField.setTextFormat(__textFormat);
		return __textFormat.font;
	}

	/**
		Specifies the font posture, using constants defined in the FontPosture
		class.
	**/
	public var fontPosture(get, set):FontPosture;

	@:noCompletion private function get_fontPosture():FontPosture
	{
		return __textFormat.italic ? ITALIC : NORMAL;
	}

	@:noCompletion private function set_fontPosture(value:FontPosture):FontPosture
	{
		if (fontPosture == value)
		{
			return __textFormat.italic ? ITALIC : NORMAL;
		}
		__textFormat.italic = value == ITALIC;
		__textField.defaultTextFormat = __textFormat;
		__textField.setTextFormat(__textFormat);
		return __textFormat.italic ? ITALIC : NORMAL;
	}

	/**
		The size in pixels for the current font family.
	**/
	public var fontSize(get, set):Int;

	@:noCompletion private function get_fontSize():Int
	{
		return __textFormat.size;
	}

	@:noCompletion private function set_fontSize(value:Int):Int
	{
		if (fontSize == value)
		{
			return fontSize;
		}
		__textFormat.size = value;
		__textField.defaultTextFormat = __textFormat;
		__textField.setTextFormat(__textFormat);
		return __textFormat.size;
	}

	/**
		Specifies the font weight, using constants defined in the FontWeight class.
	**/
	public var fontWeight(get, set):FontWeight;

	@:noCompletion private function get_fontWeight():FontWeight
	{
		return __textFormat.bold ? BOLD : NORMAL;
	}

	@:noCompletion private function set_fontWeight(value:FontWeight):FontWeight
	{
		if (fontWeight == value)
		{
			return __textFormat.bold ? BOLD : NORMAL;
		}
		__textFormat.bold = value == BOLD;
		__textField.defaultTextFormat = __textFormat;
		__textField.setTextFormat(__textFormat);
		return __textFormat.bold ? BOLD : NORMAL;
	}

	/**
		Indicates the locale of the text. StageText uses the standard locale
		identifiers. For example "en", "en_US" and "en-US" are all English;
		"ja" is Japanese. See
		[iso639-2 code list](http://www.loc.gov/standards/iso639-2/php/code_list.php)
		for a list of locale codes.
	**/
	public var locale:String = "en";

	/**
		Indicates the maximum number of characters that a user can enter into
		the text field. A script can insert more text than `maxChars` allows. If
		`maxChars` equals zero, a user can enter an unlimited amount of text
		into the text field.
	**/
	public var maxChars(get, set):Int;

	@:noCompletion private function get_maxChars():Int
	{
		return __textField.maxChars;
	}

	@:noCompletion private function set_maxChars(value:Int):Int
	{
		return __textField.maxChars = value;
	}

	/**
		Indicates whether the StageText object can display more than one line of
		text. Read-only. This value matches that of the `multiline` property in
		the StageTextInitOptions object used during construction.
	**/
	public var multiline(get, never):Bool;

	@:noCompletion private function get_multiline():Bool
	{
		return __initOptions.multiline;
	}

	/**
		Restricts the set of characters that a user can enter into the text
		ield. The system scans the restrict string from left to right.

		The value of restrict specifies the following text input restriction
		ules:

		- If the value is null, a user can enter any character.
		- If the value is an empty string, a user cannot enter any characters.
		- If the value is a string of characters, a user can enter only the
		characters in the string.
		- If the value includes a caret (^), a user cannot enter any characters
		that follow the caret.
		- The value can specify a range of allowable input characters by using
		the hyphen (-) character.
		- The value can use the \u escape sequence to construct a restrict
		string.

		**Special Characters:**

		Use a backslash to enter a caret (^) or dash (-) character verbatim. The
		accepted backslash sequences are \-, \^ and \\. The backslash must be an
		actual character in the string. When you specify a backslash in Haxe,
		use a double backslash.

		**Examples of restrict property settings:**

		The following example allows a user to enter only the dash (-) and caret
		(^) characters:

		```haxe
		my_txt.restrict = "\\-\\^";
		```

		The following example allows a user to enter only uppercase characters,
		spaces, and numbers:

		```haxe
		my_txt.restrict = "A-Z 0-9";
		```

		The following example excludes only lowercase letters:

		```haxe
		my_txt.restrict = "^a-z";
		```

		The following example allows a user to enter only uppercase letters, but
		excludes the uppercase letter Q:

		```haxe
		my_txt.restrict = "A-Z^Q";
		```

		The following example allows a user to enter only the characters from
		ASCII 32 (space) to ASCII 126 (tilde).

		```haxe
		my_txt.restrict = "\u0020-\u007E";
		```

		**Note:** Restrictions apply only to user input; a script can insert any
		characters into the text field.
	**/
	public var restrict(get, set):String;

	@:noCompletion private function get_restrict():String
	{
		return __textField.restrict;
	}

	@:noCompletion private function set_restrict(value:String):String
	{
		return __textField.restrict = value;
	}

	/**
		Indicates the label on the Return key for devices that feature a soft
		keyboard. The available values are constants defined in the
		ReturnKeyLabel class:

		- `"default"`
		- `"done"`
		- `"go"`
		- `"next"`
		- `"search"`

		This property is only a hint to the underlying platform, because not all
		devices and operating systems support these values. This property has no
		effect on devices that do not feature a soft keyboard.
	**/
	public var returnKeyLabel:ReturnKeyLabel = DEFAULT;

	/**
		The zero-based character index value of the last character in the
		current selection. For example, the first character is 0, the second
		character is 1, and so on.

		If no text is selected, this method returns the insertion point. If the
		StageText instance does not have focus, this method returns `-1`.

		On iOS, this property is not supported for for non-multiline StageText
		objects and returns `-1`.
	**/
	public var selectionActiveIndex(get, never):Int;

	@:noCompletion private function get_selectionActiveIndex():Int
	{
		return __textField.selectionEndIndex;
	}

	/**
		The zero-based character index value of the first character in the
		current selection. For example, the first character is 0, the second
		character is 1, and so on.

		If no text is selected, this method returns the insertion point. If the
		StageText instance does not have focus, this method returns `-1`.

		On iOS, this property is not supported for for non-multiline StageText
		objects and returns `-1`.
	**/
	public var selectionAnchorIndex(get, never):Int;

	@:noCompletion private function get_selectionAnchorIndex():Int
	{
		return __textField.selectionBeginIndex;
	}

	/**
		Controls the appearance of the soft keyboard.

		Devices with soft keyboards can customize the keyboard's buttons to
		match the type of input expected. For example, if numeric input is
		expected, a device can use `SoftKeyboardType.NUMBER` to display only
		numbers on the soft keyboard. Valid values are defined as constants in
		the SoftKeyboardType class:

		- `"default"`
		- `"punctuation"`
		- `"url"`
		- `"number"`
		- `"contact"`
		- `"email"`
		- `"phone"`
		- `"decimalpad"`

		These values serve as hints, to help a device display the best keyboard
		for the current operation.
	**/
	public var softKeyboardType:SoftKeyboardType = DEFAULT;

	/**
		The stage on which this StageText object is displayed.

		Set `stage` to `null` to hide this StageText object.
	**/
	public var stage(get, set):Stage;

	@:noCompletion private function get_stage():Stage
	{
		return __textField.stage;
	}

	@:noCompletion private function set_stage(value:Stage):Stage
	{
		if (__textField.stage == value)
		{
			return __textField.stage;
		}
		if (__textField.stage != null)
		{
			__textField.parent.removeChild(__textField);
			__complete = false;
		}
		if (value != null)
		{
			value.addChild(__textField);
			__dispatchComplete();
		}
		return __textField.stage;
	}

	/**
		The current text in the text field. The carriage return character
		('\r', ASCII 13) separates lines of text. Text contained in this
		property is unformatted (it has no formatting tags).
	**/
	public var text(get, set):String;

	@:noCompletion private function get_text():String
	{
		return __textField.text;
	}

	@:noCompletion private function set_text(value:String):String
	{
		return __textField.text = value;
	}

	/**
		Indicates the paragraph alignment. Valid values are defined as constants
		in the TextFormatAlign class:

		-` "left"`
		- `"center"`
		- `"right"`
		- `"justify"`
		- `"start"`
		- `"end"`

		Not all platforms support every `textAlign` value. For unsupported
		`textAlign` values, platforms use the default value
		(`TextFormatAlign.START`).
	**/
	public var textAlign(get, set):TextFormatAlign;

	@:noCompletion private function get_textAlign():TextFormatAlign
	{
		return __textAlign;
	}

	@:noCompletion private function set_textAlign(value:TextFormatAlign):TextFormatAlign
	{
		if (__textAlign == value)
		{
			return __textAlign;
		}
		__textAlign = value;
		if (value == START)
		{
			value = LEFT;
		}
		else if (value == END)
		{
			value = RIGHT;
		}
		__textFormat.align = value;
		__textField.defaultTextFormat = __textFormat;
		__textField.setTextFormat(__textFormat);
		return __textAlign;
	}

	/**
		The area on the stage in which the StageText object is displayed. The
		default is the zero rect.
	**/
	public var viewPort(get, set):Rectangle;

	@:noCompletion private function get_viewPort():Rectangle
	{
		return __viewPort;
	}

	@:noCompletion private function set_viewPort(value:Rectangle):Rectangle
	{
		if (value == null || value.width < 0 || value.height < 0)
		{
			throw new RangeError("The Rectangle value is not valid.");
		}
		__complete = false;
		__viewPort = value;
		__textField.x = __viewPort.x;
		__textField.y = __viewPort.y;
		__textField.width = __viewPort.width;
		__textField.height = __viewPort.height;

		__dispatchComplete();

		return __viewPort;
	}

	/**
		Indicates whether the StageText object is visible. StageText objects
		that are not visible are disabled.
	**/
	public var visible(get, set):Bool;

	@:noCompletion private function get_visible():Bool
	{
		return __textField.visible;
	}

	@:noCompletion private function set_visible(value:Bool):Bool
	{
		return __textField.visible = value;
	}

	/**
		Creates a StageText object.

		The StageText object is invisible until it is attached to a stage and
		until the `viewPort` property is set.
	**/
	public function new(initOptions:StageTextInitOptions = null)
	{
		super();
		if (initOptions == null)
		{
			initOptions = new StageTextInitOptions(false);
		}
		__initOptions = initOptions;
		__createTextField();
	}

	/**
		Assigns focus to the StageText object. For non-editable objects,
		`assignFocus()` does nothing.
	**/
	public function assignFocus():Void
	{
		if (__textField.parent == null)
		{
			return;
		}
		__textField.stage.focus = __textField;
	}

	/**
		Disposes of the StageText object.

		Calling `dispose()` is optional. If you do not maintain a reference to
		this StageText instance, it is eligible for garbage collection. Calling
		`dispose()` can make garbage collection occur sooner, or occur at a more
		convenient time.

	**/
	public function dispose():Void
	{
		this.stage = null;
		__textField = null;
		__textFormat = null;
	}

	/**
		Draws the StageText's view port to a bitmap.

		Capture the bitmap and set the stage to `null` to display the content
		above the StageText object.

		The bitmap is typically the same width and height as the viewport.
		Starting with AIR 15.0, when the player is on HiDPI displays, the
		bitmap's width and height can optionally be `contentsScaleFactor` times
		the width and height of the viewport. For instance, on a Mac Retina
		Display, `contentsScaleFactor` is 2, because the pixel resolution of the
		stage is doubled, so the bitmap can correspondingly be twice the size of
		the viewport.

		If you call this method before the `Event.COMPLETE` event, the method
		could draw the view port incorrectly.
	**/
	public function drawViewPortToBitmapData(bitmapData:BitmapData):Void
	{
		if (bitmapData == null)
		{
			throw new Error("The bitmap is null.");
		}
		if (bitmapData.width != __viewPort.width || bitmapData.height != __viewPort.height)
		{
			throw new ArgumentError("The bitmap's width or height is different from view port's width or height.");
		}
		bitmapData.draw(__textField);
	}

	/**
		Selects the text specified by the index values of the first and last
		characters. You specify the first and last characters of the selection
		in the `anchorIndex` and `activeIndex` parameters. If both parameter
		values are the same, this method sets the insertion point.

		On iOS, for non-multiline StageText objects, this function is not
		supported and always returns `-1`. If you call this method selecting the
		complete text string, the selection is visible. However, if you call
		this method selecting a subset of the text string, the selection is not
		visible.

		For some devices or operating systems, the selection is only visible
		when the StageText object has focus.
	**/
	public function selectRange(anchorIndex:Int, activeIndex:Int):Void
	{
		__textField.setSelection(anchorIndex, activeIndex);
	}

	@:noCompletion private function __createTextField():Void
	{
		__textField = new TextField();
		__textField.type = INPUT;
		__textField.multiline = __initOptions.multiline;
		__textField.wordWrap = __initOptions.multiline;
		__textField.addEventListener(Event.CHANGE, textField_onEvent);
		__textField.addEventListener(FocusEvent.FOCUS_IN, textField_onEvent);
		__textField.addEventListener(FocusEvent.FOCUS_OUT, textField_onEvent);
		__textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_onEvent);
		__textField.addEventListener(KeyboardEvent.KEY_UP, textField_onEvent);
		__textField.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, textField_onKeyFocusChange);
		__textFormat = new TextFormat(null, 11, 0x000000, false, false, false);
		__textField.defaultTextFormat = __textFormat;
	}

	@:noCompletion private function __dispatchComplete():Void
	{
		if (__textField.stage == null || __viewPort.isEmpty())
		{
			__complete = false;
		}
		if (!__complete && __textField.stage != null && !__viewPort.isEmpty())
		{
			__complete = true;
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}

	@:noCompletion private function textField_onEvent(event:Event):Void
	{
		dispatchEvent(event);
	}

	@:noCompletion private function textField_onKeyFocusChange(event:Event):Void
	{
		// this event should not be dispatched and should not bubble
		event.preventDefault();
		event.stopImmediatePropagation();
		event.stopPropagation();
	}
}
#else
#if air
typedef StageText = flash.text.StageText;
#end
#end
