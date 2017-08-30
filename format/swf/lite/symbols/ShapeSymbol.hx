package format.swf.lite.symbols;


import format.swf.exporters.core.ShapeCommand;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.events.Event;

class ShapeSymbol extends SWFSymbol {

	@:s public var bounds:Rectangle;
	@:s public var graphics:Graphics;

	public var useBitmapCache(default, set):Bool = false;
	private var cachedTable:Array<CacheEntry>;

	public var forbidCachedBitmapUpdate:Bool = false;
	public var snapCoordinates:Bool = false;

	static public var shapeSymbolsUsingBitmapCacheMap = new Map<ShapeSymbol, ShapeSymbol>();
	static private var lastStageWidth:Null<Int>;
	static private var lastStageHeight:Null<Int>;
	static private var eventIsListened:Bool = false;

	public function new () {

		super ();

	}

	public function set_useBitmapCache (useBitmapCache:Bool):Bool {

		if (useBitmapCache && cachedTable == null) {
			cachedTable = new Array<CacheEntry> ();
			shapeSymbolsUsingBitmapCacheMap.set(this, this);

			if(!eventIsListened) {
				var stage = openfl.Lib.current.stage;
				lastStageWidth = stage.stageWidth;
				lastStageHeight = stage.stageHeight;
				stage.addEventListener(Event.RESIZE, __clearCachedTables);
				eventIsListened = true;
			}
		} else if ( !useBitmapCache ) {
			shapeSymbolsUsingBitmapCacheMap.remove(this);
		}

		return this.useBitmapCache = useBitmapCache;
	}

	public function getCachedBitmapData (width:Int, height:Int):BitmapData {

		if (useBitmapCache) {

			if (forbidCachedBitmapUpdate && cachedTable.length > 0) {
				return cachedTable[0].bitmapData;
			}

			for (entry in cachedTable) {

				if (entry.bitmapData.physicalWidth == width && entry.bitmapData.physicalHeight == height) {

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

	public function fillDrawCommandBuffer(shapeCommands:Array<ShapeCommand>)
	{
		graphics = @:privateAccess new Graphics();

		for (command in shapeCommands) {

			switch (command) {

				case BeginFill (color, alpha):

					graphics.beginFill (color, alpha);

				case BeginBitmapFill (bitmapID, matrix, repeat, smooth):

					graphics.beginBitmapFillWithId (bitmapID, matrix, repeat, smooth);

				case BeginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio):

					graphics.beginGradientFill (fillType, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);

				case CurveTo (controlX, controlY, anchorX, anchorY):

					graphics.curveTo (controlX, controlY, anchorX, anchorY);

				case DrawImage (bitmapID, matrix, smooth):

					graphics.drawImageWithId (bitmapID, matrix, smooth);

				case EndFill:

					graphics.endFill ();

				case LineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit):

					if (thickness != null) {

						graphics.lineStyle (thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);

					} else {

						graphics.lineStyle ();

					}

				case LineTo (x, y):

					graphics.lineTo (x, y);

				case MoveTo (x, y):

					graphics.moveTo (x, y);

			}
		}

		graphics.readOnly = true;
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

		public static function logStatistics (?threshold = 0) {

			for( id in missedCountMap.keys () ) {
				var value = missedCountMap[id];
				if(value < threshold) {
					continue;
				}
				trace ('Shape id:$id; Missed count: ${value}');
			}

		}

		public static function enableContinuousLog (value:Bool) {

			continuousLogEnabled = value;

		}

	#end


	private function __clearCachedTable() {
		graphics.dispose();

		for ( cache in cachedTable ) {
			cache.bitmapData.dispose();
		}

		if ( cachedTable.length > 0 ) {
			cachedTable.splice(0, cachedTable.length);
		}
	}

	private static function __clearCachedTables(e:openfl.events.Event) {
		var width = e.currentTarget.stageWidth;
		var height = e.currentTarget.stageHeight;

		if(lastStageWidth != width || lastStageHeight != height) {
			for(s in shapeSymbolsUsingBitmapCacheMap) {
				s.__clearCachedTable();
			}
			lastStageWidth = width;
			lastStageHeight = height;
		}
	}

}


// :TODO: account for offset if desired

private class CacheEntry {

	public var bitmapData:BitmapData;

	public function new (bitmapData:BitmapData) {

		this.bitmapData = bitmapData;

	}

}
