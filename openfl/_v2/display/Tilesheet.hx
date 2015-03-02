package openfl._v2.display; #if lime_legacy


import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Lib;


class Tilesheet {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_RECT = 0x0020;
	public static inline var TILE_ORIGIN = 0x0040;
	public static inline var TILE_BLEND_NORMAL = 0x00000000;
	public static inline var TILE_BLEND_ADD = 0x00010000;
	public static inline var TILE_BLEND_MULTIPLY = 0x00020000;
	public static inline var TILE_BLEND_SCREEN = 0x00040000;
	public static inline var TILE_BLEND_SUBTRACT = 0x00080000;
	
	@:noCompletion public var __bitmap:BitmapData;
	@:noCompletion public var __handle:Dynamic;
	
	
	static private var defaultRatio:Point = new Point(0, 0);
	private var _bitmapHeight:Int;
	private var _bitmapWidth:Int;
	private var _tilePoints:Array<Point>;
	private var _tiles:Array<Rectangle>;
	private var _tileUVs:Array<Rectangle>;
	
	public function new (image:BitmapData) {
		
		__bitmap = image;
		__handle = lime_tilesheet_create (image.__handle);
		
		_bitmapWidth = __bitmap.width;
		_bitmapHeight = __bitmap.height;
		
		_tilePoints = new Array<Point>();
		_tiles = new Array<Rectangle>();
		_tileUVs = new Array<Rectangle>();
		
	}
	
	
	public function addTileRect (rectangle:Rectangle, centerPoint:Point = null):Int {
		
		_tiles.push(rectangle);
		if (centerPoint == null) _tilePoints.push(defaultRatio);
		else _tilePoints.push(new Point(centerPoint.x / rectangle.width, centerPoint.y / rectangle.height));	
		_tileUVs.push(new Rectangle(rectangle.left / _bitmapWidth, rectangle.top / _bitmapHeight, rectangle.right / _bitmapWidth, rectangle.bottom / _bitmapHeight));
		return lime_tilesheet_add_rect (__handle, rectangle, centerPoint);
		
	}
	
	
	public function drawTiles (graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void {
		
		graphics.drawTiles (this, tileData, smooth, flags, count);
		
	}
	
	
	public inline function getTileCenter(index:Int):Point {
		return _tilePoints[index];
	}
	
	public inline function getTileRect(index:Int):Rectangle {
		return _tiles[index];
	}
	
	public inline function getTileUVs(index:Int):Rectangle {
		return _tileUVs[index];
	}
	
	
	// Native Methods
	
	
	
	
	private static var lime_tilesheet_create = Lib.load ("lime", "lime_tilesheet_create", 1);
	private static var lime_tilesheet_add_rect = Lib.load ("lime", "lime_tilesheet_add_rect", 3);
	
	
}


#end