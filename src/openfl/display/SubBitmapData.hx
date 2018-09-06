package openfl.display;

import openfl.display.BitmapData;

#if !display
import js.Browser;
import js.html.CanvasElement;
import openfl._internal.renderer.RenderSession;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.filters.BitmapFilter;
import openfl.display.BitmapData.TextureRegionResult;
import openfl.utils.ByteArray;
import lime.graphics.CanvasRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.WebGLContext;
import lime.graphics.utils.ImageCanvasUtil;
import lime.utils.Float32Array;
#if (js && html5)
import js.html.CanvasRenderingContext2D;
#end
#end

@:access(openfl.geom.ColorTransform)
class SubBitmapData extends BitmapData {
	
	private var __offsetX = 0;
	private var __offsetY = 0;
	private var __texX0 = 0.0;
	private var __texX1 = 1.0;
	private var __texY0 = 0.0;
	private var __texY1 = 1.0;
	private var __texX:Int;
	private var __texY:Int;
	private var __texWidth:Int;
	private var __texHeight:Int;
	private var __parentBitmap:BitmapData;
	private var __rotated = false;

	public function new (atlasBitmap:BitmapData, x:Int, y:Int, width:Int, height:Int, frameX:Int, frameY:Int, frameWidth:Int, frameHeight:Int, rotated:Bool) {
		
		#if !display
		var w = width, h = height;
		var offsetX = 0;
		var offsetY = 0;
		if (frameWidth > 0 && frameHeight > 0) {
			
			offsetX = -frameX;
			offsetY = -frameY;
			w = frameWidth;
			h = frameHeight;
			
		} else if (rotated) {
			
			var tmp = w;
			w = h;
			h = tmp;
			
		}

		// we don't want BitmapData constructor to create a lime Image of given width/height
		// so we supply zeroes as dimensions and then initialize the fields directly
		super (0, 0, false, 0);
		this.width = w;
		this.height = h;
		rect = new Rectangle (0, 0, w, h);
		__isValid = true;
		readable = false;
		image = null;

		var gl = GL.context;
		var texture = atlasBitmap.getTexture (gl);
		__parentBitmap = atlasBitmap;
		__texX0 = x / atlasBitmap.width;
		__texX1 = (x + width) / atlasBitmap.width;
		__texY0 = y / atlasBitmap.height;
		__texY1 = (y + height) / atlasBitmap.height;
		__texX = x;
		__texY = y;
		__texWidth = width;
		__texHeight = height;
		__texture = texture;
		__textureContext = gl;
		__offsetX = offsetX;
		__offsetY = offsetY;
		__rotated = rotated;
		#else
		super(0,0,false,0);
		#end
		
	}

	override function clone ():BitmapData {
		
		return new SubBitmapData (__parentBitmap, __texX, __texY, __texWidth, __texHeight, -__offsetX, -__offsetY, width, height, __rotated);
	
	}

	#if !display
	
	function unsupported() lime.utils.Log.error("SubBitmapData does not support modification methods, please create a normal BitmapData object and draw into it");
	override function applyFilter(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter) unsupported();
	override function colorTransform(rect:Rectangle, colorTransform:ColorTransform) unsupported();
	override function copyChannel(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel, destChannel:BitmapDataChannel) unsupported();
	override function copyPixels(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false) unsupported();
	override function draw(source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false) unsupported();
	override function floodFill(x:Int, y:Int, color:Int) unsupported();
	override function fillRect(rect:Rectangle, color:Int) unsupported();
	override function merge(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt, alphaMultiplier:UInt) unsupported();
	override function noise(randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false) unsupported();
	override function paletteMap(sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null, blueArray:Array<Int> = null, alphaArray:Array<Int> = null) unsupported();
	override function perlinNoise (baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7, grayScale:Bool = false, offsets:Array<Point> = null):Void unsupported();
	override function scroll (x:Int, y:Int):Void unsupported();
	override function setPixel (x:Int, y:Int, color:Int):Void unsupported();
	override function setPixel32 (x:Int, y:Int, color:Int):Void unsupported();
	override function setPixels (rect:Rectangle, byteArray:ByteArray):Void unsupported();
	override function setVector (rect:Rectangle, inputVector:Vector<UInt>) unsupported();
		
	// not using Point class here, because we need Int coords, not Float
	static var __getPixelAbsoluteCoordsX:Int;
	static var __getPixelAbsoluteCoordsY:Int;

