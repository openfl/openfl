package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.renderer.opengl.GLRenderer)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:keep


class GLMaskManager extends AbstractMaskManager {
	
	
	private var clipRects:Array<Rectangle>;
	private var gl:GLRenderContext;
	private var numClipRects:Int;
	private var tempRect:Rectangle;
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		this.gl = renderSession.gl;
		
		clipRects = new Array ();
		numClipRects = 0;
		tempRect = new Rectangle ();
		
	}
	
	
	public override function pushMask (mask:DisplayObject):Void {
		
		// TODO: Handle true mask shape, as well as alpha test
		
		pushRect (mask.getBounds (mask), mask.__getRenderTransform ());
		
	}
	
	
	public override function pushObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			pushRect (object.__scrollRect, object.__renderTransform);
			
		}
		
		if (object.__mask != null) {
			
			pushMask (object.__mask);
			
		}
		
	}
	
	
	public override function pushRect (rect:Rectangle, transform:Matrix):Void {
		
		// TODO: Handle rotation?
		
		var stage = openfl.Lib.current.stage;
		
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
		
		scissorRect (clipRect);
		numClipRects++;
		
	}
	
	
	public override function popMask ():Void {
		
		popRect ();
		
	}
	
	
	public override function popObject (object:DisplayObject, handleScrollRect:Bool = true):Void {
		
		if (object.__mask != null) {
			
			popMask ();
			
		}
		
		if (handleScrollRect && object.__scrollRect != null) {
			
			popRect ();
			
		}
		
	}
	
	
	public override function popRect ():Void {
		
		if (numClipRects > 0) {
			
			numClipRects--;
			
			if (numClipRects > 0) {
				
				scissorRect (clipRects[numClipRects - 1]);
				
			} else {
				
				scissorRect ();
				
			}
			
		}
		
	}
	
	
	private function scissorRect (rect:Rectangle = null):Void {
		
		if (rect != null) {
			
			var renderer:GLRenderer = cast renderSession.renderer;
			
			gl.enable (gl.SCISSOR_TEST);
			
			var clipRect = tempRect;
			rect.__transform (clipRect, renderer.displayMatrix);
			
			var x = Math.floor (clipRect.x);
			var y = Math.floor (renderer.height - clipRect.y - clipRect.height);
			var width = Math.ceil (clipRect.width);
			var height = Math.ceil (clipRect.height);
			
			if (width < 0) width = 0;
			if (height < 0) height = 0;
			
			gl.scissor (x, y, width, height);
			
		} else {
			
			gl.disable (gl.SCISSOR_TEST);
			
		}
		
	}
	
	
}