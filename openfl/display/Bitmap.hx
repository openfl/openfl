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
@:access(openfl.geom.Rectangle)


class Bitmap extends DisplayObject {
	
	
	public var bitmapData (default, set):BitmapData;
	public var pixelSnapping:PixelSnapping;
	public var smoothing:Bool;
	
	#if (js && html5)
	private var __image:ImageElement;
	private var __imageVersion:Int;
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
			
			var bounds = Rectangle.__pool.get ();
			bounds.setTo (0, 0, bitmapData.width, bitmapData.height);
			bounds.__transform (bounds, matrix);
			
			rect.__expand (bounds.x, bounds.y, bounds.width, bounds.height);
			
			Rectangle.__pool.release (bounds);
			
		}
		
	}
	
	
	private override function __hitTest (x:Float, y:Float, shapeFlag:Bool, stack:Array<DisplayObject>, interactiveOnly:Bool, hitObject:DisplayObject):Bool {
		
		if (!hitObject.visible || __isMask || bitmapData == null) return false;
		if (mask != null && !mask.__hitTestMask (x, y)) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= bitmapData.width && py <= bitmapData.height) {
			
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
		
		if (bitmapData == null) return false;
		
		__getRenderTransform ();
		
		var px = __renderTransform.__transformInverseX (x, y);
		var py = __renderTransform.__transformInverseY (x, y);
		
		if (px > 0 && py > 0 && px <= bitmapData.width && py <= bitmapData.height) {
			
			return true;
			
		}
		
		return false;
		
	}
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		#if lime_cairo
		CairoBitmap.render (this, renderSession);
		#end
		
	}
	
	
	private override function __renderCairoMask (renderSession:RenderSession):Void {
		
		renderSession.cairo.rectangle (0, 0, width, height);
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		CanvasBitmap.render (this, renderSession);
		
	}
	
	
	private override function __renderCanvasMask (renderSession:RenderSession):Void {
		
		renderSession.context.rect (0, 0, width, height);
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		#if dom
		DOMBitmap.render (this, renderSession);
		#end
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		GLBitmap.render (this, renderSession);
		
	}
	
	
	public override function __updateMask (maskGraphics:Graphics):Void {
		
		if (bitmapData == null) {
			
			return;
			
		}
		
		maskGraphics.__commands.overrideMatrix (this.__worldTransform);
		maskGraphics.beginFill (0);
		maskGraphics.drawRect (0, 0, bitmapData.width, bitmapData.height);
		
		if (maskGraphics.__bounds == null) {
			
			maskGraphics.__bounds = new Rectangle ();
			
		}
		
		__getBounds (maskGraphics.__bounds, @:privateAccess Matrix.__identity);
		
		super.__updateMask (maskGraphics);
		
	}
	
	
	
	// Get & Set Methods
	
	
	
	
	private function set_bitmapData (value:BitmapData):BitmapData {
		
		bitmapData = value;
		smoothing = false;
		
		__setRenderDirty ();
		
		if (__filters != null && __filters.length > 0) {
			
			//__updateFilters = true;
			
		}
		
		#if (js && html5 && dom)
		__imageVersion = -1;
		#end
		
		return bitmapData;
		
	}
	
	
	private override function get_height ():Float {
		
		if (bitmapData != null) {
			
			return bitmapData.height * Math.abs (scaleY);
			
		}
		
		return 0;
		
	}
	
	
	private override function set_height (value:Float):Float {
		
		if (bitmapData != null) {
			
			if (value != bitmapData.height) {
				
				__setRenderDirty ();
				scaleY = value / bitmapData.height;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
	private override function get_width ():Float {
		
		if (bitmapData != null) {
			
			return bitmapData.width * Math.abs (__scaleX);
			
		}
		
		return 0;
		
	}
	
	
	private override function set_width (value:Float):Float {
		
		if (bitmapData != null) {
			
			if (value != bitmapData.width) {
				
				__setRenderDirty ();
				scaleX = value / bitmapData.width;
				
			}
			
			return value;
			
		}
		
		return 0;
		
	}
	
	
}