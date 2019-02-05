package openfl.text;

#if !flash
import openfl.utils.Assets;
import openfl.utils.ByteArray;
import openfl.utils.Future;
#if lime
import lime.text.Font as LimeFont;
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
class Font #if lime extends LimeFont #end
{
	/**
		The name of an embedded font.
	**/
	public var fontName(get, set):String;

	/**
		The style of the font. This value can be any of the values defined in the
		FontStyle class.
	**/
	public var fontStyle:FontStyle;

	/**
		The type of the font. This value can be any of the constants defined in
		the FontType class.
	**/
	public var fontType:FontType;

	@:noCompletion private static var __fontByName:Map<String, Font> = new Map();
	@:noCompletion private static var __registeredFonts:Array<Font> = new Array();

	@:noCompletion private var __initialized:Bool;

	#if openfljs
	@:noCompletion private static function __init__()
	{
		untyped Object.defineProperty(Font.prototype, "fontName",
			{
				get: untyped __js__("function () { return this.get_fontName (); }"),
				set: untyped __js__("function (v) { return this.set_fontName (v); }")
			});
	}
	#end

	public function new(name:String = null)
	{
		#if lime
		super(name);
		#end
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
		return __registeredFonts;
	}

	public static function fromBytes(bytes:ByteArray):Font
	{
		var font = new Font();
		#if lime
		font.__fromBytes(bytes);
		#end

		#if lime_cffi
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
	}

	public static function fromFile(path:String):Font
	{
		var font = new Font();
		#if lime
		font.__fromFile(path);
		#end

		#if lime_cffi
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
	}

	/**
		Specifies whether a provided string can be displayed using the
		currently assigned font.

		@param str The string to test against the current font.
		@return A value of `true` if the specified string can be fully
				displayed using this font.
	**/
	// @:noCompletion @:dox(hide) public function hasGlyphs (str:String):Bool;
	public static function loadFromBytes(bytes:ByteArray):Future<Font>
	{
		#if lime
		return LimeFont.loadFromBytes(bytes).then(function(limeFont)
		{
			var font = new Font();
			font.__fromLimeFont(limeFont);

			return Future.withValue(font);
		});
		#else
		return cast Future.withError("Cannot load font from bytes");
		#end
	}

	public static function loadFromFile(path:String):Future<Font>
	{
		#if lime
		return LimeFont.loadFromFile(path).then(function(limeFont)
		{
			var font = new Font();
			font.__fromLimeFont(limeFont);

			return Future.withValue(font);
		});
		#else
		return cast Future.withError("Cannot load font from file");
		#end
	}

	public static function loadFromName(path:String):Future<Font>
	{
		#if lime
		return LimeFont.loadFromName(path).then(function(limeFont)
		{
			var font = new Font();
			font.__fromLimeFont(limeFont);

			return Future.withValue(font);
		});
		#else
		return cast Future.withError("Cannot load font from name");
		#end
	}

	/**
		Registers a font in the global font list.

	**/
	public static function registerFont(font:Dynamic):Void
	{
		var instance:Font = null;

		if (Type.getClass(font) == null)
		{
			instance = cast(Type.createInstance(font, []), Font);
		}
		else
		{
			instance = cast(font, Font);
		}

		if (instance != null)
		{
			/*if (Reflect.hasField (font, "resourceName")) {

				instance.fontName = __ofResource (Reflect.field (font, "resourceName"));

			}*/

			__registeredFonts.push(instance);
			__fontByName[instance.fontName] = instance;
		}
	}

	#if lime
	@:noCompletion private function __fromLimeFont(font:LimeFont):Void
	{
		__copyFrom(font);
	}
	#end

	@:noCompletion private function __initialize():Bool
	{
		#if native
		if (!__initialized)
		{
			if (src != null)
			{
				// TODO: How does src get defined without being initialized in Lime?
				if (unitsPerEM == 0) __initializeSource();
				__initialized = true;
			}
			else if (src == null && __fontID != null && Assets.isLocal(__fontID))
			{
				__fromBytes(Assets.getBytes(__fontID));
				__initialized = true;
			}
		}
		#end

		return __initialized;
	}

	// Get & Set Methods
	@:noCompletion private inline function get_fontName():String
	{
		#if lime
		return name;
		#else
		return null;
		#end
	}

	@:noCompletion private inline function set_fontName(value:String):String
	{
		#if lime
		return name = value;
		#else
		return value;
		#end
	}
}
#else
typedef Font = flash.text.Font;
#end