	function __getPixelAbsoluteCoords (x:Int, y:Int):Bool {
		
		x -= __offsetX;
		y -= __offsetY;
		if (x < 0 || y < 0)
			return false;
			
		if (__rotated) {
			
			if (x > __texHeight || y > __texWidth)
				return false;
			
			var tmp = x;
			x = __texWidth - y;
			y = tmp;
			
		} else {
			
			if (x > __texWidth || y > __texHeight)
				return false;
			
		}

		__getPixelAbsoluteCoordsX = __texX + x;
		__getPixelAbsoluteCoordsY = __texY + y;
		return true;
		
	}

	override function getPixel (x:Int, y:Int):Int {
		
		if (__getPixelAbsoluteCoords (x, y)) {
			
			return __parentBitmap.image.getPixel (__getPixelAbsoluteCoordsX, __getPixelAbsoluteCoordsY, ARGB32);
		
		} else {
			
			return 0;
			
		}
		
	}

	override function getPixel32 (x:Int, y:Int):Int {
		
		if (__getPixelAbsoluteCoords (x, y)) {
			
			return __parentBitmap.image.getPixel32 (__getPixelAbsoluteCoordsX, __getPixelAbsoluteCoordsY, ARGB32);
		
		} else {
			
			return 0;
			
		}
		
	}

	override function getTexture (gl:GLRenderContext):GLTexture {
		return __texture;
	}

