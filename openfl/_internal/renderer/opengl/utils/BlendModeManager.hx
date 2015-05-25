package openfl._internal.renderer.opengl.utils;


import lime.graphics.GLRenderContext;
import openfl.display.BlendMode;
import openfl.gl.GL;


class BlendModeManager {
	
	public static var glBlendModes:Map<BlendMode, GLBlendMode> = null;
	public var currentBlendMode:BlendMode;
	public var gl:GLRenderContext;
	
	
	public function new (gl:GLRenderContext) {
		
		this.gl = gl;
		currentBlendMode = null;
		
		if (glBlendModes == null) {
			
			glBlendModes = new Map ();
			
			glBlendModes.set (BlendMode.NORMAL, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			glBlendModes.set (BlendMode.ADD, { src: ONE, dest: ONE, func: ADD } );
			glBlendModes.set (BlendMode.MULTIPLY, { src: DST_COLOR, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			glBlendModes.set (BlendMode.SCREEN, { src: ONE, dest: ONE_MINUS_SRC_COLOR, func: ADD } );
			glBlendModes.set (BlendMode.SUBTRACT, { src: ONE, dest: ONE, func: REVERSE_SUBTRACT } );
			
			// it's not necessary
			glBlendModes.set (BlendMode.LAYER, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			// possible on desktop openGL not on webGL ( func: MIN )
			glBlendModes.set (BlendMode.DARKEN, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			// possible on desktop openGL not on webGL ( func: MAX )
			glBlendModes.set (BlendMode.LIGHTEN, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			// doesn't work as flash (output is black) { src: ZERO, dest: ONE_MINUS_SRC_ALPHA, func: ADD }
			glBlendModes.set (BlendMode.ERASE, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			// doesn't work as flash (output is black) { src: ZERO, dest: SRC_ALPHA, func: ADD }
			glBlendModes.set (BlendMode.ALPHA, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			
			// Not possible			
			glBlendModes.set (BlendMode.INVERT, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			glBlendModes.set (BlendMode.DIFFERENCE, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );			
			glBlendModes.set (BlendMode.HARDLIGHT, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			glBlendModes.set (BlendMode.OVERLAY, { src: ONE, dest: ONE_MINUS_SRC_ALPHA, func: ADD } );
			
		}
		
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
		
		var glBlend:GLBlendMode = glBlendModes[currentBlendMode];
		gl.blendEquation(glBlend.func);
		gl.blendFunc(glBlend.src, glBlend.dest);
		
		
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
