package flash.text {
	
	
	/**
	 * The FontType class contains the enumerated constants
	 * `"embedded"` and `"device"` for the
	 * `fontType` property of the Font class.
	 */
	final public class FontType {
		
		/**
		 * Indicates that this is a device font. The SWF file renders fonts with
		 * those installed on the system.
		 *
		 * Using device fonts results in a smaller movie size, because font data
		 * is not included in the file. Device fonts are often a good choice for
		 * displaying text at small point sizes, because anti-aliased text can be
		 * blurry at small sizes. Device fonts are also a good choice for large
		 * blocks of text, such as scrolling text.
		 *
		 * Text fields that use device fonts may not be displayed the same across
		 * different systems and platforms, because they are rendered with fonts
		 * installed on the system. For the same reason, device fonts are not
		 * anti-aliased and may appear jagged at large point sizes.
		 */
		public static const DEVICE:String = "device";
		
		/**
		 * Indicates that this is an embedded font. Font outlines are embedded in the
		 * published SWF file.
		 *
		 * Text fields that use embedded fonts are always displayed in the chosen
		 * font, whether or not that font is installed on the playback system. Also,
		 * text fields that use embedded fonts are always anti-aliased(smoothed).
		 * You can select the amount of anti-aliasing you want by using the
		 * `TextField.antiAliasType property`.
		 *
		 * One drawback to embedded fonts is that they increase the size of the
		 * SWF file.
		 *
		 * Fonts of type `EMBEDDED` can only be used by TextField. If
		 * flash.text.engine classes are directed to use such a font they will fall
		 * back to device fonts.
		 */
		public static const EMBEDDED:String = "embedded";
		
		public static const EMBEDDED_CFF:String = "embeddedCFF";
		
	}
	
	
}