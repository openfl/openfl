package openfl.display;


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
		
		if (__commands == null) {
			
			__commands = new RenderCommands ();
			
			var element = new RenderElement ();
			element.count = 0;
			//element.type = RenderType.TRIANGLES;
			element.vertexOffset = 0;
			element.textureOffset = 2;
			element.stride = 4;
			
		}
		
		/*
		var element = __commands.elements[0];
		element.surface = bitmapData.getSurface ();
		
		UserPoint corners[4];
      UserPoint tex[4];
      for(int i=0;i<4;i++)
      {
         corners[i] =  UserPoint(inX + ((i&1)?inSrc.w:0), inY + ((i>1)?inSrc.h:0) ); 
         tex[i] = mBitmapTexture->PixelToTex(UserPoint(inSrc.x + ((i&1)?inSrc.w:0), inSrc.y + ((i>1)?inSrc.h:0) )); 
      }
      *p++ = corners[0];
      *p++ = tex[0];
      *p++ = corners[1];
      *p++ = tex[1];
      *p++ = corners[2];
      *p++ = tex[2];

      *p++ = corners[1];
      *p++ = tex[1];
      *p++ = corners[2];
      *p++ = tex[2];
      *p++ = corners[3];
      *p++ = tex[3];
		
		
		
		mBitmapBuffer.mArray.resize(0);
      mBitmapBuffer.mRendersWithoutVbo = -999;
      DrawElement &e = mBitmapBuffer.mElements[0];
      e.mCount = 0;

      e.mColour = inTint;
      if (e.mSurface)
         e.mSurface->DecRef();

      e.mSurface = inSurface;

      e.mSurface->IncRef();
      e.mFlags = (e.mFlags & ~(DRAW_BMP_REPEAT|DRAW_BMP_SMOOTH) );
      if (inRepeat)
         e.mFlags |= DRAW_BMP_REPEAT;
      if (inSmooth)
         e.mFlags |= DRAW_BMP_SMOOTH;

      mBitmapTexture = inSurface-> GetTexture(this);
	  
	  
	  
	  DrawElement &e = mBitmapBuffer.mElements[0];
      mBitmapBuffer.mArray.resize( (e.mCount+6) * e.mStride );
      UserPoint *p = (UserPoint *)&mBitmapBuffer.mArray[e.mCount*e.mStride];
      e.mCount+=6;
      
      UserPoint corners[4];
      UserPoint tex[4];
      for(int i=0;i<4;i++)
      {
         corners[i] =  UserPoint(inX + ((i&1)?inSrc.w:0), inY + ((i>1)?inSrc.h:0) ); 
         tex[i] = mBitmapTexture->PixelToTex(UserPoint(inSrc.x + ((i&1)?inSrc.w:0), inSrc.y + ((i>1)?inSrc.h:0) )); 
      }
      *p++ = corners[0];
      *p++ = tex[0];
      *p++ = corners[1];
      *p++ = tex[1];
      *p++ = corners[2];
      *p++ = tex[2];

      *p++ = corners[1];
      *p++ = tex[1];
      *p++ = corners[2];
      *p++ = tex[2];
      *p++ = corners[3];
      *p++ = tex[3];
	  
	  
	  DrawElement &e = mBitmapBuffer.mElements[0];

      if (e.mCount)
      {
         RenderData(mBitmapBuffer,0,mBitmapTrans);
         e.mCount = 0;
      }

      if (e.mSurface)
      {
         e.mSurface->DecRef();
         e.mSurface = 0;
      }
      mBitmapBuffer.mArray.resize(0);
      mBitmapTexture = 0;
		*/
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