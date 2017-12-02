package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractMaskManager;
import openfl.display.DisplayObject;
import openfl.display.Shader;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.renderer.opengl.GLRenderer)
@:access(openfl.display.DisplayObject)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)
@:keep


class GLMaskManager extends AbstractMaskManager {
	
	
	@:allow(openfl._internal.renderer.opengl) private static var maskShader = new GLMaskShader ();
	
	private var clipRects:Array<Rectangle>;
	private var gl:GLRenderContext;
	private var maskObjects:Array<DisplayObject>;
	private var numClipRects:Int;
	private var stencilReference:Int;
	private var tempRect:Rectangle;
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		this.gl = renderSession.gl;
		
		clipRects = new Array ();
		maskObjects = new Array ();
		numClipRects = 0;
		stencilReference = 0;
		tempRect = new Rectangle ();
		
	}
	
	
	public override function pushMask (mask:DisplayObject):Void {
		
		if (stencilReference == 0) {
			
			gl.enable (gl.STENCIL_TEST);
			gl.stencilMask (0xFF);
			gl.clear (gl.STENCIL_BUFFER_BIT);
			
		}
		
		gl.stencilOp (gl.KEEP, gl.KEEP, gl.INCR);
		gl.stencilFunc (gl.EQUAL, stencilReference, 0xFF);
		gl.colorMask (false, false, false, false);
		
		mask.__renderGLMask (renderSession);
		maskObjects.push (mask);
		stencilReference++;
		
		gl.stencilOp (gl.KEEP, gl.KEEP, gl.KEEP);
		gl.stencilFunc (gl.EQUAL, stencilReference, 0xFF);
		gl.colorMask (true, true, true, true);
		
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
		
		if (stencilReference == 0) return;
		
		if (stencilReference > 1) {
			
			gl.stencilOp (gl.KEEP, gl.KEEP, gl.DECR);
			gl.stencilFunc (gl.EQUAL, stencilReference, 0xFF);
			gl.colorMask (false, false, false, false);
			
			var mask = maskObjects.pop ();
			mask.__renderGLMask (renderSession);
			stencilReference--;
			
			gl.stencilOp (gl.KEEP, gl.KEEP, gl.KEEP);
			gl.stencilFunc (gl.EQUAL, stencilReference, 0xFF);
			gl.colorMask (true, true, true, true);
			
		} else {
			
			stencilReference = 0;
			gl.disable (gl.STENCIL_TEST);
			
		}
		
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


class GLMaskShader extends Shader {
	
	
	@:glFragmentSource(
		
		"varying vec2 vTexCoord;
		
		uniform sampler2D uImage0;
		
		void main(void) {
			
			vec4 color = texture2D (uImage0, vTexCoord);
			
			if (color.a == 0.0) {
				
				discard;
				
			} else {
				
				gl_FragColor = color;
				
			}
			
		}"
		
	)
	
	
	@:glVertexSource(
		
		"attribute vec4 aPosition;
		attribute vec2 aTexCoord;
		varying vec2 vTexCoord;
		
		uniform mat4 uMatrix;
		
		void main(void) {
			
			vTexCoord = aTexCoord;
			
			gl_Position = uMatrix * aPosition;
			
		}"
		
	)
	
	
	public function new (code:ByteArray = null) {
		
		super (code);
		
	}
	
	
}