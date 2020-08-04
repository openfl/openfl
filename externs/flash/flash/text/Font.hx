package flash.text;

#if flash
import lime.text.Font in LimeFont;
import openfl.utils.ByteArray;

extern class Font extends LimeFont
{
	public var fontName(default, never):String;
	public var fontStyle(default, never):FontStyle;
	public var fontType(default, never):FontType;
	public function new(#if (!flash || display) name:String = null #end);
	public static function enumerateFonts(enumerateDeviceFonts:Bool = false):Array<Font>;
	public static function fromBytes(bytes:ByteArray):Font;
	public static function fromFile(path:String):Font;
	#if (flash && !display)
	public function hasGlyphs(str:String):Bool;
	#end
	@:native("registerFont") @:noCompletion private static function __registerFont(font:Class<Dynamic>):Void;
	public static inline function registerFont(font:Dynamic):Void
	{
		try
		{
			if ((font is Class))
			{
				__registerFont(cast font);
			}
			else
			{
				__registerFont(Type.getClass(font));
			}
		}
		catch (e:Dynamic) {}
	}
}
#else
typedef Font = openfl.text.Font;
#end
