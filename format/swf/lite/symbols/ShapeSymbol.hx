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

		#if profile
			var missedCount = missedCountMap[id];
			missedCount = missedCount != null ? missedCount : 0;
			++missedCount;
			missedCountMap.set (id, missedCount);

			if (continuousLogEnabled) {

				trace ('Shape id:$id; Missed count: $missedCount');

			}
		#end

		return null;

	}


	public function setCachedBitmapData (bitmapData:BitmapData) {

		if (!useBitmapCache) {

			return ;

		}

		cachedTable.push (new CacheEntry (bitmapData));

	}

	#if profile
		private static var missedCountMap = new Map<Int, Int> ();
		private static var continuousLogEnabled:Bool = false;

		public static function __init__ () {

			#if js
				untyped __js__ ("$global.Profile = $global.Profile || {}");
				untyped __js__ ("$global.Profile.ShapeInfo = []");
				untyped __js__ ("$global.Profile.ShapeInfo.resetStatistics = format_swf_lite_symbols_ShapeSymbol.resetStatistics" );
				untyped __js__ ("$global.Profile.ShapeInfo.logStatistics = format_swf_lite_symbols_ShapeSymbol.logStatistics" );
				untyped __js__ ("$global.Profile.ShapeInfo.enableContinuousLog = format_swf_lite_symbols_ShapeSymbol.enableContinuousLog" );
			#end

		}

		public static function resetStatistics () {

			missedCountMap = new Map<Int, Int> ();

		}

		public static function logStatistics () {

			for( id in missedCountMap.keys () ) {
				trace ('Shape id:$id; Missed count: ${missedCountMap[id]}');
			}

		}

		public static function enableContinuousLog (value:Bool) {

			continuousLogEnabled = value;

		}

	#end

}


private class CacheEntry {

	public var bitmapData:BitmapData;

	public function new (bitmapData:BitmapData) {

		this.bitmapData = bitmapData;

	}

}
