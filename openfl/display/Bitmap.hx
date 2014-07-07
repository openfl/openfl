package openfl.display; #if !flash


import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if js
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;
import js.html.CSSStyleDeclaration;
import js.html.ImageElement;
import js.Browser;
#end


@:access(openfl.display.BitmapData)
class Bitmap extends DisplayObjectContainer {
	
	
	public var bitmapData:BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	
	#if js
	private var __canvas:CanvasElement;
	private var __canvasContext:CanvasRenderingContext2D;
	private var __image:ImageElement;
	#else
	private var __canvas:Dynamic;
	private var __canvasContext:Dynamic;
	private var __image:Dynamic;
	#end
	private var __glMatrix:lime.geom.Matrix4;
	
	private var vertexBuffer:lime.graphics.GLBuffer;
	private var texCoordBuffer:lime.graphics.GLBuffer;
	
	
	public function new (bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false) {
		
		super ();
		
		this.bitmapData = bitmapData;
		this.pixelSnapping = pixelSnapping;
		this.smoothing = smoothing;
		
		if (pixelSnapping == null) {
			
			this.pixelSnapping = PixelSnapping.AUTO;
			
		}
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (bitmapData != null) {
			
			var bounds = new Rectangle (0, 0, bitmapData.width, bitmapData.height);
			bounds = bounds.transform (__worldTransform);
			
			rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool):Bool {
		
		if (!visible || bitmapData == null) return false;
		
		var point = globalToLocal (new Point (x, y));
		
		if (point.x > 0 && point.y > 0 && point.x <= bitmapData.width && point.y <= bitmapData.height) {
			
			if (stack != null) {
				
				stack.push (this);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	public override function __renderCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (!__renderable || __worldAlpha <= 0) return;
		
		var context = renderSession.context;
		
		if (bitmapData != null && bitmapData.__valid) {
			
			if (__mask != null) {
				
				renderSession.maskManager.pushMask (__mask);
				
			}
			
			bitmapData.__syncImageData ();
			
			context.globalAlpha = __worldAlpha;
			var transform = __worldTransform;
			
			if (renderSession.roundPixels) {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
				
			} else {
				
				context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = false;
				untyped (context).webkitImageSmoothingEnabled = false;
				context.imageSmoothingEnabled = false;
				
			}
			
			if (scrollRect == null) {
				
				if (bitmapData.__sourceImage != null) {
					
					context.drawImage (bitmapData.__sourceImage, 0, 0);
					
				} else {
					
					context.drawImage (bitmapData.__sourceCanvas, 0, 0);
					
				}
				
			} else {
				
				if (bitmapData.__sourceImage != null) {
					
					context.drawImage (bitmapData.__sourceImage, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
					
				} else {
					
					context.drawImage (bitmapData.__sourceCanvas, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height, scrollRect.x, scrollRect.y, scrollRect.width, scrollRect.height);
					
				}
				
			}
			
			if (!smoothing) {
				
				untyped (context).mozImageSmoothingEnabled = true;
				untyped (context).webkitImageSmoothingEnabled = true;
				context.imageSmoothingEnabled = true;
				
			}
			
			if (__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
		}
		#end
		
	}
	
	
	public override function __renderDOM (renderSession:RenderSession):Void {
		
		#if js
		if (stage != null && __worldVisible && __renderable && bitmapData != null && bitmapData.__valid) {
			
			if (bitmapData.__sourceImage != null) {
				
				__renderDOMImage (renderSession);
				
			} else {
				
				__renderDOMCanvas (renderSession);
				
			}
			
		} else {
			
			if (__image != null) {
				
				renderSession.element.removeChild (__image);
				__image = null;
				__style = null;
				
			}
			
			if (__canvas != null) {
				
				renderSession.element.removeChild (__canvas);
				__canvas = null;
				__style = null;
				
			}
			
		}
		#end
		
	}
	
	
	private function __renderDOMCanvas (renderSession:RenderSession):Void {
		
		#if js
		if (__image != null) {
			
			renderSession.element.removeChild (__image);
			__image = null;
			
		}
		
		if (__canvas == null) {
			
			__canvas = cast Browser.document.createElement ("canvas");	
			__canvasContext = __canvas.getContext ("2d");
			
			if (!smoothing) {
				
				untyped (__canvasContext).mozImageSmoothingEnabled = false;
				untyped (__canvasContext).webkitImageSmoothingEnabled = false;
				__canvasContext.imageSmoothingEnabled = false;
				
			}
			
			__initializeElement (__canvas, renderSession);
			
		}
		
		bitmapData.__syncImageData ();
		
		__canvas.width = bitmapData.width;
		__canvas.height = bitmapData.height;
		
		__canvasContext.globalAlpha = __worldAlpha;
		__canvasContext.drawImage (bitmapData.__sourceCanvas, 0, 0);
		
		__applyStyle (renderSession, true, false, true);
		#end
		
	}
	
	
	private function __renderDOMImage (renderSession:RenderSession):Void {
		
		#if js
		if (__canvas != null) {
			
			renderSession.element.removeChild (__canvas);
			__canvas = null;
			
		}
		
		if (__image == null) {
			
			__image = cast Browser.document.createElement ("img");
			__image.src = bitmapData.__sourceImage.src;
			__initializeElement (__image, renderSession);
			
		}
		
		__applyStyle (renderSession, true, true, true);
		#end
		
	}
	
	
	public override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable || __worldAlpha <= 0) return;
		
		var gl = renderSession.gl;
		
		if (vertexBuffer == null) {
			
			var vertices = [
				
				bitmapData.width, bitmapData.height, 0,
				0, bitmapData.height, 0,
				bitmapData.width, 0, 0,
				0, 0, 0
				
			];
			
			vertexBuffer = gl.createBuffer ();
			gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
			gl.bufferData (gl.ARRAY_BUFFER, new lime.utils.Float32Array (cast vertices), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
			var texCoords = [
				
				1, 1, 
				0, 1, 
				1, 0, 
				0, 0, 
				
			];
			
			texCoordBuffer = gl.createBuffer ();
			gl.bindBuffer (gl.ARRAY_BUFFER, texCoordBuffer);	
			gl.bufferData (gl.ARRAY_BUFFER, new lime.utils.Float32Array (cast texCoords), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
			__glMatrix = new lime.geom.Matrix4 ();
			
		}
		
		var texture = bitmapData.getTexture (gl);
		
		//__glMatrix = new lime.geom.Matrix4 ();
		__glMatrix.identity ();
		__glMatrix[0] = __worldTransform.a;
		__glMatrix[1] = __worldTransform.b;
		__glMatrix[4] = __worldTransform.c;
		__glMatrix[5] = __worldTransform.d;
		__glMatrix[12] = __worldTransform.tx;
		__glMatrix[13] = __worldTransform.ty;
		__glMatrix.append (renderSession.projectionMatrix);
		
		gl.activeTexture (gl.TEXTURE0);
		gl.bindTexture (gl.TEXTURE_2D, texture);
		
		#if desktop
		gl.enable (gl.TEXTURE_2D);
		#end
		
		gl.uniformMatrix4fv (renderSession.glProgram.matrixUniform, false, __glMatrix);
		gl.uniform1i (renderSession.glProgram.imageUniform, 0);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
		gl.vertexAttribPointer (renderSession.glProgram.vertexAttribute, 3, gl.FLOAT, false, 0, 0);
		gl.bindBuffer (gl.ARRAY_BUFFER, texCoordBuffer);
		gl.vertexAttribPointer (renderSession.glProgram.textureAttribute, 2, gl.FLOAT, false, 0, 0);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end
		
	}
	
	
	public override function __renderMask (renderSession:RenderSession):Void {
		
		renderSession.context.rect (0, 0, width, height);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private override function get_height ():Float {
		
		if (bitmapData != null) {
			
			return bitmapData.height * scaleY;
			
		}
		
		return 0;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (bitmapData != null) {
			
			if (value != bitmapData.height) {
				
				__setTransformDirty ();
				scaleY = value / bitmapData.height;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
	private override function get_width ():Float {
		
		if (bitmapData != null) {
			
			return bitmapData.width * scaleX;
			
		}
		
		return 0;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		if (bitmapData != null) {
			
			if (value != bitmapData.width) {
				
				__setTransformDirty ();
				scaleX = value / bitmapData.width;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
}


#else
typedef Bitmap = flash.display.Bitmap;
#end