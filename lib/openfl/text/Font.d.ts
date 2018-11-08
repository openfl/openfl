import FontStyle from "./FontStyle";
import FontType from "./FontType";
import ByteArray from "./../utils/ByteArray";
import Future from "./../utils/Future";


declare namespace openfl.text {
	
	
	/**
	 * The Font class is used to manage embedded fonts in SWF files. Embedded
	 * fonts are represented as a subclass of the Font class. The Font class is
	 * currently useful only to find out information about embedded fonts; you
	 * cannot alter a font by using this class. You cannot use the Font class to
	 * load external fonts, or to create an instance of a Font object by itself.
	 * Use the Font class as an abstract base class.
	 */
	export class Font /*extends LimeFont*/ {
		
		
		/**
		 * The name of an embedded font.
		 */
		public fontName:string;
		
		protected get_fontName ():string;
		protected set_fontName (value:string):string;
		
		/**
		 * The style of the font. This value can be any of the values defined in the
		 * FontStyle class.
		 */
		public fontStyle:FontStyle;
		
		/**
		 * The type of the font. This value can be any of the constants defined in
		 * the FontType class.
		 */
		public fontType:FontType;
		
		
		public constructor (name?:string);
		
		
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
		public static enumerateFonts (enumerateDeviceFonts?:boolean):Array<Font>;
		
		
		public static fromBytes (bytes:ByteArray):Font;
		
		
		public static fromFile (path:string):Font;
		
		
		public static loadFromBytes (bytes:ByteArray):Future<Font>;
		public static loadFromFile (path:string):Future<Font>;
		public static loadFromName (path:string):Future<Font>;
		
		
		// #if flash
		// @:noCompletion @:dox(hide) public hasGlyphs (str:string):boolean;
		// #end
		
		
		/**
		 * Registers a font in the global font list.
		 * 
		 */
		public static registerFont (font:any):void;
		
		
	}
	
	
}


export default openfl.text.Font;