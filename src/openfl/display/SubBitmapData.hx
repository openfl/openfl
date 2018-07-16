package openfl.display;

import openfl.display.BitmapData;

#if !display
import js.Browser;
import js.html.CanvasElement;
import openfl._internal.renderer.RenderSession;
import openfl.geom.ColorTransform;
import openfl.geom.Rectangle;
import openfl.display.BitmapData.TextureRegionResult;
import lime.graphics.CanvasRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.WebGLContext;
import lime.graphics.utils.ImageCanvasUtil;
import lime.utils.Float32Array;
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

			__drawToCanvas (canvas.getContext ("2d"), 1, 0, 0, 1, 0, 0);

			image = lime.graphics.Image.fromCanvas (canvas);
		}
		return true;
		
	}
	
	inline function __drawToCanvas (context:CanvasRenderContext, a:Float, b:Float, c:Float, d:Float, tx:Float, ty:Float) {
		
		var parentImage = __parentBitmap.image;
		if (parentImage.type == DATA) {
			
			ImageCanvasUtil.convertToCanvas (parentImage);
			
		}

		context.setTransform (a, b, c, d, tx + __offsetX * a, ty + __offsetY * d);
		if (__rotated) {
			
			context.rotate (-90 * Math.PI / 180);
			context.translate (-__texWidth, 0);
			
		}

		context.drawImage (parentImage.src, __texX, __texY, __texWidth, __texHeight, 0, 0, __texWidth, __texHeight);
	
	}

	override function __renderCanvas (renderSession:RenderSession) {
	
		var transform = __worldTransform;
		var tx = transform.tx;
		var ty = transform.ty;
		if (renderSession.roundPixels) {
			
			tx = Math.round (tx);
			ty = Math.round (ty);
			
		}

		var context = renderSession.context;
		context.globalAlpha = 1;
		__drawToCanvas (context, transform.a, transform.b, transform.c, transform.d, tx, ty);
	
	}
	#end
	
}
