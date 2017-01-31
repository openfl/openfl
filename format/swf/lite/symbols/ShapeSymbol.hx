package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Graphics;

class ShapeSymbol extends SWFSymbol {


	public var commands:Array<ShapeCommand>;
	public var bounds:Rectangle;
	public var graphics:Graphics;

	public var useBitmapCache(default, set):Bool = false;
	private var cachedTable:Array<CacheEntry>;

	public function new () {

		super ();

	}

	public function set_useBitmapCache (useBitmapCache:Bool):Bool {

		if (useBitmapCache && cachedTable == null) {

			cachedTable = new Array<CacheEntry> ();

		}

		return this.useBitmapCache = useBitmapCache;
	}

	public function getCachedBitmapData (width:Int, height:Int):BitmapData {

		if (useBitmapCache) {

			for (entry in cachedTable) {

				if (@:privateAccess entry.bitmapData.__width == width && @:privateAccess entry.bitmapData.__height == height) {

					return entry.bitmapData;

				}

			}

		}

		return null;

	}


	public function setCachedBitmapData (bitmapData:BitmapData) {

		if (!useBitmapCache) {

			return ;

		}

		cachedTable.push (new CacheEntry (bitmapData));

	}
}

private class CacheEntry {

	public var bitmapData:BitmapData;

	public function new (bitmapData:BitmapData) {

		this.bitmapData = bitmapData;

	}

}
