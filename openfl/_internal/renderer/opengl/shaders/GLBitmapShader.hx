package openfl._internal.renderer.opengl.shaders;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.opengl.GLShader;


class GLBitmapShader extends GLShader {
	
	
	public function new (gl:GLRenderContext) {
		
		super (gl);
		
		vertexSrc = [
			
			"attribute vec4 aPosition;",
			"attribute vec2 aTexCoord;",
			"varying vec2 vTexCoord;",
			
			"uniform mat4 uMatrix;",
			
			"void main(void) {",
				
			"	vTexCoord = aTexCoord;",
			"	gl_Position = uMatrix * aPosition;",
				
			"}"
			
		];
		
		fragmentSrc = [
			
			'#ifdef GL_ES',
			'precision mediump float;',
			'#endif',
			"varying vec2 vTexCoord;",
			"uniform sampler2D uImage0;",
			"uniform float uAlpha;",
			
			"void main(void) {",
				
			"	vec4 color = texture2D (uImage0, vTexCoord);",
			"	color.a = color.a * uAlpha;",
				
			"	if (color.a == 0.0) {",
					
					"gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);",
					
			"	} else {",
					
			"		gl_FragColor = vec4 (color.rgb / color.a, color.a);",
					
			"	}",
				
			"}",
			
		];
		
		init ();
		
	}
	
	
	public override function disable ():Void {
		
		gl.disableVertexAttribArray (attributes.get ("aPosition"));
		gl.disableVertexAttribArray (attributes.get ("aTexCoord"));
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end
		
	}
	
	
	public override function enable ():Void {
		
		gl.enableVertexAttribArray (attributes.get ("aPosition"));
		gl.enableVertexAttribArray (attributes.get ("aTexCoord"));
		gl.uniform1i (uniforms.get ("uImage0"), 0);
		
		gl.activeTexture (gl.TEXTURE0);
		
		#if desktop
		gl.enable (gl.TEXTURE_2D);
		#end
		
	}
	
	
	private override function init (force:Bool = false) {
		
		super.init (force);
		
		getAttribLocation ("aPosition");
		getAttribLocation ("aTexCoord");
		getUniformLocation ("uMatrix");
		getUniformLocation ("uImage0");
		getUniformLocation ("uAlpha");
		
	}
	
}