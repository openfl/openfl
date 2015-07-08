package openfl._internal.renderer.canvas;


import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.*;
import openfl.geom.*;

@:access(openfl.display.DisplayObject)
@:keep


class CanvasMaskManager extends AbstractMaskManager {
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
	}
	
	
	public override function pushMask (mask:DisplayObject):Void {
		
		var context = renderSession.context;
		
		context.save ();
		
		//var cacheAlpha = mask.__worldAlpha;
		var transform = mask.__getTransform ();
		
		context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		
		context.beginPath ();
		mask.__renderCanvasMask (renderSession);
		
		context.clip ();
		
		//mask.worldAlpha = cacheAlpha;
		
	}
	
	
	public override function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		var context = renderSession.context;
		context.save ();
		
		context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
		
		context.beginPath ();
		context.rect (rect.x, rect.y, rect.width, rect.height);
		context.clip ();
		
	}
	
	
	public override function popMask ():Void {
		
		renderSession.context.restore ();
		
	}
	
	override public function popRect():Void {
		
		renderSession.context.restore ();
		
	}
	
	
}