package openfl.display;
#if display


import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;


/**
 * In order to optimize for faster performance than individual 
 * drawing calls, the Tilesheet provides an alternative API with
 * several constraints to play nicely with hardware rendering.
 * 
 * First, every Tilesheet can only use one BitmapData as a texture.
 * This restriction provides the opportunity to copy only one texture
 * to the GPU memory before rendering.
 * 
 * Second, the Tilesheet uses pre-defined geometry. You may make as 
 * many calls as you want to "addTileRect" to add tile geometry. You
 * can reference this geometry later when you perform batch rendering,
 * using a zero-based ID for the tile.
 * 
 * When you are ready, the "drawTiles" method accepts a draw list with
 * the ID of the tile, as well as additional values needed, depending
 * on whether you are only rendering with the tile position, or if 
 * you have enabled flags for TILE_SCALE, TILE_ROTATION, TILE_RGB,
 * TILE_ALPHA or TILE_TRANS_2x2.
 * 
 * @example
 * 
 * var bitmapData = Assets.getBitmapData("image.png");
 * var tilesheet = new Tilesheet(bitmapData);
 * 
 * var tile = tilesheet.addTileRect(new Rectangle(0, 0, 100, 100));
 * tilesheet.drawTiles(this, [ tile, 100, 100 ]);
 * 
 */
