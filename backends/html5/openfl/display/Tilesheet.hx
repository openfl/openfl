package openfl.display;


import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Point;
import openfl.geom.Rectangle;


class Tilesheet {
	
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	public static inline var TILE_TRANS_2x2 = 0x0010;
	public static inline var TILE_BLEND_NORMAL   = 0x00000000;
	public static inline var TILE_BLEND_ADD      = 0x00010000;
	public static inline var TILE_BLEND_MULTIPLY = 0x00020000;
	public static inline var TILE_BLEND_SCREEN = 0x00040000;
	
	/** @private */ public var __bitmap:BitmapData;
	/** @private */ public var __centerPoints:Array <Point>;
	/** @private */ public var __tileRects:Array <Rectangle>;
	/** @private */ public var __tileUVs:Array <Rectangle>;
	
	
	public function new (image:BitmapData) {
		
		__bitmap = image;
		__centerPoints = new Array <Point> ();
		__tileRects = new Array <Rectangle> ();
		__tileUVs = new Array <Rectangle> ();
		
	}
	
	
	public function addTileRect (rectangle:Rectangle, centerPoint:Point = null):Int {
		
		__tileRects.push (rectangle);
		
		if (centerPoint == null) {
			
			centerPoint = new Point ();
			
		}
		
		__centerPoints.push (centerPoint);
		__tileUVs.push (new Rectangle(rectangle.left / __bitmap.width, rectangle.top / __bitmap.height, rectangle.right / __bitmap.width, rectangle.bottom / __bitmap.height));
		
		return __tileRects.length - 1;
		
	}
	
	
	public function drawTiles (graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void {
		
		graphics.drawTiles (this, tileData, smooth, flags);
		
	}
	
	public inline function getTileCenter (index:Int):Point {
		return __centerPoints[index];
	}
	
	public inline function getTileRect (index:Int):Rectangle {
		return __tileRects[index];
	}
	
	public inline function getTileUVs (index:Int):Rectangle {
		return __tileUVs[index];
	}
	
	
}