package openfl._internal.renderer.opengl.shaders;


import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.GLRenderContext;


class StripShader extends AbstractShader {
	
	
	public var alpha:GLUniformLocation;
	public var offsetVector:GLUniformLocation;
	public var translationMatrix:GLUniformLocation;
	public var uSampler:GLUniformLocation;
	
	
	public function new (gl:GLRenderContext) {
		
		super (gl);
		
		fragmentSrc = [
			#if !desktop
			'precision mediump float;',
			#end
			'varying vec2 vTextureCoord;',
			//   'varying float vColor;',
			'uniform float alpha;',
			'uniform sampler2D uSampler;',
			
			'void main(void) {',
			'   gl_FragColor = texture2D(uSampler, vec2(vTextureCoord.x, vTextureCoord.y));',
			//  '   gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0);',//gl_FragColor * alpha;',
			'}'
		];
		
		vertexSrc  = [
			'attribute vec2 aVertexPosition;',
			'attribute vec2 aTextureCoord;',
			'uniform mat3 translationMatrix;',
			'uniform vec2 projectionVector;',
			'uniform vec2 offsetVector;',
			//  'uniform float alpha;',
			// 'uniform vec3 tint;',
			'varying vec2 vTextureCoord;',
			//  'varying vec4 vColor;',
			
			'void main(void) {',
			'   vec3 v = translationMatrix * vec3(aVertexPosition , 1.0);',
			'   v -= offsetVector.xyx;',
			'   gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);',
			'   vTextureCoord = aTextureCoord;',
			// '   vColor = aColor * vec4(tint * alpha, alpha);',
			'}'
		];
		
		init ();
		
	}
	
	
	public override function init ():Void {
		
		super.init ();
		
		var gl = this.gl;
		
		uSampler = gl.getUniformLocation (program, 'uSampler');
		projectionVector = gl.getUniformLocation (program, 'projectionVector');
		offsetVector = gl.getUniformLocation (program, 'offsetVector');
		colorAttribute = gl.getAttribLocation (program, 'aColor');
		
		aVertexPosition = gl.getAttribLocation (program, 'aVertexPosition');
		aTextureCoord = gl.getAttribLocation (program, 'aTextureCoord');
		
		attributes = [ aVertexPosition, aTextureCoord ];
		
		translationMatrix = gl.getUniformLocation (program, 'translationMatrix');
		alpha = gl.getUniformLocation (program, 'alpha');
		
	}
	
	
}