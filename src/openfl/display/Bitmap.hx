package openfl.display;


import openfl._internal.renderer.cairo.CairoBitmap;
import openfl._internal.renderer.cairo.CairoDisplayObject;
import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.canvas.CanvasDisplayObject;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.dom.DOMDisplayObject;
import openfl._internal.renderer.opengl.GLBitmap;
import openfl._internal.renderer.opengl.GLDisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.ImageElement;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Rectangle)


class Bitmap extends DisplayObject {
	
	
	public var bitmapData (get, set):BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	
	#if (js && html5)
	private var __image:ImageElement;
	#end
	
	private var __bitmapData:BitmapData;
	private var __imageVersion:Int;
	
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Bitmap.prototype, "bitmapData", { get: untyped __js__ ("function () { return this.get_bitmapData (); }"), set: untyped __js__ ("function (v) { return this.set_bitmapData (v); }") });
		
	}
	#end
	
	
	public function new (bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false) {
		
		super ();
		
		__bitmapData = bitmapData;
		this.pixelSnapping = pixelSnapping;
		this.smoothing = smoothing;
		
		if (pixelSnapping == null) {
			
			this.pixelSnapping = PixelSnapping.AUTO;
			
		}
		
	}
	
	
	private override function __enterFrame (deltaTime:Int):Void {
		
		if (__bitmapData != null && __bitmapData.image != null && __bitmapData.image.version != __imageVersion) {
			
			__setRenderDirty ();
			
		}
		
	}
	
	
	private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__bitmapData != null) {
			
			var bounds = Rectangle.__pool.get ();
			bounds.setTo (0, 0, __bitmapData.width, __bitmapData.height);
			bounds.__transform (bounds, matrix);
			
			rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
			
			Rectangle.__pool.release (bounds);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask || __bitmapData == null) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height) {
			
			if (__scrollRect != null && !__scrollRect.contains (px, py)) {
				
				return false;
				
			}
			
			if (stack != null && !interactiveOnly) {
				
				stack.push (hitObject);
				
			}
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __hitTestMask (x:Float, y:Float):Bool {
		
		if (__bitmapData == null) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __renderCairo (renderer:CairoRenderer):Void {
		
		if (__bitmapData != null && __bitmapData.image != null) {
			
			__imageVersion = __bitmapData.image.version;
			
		}
		
		#if lime_cairo
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CairoDisplayObject.render (this, renderer);
			CairoBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		#end
		
	}
	
	
	private override function __renderCairoMask (renderer:CairoRenderer):Void {
		
		renderer.cairo.rectangle (0, 0, width, height);
		
	}
	
	
	private override function __renderCanvas (renderer:CanvasRenderer):Void {
		
		if (__bitmapData != null && __bitmapData.image != null) {
			
			__imageVersion = __bitmapData.image.version;
			
		}
		
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CanvasBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CanvasDisplayObject.render (this, renderer);
			CanvasBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private override function __renderCanvasMask (renderer:CanvasRenderer):Void {
		
		renderer.context.rect (0, 0, width, height);
		
	}
	
	
	private override function __renderDOM (renderer:DOMRenderer):Void {
		
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			__renderDOMClear (renderer);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			DOMDisplayObject.render (this, renderer);
			DOMBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private override function __renderDOMClear (renderer:DOMRenderer):Void {
		
		DOMBitmap.clear (this, renderer);
		
	}
	
	
	private override function __renderGL (renderer:OpenGLRenderer):Void {
		
		if (__bitmapData != null && __bitmapData.image != null) {
			
			__imageVersion = __bitmapData.image.version;
			
		}
		
		__updateCacheBitmap (renderer, false);
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			GLDisplayObject.render (this, renderer);
			GLBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	private override function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		GLBitmap.renderMask (this, renderer);
		
	}
	
	
	private override function __updateCacheBitmap (renderer:DisplayObjectRenderer, force:Bool):Bool {
		
		// TODO: Handle filters without an intermediate draw
		
		if (__filters == null && renderer.__type == OPENGL && __cacheBitmap == null) return false;
		return super.__updateCacheBitmap (renderer, force);
		
	}
	
	
	public override function __updateMask (maskGraphics:Graphics):Void {
		
		if (__bitmapData == null) {
			
			return;
			
		}
		
		maskGraphics.__commands.overrideMatrix (this.__worldTransform);
		maskGraphics.beginFill (0);
		maskGraphics.drawRect (0, 0, __bitmapData.width, __bitmapData.height);
		
		if (maskGraphics.__bounds == null) {
			
			maskGraphics.__bounds = new Rectangle ();
			
		}
		
		__getBounds (maskGraphics.__bounds, @:privateAccess Matrix.__identity);
		
		super.__updateMask (maskGraphics);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_bitmapData ():BitmapData {
		
		return __bitmapData;
		
	}
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		__bitmapData = value;
		smoothing = false;
		
		__setRenderDirty ();
		
		if (__filters != null) {
			
			//__updateFilters = true;
			
		}
		
		__imageVersion = -1;
		
		return __bitmapData;
		
	}
	
	
	private override function get_height ():Float {
		
		if (__bitmapData != null) {
			
			return __bitmapData.height * Math.abs (scaleY);
			
		}
		
		return 0;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (__bitmapData != null) {
			
			if (value != __bitmapData.height) {
				
				__setRenderDirty ();
				scaleY = value / __bitmapData.height;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
	private override function get_width ():Float {
		
		if (__bitmapData != null) {
			
			return __bitmapData.width * Math.abs (__scaleX);
			
		}
		
		return 0;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		if (__bitmapData != null) {
			
			if (value != __bitmapData.width) {
				
				__setRenderDirty ();
				scaleX = value / __bitmapData.width;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
}