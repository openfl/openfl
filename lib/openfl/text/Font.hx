package openfl.text; #if (display || !flash)


import openfl.utils.Future;
// import lime.text.Font in LimeFont;
import openfl.utils.ByteArray;

@:jsRequire("openfl/text/Font", "default")

/**
 * The Font class is used to manage embedded fonts in SWF files. Embedded
 * fonts are represented as a subclass of the Font class. The Font class is
 * currently useful only to find out information about embedded fonts; you
 * cannot alter a font by using this class. You cannot use the Font class to
 * load external fonts, or to create an instance of a Font object by itself.
 * Use the Font class as an abstract base class.
 */
extern class Font /*extends LimeFont*/ {
	
	
	/**
	 * The name of an embedded font.
	 */
	public var fontName:String;
	
	/**
	 * The style of the font. This value can be any of the values defined in the
	 * FontStyle class.
	 */
	public var fontStyle:FontStyle;
	
	/**
	 * The type of the font. This value can be any of the constants defined in
	 * the FontType class.
	 */
	public var fontType:FontType;
	
	
	public function new (name:String = null);
	
	
	/**
	 * Specifies whether to provide a list of the currently available embedded
	 * fonts.
	 * 
	 * @param enumerateDeviceFonts Indicates whether you want to limit the list
	 *                             to only the currently available embedded
	 *                             fonts. If this is set to `true`
	 *                             then a list of all fonts, both device fonts
	 *                             and embedded fonts, is returned. If this is
	 *                             set to `false` then only a list of
	 *                             embedded fonts is returned.
	 * @return A list of available fonts as an array of Font objects.
	 */
	public static function enumerateFonts (enumerateDeviceFonts:Bool = false):Array<Font>;
	
	
	public static function fromBytes (bytes:ByteArray):Font;
	
	
	public static function fromFile (path:String):Font;
	
	
	public static function loadFromBytes (bytes:ByteArray):Future<Font>;
	public static function loadFromFile (path:String):Future<Font>;
	public static function loadFromName (path:String):Future<Font>;
	
	
	#if flash
	@:noCompletion @:dox(hide) public function hasGlyphs (str:String):Bool;
	#end
	
	
	/**
	 * Registers a font class in the global font list.
	 * 
	 */
	public static function registerFont (font:Class<Dynamic>):Void;
	
	
}


#else
typedef Font = flash.text.Font;
#end