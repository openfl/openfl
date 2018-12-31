package openfl.display; #if !flash


import openfl._internal.renderer.cairo.CairoBitmap;
import openfl._internal.renderer.cairo.CairoDisplayObject;
import openfl._internal.renderer.canvas.CanvasBitmap;
import openfl._internal.renderer.canvas.CanvasDisplayObject;
import openfl._internal.renderer.context3D.Context3DBitmap;
import openfl._internal.renderer.context3D.Context3DDisplayObject;
import openfl._internal.renderer.dom.DOMBitmap;
import openfl._internal.renderer.dom.DOMDisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.ImageElement;
#end


/**
 * The Bitmap class represents display objects that represent bitmap images.
 * These can be images that you load with the `openfl.Assets` or 
 * `openfl.display.Loader` classes, or they can be images that you 
 * create with the `Bitmap()` constructor.
 *
 * The `Bitmap()` constructor allows you to create a Bitmap
 * object that contains a reference to a BitmapData object. After you create a
 * Bitmap object, use the `addChild()` or `addChildAt()`
 * method of the parent DisplayObjectContainer instance to place the bitmap on
 * the display list.
 *
 * A Bitmap object can share its BitmapData reference among several Bitmap
 * objects, independent of translation or rotation properties. Because you can
 * create multiple Bitmap objects that reference the same BitmapData object,
 * multiple display objects can use the same complex BitmapData object without
 * incurring the memory overhead of a BitmapData object for each display
 * object instance.
 *
 * A BitmapData object can be drawn to the screen by a Bitmap object in one
 * of two ways: by using the default hardware renderer with a single hardware surface, 
 * or by using the slower software renderer when 3D acceleration is not available.
 * 
 * If you would prefer to perform a batch rendering command, rather than using a
 * single surface for each Bitmap object, you can also draw to the screen using the
 * `openfl.display.Tilemap` class.
 *
 * **Note:** The Bitmap class is not a subclass of the InteractiveObject
 * class, so it cannot dispatch mouse events. However, you can use the
 * `addEventListener()` method of the display object container that
 * contains the Bitmap object.
 */

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.BitmapData)
@:access(openfl.display.Graphics)
@:access(openfl.geom.ColorTransform)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class Bitmap extends DisplayObject {
	
	
	/**
	 * The BitmapData object being referenced.
	 */
	public var bitmapData (get, set):BitmapData;
	
	/**
	 * Controls whether or not the Bitmap object is snapped to the nearest pixel.
	 * This value is ignored in the native and HTML5 targets.
	 * The PixelSnapping class includes possible values:
	 * 
	 *  * `PixelSnapping.NEVER` - No pixel snapping occurs.
	 *  * `PixelSnapping.ALWAYS` - The image is always snapped to
	 * the nearest pixel, independent of transformation.
	 *  * `PixelSnapping.AUTO` - The image is snapped to the
	 * nearest pixel if it is drawn with no rotation or skew and it is drawn at a
	 * scale factor of 99.9% to 100.1%. If these conditions are satisfied, the
	 * bitmap image is drawn at 100% scale, snapped to the nearest pixel.
	 * When targeting Flash Player, this value allows the image to be drawn as fast 
	 * as possible using the internal vector renderer.
	 * 
	 */
	public var pixelSnapping:PixelSnapping;
	
	/**
	 * Controls whether or not the bitmap is smoothed when scaled. If
	 * `true`, the bitmap is smoothed when scaled. If
	 * `false`, the bitmap is not smoothed when scaled.
	 */
	public var smoothing:Bool;
	
	#if (js && html5)
	@:noCompletion private var __image:ImageElement;
	#end
	
	@:noCompletion private var __bitmapData:BitmapData;
	@:noCompletion private var __imageVersion:Int;
	
	
	#if openfljs
	@:noCompletion private static function __init__ () {
		
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
	
	
	@:noCompletion private override function __enterFrame (deltaTime:Int):Void {
		
		if (__bitmapData != null && __bitmapData.image != null && __bitmapData.image.version != __imageVersion) {
			
			__setRenderDirty ();
			
		}
		
	}
	
	
	@:noCompletion private override function __getBounds (rect:Rectangle, matrix:Matrix):Void {
		
		if (__bitmapData != null) {
			
			var bounds = Rectangle.__pool.get ();
			bounds.setTo (0, 0, __bitmapData.width, __bitmapData.height);
			bounds.__transform (bounds, matrix);
			
			rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
			
			Rectangle.__pool.release (bounds);
			
		}
		
	}
	
	
	@:noCompletion private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
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
	
	
	@:noCompletion private override function __hitTestMask (x:Float, y:Float):Bool {
		
		if (__bitmapData == null) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= __bitmapData.width && py <= __bitmapData.height) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	@:noCompletion private override function __renderCairo (renderer:CairoRenderer):Void {
		
		#if lime_cairo
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__bitmapData != null && __bitmapData.image != null) {
			
			__imageVersion = __bitmapData.image.version;
			
		}
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CairoBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CairoDisplayObject.render (this, renderer);
			CairoBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		#end
		
	}
	
	
	@:noCompletion private override function __renderCairoMask (renderer:CairoRenderer):Void {
		
		renderer.cairo.rectangle (0, 0, width, height);
		
	}
	
	
	@:noCompletion private override function __renderCanvas (renderer:CanvasRenderer):Void {
		
		__updateCacheBitmap (renderer, /*!__worldColorTransform.__isDefault ()*/ false);
		
		if (__bitmapData != null && __bitmapData.image != null) {
			
			__imageVersion = __bitmapData.image.version;
			
		}
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			CanvasBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			CanvasDisplayObject.render (this, renderer);
			CanvasBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private override function __renderCanvasMask (renderer:CanvasRenderer):Void {
		
		renderer.context.rect (0, 0, width, height);
		
	}
	
	
	@:noCompletion private override function __renderDOM (renderer:DOMRenderer):Void {
		
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
	
	
	@:noCompletion private override function __renderDOMClear (renderer:DOMRenderer):Void {
		
		DOMBitmap.clear (this, renderer);
		
	}
	
	
	@:noCompletion private override function __renderGL (renderer:OpenGLRenderer):Void {
		
		__updateCacheBitmap (renderer, false);
		
		if (__bitmapData != null && __bitmapData.image != null) {
			
			__imageVersion = __bitmapData.image.version;
			
		}
		
		if (__cacheBitmap != null && !__isCacheBitmapRender) {
			
			Context3DBitmap.render (__cacheBitmap, renderer);
			
		} else {
			
			Context3DDisplayObject.render (this, renderer);
			Context3DBitmap.render (this, renderer);
			
		}
		
		__renderEvent (renderer);
		
	}
	
	
	@:noCompletion private override function __renderGLMask (renderer:OpenGLRenderer):Void {
		
		Context3DBitmap.renderMask (this, renderer);
		
	}
	
	
	@:noCompletion private override function __updateCacheBitmap (renderer:DisplayObjectRenderer, force:Bool):Bool {
		
		// TODO: Handle filters without an intermediate draw
		
		#if lime
		if (__bitmapData == null || (__filters == null && renderer.__type == OPENGL && __cacheBitmap == null)) return false;
		return super.__updateCacheBitmap (renderer, __bitmapData.image != null && __bitmapData.image.version != __imageVersion);
		#else
		return false;
		#end
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_bitmapData ():BitmapData {
		
		return __bitmapData;
		
	}
	
	
	@:noCompletion private function set_bitmapData (value:BitmapData):BitmapData {
		
		__bitmapData = value;
		smoothing = false;
		
		__setRenderDirty ();
		
		if (__filters != null) {
			
			//__updateFilters = true;
			
		}
		
		__imageVersion = -1;
		
		return __bitmapData;
		
	}
	
	
	@:noCompletion private override function get_height ():Float {
		
		if (__bitmapData != null) {
			
			return __bitmapData.height * Math.abs (scaleY);
			
		}
		
		return 0;
		
	}
	
	
	@:noCompletion private override function set_height (value:Float):Float {
		
		if (__bitmapData != null) {
			
			if (value != __bitmapData.height) {
				
				__setRenderDirty ();
				scaleY = value / __bitmapData.height;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
	@:noCompletion private override function get_width ():Float {
		
		if (__bitmapData != null) {
			
			return __bitmapData.width * Math.abs (__scaleX);
			
		}
		
		return 0;
		
	}
	
	
	@:noCompletion private override function set_width (value:Float):Float {
		
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


#else
typedef Bitmap = flash.display.Bitmap;
#end