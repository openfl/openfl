package openfl.text;


import lime.text.Font in LimeFont;
import openfl.utils.ByteArray;


class Font extends LimeFont {
	
	
	public var fontName (get, set):String;
	public var fontStyle:FontStyle;
	public var fontType:FontType;
	
	private static var __registeredFonts = new Array<Font> ();
	
	
	public function new (name:String = null) {
		
		super (name);
		
	}
	
	
	public static function enumerateFonts (enumerateDeviceFonts:Bool = false):Array<Font> {
		
		return __registeredFonts;
		
	}
	
	
	public static function fromBytes (bytes:ByteArray):Font {
		
		var font = new Font ();
		font.__fromBytes (bytes);
		
		#if lime_cffi
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
		
	}
	
	
	public static function fromFile (path:String):Font {
		
		var font = new Font ();
		font.__fromFile (path);
		
		#if lime_cffi
		return (font.src != null) ? font : null;
		#else
		return font;
		#end
		
	}
	
	
	public static function registerFont (font:Class<Dynamic>) {
		
		var instance = cast (Type.createInstance (font, []), Font);
		
		if (instance != null) {
			
			/*if (Reflect.hasField (font, "resourceName")) {
				
				instance.fontName = __ofResource (Reflect.field (font, "resourceName"));
				
			}*/
			
			__registeredFonts.push (instance);
			
		}
		
	}
	
	
	private static function __fromLimeFont (value:LimeFont):Font {
		
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