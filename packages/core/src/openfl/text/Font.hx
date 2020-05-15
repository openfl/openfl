package openfl.text;

#if !flash
import openfl._internal.utils.Log;
import openfl.utils.Assets;
import openfl.utils.ByteArray;
import openfl.utils.Future;
import openfl.utils.Promise;
#if lime
import lime.text.Font as LimeFont;
#end
#if openfl_html5
import js.html.SpanElement;
import js.Browser;
#end

/**
	The Font class is used to manage embedded fonts in SWF files. Embedded
	fonts are represented as a subclass of the Font class. The Font class is
	currently useful only to find out information about embedded fonts; you
	cannot alter a font by using this class. You cannot use the Font class to
	load external fonts, or to create an instance of a Font object by itself.
	Use the Font class as an abstract base class.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
class Font
{
	/**
		The name of an embedded font.
	**/
	public var fontName(get, never):String;

	/**
		The style of the font. This value can be any of the values defined in the
		FontStyle class.
	**/
	public var fontStyle(get, never):FontStyle;

	/**
		The type of the font. This value can be any of the constants defined in
		the FontType class.
	**/
	public var fontType(get, never):FontType;

	#if lime
	public var limeFont(get, never):LimeFont;

	// TODO: Remove
	@:noCompletion private function __fromLimeFont(font:LimeFont):Void
	{
		return (_ : _Font).__fromLimeFont(font);
	}

	@:noCompletion public var name(get, set):String;

	@:noCompletion private function get_name():String
	{
		return _.limeFont.name;
	}

	@:noCompletion private function set_name(value:String):String
	{
		return @:privateAccess _.limeFont.name = value;
	}

	@:noCompletion private var __fontPath(get, set):String;

	@:noCompletion private function get___fontPath():String
	{
		return @:privateAccess _.limeFont.__fontPath;
	}

	@:noCompletion private function set___fontPath(value:String):String
	{
		return @:privateAccess _.limeFont.__fontPath = value;
	}
	#end

	@:allow(openfl) @:noCompletion private var _:_Font;

	private function new()
	{
		if (_ == null)
		{
			_ = new _Font(this);
		}
	}

	/**
		Specifies whether to provide a list of the currently available embedded
		fonts.

		@param enumerateDeviceFonts Indicates whether you want to limit the list
									to only the currently available embedded
									fonts. If this is set to `true`
									then a list of all fonts, both device fonts
									and embedded fonts, is returned. If this is
									set to `false` then only a list of
									embedded fonts is returned.
		@return A list of available fonts as an array of Font objects.
	**/
	public static function enumerateFonts(enumerateDeviceFonts:Bool = false):Array<Font>
	{
		return _Font.enumerateFonts(enumerateDeviceFonts);
	}

	/**
		Creates a new Font from bytes (a haxe.io.Bytes or openfl.utils.ByteArray)
		synchronously. This means that the Font will be returned immediately (if
		supported).

		@param	bytes	A haxe.io.Bytes or openfl.utils.ByteArray instance
		@returns	A new Font if successful, or `null` if unsuccessful
	**/
	public static function fromBytes(bytes:ByteArray):Font
	{
		return _Font.fromBytes(bytes);
	}

	/**
		Creates a new Font from a file path synchronously. This means that the
		Font will be returned immediately (if supported).

		@param	path	A local file path containing a font
		@returns	A new Font if successful, or `null` if unsuccessful
	**/
	public static function fromFile(path:String):Font
	{
		return _Font.fromFile(path);
	}

	#if lime
	public static function fromLimeFont(limeFont:LimeFont):Font
	{
		return _Font.fromLimeFont(limeFont);
	}
	#end

	#if false
	/**
		Specifies whether a provided string can be displayed using the
		currently assigned font.

		@param str The string to test against the current font.
		@return A value of `true` if the specified string can be fully
				displayed using this font.
	**/
	// @:noCompletion @:dox(hide) public function hasGlyphs (str:String):Bool;
	#end

	/**
		Creates a new Font from haxe.io.Bytes or openfl.utils.ByteArray data
		asynchronously. The font decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	bytes	A haxe.io.Bytes or openfl.utils.ByteArray instance
		@returns	A Future Font
	**/
	public static function loadFromBytes(bytes:ByteArray):Future<Font>
	{
		return _Font.loadFromBytes(bytes);
	}

	/**
		Creates a new Font from a file path or web address asynchronously. The file
		load and font decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A local file path or web address containing a font
		@returns	A Future Font
	**/
	public static function loadFromFile(path:String):Future<Font>
	{
		return _Font.loadFromFile(path);
	}

	/**
		Creates a new Font from a font name asynchronously. This feature should work
		for embedded CSS fonts on the HTML5 target, but is not implemented for
		registered OS fonts on native targets currently. The file
		load and font decoding will occur in the background.
		Progress, completion and error callbacks will be dispatched in the current
		thread using callbacks attached to a returned Future object.

		@param	path	A font name
		@returns	A Future Font
	**/
	public static function loadFromName(path:String):Future<Font>
	{
		return _Font.loadFromName(path);
	}

	/**
		Registers a font in the global font list.

	**/
	public static function registerFont(font:Dynamic):Void
	{
		_Font.registerFont(font);
	}

	// Get & Set Methods

	@:noCompletion private inline function get_fontName():String
	{
		return (_ : _Font).fontName;
	}

	@:noCompletion private inline function get_fontStyle():FontStyle
	{
		return (_ : _Font).fontStyle;
	}

	@:noCompletion private inline function get_fontType():FontType
	{
		return (_ : _Font).fontType;
	}

	#if lime
	@:noCompletion private inline function get_limeFont():LimeFont
	{
		return (_ : _Font).limeFont;
	}
	#end
}
#else
typedef Font = flash.text.Font;
#end
