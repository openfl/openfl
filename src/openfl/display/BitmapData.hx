package openfl.display;


import lime.app.Future;
import lime.app.Promise;
import lime.graphics.cairo.CairoExtend;
import lime.graphics.cairo.CairoFilter;
import lime.graphics.cairo.CairoImageSurface;
import lime.graphics.cairo.CairoPattern;
import lime.graphics.cairo.CairoSurface;
import lime.graphics.cairo.Cairo;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GL;
import lime.graphics.opengl.WebGLContext;
import lime.graphics.GLRenderContext;
import lime.graphics.Image;
import lime.graphics.ImageChannel;
import lime.graphics.ImageBuffer;
import lime.graphics.utils.ImageCanvasUtil;
import lime.math.color.ARGB;
import lime.math.ColorMatrix;
import lime.math.Rectangle in LimeRectangle;
import lime.math.Vector2;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
// import openfl.Lib;
import openfl._internal.renderer.canvas.CanvasBlendModeManager;
import openfl._internal.renderer.canvas.CanvasMaskManager;
import openfl._internal.renderer.RenderSession;
import openfl._internal.renderer.opengl.GLMaskManager;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.utils.PerlinNoise;
import openfl.display3D.textures.TextureBase;
import openfl.errors.Error;
import openfl.errors.IOError;
import openfl.errors.TypeError;
import openfl.filters.BitmapFilter;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.utils.Object;
import openfl.Vector;

#if (js && html5)
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.ImageData;
import js.html.ImageElement;
import js.html.Uint8ClampedArray;
import js.Browser;
#end

#if lime_cairo
import openfl._internal.renderer.cairo.CairoBlendModeManager;
import openfl._internal.renderer.cairo.CairoRenderer;
import openfl._internal.renderer.cairo.CairoMaskManager;
#end

#if gl_stats
import openfl._internal.renderer.opengl.stats.GLStats;
import openfl._internal.renderer.opengl.stats.DrawCallContext;
#end

@:access(lime.graphics.opengl.GL)
@:access(lime.graphics.Image)
@:access(lime.graphics.ImageBuffer)
@:access(lime.math.Rectangle)
@:access(openfl._internal.renderer.opengl.GLMaskManager)
@:access(openfl._internal.renderer.opengl.GLRenderer)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)
@:access(openfl.filters.BitmapFilter)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:autoBuild(openfl._internal.macros.AssetsMacro.embedBitmap())


class BitmapData implements IBitmapDrawable {
	
	
	private static inline var __bufferStride = 26;
	private static var __supportsBGRA:Null<Bool> = null;
	private static var __tempVector:Vector2 = new Vector2 ();
	private static var __textureFormat:Int;
	private static var __textureInternalFormat:Int;
	
	public var height (default, null):Int;
	public var image (default, null):Image;
	@:beta public var readable (default, null):Bool;
	public var rect (default, null):Rectangle;
	public var transparent (default, null):Bool;
	public var width (default, null):Int;
	