	override function getBuffer (gl:GLRenderContext, alpha:Float, colorTransform:ColorTransform):GLBuffer {
		
		var __bufferStride = BitmapData.__bufferStride;

		if (__buffer == null || __bufferContext != gl) {
			
			__bufferData = new Float32Array (__bufferStride * 4);

			if (__rotated) {
				
				__bufferData[0] = __offsetX + __texHeight;
				__bufferData[1] = __offsetY + __texWidth;
				__bufferData[2] = 0;

				__bufferData[3] = __texX0;
				__bufferData[4] = __texY1;

				// ------

				__bufferData[__bufferStride] = __offsetX;
				__bufferData[__bufferStride + 1] = __offsetY + __texWidth;
				__bufferData[__bufferStride + 2] = 0;

				__bufferData[__bufferStride + 3] = __texX0;
				__bufferData[__bufferStride + 4] = __texY0;

				// ------

				__bufferData[__bufferStride * 2] = __offsetX + __texHeight;
				__bufferData[__bufferStride * 2 + 1] = __offsetY;
				__bufferData[__bufferStride * 2 + 2] = 0;

				__bufferData[__bufferStride * 2 + 3] = __texX1;
				__bufferData[__bufferStride * 2 + 4] = __texY1;

				// ------

				__bufferData[__bufferStride * 3] = __offsetX;
				__bufferData[__bufferStride * 3 + 1] = __offsetY;
				__bufferData[__bufferStride * 3 + 2] = 0;

				__bufferData[__bufferStride * 3 + 3] = __texX1;
				__bufferData[__bufferStride * 3 + 4] = __texY0;
				
			} else {
				
				__bufferData[0] = __offsetX + __texWidth;
				__bufferData[1] = __offsetY + __texHeight;
				__bufferData[2] = 0;

				__bufferData[3] = __texX1;
				__bufferData[4] = __texY1;

				// ------

				__bufferData[__bufferStride] = __offsetX;
				__bufferData[__bufferStride + 1] = __offsetY + __texHeight;
				__bufferData[__bufferStride + 2] = 0;

				__bufferData[__bufferStride + 3] = __texX0;
				__bufferData[__bufferStride + 4] = __texY1;

				// ------

				__bufferData[__bufferStride * 2] = __offsetX + __texWidth;
				__bufferData[__bufferStride * 2 + 1] = __offsetY;
				__bufferData[__bufferStride * 2 + 2] = 0;

				__bufferData[__bufferStride * 2 + 3] = __texX1;
				__bufferData[__bufferStride * 2 + 4] = __texY0;

				// ------

				__bufferData[__bufferStride * 3] = __offsetX;
				__bufferData[__bufferStride * 3 + 1] = __offsetY;
				__bufferData[__bufferStride * 3 + 2] = 0;

				__bufferData[__bufferStride * 3 + 3] = __texX0;
				__bufferData[__bufferStride * 3 + 4] = __texY0;
				
			}

			for (i in 0...4) {

				__bufferData[__bufferStride * i + 5] = alpha;

				if (colorTransform != null) {

					__bufferData[__bufferStride * i + 6] = colorTransform.redMultiplier;
					__bufferData[__bufferStride * i + 11] = colorTransform.greenMultiplier;
					__bufferData[__bufferStride * i + 16] = colorTransform.blueMultiplier;
					__bufferData[__bufferStride * i + 21] = colorTransform.alphaMultiplier;
					__bufferData[__bufferStride * i + 22] = colorTransform.redOffset / 255;
					__bufferData[__bufferStride * i + 23] = colorTransform.greenOffset / 255;
					__bufferData[__bufferStride * i + 24] = colorTransform.blueOffset / 255;
					__bufferData[__bufferStride * i + 25] = colorTransform.alphaOffset / 255;

				} else {

					__bufferData[__bufferStride * i + 6] = 1;
					__bufferData[__bufferStride * i + 11] = 1;
					__bufferData[__bufferStride * i + 16] = 1;
					__bufferData[__bufferStride * i + 21] = 1;

				}

			}

			__bufferAlpha = alpha;
			__bufferColorTransform = colorTransform != null ? colorTransform.__clone () : null;
			__bufferContext = gl;
			__buffer = gl.createBuffer ();

			gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);
			#if (js && html5)
			(gl:WebGLContext).bufferData (gl.ARRAY_BUFFER, __bufferData, gl.STATIC_DRAW);
			#else
			gl.bufferData (gl.ARRAY_BUFFER, __bufferData.byteLength, __bufferData, gl.STATIC_DRAW);
			#end

		} else {

			var dirty = false;

			if (__bufferAlpha != alpha) {
				
				dirty = true;

				for (i in 0...4) {
					
					__bufferData[__bufferStride * i + 5] = alpha;
					
				}

				__bufferAlpha = alpha;
				
			}

			if ((__bufferColorTransform == null && colorTransform != null) || (__bufferColorTransform != null && !__bufferColorTransform.__equals (colorTransform))) {
				
				dirty = true;

				if (colorTransform != null) {
					
					if (__bufferColorTransform == null) {
						
						__bufferColorTransform = colorTransform.__clone ();
						
					} else {
						
						__bufferColorTransform.__copyFrom (colorTransform);
						
					}

					for (i in 0...4) {
						
						__bufferData[__bufferStride * i + 6] = colorTransform.redMultiplier;
						__bufferData[__bufferStride * i + 11] = colorTransform.greenMultiplier;
						__bufferData[__bufferStride * i + 16] = colorTransform.blueMultiplier;
						__bufferData[__bufferStride * i + 21] = colorTransform.alphaMultiplier;
						__bufferData[__bufferStride * i + 22] = colorTransform.redOffset / 255;
						__bufferData[__bufferStride * i + 23] = colorTransform.greenOffset / 255;
						__bufferData[__bufferStride * i + 24] = colorTransform.blueOffset / 255;
						__bufferData[__bufferStride * i + 25] = colorTransform.alphaOffset / 255;
						
					}
					
				} else {
					
					for (i in 0...4) {
						
						__bufferData[__bufferStride * i + 6] = 1;
						__bufferData[__bufferStride * i + 11] = 1;
						__bufferData[__bufferStride * i + 16] = 1;
						__bufferData[__bufferStride * i + 21] = 1;
						__bufferData[__bufferStride * i + 22] = 0;
						__bufferData[__bufferStride * i + 23] = 0;
						__bufferData[__bufferStride * i + 24] = 0;
						__bufferData[__bufferStride * i + 25] = 0;
						
					}
					
				}

			}

			gl.bindBuffer (gl.ARRAY_BUFFER, __buffer);

			if (dirty) {
				
				gl.bufferData (gl.ARRAY_BUFFER, __bufferData.byteLength, __bufferData, gl.STATIC_DRAW);
			
			}
			
		}

