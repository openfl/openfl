package openfl.filters; #if !flash #if !openfl_legacy


import openfl._internal.renderer.RenderSession;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.ImageData;
#end


/**
 * The BitmapFilter class is the base class for all image filter effects.
 *
 * <p>The BevelFilter, BlurFilter, ColorMatrixFilter, ConvolutionFilter,
 * DisplacementMapFilter, DropShadowFilter, GlowFilter, GradientBevelFilter,
 * and GradientGlowFilter classes all extend the BitmapFilter class. You can
 * apply these filter effects to any display object.</p>
 *
 * <p>You can neither directly instantiate nor extend BitmapFilter.</p>
 */

 @:access(openfl.display.BitmapData)
class BitmapFilter {
	
	private var __dirty:Bool = true;
	private var __shader:Shader;
	
	public function new () {
		
		
		
	}
	
	
	/**
	 * Returns a BitmapFilter object that is an exact copy of the original
	 * BitmapFilter object.
	 * 
	 * @return A BitmapFilter object.
	 */
	public function clone ():BitmapFilter {
		
		return new BitmapFilter ();
		
	}
	
	
	#if (js && html5)
	@:noCompletion public function __applyFilter (sourceData:ImageData, targetData:ImageData, sourceRect:Rectangle, destPoint:Point):Void {
		
		
		
	}
	#end
	
	@:noCompletion private function __growBounds (rect:Rectangle) {
		
		
		
	}
	
	@:noCompletion private function __applyGL (renderSession:RenderSession, source:BitmapData, target:BitmapData, sourceRect:Rectangle, destPoint:Point):Void {
		
		/*
		if (!__dirty) return;
		
		var same = source == target;
		
		if (same) {
			
		}
		
		
		__dirty = false;
		*/
	}
	
	@:noCompletion private static function __expandBounds (filters:Array<BitmapFilter>, rect:Rectangle, matrix:Matrix) {
		
		var r = new Rectangle();
		for (filter in filters) {
			filter.__growBounds (r);
		}
		
		r = r.transform(matrix);
		rect.__expand(r.x, r.y, r.width, r.height);
	}
	
	@:noCompletion private static function __applyFilters (filters:Array<BitmapFilter>, renderSession:RenderSession, source:BitmapData, target:BitmapData, sourceRect:Rectangle, destPoint:Point) {

		var same = target == source && target.__usingFramebuffer;
		if (same) target.__useOldFramebuffer = true;
		
		if (sourceRect == null) sourceRect = source.rect;
		for (filter in filters) {
			
			if (same) target.__swap();
			source.__shader = filter.__shader;
			target.__drawGL(renderSession, source, sourceRect, true, !target.__usingFramebuffer);
			
		}
		
		if (same) target.__useOldFramebuffer = false;
		
	}
	
	
}


#else
typedef BitmapFilter = openfl._legacy.filters.BitmapFilter;
#end
#else
typedef BitmapFilter = flash.filters.BitmapFilter;
#end