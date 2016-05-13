package flash.text; #if (!display && flash)


import lime.text.Font in LimeFont;
import openfl.utils.ByteArray;


extern class Font extends LimeFont {
	
	
	public var fontName (default, null):String;
	public var fontStyle (default, null):FontStyle;
	public var fontType (default, null):FontType;
	
	public function new (#if (!flash || display) name:String = null #end);
	public static function enumerateFonts (enumerateDeviceFonts:Bool = false):Array<Font>;
	public static function fromBytes (bytes:ByteArray):Font;
	public static function fromFile (path:String):Font;
	
	#if (flash && !display)
	public function hasGlyphs (str:String):Bool;
	#end
	
	public static function registerFont (font:Class<Dynamic>):Void;
	
	
}


#else
typedef Font = openfl.text.Font;
#end