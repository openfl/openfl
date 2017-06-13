package format.swf.lite;


import flash.display.BitmapData;
import flash.display.SimpleButton;
import format.swf.lite.symbols.BitmapSymbol;
import format.swf.lite.symbols.SpriteSymbol;
import format.swf.lite.symbols.SWFSymbol;
import format.swf.lite.MovieClip;
import haxe.Serializer;
import haxe.Unserializer;
import openfl.Assets;
//import org.msgpack.MsgPack;


@:keep class SWFLite {


	public static var instances = new Map<String, SWFLite> ();
	public static var fontAliases = new Map<String, String>();
	public static var fontAliasesId = new Map<Int, String>();
	public static var defaultInstance(get,null) : SWFLite;

	public var classes : Map<String, Class<Dynamic>>;
	public var classes_id : Map<Int, Class<Dynamic>>;
	public var frameRate (default, set):Float;
	public var frameTime(default, null):Int;
	public var root:SpriteSymbol;
	public var symbols:Map <Int, SWFSymbol>;
	public var symbolClassNames:Map <String, SWFSymbol>;

	public function new () {
		
		symbols = new Map <Int, SWFSymbol> ();
		classes = new Map<String, Class<Dynamic>> ();
		classes_id = new Map<Int, Class<Dynamic>> ();

		// distinction of symbol by class name and characters by ID somewhere?
		
	}
	
	
	public function createButton (className:String):SimpleButton {
		
		return null;
		
	}
	
	
	public function createMovieClip (className:String = ""):MovieClip {
		
		if (className == "") {
			
			return new MovieClip (this, root);
			
		} else {

			var symbol = symbolClassNames.get(className);

			if (symbol != null) {

				var _class: Class<Dynamic> = classes.get(symbol.className);

				if( _class != null )
				{
					return Type.createInstance( _class, [this, symbol]);
				}
				else
				{
					_class = classes_id.get(cast symbol.id);

					if( _class != null )
					{
						return Type.createInstance( _class, [this, symbol]);
					}
				}
				if (Std.is (symbol, SpriteSymbol)) {

					return new MovieClip (this, cast symbol);

				}
				
			}
			
		}
		
		return null;
		
	}
	
	
	public function getBitmapData (className:String):BitmapData {

		var symbol = symbolClassNames.get(className);

		if (symbol != null) {

			if (Std.is (symbol, BitmapSymbol)) {

				var bitmap:BitmapSymbol = cast symbol;
				return Assets.getBitmapData (bitmap.path);

			}
			
		}
		
		return null;
		
	}
	
	
	public function hasSymbol (className:String):Bool {

		return symbolClassNames.exists(className);

	}
	
	
	private static function resolveClass (name:String):Class <Dynamic> {
		
		var value = Type.resolveClass (name);
		
		#if flash
		
		if (value == null) value = Type.resolveClass (StringTools.replace (name, "openfl", "flash"));
		if (value == null) value = Type.resolveClass (StringTools.replace (name, "openfl._legacy", "flash"));
		if (value == null) value = Type.resolveClass (StringTools.replace (name, "openfl._v2", "flash"));
		
		#elseif openfl_legacy
		
		if (value == null) value = Type.resolveClass (StringTools.replace (name, "openfl", "openfl._legacy"));
		
		#else
		
		if (value == null) value = Type.resolveClass (StringTools.replace (name, "openfl._legacy", "openfl"));
		if (value == null) value = Type.resolveClass (StringTools.replace (name, "openfl._v2", "openfl"));
		
		#end
		
		return value;
		
	}
	
	
	private static function resolveEnum (name:String):Enum <Dynamic> {
		
		var value = Type.resolveEnum (name);
		
		#if flash
		
		if (value == null) value = Type.resolveEnum (StringTools.replace (name, "openfl", "flash"));
		if (value == null) value = Type.resolveEnum (StringTools.replace (name, "openfl._legacy", "flash"));
		if (value == null) value = Type.resolveEnum (StringTools.replace (name, "openfl._v2", "flash"));
		if (value == null) value = cast Type.resolveClass (name);
		if (value == null) value = cast Type.resolveClass (StringTools.replace (name, "openfl", "flash"));
		if (value == null) value = cast Type.resolveClass (StringTools.replace (name, "openfl._legacy", "flash"));
		if (value == null) value = cast Type.resolveClass (StringTools.replace (name, "openfl._v2", "flash"));
		
		#elseif openfl_legacy
		
		if (value == null) value = Type.resolveEnum (StringTools.replace (name, "openfl", "openfl._legacy"));
		
		#else
		
		if (value == null) value = Type.resolveEnum (StringTools.replace (name, "openfl._legacy", "openfl"));
		if (value == null) value = Type.resolveEnum (StringTools.replace (name, "openfl._v2", "openfl"));
		
		#end
		
		return value;
		
	}
	
	
	public function serialize ():String {
		
		var serializer = new Serializer ();
//		serializer.useCache = true;
		symbolClassNames = null;
		serializer.serialize (this);
		return serializer.toString ();

	}

	private function cacheSymbolClassNames () {

		symbolClassNames = new Map();

		for (symbol in symbols) {
			if (symbol.className != null) {
				symbolClassNames.set(symbol.className, symbol);
			}
		}

	}

	private function prepareShapeBitmaps () {

		for (symbol in symbols) {
			if(Std.is(symbol, format.swf.lite.symbols.ShapeSymbol)) {
				@:privateAccess cast(symbol, format.swf.lite.symbols.ShapeSymbol).graphics.__commands.resolveBitmapDatas(this);
			}
		}
	}
	
	
	public static function unserialize (data:String):SWFLite {
		
		if (data == null) {
			
			return null;
			
		}
		
		var unserializer = new Unserializer (data);
		unserializer.setResolver ({ resolveClass: resolveClass, resolveEnum: resolveEnum });

		var swf_lite:SWFLite = cast unserializer.unserialize ();
		swf_lite.cacheSymbolClassNames();
		swf_lite.classes = new Map ();
		swf_lite.classes_id = new Map ();

		swf_lite.prepareShapeBitmaps();
		
		return swf_lite;
	}
	
	public static function get_defaultInstance() {
		return instances.get("lib/graphics/graphics.dat");
	}

	private function set_frameRate (value:Float):Float {
		frameTime = Std.int(1000 / value);
		frameRate = value;
	
		return value;
	}
}