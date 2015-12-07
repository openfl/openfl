package openfl.text; #if (!display && !flash) #if !openfl_legacy


import lime.text.Font in LimeFont;
import openfl.utils.ByteArray;


/**
 * The Font class is used to manage embedded fonts in SWF files. Embedded
 * fonts are represented as a subclass of the Font class. The Font class is
 * currently useful only to find out information about embedded fonts; you
 * cannot alter a font by using this class. You cannot use the Font class to
 * load external fonts, or to create an instance of a Font object by itself.
 * Use the Font class as an abstract base class.
 */
class Font extends LimeFont {
	
	
	/**
	 * The name of an embedded font.
	 */
	public var fontName (get, set):String;
	
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
	
	@:noCompletion private static var __registeredFonts = new Array<Font> ();
	
	
	public function new (name:String = null) {
		
		super (name);
		
	}
	
	
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
	public static function enumerateFonts (enumerateDeviceFonts:Bool = false):Array<Font> {
		
		return __registeredFonts;
		
	}
	
	
	public static function fromBytes (bytes:ByteArray):Font {
		
		var font = new Font ();
		font.__fromBytes (bytes);
		
		#if (cpp || neko || nodejs)
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
		
	}
	
	
	public static function fromFile (path:String):Font {
		
		var font = new Font ();
		font.__fromFile (path);
		
		#if (cpp || neko || nodejs)
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
		
	}
	
	
	/**
	 * Registers a font class in the global font list.
	 * 
	 */
	public static function registerFont (font:Class<Dynamic>) {
		
		var instance = cast (Type.createInstance (font, []), Font);
		
		if (instance != null) {
			
			/*if (Reflect.hasField (font, "resourceName")) {
				
				instance.fontName = __ofResource (Reflect.field (font, "resourceName"));
				
			}*/
			
			__registeredFonts.push (instance);
			
		}
		
	}
	
	
	@:noCompletion private static function __fromLimeFont (value:LimeFont):Font {
		
		var font = new Font ();
		font.name = value.name;
		font.src = value.src;
		return font;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private inline function get_fontName ():String {
		
		return name;
		
	}
	
	
	private inline function set_fontName (value:String):String {
		
		return name = value;
		
	}
	
	
}


#else
typedef Font = openfl._legacy.text.Font;
#end
#else


import lime.text.Font in LimeFont;
import openfl.utils.ByteArray;

/**
 * The Font class is used to manage embedded fonts in SWF files. Embedded
 * fonts are represented as a subclass of the Font class. The Font class is
 * currently useful only to find out information about embedded fonts; you
 * cannot alter a font by using this class. You cannot use the Font class to
 * load external fonts, or to create an instance of a Font object by itself.
 * Use the Font class as an abstract base class.
 */

#if flash
@:native("flash.text.Font")
#end


extern class Font extends LimeFont {
	
	
	/**
	 * The name of an embedded font.
	 */
	#if (flash && !display)
	public var fontName (default, null):String;
	#else
	public var fontName (get, set):String;
	#end
	
	/**
	 * The style of the font. This value can be any of the values defined in the
	 * FontStyle class.
	 */
	#if (flash && !display)
	public var fontStyle (default, null):FontStyle;
	#else
	public var fontStyle:FontStyle;
	#end
	
	/**
	 * The type of the font. This value can be any of the constants defined in
	 * the FontType class.
	 */
	#if (flash && !display)
	public var fontType (default, null):FontType;
	#else
	public var fontType:FontType;
	#end
	
	
	public function new (#if (!flash || display) name:String = null #end);
	
	
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
	public static function enumerateFonts (enumerateDeviceFonts:Bool = false):Array<Font>;
	
	
	public static function fromBytes (bytes:ByteArray):Font;
	
	
	public static function fromFile (path:String):Font;
	
	
	#if (flash && !display)
	public function hasGlyphs (str:String):Bool;
	#end
	
	
	/**
	 * Registers a font class in the global font list.
	 * 
	 */
	public static function registerFont (font:Class<Dynamic>):Void;
	
	
}


#end