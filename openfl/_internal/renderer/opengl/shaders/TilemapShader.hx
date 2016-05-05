package openfl._internal.renderer.opengl.shaders;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.shaders.DefaultShader.Attrib;
import openfl._internal.renderer.opengl.shaders.DefaultShader.Uniform;
import openfl._internal.renderer.opengl.shaders.DefaultShader.Varying;
import openfl._internal.renderer.opengl.GLShader;


class TilemapShader extends GLShader {
	
	
	public function new (gl:GLRenderContext) {
		
		super (gl);
		
		vertexSrc = [
			"attribute vec2 openfl_aPosition;",
			"attribute vec2 openfl_aTexCoord0;",
			"uniform mat4 openfl_uProjectionMatrix;",
			"varying vec2 openfl_vTexCoord;",
			
			"void main (void) {",
				
				"openfl_vTexCoord = openfl_aTexCoord0;",
				"gl_Position = openfl_uProjectionMatrix * vec4 (openfl_aPosition, 0.0, 1.0);",
				
			"}"
		];
		
		fragmentSrc = [
			'#ifdef GL_ES',
			'precision mediump float;',
			'#endif',
			"varying vec2 openfl_vTexCoord;",
			"uniform sampler2D openfl_uSampler0;",
			
			"void main (void) {",
				
				"gl_FragColor = texture2D (openfl_uSampler0, openfl_vTexCoord);",
				
			"}",
			
		];
		
		init ();
		
	}
	
	
	private override function init (force:Bool = false) {
		
		super.init (force);
		
		getAttribLocation (Attrib.Position);
		getAttribLocation (Attrib.TexCoord);
		//getAttribLocation (Attrib.Color);
		getUniformLocation (Uniform.ProjectionMatrix);
		getUniformLocation (Uniform.Sampler);
		//getUniformLocation (Uniform.ColorMultiplier);
		//getUniformLocation (Uniform.ColorOffset);
		//getUniformLocation (Uniform.UseColorTransform);
		
	}
	
}