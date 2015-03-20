package openfl._internal.renderer.opengl.shaders;


import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.GLRenderContext;


class AbstractShader {
	
	
	private static var __UID = 0;
	
	public var attributes:Array<Int>;
	public var aTextureCoord:Int;
	public var aVertexPosition:Int;
	public var colorAttribute:Int;
	public var fragmentSrc:Array<String>;
	public var gl:GLRenderContext;
	public var program:GLProgram;
	public var projectionVector:GLUniformLocation;
	public var uniforms:Map<String, Dynamic>;
	public var vertexSrc:Array<String>;
	public var _UID:Int;
	
	
	private function new (gl:GLRenderContext) {
		
		_UID = __UID++;
		
		this.gl = gl;
		program = null;
		
		attributes = [];
	}
	
	
	public function destroy ():Void {
		
		if (program != null) {
			
			gl.deleteProgram (program);
			
		}
		
		uniforms = null;
		gl = null;
		attributes = null;
		
	}
	
	
	public function init ():Void {
		
		var gl = this.gl;
		
		var program = AbstractShader.compileProgram (gl, vertexSrc, fragmentSrc);
		gl.useProgram (program);
		
		this.program = program;
		
	}
	
	
	public static function compileProgram (gl:GLRenderContext, vertexSrc, fragmentSrc):Dynamic {
		
		var fragmentShader = AbstractShader.CompileFragmentShader (gl, fragmentSrc);
		var vertexShader = AbstractShader.CompileVertexShader (gl, vertexSrc);
		
		var shaderProgram = gl.createProgram ();
		
		if (fragmentShader != null && vertexShader != null) {
			
			gl.attachShader (shaderProgram, vertexShader);
			gl.attachShader (shaderProgram, fragmentShader);
			gl.linkProgram (shaderProgram);
			
			if (gl.getProgramParameter(shaderProgram, gl.LINK_STATUS) == 0) {
				
				trace ("Could not initialize shaders");
				
			}
			
		}
		
		return shaderProgram;
		
	}
	
	
	public static function CompileVertexShader (gl:GLRenderContext, shaderSrc) {
		
		return AbstractShader._CompileShader (gl, shaderSrc, gl.VERTEX_SHADER);
		
	}
	
	
	public static function CompileFragmentShader (gl:GLRenderContext, shaderSrc) {
		
		return AbstractShader._CompileShader (gl, shaderSrc, gl.FRAGMENT_SHADER);
		
	}
	
	
	public static function _CompileShader (gl:GLRenderContext, shaderSrc, shaderType) {
		
		var src = shaderSrc.join ("\n");
		var shader = gl.createShader (shaderType);
		gl.shaderSource (shader, src);
		gl.compileShader (shader);
		
		if (gl.getShaderParameter (shader, gl.COMPILE_STATUS) == 0) {
			
			//trace ("Error compiling " + Type.getClassName (Type.getClass (this)));
			trace (gl.getShaderInfoLog (shader));
			return null;
			
		}
		
		return shader;
		
	}
	
	
}