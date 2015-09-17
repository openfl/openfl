package openfl._internal.renderer.cairo;


import lime.math.Matrix3;
import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.*;
import openfl.geom.*;

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
		var transform = mask.__getWorldTransform ();
		
		cairo.matrix = transform.__toMatrix3 ();
		
		cairo.newPath ();
		mask.__renderCairoMask (renderSession);
		cairo.clip ();
		
		//mask.worldAlpha = cacheAlpha;
		
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
	
	
	public override function popRect ():Void {
		
		renderSession.context.restore ();
		
	}
	
	
}