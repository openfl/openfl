package openfl.display;


import openfl._internal.renderer.cairo.CairoBitmap;
import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.opengl.GLBitmap;
import openfl._internal.renderer.RenderSession;
import openfl.geom.Matrix;
import openfl.geom.Point;
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


class Bitmap extends DisplayObject implements IShaderDrawable {
	
	
	public var bitmapData (get, set):BitmapData;
	public var pixelSnapping:PixelSnapping;
	@:beta public var shader:Shader;
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
		
		// TODO: Do not set as dirty for DOM render
		
		// #if (!js || !dom)
		if (__bitmapData != null && __bitmapData.image != null) {
			
			var image = __bitmapData.image;
			if (__bitmapData.image.version != __imageVersion) {
				__setRenderDirty ();
				__imageVersion = image.version;
			}
			
		}
		// #end
		
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
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			CairoBitmap.render (this, renderSession);
			
		}
		#end
		
	}
	
	
	private override function __renderCairoMask (renderSession:RenderSession):Void {
		
		renderSession.cairo.rectangle (0, 0, width, height);
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			CanvasBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			CanvasBitmap.render (this, renderSession);
			
		}
		
	}
	
	
	private override function __renderCanvasMask (renderSession:RenderSession):Void {
		
		renderSession.context.rect (0, 0, width, height);
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, !__worldColorTransform.__isDefault ());
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			__renderDOMClear (renderSession);
			__cacheBitmap.stage = stage;
			
			DOMBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			DOMBitmap.render (this, renderSession);
			
		}
		
	}
	
	
	private override function __renderDOMClear (renderSession: RenderSession):Void {
		
		DOMBitmap.clear (this, renderSession);
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, false);
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			GLBitmap.render (__cacheBitmap, renderSession);
			
		} else {
			
			GLBitmap.render (this, renderSession);
			
		}
		
	}
	
	
	private override function __renderGLMask (renderSession:RenderSession):Void {
		
		__updateCacheBitmap (renderSession, false);
		
		if (__cacheBitmap != null && !__cacheBitmapRender) {
			
			GLBitmap.renderMask (__cacheBitmap, renderSession);
			
		} else {
			
			GLBitmap.renderMask (this, renderSession);
			
		}
		
	}
	
	
	private override function __updateCacheBitmap (renderSession:RenderSession, force:Bool):Bool {
		
		if (filters == null) return false;
		return super.__updateCacheBitmap (renderSession, force);
		
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
		
		if (__filters != null && __filters.length > 0) {
			
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