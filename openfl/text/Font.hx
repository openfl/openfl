/*
 
 This class provides code completion and inline documentation, but it does 
 not contain runtime support. It should be overridden by a compatible
 implementation in an OpenFL backend, depending upon the target platform.
 
*/

package openfl.text;
#if display


/**
 * The Font class is used to manage embedded fonts in SWF files. Embedded
 * fonts are represented as a subclass of the Font class. The Font class is
 * currently useful only to find out information about embedded fonts; you
 * cannot alter a font by using this class. You cannot use the Font class to
 * load external fonts, or to create an instance of a Font object by itself.
 * Use the Font class as an abstract base class.
 */
extern class Font {

	/**
	 * The name of an embedded font.
	 */
	var fontName(default,null) : String;

	/**
	 * The style of the font. This value can be any of the values defined in the
	 * FontStyle class.
	 */
	var fontStyle(default,null) : FontStyle;

	/**
	 * The type of the font. This value can be any of the constants defined in
	 * the FontType class.
	 */
	var fontType(default,null) : FontType;
	function new() : Void;

	/**
	 * Specifies whether to provide a list of the currently available embedded
	 * fonts.
	 * 
	 * @param enumerateDeviceFonts Indicates whether you want to limit the list
	 *                             to only the currently available embedded
	 *                             fonts. If this is set to <code>true</code>
	 *                             then a list of all fonts, both device fonts
	 *                             and embedded fonts, is returned. If this is
	 *                             set to <code>false</code> then only a list of
	 *                             embedded fonts is returned.
	 * @return A list of available fonts as an array of Font objects.
	 */
	static function enumerateFonts(enumerateDeviceFonts : Bool = false) : Array<Font>;

	/**
	 * Registers a font class in the global font list.
	 * 
	 */
	static function registerFont(font : Class<Dynamic>) : Void;
}


#end
