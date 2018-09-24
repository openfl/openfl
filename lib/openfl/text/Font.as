package openfl.text {
	
	
	import openfl.utils.Future;
	// import lime.text.Font in LimeFont;
	import openfl.utils.ByteArray;
	
	
	/**
	 * @externs
	 * The Font class is used to manage embedded fonts in SWF files. Embedded
	 * fonts are represented as a subclass of the Font class. The Font class is
	 * currently useful only to find out information about embedded fonts; you
	 * cannot alter a font by using this class. You cannot use the Font class to
	 * load external fonts, or to create an instance of a Font object by itself.
	 * Use the Font class as an abstract base class.
	 */
	public class Font /*extends LimeFont*/ {
		
		
		/**
		 * The name of an embedded font.
		 */
		public var fontName:String;
		
		protected function get_fontName ():String { return null; }
		protected function set_fontName (value:String):String { return null; }
		
		/**
		 * The style of the font. This value can be any of the values defined in the
		 * FontStyle class.
		 */
		public var fontStyle:String;
		
		/**
		 * The type of the font. This value can be any of the constants defined in
		 * the FontType class.
		 */
		public var fontType:String;
		
		
		public function Font (name:String = null) {}
		
		
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
		public static function enumerateFonts (enumerateDeviceFonts:Boolean = false):Array { return null; }
		
		
		public static function fromBytes (bytes:ByteArray):Font { return null; }
		
		
		public static function fromFile (path:String):Font { return null; }
		
		
		public static function loadFromBytes (bytes:ByteArray):Future { return null; }
		public static function loadFromFile (path:String):Future { return null; }
		public static function loadFromName (path:String):Future { return null; }
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public function hasGlyphs (str:String):Bool;
		// #end
		
		
		/**
		 * Registers a font in the global font list.
		 * 
		 */
		public static function registerFont (font:*):void {}
		
		
	}
	
	
}