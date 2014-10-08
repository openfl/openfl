package openfl.display; #if (flash || openfl_next || js || display)


import openfl.display.BitmapData;
import openfl.display.Graphics;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

@:allow(openfl.display.Graphics)


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
	
	@:noCompletion private static var __defaultPoint = new Point (0, 0);
	
	@:noCompletion private var __bitmap:BitmapData;
	@:noCompletion private var __centerPoints:Array<Point>;
	@:noCompletion private var __tileRects:Array<Rectangle>;
	@:noCompletion private var __tileUVs:Array<Rectangle>;
	
	#if flash
	@:noCompletion private var __bitmapHeight:Int;
	@:noCompletion private var __bitmapWidth:Int;
	@:noCompletion private var __ids:Vector<Int>;
	@:noCompletion private var __indices:Vector<Int>;
	@:noCompletion private var __uvs:Vector<Float>;
	@:noCompletion private var __vertices:Vector<Float>;
	#end
	
	
	public function new (image:BitmapData) {
		
		__bitmap = image;
		__centerPoints = new Array<Point> ();
		__tileRects = new Array<Rectangle> ();
		__tileUVs = new Array<Rectangle> ();
		
		#if flash
		__bitmapWidth = __bitmap.width;
		__bitmapHeight = __bitmap.height;
		__ids = new Vector <Int>();
		__vertices = new Vector <Float>();
		__indices = new Vector <Int>();
		__uvs = new Vector <Float>();
		#end
		
	}
	
	
	public function addTileRect (rectangle:Rectangle, centerPoint:Point = null):Int {
		
		__tileRects.push (rectangle);
		
		if (centerPoint == null) {
			
			centerPoint = __defaultPoint;
			
		}
		
		#if flash
		__centerPoints.push (new Point (centerPoint.x / rectangle.width, centerPoint.y / rectangle.height));
		#else
		__centerPoints.push (centerPoint);
		#end
		
		__tileUVs.push (new Rectangle (rectangle.left / __bitmap.width, rectangle.top / __bitmap.height, rectangle.right / __bitmap.width, rectangle.bottom / __bitmap.height));
		
		return __tileRects.length - 1;
		
	}
	
	
	#if flash
	private inline function adjustIDs (vec:Vector<Int>, len:Int):Vector<Int> {
		
		if (vec.length != len) {
			
			var prevLen = vec.length;
			vec.fixed = false;
			vec.length = len;
			vec.fixed = true;
			
			for (i in prevLen...len)
				vec[i] = -1;
				
		}
		
		return vec;
		
	}
	
	
	private inline function adjustIndices (vec:Vector<Int>, len:Int):Vector<Int> {
		
		if (vec.length != len) {
			
			vec.fixed = false;
			
			if (vec.length > len) {
				
				vec.length = len;
				vec.fixed = true;
				
			} else {
				
				var offset6 = vec.length;
				var offset4 = cast (4 * offset6 / 6, Int);
				vec.length = len;
				vec.fixed = true;
				
				while (offset6 < len) {
					
					vec[offset6] = 0 + offset4;
					vec[offset6 + 1] = vec[offset6 + 3] = 1 + offset4;
					vec[offset6 + 2] = vec[offset6 + 5] = 2 + offset4;
					vec[offset6 + 4] = 3 + offset4;
					offset4 += 4;
					offset6 += 6;
					
				}
				
			}
			
		}
		
		return vec;
		
	}
	
	
	private inline function adjustLen (vec:Vector<Float>, len:Int):Vector<Float> {
		
		if (vec.length != len) {
			
			vec.fixed = false;
			vec.length = len;
			vec.fixed = true;
			
		}
		
		return vec;
		
	}
	#end
	
	
	public function drawTiles (graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, count:Int = -1):Void {
		
		graphics.drawTiles (this, tileData, smooth, flags, count);
		
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


#else
typedef Tilesheet = openfl._v2.display.Tilesheet;
#end