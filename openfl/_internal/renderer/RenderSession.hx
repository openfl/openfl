package openfl._internal.renderer; #if (!display && !flash)


import lime.graphics.CairoRenderContext;
import lime.graphics.CanvasRenderContext;
import lime.graphics.DOMRenderContext;
import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLFramebuffer;
//import openfl._internal.renderer.opengl.utils.BlendModeManager;
//import openfl._internal.renderer.opengl.utils.FilterManager;
//import openfl._internal.renderer.opengl.utils.ShaderManager;
//import openfl._internal.renderer.opengl.utils.SpriteBatch;
//import openfl._internal.renderer.opengl.utils.StencilManager;
import openfl._internal.renderer.cairo.CairoGraphics;
import openfl._internal.renderer.cairo.CairoTextField;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.canvas.CanvasTextField;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BitmapDataChannel;
import openfl.display.Sprite;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.text.TextField;

@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)


class RenderSession {
	
	private static var IDENTITY:Matrix = new Matrix();
	
	public var allowSmoothing:Bool;
	public var cairo:CairoRenderContext;
	public var context:CanvasRenderContext;
	public var element:DOMRenderContext;
	public var gl:GLRenderContext;
	public var renderer:AbstractRenderer;
	public var roundPixels:Bool;
	public var transformProperty:String;
	public var transformOriginProperty:String;
	public var upscaled:Bool;
	public var vendorPrefix:String;
	public var projectionMatrix:Matrix;
	public var z:Int;
	
	public var drawCount:Int;
	public var currentBlendMode:BlendMode;
	public var activeTextures:Int = 0;
	
	//public var shaderManager:ShaderManager;
	public var blendModeManager:AbstractBlendModeManager;
	public var filterManager:AbstractFilterManager;
	public var maskManager:AbstractMaskManager;
	public var shaderManager:AbstractShaderManager;
	//public var filterManager:FilterManager;
	//public var blendModeManager:BlendModeManager;
	//public var spriteBatch:SpriteBatch;
	//public var stencilManager:StencilManager;
	//public var defaultFramebuffer:GLFramebuffer;

	private var minBounds:Point;
	private var maxBounds:Point;
	
	
	public function new () {
		
		allowSmoothing = true;
		//maskManager = new MaskManager (this);
		
	}
	

	public function updateCachedBitmap( shape:DisplayObject ) {

		var dirty = (shape.__cachedShapeBounds == null) || hierarchyDirty( shape );

		if (dirty) {

			shape.__cacheAsBitmapMatrix = null;
			shape.__updateTransforms();
			shape.__minCacheAsBitmapBounds = new Point( Math.POSITIVE_INFINITY,  Math.POSITIVE_INFINITY );
			shape.__maxCacheAsBitmapBounds = new Point( Math.NEGATIVE_INFINITY,  Math.NEGATIVE_INFINITY );

			getCachedBitmapBounds( shape, shape );

			var bounds =  new Rectangle();
			bounds.x = shape.__minCacheAsBitmapBounds.x;
			bounds.y = shape.__minCacheAsBitmapBounds.y;
			bounds.width = shape.__maxCacheAsBitmapBounds.x - shape.__minCacheAsBitmapBounds.x;
			bounds.height = shape.__maxCacheAsBitmapBounds.y - shape.__minCacheAsBitmapBounds.y;

			var offset = new Point( bounds.x, bounds.y );
			offset.x -= shape.__cachedShapeBounds.x;
			offset.y -= shape.__cachedShapeBounds.y;

			offsetCachedBitmapBounds( shape, offset );

			if (bounds.width > 0 && bounds.height > 0) {

				shape.__cachedBitmap = new BitmapData( Std.int(bounds.width), Std.int(bounds.height), true, 0x0 );

				flatten( shape, shape.__cachedBitmap );
			
			} else {

				shape.__cachedBitmap = null;

			}

			shape.__filterDirty = true;

		}
	}


	private function hierarchyDirty( shape:DisplayObject ):Bool {

		var dirty = false;

		if (Std.is(shape, DisplayObjectContainer)) {
			var cont:DisplayObjectContainer = cast shape;
			for (i in 0...cont.numChildren) {
				dirty = dirty || hierarchyDirty( cont.getChildAt( i ) ); 
			}
		}
		
		if (shape.__filterDirty) {
			shape.__filterDirty = false;
			dirty = true;
		}

		if (shape.__transformDirty) {
			shape.__transformDirty = false;
			dirty = true;
		}

		if (shape.__renderDirty) {
			shape.__renderDirty = false;
			dirty = true;
		}

		if (shape.__graphics != null && shape.__graphics.__dirty) {
			shape.__graphics.__dirty = false;
			dirty = true;
		}

		var bitmap:Bitmap = cast shape;
		if (Std.is(shape, Bitmap) && bitmap.__renderable && bitmap.__worldAlpha > 0 && bitmap.bitmapData != null && bitmap.bitmapData.image.dirty) {
			bitmap.bitmapData.image.dirty = false;
			dirty = true;
		}

		var textField:TextField = cast shape;
		if ( Std.is(shape, TextField) && textField.__dirty) {
			dirty = true;
		}


		return dirty;
	}