extern class Tilesheet {
	
	
	static var TILE_SCALE:Int;
	static var TILE_ROTATION:Int;
	static var TILE_RGB:Int;
	static var TILE_ALPHA:Int;
	static var TILE_TRANS_2x2:Int;
	
	static var TILE_BLEND_NORMAL:Int;
	static var TILE_BLEND_ADD:Int;
	
	
	function new(inImage:BitmapData):Void;
	
	/**
	 * Add a new tile to the Tilesheet
	 * 
	 * Beginning with 0, each tile is assigned an indentifier internally, which you
	 * can use to reference the geometry later while rendering.
	 * 
	 * For example, if you have only called "addTileRect" once on a Tilesheet, you
	 * would reference that tile using a tile ID of 0. If you have called "addTileRect"
	 * three times, the third tile would have an ID of 2.
	 * 
	 * Specify a rectangle within the bounds of the Tilesheet bitmap. This portion of the 
	 * Tilesheet will be rendered when ever you request a draw of this tile ID.
	 * 
	 * You may also (optionally) specify a center point, which is used during positioning,
	 * scale and rotation. The center point should be a coordinate within the tile
	 * rectangle.
	 * 
	 * @param	rectangle
	 * @param	centerPoint
	 */
	function addTileRect(rectangle:Rectangle, centerPoint:Point = null):Int;
	
	/**
	 * Fast method to render a batch of tiles from the Tilesheet graphic
	 * 
	 * A standard "drawTiles" call expects a repeating set of three values: the X and Y
	 * coordinates, followed by the tileID that should be rendered. You can repeat this
	 * pattern for as many tiles you wish to render.
	 * 
	 * If you specify drawing flags, the draw list increases in size to accommodate the 
	 * additional properties needed. You may specify TILE_SCALE, TILE_ROTATION, TILE_RGB 
	 * and/or TILE_ALPHA.
	 * 
	 * This means that the draw list will increase from [ x, y, tileID ... ] to
	 * [ x, y, tileID, scale, rotation, red, green, blue, alpha ... ] depending on which
	 * flags are active.
	 * 
	 * If you use the TILE_TRANS_2x2 flag, it means you wish to use a 2x2 Matrix transform
	 * while rendering. If you use TILE_TRANS_2x2, the TILE_SCALE and TILE_ROTATION flags
	 * will be ignored. Using this flag, the draw list will expect the following order:
	 * 
	 * [ x, y, tileID, a, b, c, d, red, green, blue, alpha ... ]
	 * 
	 * ...of course, if you are not using TILE_RGB or TILE_ALPHA, then you would repeat the
	 * pattern directly following the matrix "a", "b", "c" and "d" values.
	 * 
	 * @example
	 * 
	 * var bitmapData = Assets.getBitmapData("image.png");
	 * var tilesheet = new Tilesheet(bitmapData);
	 * 
	 * tilesheet.addTileRect(new Rectangle(0, 0, 100, 100));
	 * 
	 * // x, y, tileID, scale, alpha
	 * 
	 * var drawList = [
	 * 	100, 100, 0, 2, 0.5,
	 * 	100, 200, 0, 2, 0.5
	 * ];
	 * 
	 * tilesheet.drawTiles(this, drawList, true, Tilesheet.TILE_SCALE | Tilesheet.TILE_ALPHA);
	 * 
	 * @param	graphics		The nme.display.Graphics object to use for drawing
	 * @param	tileData		An array of all position, ID and optional values for use in drawing
	 * @param	smooth		(Optional) Whether tiles should be smoothed while drawing(Default: false)
	 * @param	flags		(Optional) Flags to enable scale, rotation, RGB and/or alpha when drawing(Default: 0)
	 */
	function drawTiles(graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void;
	
}


#elseif flash


import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Vector;


class Tilesheet
{
	
	public static inline var TILE_SCALE = 0x0001;
	public static inline var TILE_ROTATION = 0x0002;
	public static inline var TILE_RGB = 0x0004;
	public static inline var TILE_ALPHA = 0x0008;
	
	// Will ignore scale and rotation....
	// (not supported right now)
	public static inline var TILE_TRANS_2x2 = 0x0010;
	
	
	public static inline var TILE_BLEND_NORMAL   = 0x00000000;
	public static inline var TILE_BLEND_ADD      = 0x00010000;
	
	/**
	 * @private
	 */
	public var nmeBitmap:BitmapData;
	
	static private var defaultRatio:Point = new Point(0, 0);
	private var bitmapHeight:Int;
	private var bitmapWidth:Int;
	private var tilePoints:Array<Point>;
	private var tiles:Array<Rectangle>;
	private var tileUVs:Array<Rectangle>;
	private var _ids:Vector<Int>;
	private var _vertices:Vector<Float>;
	private var _indices:Vector<Int>;
	private var _uvs:Vector<Float>;
	
	
	public function new(inImage:BitmapData)
	{
		nmeBitmap = inImage;
		
		bitmapWidth = nmeBitmap.width;
		bitmapHeight = nmeBitmap.height;
		
		tilePoints = new Array<Point>();
		tiles = new Array<Rectangle>();
		tileUVs = new Array<Rectangle>();
		_ids = new Vector<Int>();
		_vertices = new Vector<Float>();
		_indices = new Vector<Int>();
		_uvs = new Vector<Float>();
		
	}
	
	
	public function addTileRect(rectangle:Rectangle, centerPoint:Point = null):Int
	{
		tiles.push(rectangle);
		if (centerPoint == null) tilePoints.push(defaultRatio);
		else tilePoints.push(new Point(centerPoint.x / rectangle.width, centerPoint.y / rectangle.height));	
		tileUVs.push(new Rectangle(rectangle.left / bitmapWidth, rectangle.top / bitmapHeight, rectangle.right / bitmapWidth, rectangle.bottom / bitmapHeight));
		return tiles.length - 1;
	}
	
	
	private function adjustIDs(vec:Vector<Int>, len:#if haxe3 Int #else UInt #end)
	{
		if (vec.length != len)
		{
			var prevLen = vec.length;
			vec.fixed = false;
			vec.length = len;
			vec.fixed = true;
			for (i in prevLen...len)
				vec[i] = -1;
		}
		return vec;
	}
	
	
	private function adjustIndices(vec:Vector<Int>, len:#if haxe3 Int #else UInt #end)
	{
		if (vec.length != len)
		{
			vec.fixed = false;
			if (vec.length > len)
			{
				vec.length = len;
				vec.fixed = true;
			}
			else 
			{
				var offset6 = vec.length;
				var offset4 = cast(4 * offset6 / 6, Int);
				vec.length = len;
				vec.fixed = true;
				while (offset6 < len)
				{
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
	
	
	private function adjustLen(vec:Vector<Float>, len:#if haxe3 Int #else UInt #end)
	{
		if (vec.length != len)
		{
			vec.fixed = false;
			vec.length = len;
			vec.fixed = true;
		}
		return vec;
	}
	
	
	/**
	 * Fast method to draw a batch of tiles using a Tilesheet
	 * 
	 * The input array accepts the x, y and tile ID for each tile you wish to draw.
	 * For example, an array of [ 0, 0, 0, 10, 10, 1 ] would draw tile 0 to(0, 0) and
	 * tile 1 to(10, 10)
	 * 
	 * You can also set flags for TILE_SCALE, TILE_ROTATION, TILE_RGB and
	 * TILE_ALPHA.
	 * 
	 * Depending on which flags are active, this is the full order of the array:
	 * 
	 * [ x, y, tile ID, scale, rotation, red, green, blue, alpha, x, y ... ]
	 * 
	 * @param	graphics		The native.display.Graphics object to use for drawing
	 * @param	tileData		An array of all position, ID and optional values for use in drawing
	 * @param	smooth		(Optional) Whether drawn tiles should be smoothed(Default: false)
	 * @param	flags		(Optional) Flags to enable scale, rotation, RGB and/or alpha when drawing(Default: 0)
	 */
	public function drawTiles(graphics:Graphics, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0):Void
	{
		var useScale = (flags & TILE_SCALE) > 0;
		var useRotation = (flags & TILE_ROTATION) > 0;
		var useRGB = (flags & TILE_RGB) > 0;
		var useAlpha = (flags & TILE_ALPHA) > 0;
		var useTransform = (flags & TILE_TRANS_2x2) > 0;
		
		if (useTransform || useScale || useRotation || useRGB || useAlpha)
		{
			var scaleIndex = 0;
			var rotationIndex = 0;
			var rgbIndex = 0;
			var alphaIndex = 0;
			var transformIndex = 0;
			var numValues = 3;
			
			if (useScale) { scaleIndex = numValues; numValues ++; }
			if (useRotation) { rotationIndex = numValues; numValues ++; }
			if (useTransform) { transformIndex = numValues; numValues += 4; }
			if (useRGB) { rgbIndex = numValues; numValues += 3; }
			if (useAlpha) { alphaIndex = numValues; numValues ++; }
			
			var totalCount = tileData.length;
			var itemCount = Std.int(totalCount / numValues);
			
			var ids = adjustIDs(_ids, itemCount);
			var vertices = adjustLen(_vertices, itemCount * 8); 
			var indices = adjustIndices(_indices, itemCount * 6); 
			var uvtData = adjustLen(_uvs, itemCount * 8); 
			
			var index = 0;
			var offset8 = 0;
			var tileIndex:Int = 0;
			var tileID:Int = 0;
			var cacheID:Int = -1;
			
			var tile:Rectangle = null;
			var tileUV:Rectangle = null;
			var tilePoint:Point = null;
			var tileHalfHeight:Float = 0;
			var tileHalfWidth:Float = 0;
			var tileHeight:Float = 0;
			var tileWidth:Float = 0;

			while (index < totalCount)
			{
				var x = tileData[index];
				var y = tileData[index + 1];
				var tileID = Std.int(tileData[index + 2]);
				var scale = 1.0;
				var rotation = 0.0;
				var alpha = 1.0;
				
				if (useScale)
				{
					scale = tileData[index + scaleIndex];
				}
				
				if (useRotation)
				{
					rotation = tileData[index + rotationIndex];
				}
				
				if (useRGB)
				{
					//ignore for now
				}
				
				if (useAlpha)
				{
					alpha = tileData[index + alphaIndex];
				}
				
				if (cacheID != tileID)
				{
					cacheID = tileID;
					tile = tiles[tileID];
					tileUV = tileUVs[tileID];
					tilePoint = tilePoints[tileID];
				}
				
				if (useTransform) 
				{
					var tw = tile.width;
					var th = tile.height;
					var t0 = tileData[index + transformIndex];
					var t1 = tileData[index + transformIndex + 1];
					var t2 = tileData[index + transformIndex + 2];
					var t3 = tileData[index + transformIndex + 3];
					var ox = tilePoint.x * tw;
					var oy = tilePoint.y * th;
					var ox_ = ox * t0 + oy * t2;
					oy = ox * t1 + oy * t3;
					x -= ox_;
					y -= oy;
					vertices[offset8] = x;
					vertices[offset8 + 1] = y;
					vertices[offset8 + 2] = x + tw * t0;
					vertices[offset8 + 3] = y + tw * t1;
					vertices[offset8 + 4] = x + th * t2;
					vertices[offset8 + 5] = y + th * t3;
					vertices[offset8 + 6] = x + tw * t0 + th * t2;
					vertices[offset8 + 7] = y + tw * t1 + th * t3;
				}
				else
				{
					var tileWidth = tile.width * scale;
					var tileHeight = tile.height * scale;
					if (rotation != 0)
					{
						var kx = tilePoint.x * tileWidth;
						var ky = tilePoint.y * tileHeight;
						var akx = (1 - tilePoint.x) * tileWidth;
						var aky = (1 - tilePoint.y) * tileHeight;
						var ca = Math.cos(rotation);
						var sa = Math.sin(rotation);
						var xc = kx * sa, xs = kx * ca, yc = ky * sa, ys = ky * ca;
						var axc = akx * sa, axs = akx * ca, ayc = aky * sa, ays = aky * ca;
						vertices[offset8] = x - (xc + ys);
						vertices[offset8 + 1] = y - (-xs + yc);
						vertices[offset8 + 2] = x + axc - ys;
						vertices[offset8 + 3] = y - (axs + yc);
						vertices[offset8 + 4] = x - (xc - ays);
						vertices[offset8 + 5] = y + xs + ayc;
						vertices[offset8 + 6] = x + axc + ays;
						vertices[offset8 + 7] = y + (-axs + ayc);
					}
					else 
					{
						x -= tilePoint.x * tileWidth;
						y -= tilePoint.y * tileHeight;
						vertices[offset8] = vertices[offset8 + 4] = x;
						vertices[offset8 + 1] = vertices[offset8 + 3] = y;
						vertices[offset8 + 2] = vertices[offset8 + 6] = x + tileWidth;
						vertices[offset8 + 5] = vertices[offset8 + 7] = y + tileHeight;
					}
				}
				
				if (ids[tileIndex] != tileID)
				{
					ids[tileIndex] = tileID;
					uvtData[offset8] = uvtData[offset8 + 4] = tileUV.left;
					uvtData[offset8 + 1] = uvtData[offset8 + 3] = tileUV.top;
					uvtData[offset8 + 2] = uvtData[offset8 + 6] = tileUV.width;
					uvtData[offset8 + 5] = uvtData[offset8 + 7] = tileUV.height;
				}
				
				offset8 += 8;
				index += numValues;
				tileIndex++;
			}
			
			graphics.beginBitmapFill(nmeBitmap, null, false, smooth);
			graphics.drawTriangles(vertices, indices, uvtData);
			
		}
		else
		{
			
			var index = 0;
			var matrix = new Matrix();
			
			while (index < tileData.length)
			{
				var x = tileData[index];
				var y = tileData[index + 1];
				var tileID = Std.int(tileData[index + 2]);
				index += 3;
				
				var tile = tiles[tileID];
				var centerPoint = tilePoints[tileID];
				var ox = centerPoint.x * tile.width, oy = centerPoint.y * tile.height;
				
				var scale = 1.0;
				var rotation = 0.0;
				var alpha = 1.0;
				
				if (useScale)
				{
					scale = tileData[index];
					index ++;
				}
				
				if (useRotation)
				{
					rotation = tileData[index];
					index ++;
				}
				
				if (useRGB)
				{
					//ignore for now
					index += 3;
				}
				
				if (useAlpha)
				{
					alpha = tileData[index];
					index++;
				}
				
				matrix.tx = x - tile.x - ox;
				matrix.ty = y - tile.y - oy;
				
				// need to add support for rotation, alpha, scale and RGB
				
				graphics.beginBitmapFill(nmeBitmap, matrix, false, smooth);
				graphics.drawRect(x - ox, y - oy, tile.width, tile.height);
			}
			
		}
		
		graphics.endFill();
	}
	
}



#end