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
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

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
	
	
	public function new () {
		
		allowSmoothing = true;
		//maskManager = new MaskManager (this);
		
	}
	

	
	public function updateCachedBitmap( shape:DisplayObject ) {

		var dirty = (shape.__cachedBounds == null) || hierarchyDirty( shape );

		if (dirty) {

			shape.__cachedBounds =  new Rectangle();

			shape.__cacheAsBitmapMatrix = shape.parent.__worldTransform.clone();
			shape.__cacheAsBitmapMatrix.rotate( shape.rotation * Math.PI / 180 );
			shape.__cacheAsBitmapMatrix.translate( -shape.__worldTransform.tx, -shape.__worldTransform.ty );
			
			getCachedBitmapBounds( shape, shape.__cachedBounds, shape.__cacheAsBitmapMatrix );

			shape.__cachedBitmap = new BitmapData( Std.int(shape.__cachedBounds.width), Std.int(shape.__cachedBounds.height), true, 0x00ffffff );

			flatten( shape, shape.__cachedBitmap );
		}
	}


	private function hierarchyDirty( shape:DisplayObject ):Bool {
		
		if (Std.is(shape, DisplayObjectContainer)) {
			var cont:DisplayObjectContainer = cast shape;
			for (i in 0...cont.numChildren) {
				if (hierarchyDirty( cont.getChildAt( i ) )) 
					return true;
			}
		}

		if (shape.__filterDirty)
			return true;

		if (shape.__graphics != null && shape.__graphics.__dirty) 
			return true;

		var bitmap:Bitmap = cast shape;
		if (bitmap == null || !bitmap.__renderable || bitmap.__worldAlpha <= 0)
			return false;

		if (bitmap.bitmapData != null && bitmap.bitmapData.image.dirty)
			return true;

		return false;
	}

	private function getCachedBitmapBounds (shape:DisplayObject, bounds:Rectangle, transform:Matrix ) {

		if (Std.is(shape, DisplayObjectContainer)) {
			var cont:DisplayObjectContainer = cast shape;
			for (i in 0...cont.numChildren) {
				cont.__cacheAsBitmapMatrix = cont.__transform.clone();
				getCachedBitmapBounds( cont.getChildAt( i ), bounds, cont.__cacheAsBitmapMatrix );
			}
		}
				
		var graphics = shape.__graphics;
		if (graphics!=null) {
			CanvasGraphics.render (graphics, this, shape.__cacheAsBitmapMatrix );
			
			if (graphics.__bitmap != null) 
				updateBoundsRectangle( shape, graphics.__bitmap, bounds );
		}

		var bitmap:Bitmap = cast shape;
		if (bitmap != null && (bitmap.__renderable || bitmap.__worldAlpha > 0) && bitmap.bitmapData != null) 
			updateBoundsRectangle( bitmap, bitmap.bitmapData, bounds );
		
	}

	
	private function updateBoundsRectangle( shape:DisplayObject, bmd:BitmapData, bounds:Rectangle ) {

		var topLeft = shape.__cacheAsBitmapMatrix.transformPoint( new Point( 0, 0 ) );
		var topRight = shape.__cacheAsBitmapMatrix.transformPoint( new Point( bmd.width, 0 ) );
		var bottomLeft = shape.__cacheAsBitmapMatrix.transformPoint( new Point( 0, bmd.height ) );
		var bottomRight = shape.__cacheAsBitmapMatrix.transformPoint( new Point( bmd.width, bmd.height ) );
		
		var top = Math.min( topLeft.y,  Math.min( topRight.y,  Math.min( bottomLeft.y, bottomRight.y ) ) );
		var bottom = Math.max( topLeft.y,  Math.max( topRight.y,  Math.max( bottomLeft.y, bottomRight.y ) ) );
		var left = Math.min( topLeft.x,  Math.min( topRight.x,  Math.min( bottomLeft.x, bottomRight.x ) ) );
		var right = Math.max( topLeft.x,  Math.max( topRight.x,  Math.max( bottomLeft.x, bottomRight.x ) ) );

		bounds.x = Math.min( bounds.x, left);
		bounds.y = Math.min( bounds.y, top);
		bounds.width = Math.max( bounds.width, right - left);
		bounds.height = Math.max( bounds.height, bottom - top);
		
	}


	private static var ctr:Int = 0;
	private static var ctr2:Int = 0;
	private function flatten (shape:DisplayObject, bmd:BitmapData ) {

		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
				
		if (Std.is(shape, DisplayObjectContainer)) {
			var cont:DisplayObjectContainer = cast shape;
			for (i in 0...cont.numChildren) {
				flatten( cont.getChildAt( i ), bmd );
			}
		}

		var boundsTransform = shape.__cacheAsBitmapMatrix;
		boundsTransform.tx -= shape.__cachedBounds.x;
		boundsTransform.ty -= shape.__cachedBounds.y;

		var graphics = shape.__graphics;
		if (graphics!=null) {
			CanvasGraphics.render ( graphics, this, IDENTITY );
			
			if (graphics.__bitmap!=null)
				bmd.draw( graphics.__bitmap, boundsTransform, null, null, null, true );
		}

		var bitmap:Bitmap = cast shape;
		if (bitmap != null && (bitmap.__renderable || bitmap.__worldAlpha > 0) && bitmap.bitmapData != null) {
			bmd.draw( bitmap.bitmapData, boundsTransform, null, null, null, true );
		}

	}	
	
}


#end