		return __buffer;
		
	}

	override function __getTextureRegion (uvX:Float, uvY:Float, uvWidth:Float, uvHeight:Float, result:TextureRegionResult) {
		
		// translate (back) to pixel coordinates inside the SubBitmapData region
		var left = uvX * width;
		var right = uvWidth * width;
		var top = uvY * height;
		var bottom = uvHeight * height;

		if (__rotated) {
			
			result.u0 = (__texX + __texWidth - top + __offsetY) / __parentBitmap.width;
			result.v0 = (__texY + left - __offsetX) / __parentBitmap.height;

			result.u1 = (__texX + __texWidth - top + __offsetY) / __parentBitmap.width;
			result.v1 = (__texY + right - __offsetX) / __parentBitmap.height;

			result.u2 = (__texX + __texWidth - bottom + __offsetY) / __parentBitmap.width;
			result.v2 = (__texY + right - __offsetX) / __parentBitmap.height;

			result.u3 = (__texX + __texWidth - bottom + __offsetY)/ __parentBitmap.width;
			result.v3 = (__texY + left - __offsetX) / __parentBitmap.height;
			
		} else {
			
			var u0 = (__texX + left - __offsetX) / __parentBitmap.width;
			var v0 = (__texY + top - __offsetY) / __parentBitmap.height;
			var u1 = (__texX + right - __offsetX) / __parentBitmap.width;
			var v1 = (__texY + bottom - __offsetY) / __parentBitmap.height;
			result.u0 = u0;
			result.v0 = v0;
			result.u1 = u1;
			result.v1 = v0;
			result.u2 = u1;
			result.v2 = v1;
			result.u3 = u0;
			result.v3 = v1;
			
		}
		
	}

	override function __prepareImage () {
		
		if (image == null) {
			
			var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			canvas.width = width;
			canvas.height = height;

			__drawToCanvas (canvas.getContext ("2d"), @:privateAccess Matrix.__identity, true, 1, null, false);

			image = lime.graphics.Image.fromCanvas (canvas);
		}
		return true;
		
	}

	override function __renderCanvas (renderSession:RenderSession) {
	
		renderSession.context.globalAlpha = 1;
		__drawToCanvas (renderSession.context, __worldTransform, renderSession.roundPixels, renderSession.pixelRatio, null, false);
	
	}

	#if (js && html5)
	override function __canBeDrawnToCanvas ():Bool {
		
		return __parentBitmap.__canBeDrawnToCanvas ();
		
	} 
	
	static var __drawToCanvasTransform = new Matrix();

	override function __drawToCanvas (context:CanvasRenderingContext2D, transform:Matrix, roundPixels:Bool, pixelRatio:Float, scrollRect:Rectangle, useScrollRectCoords:Bool):Void {

		var parentImage = __parentBitmap.image;
		if (parentImage.type == DATA) {
			
			ImageCanvasUtil.convertToCanvas (parentImage);
			
		}
		
		var sx:Float = __texX;
		var sy:Float = __texY;
		var w:Float = __texWidth;
		var h:Float = __texHeight;
		var dx:Float = 0;
		var dy:Float = 0;
		var offsetX:Float = __offsetX;
		var offsetY:Float = __offsetY;
		
		if (scrollRect != null) {

			offsetX -= scrollRect.x;
			offsetY -= scrollRect.y;
			
			if (!__rotated) {
				if (offsetX < 0) {
					sx += -offsetX;
					w = Math.min(scrollRect.width, __texWidth + offsetX);
					offsetX = 0;
				} else {
					w = Math.min(scrollRect.width - offsetX, __texWidth);
				}

				if (offsetY < 0) {
					sy += -offsetY;
					h = Math.min(scrollRect.height, __texHeight + offsetY);
					offsetY = 0;
				} else {
					h = Math.min(scrollRect.height - offsetY, __texHeight);
				}
			} else {
				
				if (offsetX < 0) {
					sy += -offsetX;
					h = Math.min(scrollRect.width, __texHeight + offsetX);
					offsetX = 0;
				} else {
					h = Math.min(scrollRect.width - offsetX, __texHeight);
				}

				if (offsetY < 0) {
					var rightOffset = scrollRect.height - offsetY;
					sx = Std.int(Math.max(__texX, __texX + __texWidth - rightOffset));
					w = scrollRect.height;
					offsetY = 0;
				} else {
					w = scrollRect.height - offsetY;
					sx = Std.int(Math.max(__texX, __texX + __texWidth - w));
				}
			}

			if (useScrollRectCoords) {
				dx = scrollRect.x;
				dy = scrollRect.y;
			}
		}
		
		__drawToCanvasTransform.copyFrom(transform);
		__drawToCanvasTransform.__translateTransformed(offsetX, offsetY);

		var scale = pixelRatio / this.__pixelRatio; // Bitmaps can have different pixelRatio than display, therefore we need to scale them properly
		var transform = __drawToCanvasTransform;
		
		if (roundPixels) {
			
			context.setTransform (transform.a * scale, transform.b, transform.c, transform.d * scale, Math.round (transform.tx * pixelRatio), Math.round  (transform.ty * pixelRatio));
			
		} else {
			
			context.setTransform (transform.a * scale, transform.b, transform.c, transform.d * scale, transform.tx * pixelRatio, transform.ty * pixelRatio);
			
		}
		
		if (__rotated) {
			
			context.translate (0, w);
			context.rotate (-90 * Math.PI / 180);
			
		}

		context.drawImage (parentImage.src, sx, sy, w, h, dx, dy, w, h);

	}
	#end

	#end
	
}
