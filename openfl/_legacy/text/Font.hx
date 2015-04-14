package openfl._legacy.text; #if openfl_legacy


import haxe.Resource;
import openfl._legacy.Assets;
import openfl.display.Stage;
import openfl.utils.ByteArray;
import openfl.Lib;

#if lime_hybrid
import lime.text.Font in LimeFont;
#end

#if lime_hybrid
@:autoBuild(openfl.Assets.embedFont())
#else
@:autoBuild(openfl._legacy.Assets.embedFont())
#end


class Font {
	
	
	public var fontName (default, null):String;
	public var fontStyle (default, null):FontStyle;
	public var fontType (default, null):FontType;
	
	@:noCompletion private var __fontPath:String;
	
	@:noCompletion private static var __registeredFonts = new Array<Font> ();
	@:noCompletion private static var __deviceFonts:Array<Font>;
	
	
	public function new (filename:String = "", style:FontStyle = null, type:FontType = null):Void {
		
		if (filename == "") {
			
			var fontClass = Type.getClass (this);
			
			if (Reflect.hasField (fontClass, "resourceName")) {
				
				__fromBytes (ByteArray.fromBytes (Resource.getBytes (Reflect.field (fontClass, "resourceName"))));
				
			} else {
				
				//var className = Type.getClassName (Type.getClass (this));
				//fontName = className.split (".").pop ();
				//fontStyle = FontStyle.REGULAR;
				//fontType = FontType.EMBEDDED;
				
			}
			
		} else {
			
			__fontPath = filename;
			fontName = filename;
			fontStyle = style == null ? FontStyle.REGULAR : style;
			fontType = type == null ? FontType.EMBEDDED : type;
			
		}
		
	}
	
	
	public static function enumerateFonts (enumerateDeviceFonts:Bool = false):Array<Font> {
		
		var result = __registeredFonts.copy ();
		
		if (enumerateDeviceFonts) {
			
			if (__deviceFonts == null) {
				
				__deviceFonts = new Array<Font> ();
				var styles = [ FontStyle.BOLD, FontStyle.BOLD_ITALIC, FontStyle.ITALIC, FontStyle.REGULAR ];
				lime_font_iterate_device_fonts (function (name, style) __deviceFonts.push (new Font (name, styles[style], FontType.DEVICE)));
				
			}
			
			result = result.concat (__deviceFonts);
			
		}
		
		return result;
		
	}
	
	
	public static function fromBytes (bytes:ByteArray):Font {
		
		var font = new Font ();
		font.__fromBytes (bytes);
		return font;
		
	}
	
	
	public static function fromFile (path:String):Font {
		
		var font = new Font ();
		font.__fromFile (path);
		return font;
		
	}
	
	
	public static function load (filename:String):NativeFontData {
		
		var result = freetype_import_font (filename, null, 1024 * 20, null);
		return result;
		
	}
	
	
	public static function loadBytes (bytes:ByteArray):NativeFontData {
		
		var result = freetype_import_font ("", null, 1024 * 20, bytes);
		return result;
		
	}
	
	
	public static function registerFont (font:Class<Font>):Void {
		
		var instance = Type.createInstance (font, []);
		
		if (instance != null) {
			
			if (Reflect.hasField (font, "resourceName")) {
				
				lime_font_register_font (instance.fontName, ByteArray.fromBytes (Resource.getBytes (Reflect.field (font, "resourceName"))));
				
			}
			
			__registeredFonts.push (cast instance);
			
		}
		
	}
	
	
	public function toString ():String {
		
		return "{ name=" + fontName + ", style=" + fontStyle + ", type=" + fontType + " }";
		
	}
	
	
	@:noCompletion private function __fromBytes (bytes:ByteArray):Void {
		
		var details = loadBytes (bytes);
		fontName = details.family_name;
		
		if (details.is_bold && details.is_italic) {
			
			fontStyle = FontStyle.BOLD_ITALIC;
			
		} else if (details.is_bold) {
			
			fontStyle = FontStyle.BOLD;
			
		} else if (details.is_italic) {
			
			fontStyle = FontStyle.ITALIC;
			
		} else {
			
			fontStyle = FontStyle.REGULAR;
			
		}
		
		fontType = FontType.EMBEDDED;
		
	}
	
	
	@:noCompletion private function __fromFile (path:String):Void {
		
		__fontPath = path;
		
		if (__fontPath != null) {
			
			var details = Font.load (__fontPath);
			fontName = details.family_name;
			
			if (details.is_bold && details.is_italic) {
				
				fontStyle = FontStyle.BOLD_ITALIC;
				
			} else if (details.is_bold) {
				
				fontStyle = FontStyle.BOLD;
				
			} else if (details.is_italic) {
				
				fontStyle = FontStyle.ITALIC;
				
			} else {
				
				fontStyle = FontStyle.REGULAR;
				
			}
			
			fontType = FontType.EMBEDDED;
			
		}
		
	}
	
	
	#if lime_hybrid
	public static function __fromLimeFont (value:LimeFont):Font {
		
		var font = new Font ();
		font.fontName = value.name;
		font.__fontPath = value.src;
		return font;
		
	}
	
	public var name (get, set):String;
	
	private function get_name ():String { return fontName; }
	private function set_name (value:String):String { return fontName = value; }
	#end
	
	
	
	
	// Native Methods
	
	
	
	
	private static var freetype_import_font = Lib.load ("lime-legacy", "freetype_import_font", 4);
	private static var lime_font_register_font = Lib.load ("lime-legacy", "lime_legacy_font_register_font", 2);
	private static var lime_font_iterate_device_fonts = Lib.load ("lime-legacy", "lime_legacy_font_iterate_device_fonts", 1);
	
	
}


typedef NativeFontData = {
	
	var has_kerning: Bool;
	var is_fixed_width: Bool;
	var has_glyph_names: Bool;
	var is_italic: Bool;
	var is_bold: Bool;
	var num_glyphs: Int;
	var family_name: String;
	var style_name: String;
	var em_size: Int;
	var ascend: Int;
	var descend: Int;
	var height: Int;
	var glyphs: Array<NativeGlyphData>;
	var kerning: Array<NativeKerningData>;
	
}


typedef NativeGlyphData = {
	
	var char_code: Int;
	var advance: Int;
	var min_x: Int;
	var max_x: Int;
	var min_y: Int;
	var max_y: Int;
	var points: Array<Int>;
	
}


typedef NativeKerningData = {
	
	var left_glyph:Int;
	var right_glyph:Int;
	var x:Int;
	var y:Int;
	
}


#end