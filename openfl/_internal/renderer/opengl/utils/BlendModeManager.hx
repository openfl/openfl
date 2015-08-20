package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;
import openfl.display.BlendMode;
import openfl.gl.GL;


class BlendModeManager {
	
	public var currentBlendMode:BlendMode;
	public var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		currentBlendMode = null;
		
	}
	
	
	public function destroy ():Void {
		
		gl = null;
		
	}
	
	
	public function setBlendMode (blendMode:BlendMode, ?force:Bool = false):Bool {
		
		if (blendMode == null) {
			
			blendMode = BlendMode.NORMAL;
			force = true;
			
		}
		
		if (!force && currentBlendMode == blendMode) {
			
			return false;
			
		}
		
		currentBlendMode = blendMode;
		
		switch (blendMode) {
			
			case ADD:
				
				gl.blendEquation (GL.FUNC_ADD);
				gl.blendFunc (GL.ONE, GL.ONE);
			
			case MULTIPLY:
				
				gl.blendEquation (GL.FUNC_ADD);
				gl.blendFunc (GL.DST_COLOR, GL.ONE_MINUS_SRC_ALPHA);
			
			case SCREEN:
				
				gl.blendEquation (GL.FUNC_ADD);
				gl.blendFunc (GL.ONE, GL.ONE_MINUS_SRC_COLOR);
			
			case SUBTRACT:
				
				gl.blendEquation (GL.FUNC_REVERSE_SUBTRACT);
				gl.blendFunc (GL.ONE, GL.ONE);
			
			#if desktop
			case DARKEN:
				
				gl.blendEquation (0x8007); // GL_MIN
				gl.blendFunc (GL.ONE, GL.ONE);
				
			case LIGHTEN:
				
				gl.blendEquation (0x8008); // GL_MAX
				gl.blendFunc (GL.ONE, GL.ONE);
			#end
			
			default:
				
				gl.blendEquation (GL.FUNC_ADD);
				gl.blendFunc (GL.ONE, GL.ONE_MINUS_SRC_ALPHA);
			
		}
		
		return true;
		
	}
	
	
}

typedef GLBlendMode = {
	src:GLBlendFunction, dest:GLBlendFunction, func:GLBlendEquation
}

@:enum abstract GLBlendEquation(Int) from Int to Int {
	var ADD = GL.FUNC_ADD;
	var SUBTRACT = GL.FUNC_SUBTRACT;
	var REVERSE_SUBTRACT = GL.FUNC_REVERSE_SUBTRACT;
	
}

@:enum abstract GLBlendFunction(Int) from Int to Int {
	var ZERO = GL.ZERO;
	var ONE = GL.ONE;
	var SRC_COLOR = GL.SRC_COLOR;
	var DST_COLOR = GL.DST_COLOR;
	var ONE_MINUS_SRC_COLOR = GL.ONE_MINUS_SRC_COLOR;
	var ONE_MINUS_DST_COLOR = GL.ONE_MINUS_DST_COLOR;
	var CONSTANT_COLOR = GL.CONSTANT_COLOR;
	var ONE_MINUS_CONSTANT_COLOR = GL.ONE_MINUS_CONSTANT_COLOR;
	var SRC_ALPHA = GL.SRC_ALPHA;
	var DST_ALPHA = GL.DST_ALPHA;
	var ONE_MINUS_SRC_ALPHA = GL.ONE_MINUS_SRC_ALPHA;
	var ONE_MINUS_DST_ALPHA = GL.ONE_MINUS_DST_ALPHA;
	var CONSTANT_ALPHA = GL.CONSTANT_ALPHA;
	var ONE_MINUS_CONSTANT_ALPHA = GL.ONE_MINUS_CONSTANT_ALPHA;
	var SRC_ALPHA_SATURATE = GL.SRC_ALPHA_SATURATE;
}
