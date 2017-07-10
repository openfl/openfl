package format.swf.lite;


import flash.display.BitmapData;
import flash.display.SimpleButton;
import format.swf.lite.symbols.BitmapSymbol;
import format.swf.lite.symbols.SpriteSymbol;
import format.swf.lite.symbols.SWFSymbol;
import format.swf.lite.MovieClip;
import haxe.io.Bytes;
import haxe.Json;
import openfl.Assets;
//import org.msgpack.MsgPack;


@:keep class SWFLite implements hxbit.Serializable {


	public static var instances = new Map<String, SWFLite> ();
	public static var fontAliases = new Map<String, String>();
	public static var fontAliasesId = new Map<Int, String>();
	public static var defaultInstance(get,null) : SWFLite;

	public var classes : Map<String, Class<Dynamic>>;
	public var classes_id : Map<Int, Class<Dynamic>>;
	@:s public var frameRate (default, set):Float;
	public var frameTime(default, null):Int;
	@:s public var root:SpriteSymbol;
	@:s public var symbols:Map <Int, SWFSymbol>;
	@:s public var symbolClassNames:Map <String, SWFSymbol>;

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


	public function serializeLibrary ():haxe.io.Bytes {

		var serializer = new hxbit.Serializer ();
//		serializer.useCache = true;
		symbolClassNames = null;
		return serializer.serialize (this);

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


	public static function unserializeLibrary (data:haxe.io.Bytes):SWFLite {

		if (data == null) {

			return null;

		}

		var unserializer = new hxbit.Serializer ();

		var swf_lite:SWFLite = cast unserializer.unserialize (data, SWFLite);
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