	private function getCachedBitmapBounds (shape:DisplayObject, cacheAsBitmapShape:DisplayObject, point:Point = null ) {

		var graphics = shape.__graphics;
		
		var textField:TextField = cast shape;
		if ( Std.is(shape, TextField) && textField.__dirty) {
			#if (js && html5)
			CanvasTextField.render (textField, this, textField.__worldTransform);
			#elseif lime_cairo
			CairoTextField.render (textField, this, textField.__worldTransform);
			#end
		}

		if (graphics!=null) {
			
			#if (js && html5)
			CanvasGraphics.render (graphics, this, null);
			#elseif lime_cairo
			CairoGraphics.render (graphics, this, null);
			#end
			
			if (graphics.__bitmap != null) {

				shape.__cacheAsBitmapMatrix = shape.__graphics.__worldTransform.clone();

				if (point == null)
					point = new Point( shape.__graphics.__worldTransform.tx,  shape.__graphics.__worldTransform.ty );
				
				shape.__cacheAsBitmapMatrix.tx -= point.x;
				shape.__cacheAsBitmapMatrix.ty -= point.y;

				updateBoundsRectangle( shape, graphics.__bitmap, cacheAsBitmapShape, point );

			}
		}

		if (point == null) {
			point = new Point( shape.__worldTransform.tx,  shape.__worldTransform.ty );

			if (cacheAsBitmapShape.__cachedShapeBounds == null) {
				cacheAsBitmapShape.__cachedShapeBounds = new Rectangle( point.x, point.y, 0, 0 );
			}

		}

		var bitmap:Bitmap = cast shape;
		if (Std.is( shape, Bitmap )) {

			var bitmap:Bitmap = cast shape;
			if (bitmap != null && (bitmap.__renderable || bitmap.__worldAlpha > 0) && bitmap.bitmapData != null) {

				bitmap.__cacheAsBitmapMatrix = bitmap.__worldTransform.clone();
				bitmap.__cacheAsBitmapMatrix.tx -= point.x;
				bitmap.__cacheAsBitmapMatrix.ty -= point.y;

				updateBoundsRectangle( bitmap, bitmap.bitmapData, cacheAsBitmapShape, point );
			}
		}

		if ( shape.__cacheAsBitmapMatrix == null ) {
			shape.__cacheAsBitmapMatrix = shape.__worldTransform.clone();
			shape.__cacheAsBitmapMatrix.tx -= point.x;
			shape.__cacheAsBitmapMatrix.ty -= point.y;
		}

		if (shape.__mask != null) {

			#if (js && html5)
			CanvasGraphics.render (shape.__mask.__graphics, this, null);
			#elseif lime_cairo
			CairoGraphics.render (shape.__mask.__graphics, this, null);
			#end

			updateBoundsRectangle( shape.__mask, shape.__mask.__graphics.__bitmap, cacheAsBitmapShape, point );	

		}

		if (Std.is(shape, DisplayObjectContainer)) {
			var cont:DisplayObjectContainer = cast shape;
			for (i in 0...cont.numChildren) {

				var child = cont.getChildAt( i );

				getCachedBitmapBounds( child, cacheAsBitmapShape, point );
			}
		}
				

	}

	
    private function updateBoundsRectangle( shape:DisplayObject, bmd:BitmapData, cacheAsBitmapShape:DisplayObject, point:Point ) {

		var transform = shape.__graphics != null ? shape.__graphics.__worldTransform : shape.__worldTransform;
		var topLeft = transform.transformPoint( new Point( 0, 0 ) );
		var topRight = transform.transformPoint( new Point( bmd.width, 0 ) );
		var bottomLeft = transform.transformPoint( new Point( 0, bmd.height ) );
		var bottomRight = transform.transformPoint( new Point( bmd.width,  bmd.height ) );
		
		var top = Math.min( topLeft.y,  Math.min( topRight.y,  Math.min( bottomLeft.y, bottomRight.y ) ) );
		var bottom = Math.max( topLeft.y,  Math.max( topRight.y,  Math.max( bottomLeft.y, bottomRight.y ) ) );
		var left = Math.min( topLeft.x,  Math.min( topRight.x,  Math.min( bottomLeft.x, bottomRight.x ) ) );
		var right = Math.max( topLeft.x,  Math.max( topRight.x,  Math.max( bottomLeft.x, bottomRight.x ) ) );

		shape.__cachedShapeBounds = new Rectangle( topLeft.x, topLeft.y, right - left, bottom - top );

		if (!shape.__isMask) {

			cacheAsBitmapShape.__minCacheAsBitmapBounds.x = Math.min( cacheAsBitmapShape.__minCacheAsBitmapBounds.x, left);
			cacheAsBitmapShape.__minCacheAsBitmapBounds.y = Math.min( cacheAsBitmapShape.__minCacheAsBitmapBounds.y, top);
			cacheAsBitmapShape.__maxCacheAsBitmapBounds.x = Math.max( cacheAsBitmapShape.__maxCacheAsBitmapBounds.x, right);
			cacheAsBitmapShape.__maxCacheAsBitmapBounds.y = Math.max( cacheAsBitmapShape.__maxCacheAsBitmapBounds.y, bottom);

		}

	}

