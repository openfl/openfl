package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.DisplayObject;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:keep


class GLMaskManager extends AbstractMaskManager {
	
	
	private var clipRects:Array<Rectangle>;
	private var gl:GLRenderContext;
	private var numClipRects:Int;
	
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		this.gl = renderSession.gl;
		
		clipRects = new Array ();
		numClipRects = 0;
		
	}
	
	
	public override function pushMask (mask:DisplayObject):Void {
		
		// TODO: Handle true mask shape, as well as alpha test
		
		pushRect (mask.getBounds (mask), mask.__worldTransform);
		
	}
	
	
	public override function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		// TODO: Handle rotation?
		
		if (numClipRects == clipRects.length) {
			
			clipRects[numClipRects] = new Rectangle ();
			
		}
		
		var clipRect = clipRects[numClipRects];
		rect.__transform (clipRect, transform);
		
		if (numClipRects > 0) {
			
			var parentClipRect = clipRects[numClipRects - 1];
			clipRect.__contract (parentClipRect.x, parentClipRect.y, parentClipRect.width, parentClipRect.height);
			
		}
		
		if (clipRect.height < 0) {
			
			clipRect.height = 0;
			
		}
		
		if (clipRect.width < 0) {
			
			clipRect.width = 0;
			
		}
		
		gl.enable (gl.SCISSOR_TEST);
		gl.scissor (Math.floor (clipRect.x), Math.floor (renderSession.renderer.height - clipRect.y - clipRect.height), Math.ceil (clipRect.width), Math.ceil (clipRect.height));
		
		numClipRects++;
		
	}
	
	
	public override function popMask ():Void {
		
		popRect ();
		
	}
	
	
	public override function popRect ():Void {
		
		if (numClipRects > 0) {
			
			numClipRects--;
			
		}
		
		if (numClipRects == 0) {
			
			gl.disable (gl.SCISSOR_TEST);
			
		}
		
	}
	
	
}