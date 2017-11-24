package openfl.text;


import lime.text.Font in LimeFont;
import openfl.utils.Assets;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class Font extends LimeFont {
	
	
	public var fontName (get, set):String;
	public var fontStyle:FontStyle;
	public var fontType:FontType;
	
	private static var __fontByName = new Map<String, Font> ();
	private static var __registeredFonts = new Array<Font> ();
	
	private var __initialized:Bool;
	
	
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
			__fontByName[instance.name] = instance;
			
		}
		
	}
	
	
	private static function __fromLimeFont (value:LimeFont):Font {
		
		var font = new Font ();
		font.name = value.name;
		font.src = value.src;
		return font;
		
	}
	
	
	private function __initialize ():Bool {
		
		#if native
		if (!__initialized) {
			
			if (src != null) {
				
				__initialized = true;
				
			} #if (lime >= "5.9.0") else if (src == null && __fontID != null && Assets.isLocal (__fontID)) {
				
				__fromBytes (Assets.getBytes (__fontID));
				__initialized = true;
				
			} #end
			
		}
		#end
		
		return __initialized;
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private inline function get_fontName ():String {
		
		return name;
		
	}
	
	
	private inline function set_fontName (value:String):String {
		
		return name = value;
		
	}
	
	
}