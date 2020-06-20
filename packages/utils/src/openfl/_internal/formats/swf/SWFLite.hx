package openfl._internal.formats.swf;

import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl._internal.symbols.BitmapSymbol;
import openfl._internal.symbols.SpriteSymbol;
import openfl._internal.symbols.SWFSymbol;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.Assets;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.symbols.SWFSymbol)
@SuppressWarnings("checkstyle:FieldDocComment")
@:keep class SWFLite
{
	public static var instances:Map<String, SWFLite> = new Map();

	public var frameRate:Float;
	public var library:SWFLiteLibrary;
	public var root:SpriteSymbol;
	public var symbols:Map<Int, SWFSymbol>;

	private var symbolsByClassName:Map<String, SWFSymbol>;

	public function new()
	{
		symbols = new Map<Int, SWFSymbol>();
		symbolsByClassName = new Map<String, SWFSymbol>();

		// distinction of symbol by class name and characters by ID somewhere?
	}

	public function createButton(className:String):SimpleButton
	{
		return null;
	}

	public function createMovieClip(className:String = ""):MovieClip
	{
		if (className == "")
		{
			return cast root.__createObject(this);
		}
		else
		{
			var symbol = symbolsByClassName.get(className);
			if (symbol != null)
			{
				if (Std.is(symbol, SpriteSymbol))
				{
					return cast(symbol, SpriteSymbol).__createObject(this);
				}
			}
		}

		return null;
	}

	public function getBitmapData(className:String):BitmapData
	{
		var symbol = symbolsByClassName.get(className);

		if (symbol != null)
		{
			if (Std.is(symbol, BitmapSymbol))
			{
				var bitmap:BitmapSymbol = cast symbol;
				return Assets.getBitmapData(bitmap.path);
			}
		}

		return null;
	}

	public function hasSymbol(className:String):Bool
	{
		return symbolsByClassName.exists(className);
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function resolveClass(name:String):Class<Dynamic>
	{
		var value = Type.resolveClass(name);

		#if flash
		if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl", "flash"));
		if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl._legacy", "flash"));
		if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl._v2", "flash"));
		#elseif openfl_legacy
		if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl", "openfl._legacy"));
		#else
		if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl._legacy", "openfl"));
		if (value == null) value = Type.resolveClass(StringTools.replace(name, "openfl._v2", "openfl"));
		#end

		return value;
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private static function resolveEnum(name:String):Enum<Dynamic>
	{
		var value = Type.resolveEnum(name);

		#if flash
		if (value == null) value = Type.resolveEnum(StringTools.replace(name, "openfl", "flash"));
		if (value == null) value = Type.resolveEnum(StringTools.replace(name, "openfl._legacy", "flash"));
		if (value == null) value = Type.resolveEnum(StringTools.replace(name, "openfl._v2", "flash"));
		if (value == null) value = cast Type.resolveClass(name);
		if (value == null) value = cast Type.resolveClass(StringTools.replace(name, "openfl", "flash"));
		if (value == null) value = cast Type.resolveClass(StringTools.replace(name, "openfl._legacy", "flash"));
		if (value == null) value = cast Type.resolveClass(StringTools.replace(name, "openfl._v2", "flash"));
		#elseif openfl_legacy
		if (value == null) value = Type.resolveEnum(StringTools.replace(name, "openfl", "openfl._legacy"));
		#else
		if (value == null) value = Type.resolveEnum(StringTools.replace(name, "openfl._legacy", "openfl"));
		if (value == null) value = Type.resolveEnum(StringTools.replace(name, "openfl._v2", "openfl"));
		#end

		return value;
	}

	public function serialize():String
	{
		var serializer = new Serializer();
		serializer.serialize(this);
		return serializer.toString();
	}

	public static function unserialize(data:String):SWFLite
	{
		if (data == null)
		{
			return null;
		}

		var unserializer = new Unserializer(data);
		unserializer.setResolver({resolveClass: resolveClass, resolveEnum: resolveEnum});

		var swfLite:SWFLite = cast unserializer.unserialize();
		if (swfLite != null)
		{
			swfLite.__init();
		}

		return swfLite;
	}

	private function __init():Void
	{
		if (symbols == null) return;
		if (symbolsByClassName == null) symbolsByClassName = new Map<String, SWFSymbol>();

		for (symbol in symbols)
		{
			if (symbol == null || symbol.className == null) continue;
			symbolsByClassName.set(symbol.className, symbol);
		}
	}
}
