package openfl.display;


import openfl._internal.renderer.cairo.CairoBitmap;
import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.opengl.GLBitmap;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.opengl.batcher.Quad;
import openfl._internal.renderer.opengl.batcher.BlendMode as BatcherBlendMode;
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
	public var pixelSnapping (get, set):PixelSnapping;
	@:beta public var shader:Shader;
	public var smoothing:Bool;
	
	#if (js && html5)
	private var __image:ImageElement;
	#end
	
	private var __bitmapData:BitmapData;
	private var __imageVersion:Int;
	
	var __batchQuad:Quad;
	var __batchQuadDirty:Bool = true;
	
	#if openfljs
	private static function __init__ () {
		
		untyped Object.defineProperty (Bitmap.prototype, "bitmapData", { get: untyped __js__ ("function () { return this.get_bitmapData (); }"), set: untyped __js__ ("function (v) { return this.set_bitmapData (v); }") });
		
	}
	#end
	
	
	public function new (bitmapData:BitmapData = null, pixelSnapping:PixelSnapping = null, smoothing:Bool = false) {
		
		super ();
		
		__bitmapData = bitmapData;

		if (pixelSnapping == null) pixelSnapping = PixelSnapping.AUTO;
		__pixelSnapping = pixelSnapping;

		this.smoothing = smoothing;
		
	}
	
	private override function __cleanup ():Void {
		
		super.__cleanup ();
		
		if (__bitmapData != null) {
			
			__bitmapData.__cleanup ();
			
		}
		
		if (__batchQuad != null) {
			
			Quad.pool.release (__batchQuad);
			__batchQuad = null;
			
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
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject, hitTestWhenMouseDisabled:Bool = false):Bool {
		
		if (!hitObject.visible || __isMask || __bitmapData == null) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height) {
			
			if (__scrollRect != null && !__scrollRect.contains (px, py)) {
				
				return false;
				
			}
			
			if (stack != null && !interactiveOnly && !hitTestWhenMouseDisabled) {
				
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
	
	
	function __getBatchQuad (renderSession:RenderSession):Quad {
		
		if (__batchQuadDirty) {
			if (__batchQuad == null) {
				__batchQuad = Quad.pool.get ();
			}
			
			var snapToPixel = renderSession.roundPixels || __snapToPixel ();
			var transform = (cast renderSession.renderer : GLRenderer).getDisplayTransformTempMatrix (__renderTransform, snapToPixel);
			bitmapData.__fillBatchQuad (transform, __batchQuad.vertexData);
			__batchQuad.texture = __bitmapData.getTexture (renderSession.gl);
			__batchQuadDirty = false;
		}
		
		__batchQuad.setup(__worldAlpha, __worldColorTransform, BatcherBlendMode.fromOpenFLBlendMode(__worldBlendMode), smoothing);
		
		return __batchQuad;
		
	}

	override function __updateTransforms (overrideTransform:Matrix = null):Void {
		super.__updateTransforms (overrideTransform);
		
		if (overrideTransform == null) {
			__batchQuadDirty = true;
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
		
		if (!__hasFilters () && renderSession.gl != null && __cacheBitmap == null) return false;
		return super.__updateCacheBitmap (renderSession, force);
		
	}
	
	
	override function __forceRenderDirty() {
		
		super.__forceRenderDirty ();
		
		__batchQuadDirty = true;
		
	}
	
	
	// Get & Set Methods
	
	
	
	
	private function get_bitmapData ():BitmapData {
		
		return __bitmapData;
		
	}
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		__bitmapData = value;
		smoothing = false;
		
		__setRenderDirty ();
		__batchQuadDirty = true;
		
		if (__hasFilters ()) {
			
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
			
			if (value != __bitmapData.height * __scaleY) {
				
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
			
			if (value != __bitmapData.width * __scaleX) {
				
				__setRenderDirty ();
				scaleX = value / __bitmapData.width;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
}