	private var __blendMode:BlendMode;
	private var __buffer:GLBuffer;
	private var __bufferColorTransform:ColorTransform;
	private var __bufferContext:GLRenderContext;
	private var __bufferAlpha:Float;
	private var __bufferData:Float32Array;
	private var __framebuffer:GLFramebuffer;
	private var __framebufferContext:GLRenderContext;
	private var __isMask:Bool;
	private var __isValid:Bool;
	private var __renderable:Bool;
	private var __surface:CairoSurface;
	private var __texture:GLTexture;
	private var __textureContext:GLRenderContext;
	private var __textureVersion:Int;
	private var __transform:Matrix;
	private var __worldAlpha:Float;
	private var __worldColorTransform:ColorTransform;
	private var __worldTransform:Matrix;
	
	
	public function new (width:Int, height:Int, transparent:Bool = true, fillColor:UInt = 0xFFFFFFFF) {
		
		this.transparent = transparent;
		
		#if (neko || (js && html5))
		width = width == null ? 0 : width;
		height = height == null ? 0 : height;
		#end
		
		width = width < 0 ? 0 : width;
		height = height < 0 ? 0 : height;
		
		this.width = width;
		this.height = height;
		rect = new Rectangle (0, 0, width, height);
		
		if (width > 0 && height > 0) {
			
			if (transparent) {
				
				if ((fillColor & 0xFF000000) == 0) {
					
					fillColor = 0;
					
				}
				
			} else {
				
				fillColor = (0xFF << 24) | (fillColor & 0xFFFFFF);
				
			}
			
			fillColor = (fillColor << 8) | ((fillColor >> 24) & 0xFF);
			
			#if sys
			var buffer = new ImageBuffer (new UInt8Array (width * height * 4), width, height);
			buffer.format = BGRA32;
			buffer.premultiplied = true;
			
			image = new Image (buffer, 0, 0, width, height);
			
			if (fillColor != 0) {
				
				image.fillRect (image.rect, fillColor);
				
			}
			//#elseif (js && html5)
			//var buffer = new ImageBuffer (null, width, height);
			//var canvas:CanvasElement = cast Browser.document.createElement ("canvas");
			//buffer.__srcCanvas = canvas;
			//buffer.__srcContext = canvas.getContext ("2d");
			//
			//image = new Image (buffer, 0, 0, width, height);
			//image.type = CANVAS;
			//
			//if (fillColor != 0) {
				//
				//image.fillRect (image.rect, fillColor);
				//
			//}
			#else
			image = new Image (null, 0, 0, width, height, fillColor);
			#end
			
			image.transparent = transparent;
			
			__isValid = true;
			readable = true;
			
		}
		
		__worldTransform = new Matrix ();
		__worldColorTransform = new ColorTransform ();
		__renderable = true;
		
	}
	
	
	public function applyFilter (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, filter:BitmapFilter):Void {
		
		if (!readable || sourceBitmapData == null || !sourceBitmapData.readable) return;
		
		filter.__applyFilter (this, sourceBitmapData, sourceRect, destPoint);
		
	}
	
	
	public function clone ():BitmapData {
		
		if (!__isValid) {
			
			return new BitmapData (width, height, transparent, 0);
			
		} else if (!readable && image == null) {
			
			var bitmapData = new BitmapData (0, 0, transparent, 0);
			
			bitmapData.width = width;
			bitmapData.height = height;
			bitmapData.rect.copyFrom (rect);
			
			bitmapData.__framebuffer = __framebuffer;
			bitmapData.__framebufferContext = __framebufferContext;
			bitmapData.__texture = __texture;
			bitmapData.__textureContext = __textureContext;
			bitmapData.__isValid = true;
			
			return bitmapData;
			
		} else {
			
			return BitmapData.fromImage (image.clone (), transparent);
			
		}
		
	}
	
	
	public function colorTransform (rect:Rectangle, colorTransform:ColorTransform):Void {
		
		if (!readable) return;
		
		image.colorTransform (rect.__toLimeRectangle (), colorTransform.__toLimeColorMatrix ());
		
	}
	
	
	public function compare (otherBitmapData:BitmapData):Dynamic {
		
		if (otherBitmapData == this) {
			
			return 0;
			
		} else if (otherBitmapData == null) {
			
			return -1;
			
		} else if (readable == false || otherBitmapData.readable == false) {
			
			return -2;
			
		} else if (width != otherBitmapData.width) {
			
			return -3;
			
		} else if (height != otherBitmapData.height) {
			
			return -4;
			
		}
		
		if (image != null && otherBitmapData.image != null && image.format == otherBitmapData.image.format) {
			
			var bytes = image.data;
			var otherBytes = otherBitmapData.image.data;
			var equal = true;
			
			for (i in 0...bytes.length) {
				
				if (bytes[i] != otherBytes[i]) {
					
					equal = false;
					break;
					
				}
			}
			
			if (equal) {
				
				return 0;
				
			}
			
		}
		
		var bitmapData = null;
		var foundDifference, pixel:ARGB, otherPixel:ARGB, comparePixel:ARGB, r, g, b, a;
		
		for (y in 0...height) {
			
			for (x in 0...width) {
				
				foundDifference = false;
				
				pixel = getPixel32 (x, y);
				otherPixel = otherBitmapData.getPixel32 (x, y);
				comparePixel = 0;
				
				if (pixel != otherPixel) {
					
					r = pixel.r - otherPixel.r;
					g = pixel.g - otherPixel.g;
					b = pixel.b - otherPixel.b;
					
					if (r < 0) r *= -1;
					if (g < 0) g *= -1;
					if (b < 0) b *= -1;
					
					if (r == 0 && g == 0 && b == 0) {
						
						a = pixel.a - otherPixel.a;
						
						if (a != 0) {
							
							comparePixel.r = 0xFF;
							comparePixel.g = 0xFF;
							comparePixel.b = 0xFF;
							comparePixel.a = a;
							
							foundDifference = true;
							
						}
						
					} else {
						
						comparePixel.r = r;
						comparePixel.g = g;
						comparePixel.b = b;
						comparePixel.a = 0xFF;
						
						foundDifference = true;
						
					}
					
				}
				
				if (foundDifference) {
					
					if (bitmapData == null) {
						
						bitmapData = new BitmapData (width, height, transparent || otherBitmapData.transparent, 0x00000000);
						
					}
					
					bitmapData.setPixel32 (x, y, comparePixel);
					
				}
				
			}
			
		}
		
		if (bitmapData == null) {
			
			return 0;
			
		}
		
		return bitmapData;
		
	}
	
	
	public function copyChannel (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, sourceChannel:BitmapDataChannel, destChannel:BitmapDataChannel):Void {
		
		if (!readable) return;
		
		var sourceChannel = switch (sourceChannel) {
			
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
			
		}
		
		var destChannel = switch (destChannel) {
			
			case 1: ImageChannel.RED;
			case 2: ImageChannel.GREEN;
			case 4: ImageChannel.BLUE;
			case 8: ImageChannel.ALPHA;
			default: return;
			
		}
		
		image.copyChannel (sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), sourceChannel, destChannel);
		
	}
	
	
	public function copyPixels (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, alphaBitmapData:BitmapData = null, alphaPoint:Point = null, mergeAlpha:Bool = false):Void {
		
		if (!readable || sourceBitmapData == null) return;
		
		if (alphaPoint != null) {
			
			__tempVector.x = alphaPoint.x;
			__tempVector.y = alphaPoint.y;
			
		}
		
		image.copyPixels (sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), alphaBitmapData != null ? alphaBitmapData.image : null, alphaPoint != null ? __tempVector : null, mergeAlpha);
		
	}
	
	
	public function dispose ():Void {
		
		image = null;
		
		width = 0;
		height = 0;
		rect = null;
		
		__isValid = false;
		readable = false;
		
		__surface = null;
		
		__buffer = null;
		__framebuffer = null;
		__framebufferContext = null;
		__texture = null;
		__textureContext = null;
		
		//if (__texture != null) {
			//
			//var renderer = @:privateAccess Lib.current.stage.__renderer;
			//
			//if(renderer != null) {
				//
				//var renderSession = @:privateAccess renderer.renderSession;
				//var gl = renderSession.gl;
				//
				//if (gl != null) {
					//
					//gl.deleteTexture (__texture);
					//__texture = null;
					//
				//}
				//
			//}
			//
		//}
		
	}
	
	
	@:beta public function disposeImage ():Void {
		
		readable = false;
		
	}
	
	
	public function draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		if (matrix == null) {
			
			matrix = new Matrix ();
			
			if (source.__transform != null) {
				
				matrix.copyFrom (source.__transform);
				matrix.tx = 0;
				matrix.ty = 0;
				
			}
			
		}
		
		if (!readable /*|| !source.readable*/) {
			
			if (GL.context != null) {
				
				var gl = GL.context;
				
				gl.bindFramebuffer (gl.FRAMEBUFFER, __getFramebuffer (gl));
				gl.viewport (0, 0, width, height);
				
				var renderer = new GLRenderer (null, gl, this);
				
				var renderSession = renderer.renderSession;
				renderSession.clearRenderDirty = false;
				renderSession.shaderManager = cast (null, GLRenderer).renderSession.shaderManager;
				
				var matrixCache = source.__worldTransform;
				source.__updateTransforms (matrix);
				source.__updateChildren (false);
				source.__renderGL (renderer.renderSession);
				source.__updateTransforms (matrixCache);
				source.__updateChildren (true);
				
				gl.bindFramebuffer (gl.FRAMEBUFFER, null);
				
			}
			
		} else {
			
			#if (js && html5)
			
			if (colorTransform != null) {
				
				var bounds = Rectangle.__pool.get ();
				var boundsMatrix = Matrix.__pool.get ();
				
				source.__getBounds (bounds, boundsMatrix);
				
				var width:Int = Math.ceil (bounds.width);
				var height:Int = Math.ceil (bounds.height);
				
				var copy = new BitmapData (width, height, true, 0);
				copy.draw (source);
				copy.colorTransform (copy.rect, colorTransform);
				source = copy;
				
				Rectangle.__pool.release (bounds);
				Matrix.__pool.release (boundsMatrix);
				
			}
			
			ImageCanvasUtil.convertToCanvas (image);
			
			var buffer = image.buffer;
			
			var renderSession = new RenderSession ();
			renderSession.renderType = CANVAS;
			// renderSession.lockTransform = true;
			renderSession.clearRenderDirty = false;
			renderSession.context = cast buffer.__srcContext;
			renderSession.allowSmoothing = smoothing;
			//renderSession.roundPixels = true;
			renderSession.maskManager = new CanvasMaskManager (renderSession);
			renderSession.blendModeManager = new CanvasBlendModeManager (renderSession);
			renderSession.blendModeManager.setBlendMode(blendMode);
			
			if (!smoothing) {
				
				untyped (buffer.__srcContext).mozImageSmoothingEnabled = false;
				//untyped (buffer.__srcContext).webkitImageSmoothingEnabled = false;
				untyped (buffer.__srcContext).msImageSmoothingEnabled = false;
				untyped (buffer.__srcContext).imageSmoothingEnabled = false;
				
			}
			
			if (clipRect != null) {
				
				renderSession.maskManager.pushRect (clipRect, new Matrix ());
				
			}
			
			var matrixCache = source.__worldTransform;
			source.__updateTransforms (matrix);
			source.__updateChildren (false);
			source.__renderCanvas (renderSession);
			source.__updateTransforms (matrixCache);
			source.__updateChildren (true);
			
			if (!smoothing) {
				
				untyped (buffer.__srcContext).mozImageSmoothingEnabled = true;
				//untyped (buffer.__srcContext).webkitImageSmoothingEnabled = true;
				untyped (buffer.__srcContext).msImageSmoothingEnabled = true;
				untyped (buffer.__srcContext).imageSmoothingEnabled = true;
				
			}
			
			if (clipRect != null) {
				
				renderSession.maskManager.popRect ();
				
			}
			
			buffer.__srcContext.setTransform (1, 0, 0, 1, 0, 0);
			buffer.__srcImageData = null;
			buffer.data = null;
			
			image.dirty = true;
			image.version++;
			
			#elseif lime_cairo
			
			if (source == this) {
				
				source = clone ();
				
			}
			
			if (colorTransform != null) {
				
				var bounds = Rectangle.__pool.get ();
				var boundsMatrix = Matrix.__pool.get ();
				
				source.__getBounds (bounds, boundsMatrix);
				
				var width:Int = Math.ceil (bounds.width);
				var height:Int = Math.ceil (bounds.height);
				
				var copy = new BitmapData (width, height, true, 0);
				copy.draw (source);
				copy.colorTransform (copy.rect, colorTransform);
				source = copy;
				
				Rectangle.__pool.release (bounds);
				Matrix.__pool.release (boundsMatrix);
				
			}
			
			var surface = getSurface ();
			var cairo = new Cairo (surface);
			
			if (!smoothing) {
				
				cairo.antialias = NONE;
				
			}
			
			var renderSession = new RenderSession ();
			renderSession.renderType = CAIRO;
			// renderSession.lockTransform = true;
			renderSession.clearRenderDirty = false;
			renderSession.cairo = cairo;
			renderSession.allowSmoothing = smoothing;
			//renderSession.roundPixels = true;
			renderSession.maskManager = new CairoMaskManager (renderSession);
			renderSession.blendModeManager = new CairoBlendModeManager (renderSession);
			renderSession.blendModeManager.setBlendMode(blendMode);
			
			if (clipRect != null) {
				
				renderSession.maskManager.pushRect (clipRect, new Matrix ());
				
			}
			
			var matrixCache = source.__worldTransform;
			source.__updateTransforms (matrix);
			source.__updateChildren (false);
			source.__renderCairo (renderSession);
			source.__updateTransforms (matrixCache);
			source.__updateChildren (true);
			
			if (clipRect != null) {
				
				renderSession.maskManager.popRect ();
				
			}
			
			surface.flush ();
			
			image.dirty = true;
			image.version++;
			
			#end
			
		}
		
	}
	
	
	public function drawWithQuality (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false, quality:StageQuality = null):Void {
		
		draw (source, matrix, colorTransform, blendMode, clipRect, quality != LOW ? smoothing : false);
		
	}
	
	
	public function encode (rect:Rectangle, compressor:Object, byteArray:ByteArray = null):ByteArray {
		
		if (!readable || rect == null) return byteArray = null;
		if (byteArray == null) byteArray = new ByteArray();
		
		var image = this.image;
		
		if (!rect.equals (this.rect)) {
			
			var matrix = Matrix.__pool.get ();
			matrix.tx = Math.round (-rect.x);
			matrix.ty = Math.round (-rect.y);
			
			var bitmapData = new BitmapData (Math.ceil (rect.width), Math.ceil (rect.height), true, 0);
			bitmapData.draw (this, matrix);
			
			image = bitmapData.image;
			
			Matrix.__pool.release (matrix);
			
		}
		
		if (Std.is (compressor, PNGEncoderOptions)) {
			
			byteArray.writeBytes (ByteArray.fromBytes (image.encode ("png")));
			return byteArray;
			
		} else if (Std.is (compressor, JPEGEncoderOptions)) {
			
			byteArray.writeBytes (ByteArray.fromBytes (image.encode ("jpg", cast (compressor, JPEGEncoderOptions).quality)));
			return byteArray;
			
		}
		
		return byteArray = null;
		
	}
	
	
	public function fillRect (rect:Rectangle, color:Int):Void {
		
		if (rect == null) return;
		
		if (transparent && (color & 0xFF000000) == 0) {
			
			color = 0;
			
		}
		
		if (readable) {
			
			image.fillRect (rect.__toLimeRectangle (), color, ARGB32);
			
		} else if (__framebuffer != null) {
			
			var gl = GL.context;
			var color:ARGB = (color:ARGB);
			var useScissor = !this.rect.equals (rect);
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, __framebuffer);
			
			if (useScissor) {
				
				gl.enable (gl.SCISSOR_TEST);
				gl.scissor (Math.round (rect.x), Math.round (rect.y), Math.round (rect.width), Math.round (rect.height));
				
			}
			
			gl.clearColor (color.r / 0xFF, color.g / 0xFF, color.b / 0xFF, color.a / 0xFF);
			gl.clear (gl.COLOR_BUFFER_BIT);
			
			if (useScissor) {
				
				gl.disable (gl.SCISSOR_TEST);
				
			}
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, null);
			
		}
		
	}
	
	
	public function floodFill (x:Int, y:Int, color:Int):Void {
		
		if (!readable) return;
		image.floodFill (x, y, color, ARGB32);
		
	}
	
	
	public static function fromBase64 (base64:String, type:String):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true, 0);
		bitmapData.__fromBase64 (base64, type);
		return bitmapData;
		
	}
	
	
	public static function fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true, 0);
		bitmapData.__fromBytes (bytes, rawAlpha);
		return bitmapData;
		
	}
	
	
	#if (js && html5)
	public static function fromCanvas (canvas:CanvasElement, transparent:Bool = true):BitmapData {
		
		if (canvas == null) return null;
		
		var bitmapData = new BitmapData (0, 0, transparent, 0);
		bitmapData.__fromImage (Image.fromCanvas (canvas));
		bitmapData.image.transparent = transparent;
		return bitmapData;
		
	}
	#end
	
	
	public static function fromFile (path:String):BitmapData {
		
		var bitmapData = new BitmapData (0, 0, true, 0);
		bitmapData.__fromFile (path);
		return bitmapData;
		
	}
	
	
	public static function fromImage (image:Image, transparent:Bool = true):BitmapData {
		
		if (image == null || image.buffer == null) return null;
		
		var bitmapData = new BitmapData (0, 0, transparent, 0);
		bitmapData.__fromImage (image);
		bitmapData.image.transparent = transparent;
		return bitmapData;
		
	}
	
	
	public static function fromTexture (texture:TextureBase):BitmapData {
		
		if (texture == null) return null;
		
		var bitmapData = new BitmapData (texture.__width, texture.__height, true, 0);
		bitmapData.readable = false;
		bitmapData.__texture = texture.__textureID;
		bitmapData.__textureContext = texture.__textureContext;
		bitmapData.image = null;
		return bitmapData;
		
	}
	
	
	public function generateFilterRect (sourceRect:Rectangle, filter:BitmapFilter):Rectangle {
		
		return sourceRect.clone ();
		
	}
	
	
	public function getBuffer (gl:GLRenderContext, alpha:Float, colorTransform:ColorTransform):GLBuffer {
		
		if (__buffer == null || __bufferContext != gl) {
			
			#if openfl_power_of_two
			
			var newWidth = 1;
			var newHeight = 1;
			
			while (newWidth < width) {
				
				newWidth <<= 1;
				
			}
			
			while (newHeight < height) {
				
				newHeight <<= 1;
				
			}
			
			var uvWidth = width / newWidth;
			var uvHeight = height / newHeight;
			
			#else
			
			var uvWidth = 1;
			var uvHeight = 1;
			
			#end
			
			//__bufferData = new Float32Array ([
				//
				//width, height, 0, uvWidth, uvHeight, alpha, (color transform, color offset...)
				//0, height, 0, 0, uvHeight, alpha, (color transform, color offset...)
				//width, 0, 0, uvWidth, 0, alpha, (color transform, color offset...)
				//0, 0, 0, 0, 0, alpha, (color transform, color offset...)
				//
				//
			//]);
			
			//[ colorTransform.redMultiplier, 0, 0, 0, 0, colorTransform.greenMultiplier, 0, 0, 0, 0, colorTransform.blueMultiplier, 0, 0, 0, 0, colorTransform.alphaMultiplier ];
			//[ colorTransform.redOffset / 255, colorTransform.greenOffset / 255, colorTransform.blueOffset / 255, colorTransform.alphaOffset / 255 ]
			
			__bufferData = new Float32Array (__bufferStride * 4);
			
			__bufferData[0] = width;
			__bufferData[1] = height;
			__bufferData[3] = uvWidth;
			__bufferData[4] = uvHeight;
			__bufferData[__bufferStride + 1] = height;
			__bufferData[__bufferStride + 4] = uvHeight;
			__bufferData[__bufferStride * 2] = width;
			__bufferData[__bufferStride * 2 + 3] = uvWidth;
			
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
			//gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
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
	
	
	public function getColorBoundsRect (mask:Int, color:Int, findColor:Bool = true):Rectangle {
		
		if (!readable) return new Rectangle (0, 0, width, height);
		
		if (!transparent || ((mask >> 24) & 0xFF) > 0) {
			
			var color = (color:ARGB);
			if (color.a == 0) color = 0;
			
		}
		
		var rect = image.getColorBoundsRect (mask, color, findColor, ARGB32);
		return new Rectangle (rect.x, rect.y, rect.width, rect.height);
		
	}
	
	
	public function getPixel (x:Int, y:Int):Int {
		
		if (!readable) return 0;
		return image.getPixel (x, y, ARGB32);
		
	}
	
	
	public function getPixel32 (x:Int, y:Int):Int {
		
		if (!readable) return 0;
		return image.getPixel32 (x, y, ARGB32);
		
	}
	
	
	public function getPixels (rect:Rectangle):ByteArray {
		
		if (!readable) return null;
		if (rect == null) rect = this.rect;
		var byteArray = ByteArray.fromBytes (image.getPixels (rect.__toLimeRectangle (), ARGB32));
		// TODO: System endian order
		byteArray.endian = BIG_ENDIAN;
		return byteArray;
		
	}
	
	
	public function getSurface ():CairoImageSurface {
		
		if (!readable) return null;
		
		if (__surface == null) {
			
			
			__surface = CairoImageSurface.fromImage (image);
			
		}
		
		return __surface;
		
	}
	
	
	public function getTexture (gl:GLRenderContext):GLTexture {
		
		if (!__isValid) return null;
		
		if (__texture == null || __textureContext != gl) {
			
			__textureContext = gl;
			__texture = gl.createTexture ();
			
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.NEAREST);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.NEAREST);
			__textureVersion = -1;
			
		}
		
		#if (js && html5)
		ImageCanvasUtil.sync (image, false);
		#end
		
		if (image != null && image.version != __textureVersion) {
			
			var internalFormat, format;
			
			if (__surface != null) {
				
				__surface.flush ();
				
			}
			
			if (image.buffer.bitsPerPixel == 1) {
				
				internalFormat = gl.ALPHA;
				format = gl.ALPHA;
				
			} else {
				
				if (__supportsBGRA == null) {
					
					__textureInternalFormat = gl.RGBA;
					
					var bgraExtension = null;
					#if (!js || !html5)
					bgraExtension = gl.getExtension ("EXT_bgra");
					if (bgraExtension == null)
						bgraExtension = gl.getExtension ("EXT_texture_format_BGRA8888");
					if (bgraExtension == null)
						bgraExtension = gl.getExtension ("APPLE_texture_format_BGRA8888");
					#end
					
					if (bgraExtension != null) {
						
						__supportsBGRA = true;
						__textureFormat = bgraExtension.BGRA_EXT;
						
						#if (!ios && !tvos)
						if (gl.type == GLES) {
							
							__textureInternalFormat = bgraExtension.BGRA_EXT;
							
						}
						#end
						
					} else {
						
						__supportsBGRA = false;
						__textureFormat = gl.RGBA;
						
					}
					
				}
				
				internalFormat = __textureInternalFormat;
				format = __textureFormat;
				
			}
			
			gl.bindTexture (gl.TEXTURE_2D, __texture);
			
			var textureImage = image;
			
			#if (js && html5)
			
			if (textureImage.type != DATA && !textureImage.premultiplied) {
				
				gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
				
			} else if (!textureImage.premultiplied && textureImage.transparent) {
				
				gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
				//gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);
				//textureImage = textureImage.clone ();
				//textureImage.premultiplied = true;
				
			}
			
			// TODO: Some way to support BGRA on WebGL?
			
			if (!__supportsBGRA && textureImage.format != RGBA32) {
				
				textureImage = textureImage.clone ();
				textureImage.format = RGBA32;
				//textureImage.buffer.premultiplied = true;
				#if openfl_power_of_two
				textureImage.powerOfTwo = true;
				#end
				
			}
			
			if (textureImage.type == DATA) {
				
				gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, textureImage.buffer.width, textureImage.buffer.height, 0, format, gl.UNSIGNED_BYTE, textureImage.data);
				
			} else {
				
				(gl:WebGLContext).texImage2D (gl.TEXTURE_2D, 0, internalFormat, format, gl.UNSIGNED_BYTE, textureImage.src);
				
			}
			
			#else
			
			if (#if openfl_power_of_two !textureImage.powerOfTwo || #end (!textureImage.premultiplied && textureImage.transparent)) {
				
				textureImage = textureImage.clone ();
				textureImage.premultiplied = true;
				#if openfl_power_of_two
				textureImage.powerOfTwo = true;
				#end
				
			}
			
			gl.texImage2D (gl.TEXTURE_2D, 0, internalFormat, textureImage.buffer.width, textureImage.buffer.height, 0, format, gl.UNSIGNED_BYTE, textureImage.data);
			
			#end
			
			gl.bindTexture (gl.TEXTURE_2D, null);
			__textureVersion = image.version;
			
		}
		
		if (!readable && image != null) {
			
			__surface = null;
			image = null;
			
		}
		
		return __texture;
		
	}
	
	
	public function getVector (rect:Rectangle) {
		
		var pixels = getPixels (rect);
		var length = Std.int (pixels.length / 4);
		var result = new Vector<UInt> (length, true);
		
		for (i in 0...length) {
			
			result[i] = pixels.readUnsignedInt ();
			
		}
		
		return result;
		
	}
	
	
	public function histogram (hRect:Rectangle = null) {
		
		var rect = hRect != null ? hRect : new Rectangle (0, 0, width, height);
		var pixels = getPixels (rect);
		var result = [for (i in 0...4) [for (j in 0...256) 0]];
		
		for (i in 0...pixels.length) {
			
			++result[i % 4][pixels.readUnsignedByte ()];
			
		}
		
		return result;
		
	}
	
	
	public function hitTest (firstPoint:Point, firstAlphaThreshold:Int, secondObject:Object, secondBitmapDataPoint:Point = null, secondAlphaThreshold:Int = 1):Bool {
		
		if (!readable) return false;
		
		// #if !openfljs
		if (Std.is (secondObject, Bitmap)) {
			
			secondObject = cast (secondObject, Bitmap).__bitmapData;
			
		}
		// #end
		
		if (Std.is (secondObject, Point)) {
			
			var secondPoint:Point = cast secondObject;
			
			var x = Std.int (secondPoint.x - firstPoint.x);
			var y = Std.int (secondPoint.y - firstPoint.y);
			
			if (rect.contains (x, y)) {
				
				var pixel = getPixel32 (x, y);
				
				if ((pixel >> 24) & 0xFF > firstAlphaThreshold) {
					
					return true;
					
				}
				
			}
			
		} else if (Std.is (secondObject, BitmapData)) {
			
			var secondBitmapData:BitmapData = cast secondObject;
			var x, y;
			
			if (secondBitmapDataPoint == null) {
				
				x = 0;
				y = 0;
				
			} else {
				
				x = Std.int (secondBitmapDataPoint.x - firstPoint.x);
				y = Std.int (secondBitmapDataPoint.y - firstPoint.y);
				
			}
			
			if (rect.contains (x, y)) {
				
				var hitRect = Rectangle.__pool.get ();
				hitRect.setTo (x, y, Math.min (secondBitmapData.width, width - x), Math.min (secondBitmapData.height, height - y));
				
				var pixels = getPixels (hitRect);
				
				hitRect.offset (-x, -y);
				var testPixels = secondBitmapData.getPixels (hitRect);
				
				var length = Std.int (hitRect.width * hitRect.height);
				var pixel, testPixel;
				
				Rectangle.__pool.release (hitRect);
				
				for (i in 0...length) {
					
					pixel = pixels.readUnsignedInt ();
					testPixel = testPixels.readUnsignedInt ();
					
					if ((pixel >> 24) & 0xFF > firstAlphaThreshold && (testPixel >> 24) & 0xFF > secondAlphaThreshold) {
						
						return true;
						
					}
					
				}
				
				return false;
				
			}
			
		} else if (Std.is (secondObject, Rectangle)) {
			
			var secondRectangle = Rectangle.__pool.get ();
			secondRectangle.copyFrom (cast secondObject);
			secondRectangle.offset (-firstPoint.x, -firstPoint.y);
			secondRectangle.__contract (0, 0, width, height);
			
			if (secondRectangle.width > 0 && secondRectangle.height > 0) {
				
				var pixels = getPixels (secondRectangle);
				var length = Std.int (pixels.length / 4);
				var pixel;
				
				for (i in 0...length) {
					
					pixel = pixels.readUnsignedInt ();
					
					if ((pixel >> 24) & 0xFF > firstAlphaThreshold) {
						
						Rectangle.__pool.release (secondRectangle);
						return true;
						
					}
					
				}
				
			}
			
			Rectangle.__pool.release (secondRectangle);
			
		}
		
		return false;
		
	}
	
	
	public static function loadFromBase64 (base64:String, type:String):Future<BitmapData> {
		
		return Image.loadFromBase64 (base64, type).then (function (image) {
			
			return Future.withValue (BitmapData.fromImage (image));
			
		});
		
	}
	
	
	public static function loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData> {
		
		return Image.loadFromBytes (bytes).then (function (image) {
			
			var bitmapData = BitmapData.fromImage (image);
			
			if (rawAlpha != null) {
				
				bitmapData.__applyAlpha (rawAlpha);
				
			}
			
			return Future.withValue (bitmapData);
			
		});
		
	}
	
	
	public static function loadFromFile (path:String):Future<BitmapData> {
		
		return Image.loadFromFile (path).then (function (image) {
			
			return Future.withValue (BitmapData.fromImage (image));
			
		});
		
	}
	
	
	public function lock ():Void {
		
		
		
	}
	
	
	public function merge (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redMultiplier:UInt, greenMultiplier:UInt, blueMultiplier:UInt, alphaMultiplier:UInt):Void {
		
		if (!readable || sourceBitmapData == null || !sourceBitmapData.readable || sourceRect == null || destPoint == null) return;
		image.merge (sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier);
		
	}
	
	
	public function noise (randomSeed:Int, low:Int = 0, high:Int = 255, channelOptions:Int = 7, grayScale:Bool = false):Void {
		
		if (!readable) return;
		
		//Seeded Random Number Generator
		var rand:Void->Int = {
			function func():Int 
			{	
				randomSeed = randomSeed * 1103515245 + 12345; 
				return Std.int(Math.abs(randomSeed / 65536)) % 32768; 
			}
		};
		rand();
		
		//Range of values to value to.
		var range:Int = high - low;
		var data:ByteArray = new ByteArray();
		
		var redChannel:Bool = ((channelOptions & ( 1 << 0 )) >> 0) == 1;
		var greenChannel:Bool = ((channelOptions & ( 1 << 1 )) >> 1) == 1;
		var blueChannel:Bool = ((channelOptions & ( 1 << 2 )) >> 2) == 1;
		var alphaChannel:Bool = ((channelOptions & ( 1 << 3 )) >> 3) == 1;
		
		for (y in 0...height)
		{
			for (x in 0...width)
			{
				//Default channel colours if all channel options are false.
				var red:Int = 0;
				var blue:Int = 0;
				var green:Int = 0;
				var alpha:Int = 255;
				
				if (grayScale)
				{
					red = green = blue = low + (rand() % range);
					alpha = 255;
				}
				else
				{
					if (redChannel) red = low + (rand() % range);
					if (greenChannel) green = low + (rand() % range);
					if (blueChannel) blue = low + (rand() % range);
					if (alphaChannel) alpha = low + (rand() % range);
				}
				
				var rgb:Int = alpha;
				rgb = (rgb << 8) + red;
				rgb = (rgb << 8) + green;
				rgb = (rgb << 8) + blue;
				
				setPixel32(x, y, rgb);
			}
		}
		
	}
	
	
	public function paletteMap (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, redArray:Array<Int> = null, greenArray:Array<Int> = null, blueArray:Array<Int> = null, alphaArray:Array<Int> = null):Void {
		
		var sw:Int = Std.int (sourceRect.width);
		var sh:Int = Std.int (sourceRect.height);
		
		var pixels = sourceBitmapData.getPixels (sourceRect);
		
		var pixelValue:Int, r:Int, g:Int, b:Int, a:Int, color:Int;
		
		for (i in 0...(sh * sw)) {
			
			pixelValue = pixels.readUnsignedInt();
			
			a = (alphaArray == null) ? pixelValue & 0xFF000000 : alphaArray[(pixelValue >> 24) & 0xFF];
			r = (redArray == null) ? pixelValue & 0x00FF0000 : redArray[(pixelValue >> 16) & 0xFF];
			g = (greenArray == null) ? pixelValue & 0x0000FF00 : greenArray[(pixelValue >> 8) & 0xFF];
			b = (blueArray == null) ? pixelValue & 0x000000FF : blueArray[(pixelValue) & 0xFF];
			
			color = a + r + g + b;
			
			pixels.position = i * 4;
			pixels.writeUnsignedInt(color);
			
		}
		
		pixels.position = 0;
		var destRect = Rectangle.__pool.get ();
		destRect.setTo (destPoint.x, destPoint.y, sw, sh);
		setPixels (destRect, pixels);
		Rectangle.__pool.release (destRect);
		
	}
	
	
	public function perlinNoise (baseX:Float, baseY:Float, numOctaves:UInt, randomSeed:Int, stitch:Bool, fractalNoise:Bool, channelOptions:UInt = 7, grayScale:Bool = false, offsets:Array<Point> = null):Void {
		
		if (!readable) return;
		var noise = new PerlinNoise (randomSeed, numOctaves, 0.01);
		noise.fill (this, baseX, baseY, 0);
		
	}
	
	
	public function scroll (x:Int, y:Int):Void {
		
		if (!readable) return;
		image.scroll (x, y);
		
	}
	
	
	public function setPixel (x:Int, y:Int, color:Int):Void {
		
		if (!readable) return;
		image.setPixel (x, y, color, ARGB32);
		
	}
	
	
	public function setPixel32 (x:Int, y:Int, color:Int):Void {
		
		if (!readable) return;
		image.setPixel32 (x, y, color, ARGB32);
		
	}
	
	
	public function setPixels (rect:Rectangle, byteArray:ByteArray):Void {
		
		if (!readable || rect == null) return;
		
		var length = (rect.width * rect.height * 4);
		if (byteArray.bytesAvailable < length) throw new Error ("End of file was encountered.", 2030);
		
		image.setPixels (rect.__toLimeRectangle (), byteArray, ARGB32, byteArray.endian);
		
	}
	
	
	public function setVector (rect:Rectangle, inputVector:Vector<UInt>) {
		
		var byteArray = new ByteArray ();
		byteArray.length = inputVector.length * 4;
		
		for (color in inputVector) {
			
			byteArray.writeUnsignedInt (color);
			
		}
		
		byteArray.position = 0;
		setPixels (rect, byteArray);
		
	}
	
	
	public function threshold (sourceBitmapData:BitmapData, sourceRect:Rectangle, destPoint:Point, operation:String, threshold:Int, color:Int = 0x00000000, mask:Int = 0xFFFFFFFF, copySource:Bool = false):Int {
		
		if (sourceBitmapData == null || sourceRect == null || destPoint == null || sourceRect.x > sourceBitmapData.width || sourceRect.y > sourceBitmapData.height || destPoint.x > width || destPoint.y > height) return 0;
		
		return image.threshold (sourceBitmapData.image, sourceRect.__toLimeRectangle (), destPoint.__toLimeVector2 (), operation, threshold, color, mask, copySource, ARGB32);
		
	}
	
	
	public function unlock (changeRect:Rectangle = null):Void {
		
		
		
	}
	
	
	private function __applyAlpha (alpha:ByteArray):Void {
		
		#if (js && html5)
		ImageCanvasUtil.convertToCanvas (image);
		ImageCanvasUtil.createImageData (image);
		#end
		
		var data = image.buffer.data;
		
		for (i in 0...alpha.length) {
			
			data[i * 4 + 3] = alpha.readUnsignedByte ();
			
		}
		
		image.version++;
		
	}
	
	
	private function __draw (source:IBitmapDrawable, matrix:Matrix = null, colorTransform:ColorTransform = null, blendMode:BlendMode = null, clipRect:Rectangle = null, smoothing:Bool = false):Void {
		
		if (matrix == null) {
			
			matrix = new Matrix ();
			
			if (source.__transform != null) {
				
				matrix.copyFrom (source.__transform);
				matrix.tx = 0;
				matrix.ty = 0;
				
			}
			
		}
		
		if (!readable /*|| !source.readable*/) {
			
			if (GL.context != null) {
				
				var gl = GL.context;
				
				gl.bindFramebuffer (gl.FRAMEBUFFER, __getFramebuffer (gl));
				gl.viewport (0, 0, width, height);
				
				var renderer = new GLRenderer (null, gl, this);
				
				var renderSession = renderer.renderSession;
				renderSession.clearRenderDirty = true;
				renderSession.shaderManager = cast (null, GLRenderer).renderSession.shaderManager;
				
				var matrixCache = source.__worldTransform;
				source.__updateTransforms (matrix);
				source.__updateChildren (false);
				source.__renderGL (renderer.renderSession);
				source.__updateTransforms (matrixCache);
				source.__updateChildren (true);
				
				gl.bindFramebuffer (gl.FRAMEBUFFER, null);
				
			}
			
		} else {
			
			#if (js && html5)
			
			if (colorTransform != null) {
				
				var bounds = Rectangle.__pool.get ();
				var boundsMatrix = Matrix.__pool.get ();
				
				source.__getBounds (bounds, boundsMatrix);
				
				var width:Int = Math.ceil (bounds.width);
				var height:Int = Math.ceil (bounds.height);
				
				var copy = new BitmapData (width, height, true, 0);
				copy.draw (source);
				copy.colorTransform (copy.rect, colorTransform);
				source = copy;
				
				Rectangle.__pool.release (bounds);
				Matrix.__pool.release (boundsMatrix);
				
			}
			
			ImageCanvasUtil.convertToCanvas (image);
			
			var buffer = image.buffer;
			
			var renderSession = new RenderSession ();
			renderSession.renderType = CANVAS;
			// renderSession.lockTransform = true;
			renderSession.clearRenderDirty = true;
			renderSession.context = cast buffer.__srcContext;
			renderSession.allowSmoothing = smoothing;
			//renderSession.roundPixels = true;
			renderSession.maskManager = new CanvasMaskManager (renderSession);
			renderSession.blendModeManager = new CanvasBlendModeManager (renderSession);
			
			if (!smoothing) {
				
				untyped (buffer.__srcContext).mozImageSmoothingEnabled = false;
				//untyped (buffer.__srcContext).webkitImageSmoothingEnabled = false;
				untyped (buffer.__srcContext).msImageSmoothingEnabled = false;
				untyped (buffer.__srcContext).imageSmoothingEnabled = false;
				
			}
			
			if (clipRect != null) {
				
				renderSession.maskManager.pushRect (clipRect, new Matrix ());
				
			}
			
			var matrixCache = source.__worldTransform;
			source.__updateTransforms (matrix);
			source.__updateChildren (false);
			
			var cacheRenderable = source.__renderable;
			if (source.__isMask) {
				
				source.__renderable = true;
				
			}
			
			var cacheAlpha = source.__worldAlpha;
 			source.__worldAlpha = 1;
 			
			source.__renderCanvas (renderSession);
			source.__renderable = cacheRenderable;
			source.__worldAlpha = cacheAlpha;
			
			source.__updateTransforms (matrixCache);
			source.__updateChildren (true);
			
			if (!smoothing) {
				
				untyped (buffer.__srcContext).mozImageSmoothingEnabled = true;
				//untyped (buffer.__srcContext).webkitImageSmoothingEnabled = true;
				untyped (buffer.__srcContext).msImageSmoothingEnabled = true;
				untyped (buffer.__srcContext).imageSmoothingEnabled = true;
				
			}
			
			if (clipRect != null) {
				
				renderSession.maskManager.popRect ();
				
			}
			
			buffer.__srcContext.setTransform (1, 0, 0, 1, 0, 0);
			buffer.__srcImageData = null;
			buffer.data = null;
			
			image.dirty = true;
			image.version++;
			
			#elseif lime_cairo
			
			if (source == this) {
				
				source = clone ();
				
			}
			
			if (colorTransform != null) {
				
				var bounds = Rectangle.__pool.get ();
				var boundsMatrix = Matrix.__pool.get ();
				
				source.__getBounds (bounds, boundsMatrix);
				
				var width:Int = Math.ceil (bounds.width);
				var height:Int = Math.ceil (bounds.height);
				
				var copy = new BitmapData (width, height, true, 0);
				copy.draw (source);
				copy.colorTransform (copy.rect, colorTransform);
				source = copy;
				
				Rectangle.__pool.release (bounds);
				Matrix.__pool.release (boundsMatrix);
				
			}
			
			var surface = getSurface ();
			var cairo = new Cairo (surface);
			
			if (!smoothing) {
				
				cairo.antialias = NONE;
				
			}
			
			var renderSession = new RenderSession ();
			renderSession.renderType = CAIRO;
			// renderSession.lockTransform = true;
			renderSession.clearRenderDirty = true;
			renderSession.cairo = cairo;
			renderSession.allowSmoothing = smoothing;
			//renderSession.roundPixels = true;
			renderSession.maskManager = new CairoMaskManager (renderSession);
			renderSession.blendModeManager = new CairoBlendModeManager (renderSession);
			
			if (clipRect != null) {
				
				renderSession.maskManager.pushRect (clipRect, new Matrix ());
				
			}
			
			var matrixCache = source.__worldTransform;
			source.__updateTransforms (matrix);
			source.__updateChildren (false);
			
			// TODO: Force renderable using render session?
			
			var cacheRenderable = source.__renderable;
			if (source.__isMask) {
				
				source.__renderable = true;
				
			}
			
			var cacheAlpha = source.__worldAlpha;
 			source.__worldAlpha = 1;
 			
			source.__renderCairo (renderSession);
			source.__renderable = cacheRenderable;
			source.__worldAlpha = cacheAlpha;
			
			source.__updateTransforms (matrixCache);
			source.__updateChildren (true);
			
			if (clipRect != null) {
				
				renderSession.maskManager.popRect ();
				
			}
			
			surface.flush ();
			
			image.dirty = true;
			image.version++;
			
			#end
			
		}
		
	}
	
	
	private inline function __fromBase64 (base64:String, type:String):Void {
		
		var image = Image.fromBase64 (base64, type);
		__fromImage (image);
		
	}
	
	
	private inline function __fromBytes (bytes:ByteArray, rawAlpha:ByteArray = null):Void {
		
		var image = Image.fromBytes (bytes);
		__fromImage (image);
		
		if (rawAlpha != null) {
			
			__applyAlpha (rawAlpha);
			
		}
		
	}
	
	
	private function __fromFile (path:String):Void {
		
		var image = Image.fromFile (path);
		__fromImage (image);
		
	}
	
	
	private function __fromImage (image:Image):Void {
		
		if (image != null && image.buffer != null) {
			
			this.image = image;
			
			width = image.width;
			height = image.height;
			rect = new Rectangle (0, 0, image.width, image.height);
			
			#if sys
			image.format = BGRA32;
			image.premultiplied = true;
			#end
			
			readable = true;
			__isValid = true;
			
		}
		
	}
	
	
	private function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		var bounds = Rectangle.__pool.get ();
		this.rect.__transform (bounds, matrix);
		rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
		Rectangle.__pool.release (bounds);
		
	}
	
	
	private function __getFramebuffer (gl:GLRenderContext):GLFramebuffer {
		
		if (__framebuffer == null || __framebufferContext != gl) {
			
			getTexture (gl);
			
			__framebufferContext = gl;
			__framebuffer = gl.createFramebuffer ();
			
			gl.bindFramebuffer (gl.FRAMEBUFFER, __framebuffer);
			gl.framebufferTexture2D (gl.FRAMEBUFFER, gl.COLOR_ATTACHMENT0, gl.TEXTURE_2D, __texture, 0);
			
		}
		
		return __framebuffer;
		
	}
	
	
	private inline function __loadFromBase64 (base64:String, type:String):Future<BitmapData> {
		
		return Image.loadFromBase64 (base64, type).then (function (image) {
			
			__fromImage (image);
			return Future.withValue (this);
			
		});
		
	}
	
	
	private inline function __loadFromBytes (bytes:ByteArray, rawAlpha:ByteArray = null):Future<BitmapData> {
		
		return Image.loadFromBytes (bytes).then (function (image) {
			
			__fromImage (image);
			
			if (rawAlpha != null) {
				
				__applyAlpha (rawAlpha);
				
			}
			
			return Future.withValue (this);
			
		});
		
	}
	
	
	private function __loadFromFile (path:String):Future<BitmapData> {
		
		return Image.loadFromFile (path).then (function (image) {
			
			__fromImage (image);
			return Future.withValue (this);
			
		});
		
	}
	
	
	private function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		if (!readable) return;
		
		var cairo = renderSession.cairo;
		
		if (__worldTransform == null) __worldTransform = new Matrix ();
		
		var transform = __worldTransform;
		
		if (renderSession.roundPixels) {
			
			var matrix = transform.__toMatrix3 ();
			matrix.tx = Math.round (matrix.tx);
			matrix.ty = Math.round (matrix.ty);
			cairo.matrix = matrix;
			
		} else {
			
			cairo.matrix = transform.__toMatrix3 ();
			
		}
		
		var surface = getSurface ();
		
		if (surface != null) {
			
			var pattern = CairoPattern.createForSurface (surface);
			
			if (!renderSession.allowSmoothing || cairo.antialias == NONE) {
				
				pattern.filter = CairoFilter.NEAREST;
				
			} else {
				
				pattern.filter = CairoFilter.GOOD;
				
			}
			
			cairo.source = pattern;
			cairo.paint ();
			
		}
		#end
		
	}
	
	
	private function __renderCairoMask (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	private function __renderCanvas (renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (!readable) return;
		
		if (image.type == DATA) {
			
			ImageCanvasUtil.convertToCanvas (image);
			
		}
		
		var context = renderSession.context;
		
		if (__worldTransform == null) __worldTransform = new Matrix ();
		
		context.globalAlpha = 1;
		var transform = __worldTransform;
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
		context.drawImage (image.src, 0, 0);
		#end
		
	}
	
	
	private function __renderCanvasMask (renderSession:RenderSession):Void {
		
		
		
	}
	
	
	private function __renderGL (renderSession:RenderSession):Void {
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl = renderSession.gl;
		
		renderSession.blendModeManager.setBlendMode (NORMAL);
		
		var shader = renderSession.shaderManager.defaultShader;
		
		shader.data.uImage0.input = this;
		shader.data.uImage0.smoothing = renderSession.allowSmoothing && (renderSession.upscaled);
		shader.data.uMatrix.value = renderer.getMatrix (__worldTransform);
		
		renderSession.shaderManager.setShader (shader);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, getBuffer (gl, 1, __worldColorTransform));
		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		gl.vertexAttribPointer (shader.data.aAlpha.index, 1, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE);
		#end
		
	}
	
	
	private function __renderGLMask (renderSession:RenderSession):Void {
		
		var renderer:GLRenderer = cast renderSession.renderer;
		var gl = renderSession.gl;
		
		var shader = GLMaskManager.maskShader;
		
		shader.data.uImage0.input = this;
		shader.data.uImage0.smoothing = renderSession.allowSmoothing && (renderSession.upscaled);
		shader.data.uMatrix.value = renderer.getMatrix (__worldTransform);
		
		renderSession.shaderManager.setShader (shader);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, getBuffer (gl, 1, __worldColorTransform));
		gl.vertexAttribPointer (shader.data.aPosition.index, 3, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 0);
		gl.vertexAttribPointer (shader.data.aTexCoord.index, 2, gl.FLOAT, false, 6 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		#if gl_stats
			GLStats.incrementDrawCall (DrawCallContext.STAGE);
		#end
		
	}
	
	
	function __resize (width:Int, height:Int) {
		
		this.width = width;
		this.height = height;
		this.rect.width = width;
		this.rect.height = height;
		
	}
	
	
	private function __sync ():Void {
		
		#if (js && html5)
		ImageCanvasUtil.sync (image, false);
		#end
		
	}
	
	
	public function __updateChildren (transformOnly:Bool):Void {
		
		
		
	}
	
	
	public function __updateMask (maskGraphics:Graphics):Void {
		
		
		
	}
	
	
	public function __updateTransforms (overrideTransform:Matrix = null):Void {
		
		if (overrideTransform == null) {
			
			__worldTransform.identity ();
			
		} else {
			
			__worldTransform = overrideTransform;
			
		}
		
	}
	
	
}