	private function offsetCachedBitmapBounds (shape:DisplayObject, boundsOffset:Point ) {

		shape.__cacheAsBitmapMatrix.tx += -boundsOffset.x;	
		shape.__cacheAsBitmapMatrix.ty += -boundsOffset.y;
	
		if (Std.is(shape, DisplayObjectContainer)) {
			
			var cont:DisplayObjectContainer = cast shape;
			for (i in 0...cont.numChildren) {

				var child = cont.getChildAt( i );

				offsetCachedBitmapBounds( child, boundsOffset );

			}

		}
	
	}


	private function flatten (shape:DisplayObject, flattendBmd:BitmapData  ) {

		if (!shape.__renderable || !shape.__visible || shape.__worldAlpha <= 0 || shape.__isMask) return;

		var layer = new BitmapData( flattendBmd.width, flattendBmd.height, true, 0x0 );

		var graphics = shape.__graphics;
		if (graphics!=null) {

			#if (js && html5)
			CanvasGraphics.render (graphics, this, null);
			#elseif lime_cairo
			CairoGraphics.render (graphics, this, null);
			#end
			
			if (graphics.__bitmap != null) {

				layer.draw( graphics.__bitmap, shape.__cacheAsBitmapMatrix, null, null, null, true );

			}
		}

		var bitmap:Bitmap = cast shape;
		
		if (bitmap != null && (bitmap.__renderable || bitmap.__worldAlpha > 0) && bitmap.bitmapData != null) {

			layer.draw( bitmap.bitmapData, shape.__cacheAsBitmapMatrix, null, null, null, true );

		}
				
		if (Std.is(shape, DisplayObjectContainer)) {

			var cont:DisplayObjectContainer = cast shape;
			
			for (i in 0...cont.numChildren) {

				flatten( cont.getChildAt( i ), layer );

			}
		}

		if (shape.__mask != null) {

			var maskBitmap = new BitmapData( layer.width, layer.height, true, 0x0 );
			maskBitmap.draw( shape.__mask.__graphics.__bitmap,  shape.__mask.__cacheAsBitmapMatrix , null, null, null, true );

			var sw:Int = Std.int (layer.width);
			var sh:Int = Std.int (layer.height);
			
			var srcPxls = layer.getPixels (layer.rect);
			var maskPxls = maskBitmap.getPixels (layer.rect);
			srcPxls.position = maskPxls.position = 0;
			
			var srcValue:Int, maskValue:Int, srcA:Int, maskA:Int, color:Int;

			for (i in 0...(sh * sw)) {
				
				srcValue = srcPxls.readUnsignedInt ();
				maskValue = maskPxls.readUnsignedInt ();
				
				srcA = (srcValue >> 24) & 0xFF;
				maskA = (maskValue >> 24) & 0xFF;
				color = ( srcValue & 0xFFFFFF) | (Std.int(srcA * maskA / 0xFF) << 24);
				
				srcPxls.position = i * 4;
				srcPxls.writeUnsignedInt (color);
			}

			layer.setPixels (layer.rect, srcPxls);

			maskBitmap = null;
			srcPxls = maskPxls = null;
		}

		flattendBmd.draw( layer, null, null, null, null, true );

		layer.dispose();
		layer = null;

	}	
	
}


#end
