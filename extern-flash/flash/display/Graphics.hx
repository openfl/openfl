package flash.display; #if (!display && flash)


import openfl.display.Tilesheet;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.Vector;

@:access(openfl.display.Tilesheet)


@:final extern class Graphics {
	
	
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
	public static inline var TILE_BLEND_DARKEN = 0x00100000;
	public static inline var TILE_BLEND_LIGHTEN = 0x00200000;
	public static inline var TILE_BLEND_OVERLAY = 0x00400000;
	public static inline var TILE_BLEND_HARDLIGHT = 0x00800000;
	public static inline var TILE_BLEND_DIFFERENCE = 0x01000000;
	public static inline var TILE_BLEND_INVERT = 0x02000000;
	
	
	public function beginBitmapFill (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public function beginFill (color:UInt = 0, alpha:Float = 1):Void;
	public function beginGradientFill (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Null<Float> = null):Void;
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash10) public function beginShaderFill (shader:Shader, matrix:Matrix = null):Void;
	#end
	
	public function clear ():Void;
	
	@:require(flash10) public function copyFrom (sourceGraphics:Graphics):Void;
	@:require(flash11) public function cubicCurveTo (controlX1:Float, controlY1:Float, controlX2:Float, controlY2:Float, anchorX:Float, anchorY:Float):Void;
	public function curveTo (controlX:Float, controlY:Float, anchorX:Float, anchorY:Float):Void;
	public function drawCircle (x:Float, y:Float, radius:Float):Void;
	public function drawEllipse (x:Float, y:Float, width:Float, height:Float):Void;
	@:require(flash10) public function drawGraphicsData (graphicsData:Vector<IGraphicsData>):Void;
	@:require(flash10) public function drawPath (commands:Vector<Int>, data:Vector<Float>, ?winding:GraphicsPathWinding):Void;
	public function drawRect (x:Float, y:Float, width:Float, height:Float):Void;
	public function drawRoundRect (x:Float, y:Float, width:Float, height:Float, rx:Float, ry:Float = -1):Void;
	public function drawRoundRectComplex (x:Float, y:Float, width:Float, height:Float, topLeftRadius:Float, topRightRadius:Float, bottomLeftRadius:Float, bottomRightRadius:Float):Void;
	
	
	public inline function drawTiles (sheet:Tilesheet, tileData:Array<Float>, smooth:Bool = false, flags:Int = 0, ?shader:Shader, count:Int = -1):Void {
		
		#if (flash && !display)
		
		var useScale = (flags & Tilesheet.TILE_SCALE) > 0;
		var useRotation = (flags & Tilesheet.TILE_ROTATION) > 0;
		var useRGB = (flags & Tilesheet.TILE_RGB) > 0;
		var useAlpha = (flags & Tilesheet.TILE_ALPHA) > 0;
		var useTransform = (flags & Tilesheet.TILE_TRANS_2x2) > 0;
		var useRect = (flags & Tilesheet.TILE_RECT) > 0;
		var useOrigin = (flags & Tilesheet.TILE_ORIGIN) > 0;
		
		var tile:Rectangle = null;
		var tileUV:Rectangle = null;
		var tilePoint:Point = null;
		
		var numValues = 3;
		var totalCount = count;
		var itemCount;
		if (count < 0) {
			
			totalCount = tileData.length;
			
		}
		
		if (useTransform || useScale || useRotation || useRGB || useAlpha) {
			
			var scaleIndex = 0;
			var rotationIndex = 0;
			var rgbIndex = 0;
			var alphaIndex = 0;
			var transformIndex = 0;
			
			if (useRect) { numValues = useOrigin ? 8 : 6; }
			if (useScale) { scaleIndex = numValues; numValues ++; }
			if (useRotation) { rotationIndex = numValues; numValues ++; }
			if (useTransform) { transformIndex = numValues; numValues += 4; }
			if (useRGB) { rgbIndex = numValues; numValues += 3; }
			if (useAlpha) { alphaIndex = numValues; numValues ++; }
			
			itemCount = Std.int (totalCount / numValues);
			var ids = sheet.adjustIDs (sheet.__ids, itemCount);
			var vertices = sheet.adjustLen (sheet.__vertices, itemCount * 8); 
			var indices = sheet.adjustIndices (sheet.__indices, itemCount * 6); 
			var uvtData = sheet.adjustLen (sheet.__uvs, itemCount * 8); 
			
			var index = 0;
			var offset8 = 0;
			var tileIndex:Int = 0;
			var tileID:Int = 0;
			var cacheID:Int = -1;
			
			while (index < totalCount) {
				
				var x = tileData[index];
				var y = tileData[index + 1];
				var tileID = (!useRect) ? Std.int(tileData[index + 2]) : -1;
				var scale = 1.0;
				var rotation = 0.0;
				var alpha = 1.0;
				
				if (useScale) {
					
					scale = tileData[index + scaleIndex];
					
				}
				
				if (useRotation) {
					
					rotation = tileData[index + rotationIndex];
					
				}
				
				if (useRGB) {
					
					//ignore for now
					
				}
				
				if (useAlpha) {
					
					alpha = tileData[index + alphaIndex];
					
				}
				
				if (!useRect && cacheID != tileID) {
					
					cacheID = tileID;
					tile = sheet.__tileRects[tileID];
					tileUV = sheet.__tileUVs[tileID];
					tilePoint = sheet.__centerPoints[tileID];
					
				} else if (useRect) {
					
					tile = sheet.__rectTile;
					tile.setTo (tileData[index + 2], tileData[index + 3], tileData[index + 4], tileData[index + 5]);
					tileUV = sheet.__rectUV;
					tileUV.setTo (tile.x / sheet.__bitmap.width, tile.y / sheet.__bitmap.height, tile.right / sheet.__bitmap.width, tile.bottom / sheet.__bitmap.height);
					tilePoint = sheet.__point;
					
					if (useOrigin) {
						
						tilePoint.setTo (tileData[index + 6] / tile.width, tileData[index + 7] / tile.height);
						
					} else {
						
						tilePoint.setTo (0, 0);
						
					}
					
				}
				
				if (useTransform) {
					
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
					
				} else {
					
					var tileWidth = tile.width * scale;
					var tileHeight = tile.height * scale;
					
					if (rotation != 0) {
						
						var ca = Math.cos (rotation);
						var sa = Math.sin (rotation);
						var tw = tile.width;
						var th = tile.height;
						var t0 = ca;
						var t1 = sa;
						var t2 = -sa;
						var t3 = ca;
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
						
					} else {
						
						x -= tilePoint.x * tileWidth;
						y -= tilePoint.y * tileHeight;
						vertices[offset8] = vertices[offset8 + 4] = x;
						vertices[offset8 + 1] = vertices[offset8 + 3] = y;
						vertices[offset8 + 2] = vertices[offset8 + 6] = x + tileWidth;
						vertices[offset8 + 5] = vertices[offset8 + 7] = y + tileHeight;
						
					}
					
				}
				
				if (ids[tileIndex] != tileID || useRect) {
					
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
			
			this.beginBitmapFill (sheet.__bitmap, null, false, smooth);
			this.drawTriangles (vertices, indices, uvtData);
			
		} else {
			
			var index = 0;
			var matrix = new Matrix ();
			while (index < totalCount) {
				
				var x = tileData[index++];
				var y = tileData[index++];
				var tileID = (!useRect) ? Std.int (tileData[index++]) : -1;
				var ox:Float = 0; 
				var oy:Float = 0;
				
				if (!useRect) {
					
					tile = sheet.__tileRects[tileID];
					tilePoint = sheet.__centerPoints[tileID];
					ox = tilePoint.x * tile.width;
					oy = tilePoint.y * tile.height;
				}
				else {
					tile = sheet.__rectTile;
					tile.setTo(tileData[index++], tileData[index++], tileData[index++], tileData[index++]);
					if (useOrigin)
					{
						ox = tileData[index++];
						oy = tileData[index++];
					}
				}
				
				matrix.tx = x - tile.x - ox;
				matrix.ty = y - tile.y - oy;
				
				this.beginBitmapFill (sheet.__bitmap, matrix, false, smooth);
				this.drawRect (x - ox, y - oy, tile.width, tile.height);
				
			}
			
		}
		
		this.endFill ();
		
		#end
		
	}
	
	
	@:require(flash10) public function drawTriangles (vertices:Vector<Float>, ?indices:Vector<Int> = null, ?uvtData:Vector<Float> = null, ?culling:TriangleCulling, ?colors:Vector<Int>, blendMode:Int = 0):Void;
	public function endFill ():Void;
	@:require(flash10) public function lineBitmapStyle (bitmap:BitmapData, matrix:Matrix = null, repeat:Bool = true, smooth:Bool = false):Void;
	public function lineGradientStyle (type:GradientType, colors:Array<UInt>, alphas:Array<Float>, ratios:Array<Int>, matrix:Matrix = null, ?spreadMethod:SpreadMethod, ?interpolationMethod:InterpolationMethod, focalPointRatio:Null<Float> = null):Void;
	public function lineStyle (thickness:Null<Float> = null, color:Null<UInt> = null, alpha:Null<Float> = null, pixelHinting:Null<Bool> = null, ?scaleMode:LineScaleMode, ?caps:CapsStyle, ?joints:JointStyle, miterLimit:Null<Float> = 3):Void;
	public function lineTo (x:Float, y:Float):Void;
	public function moveTo (x:Float, y:Float):Void;
	
	
	#if flash
	@:noCompletion @:dox(hide) @:require(flash11_6) public function readGraphicsData (recurse:Bool = true):Vector<IGraphicsData>;
	#end
	
	
}


#else
typedef Graphics = openfl.display.Graphics;
#end