package openfl._internal.renderer.cairo;


import lime.math.Matrix3;
import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.*;
import openfl.geom.*;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:keep


class CairoMaskManager extends AbstractMaskManager {
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
	}
	
	
	public override function pushMask (mask:DisplayObject):Void {
		
		var cairo = renderSession.cairo;
		
		cairo.save ();
		
		//var cacheAlpha = mask.__worldAlpha;
		var transform = mask.__getRenderTransform ();
		
		cairo.matrix = transform.__toMatrix3 ();
		
		cairo.newPath ();
		mask.__renderCairoMask (renderSession);
		cairo.clip ();
		
		//mask.worldAlpha = cacheAlpha;
		
	}
	
	
	public override function pushObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			pushRect (object.__scrollRect, object.__renderTransform);
			
		}
		
		if (!object.__cacheBitmapRender && object.__mask != null) {
			
			pushMask (object.__mask);
			
		}
		
	}
	
	
	public override function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		var cairo = renderSession.cairo;
		cairo.save ();
		
		cairo.matrix = new Matrix3 (transform.a, transform.c, transform.b, transform.d, transform.tx, transform.ty);
		
		cairo.newPath ();
		cairo.rectangle (rect.x, rect.y, rect.width, rect.height);
		cairo.clip ();
		
	}
	
	
	public override function popMask ():Void {
		
		renderSession.cairo.restore ();
		
	}
	
	
	public override function popObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (!object.__cacheBitmapRender && object.__mask != null) {
			
			popMask ();
			
		}
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			popRect ();
			
		}
		
	}
	
	
	public override function popRect ():Void {
		
		renderSession.cairo.restore ();
		
	}
	
	
}