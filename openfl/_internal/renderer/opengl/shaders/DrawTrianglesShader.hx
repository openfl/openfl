package openfl._internal.renderer.opengl.shaders;

import lime.graphics.GLRenderContext;
import lime.graphics.opengl.GLUniformLocation;

class DrawTrianglesShader extends AbstractShader {

	public var offsetVector:GLUniformLocation;
	public var translationMatrix:GLUniformLocation;
	public var patternTL:GLUniformLocation;
	public var patternBR:GLUniformLocation;
	public var sampler:GLUniformLocation;
	public var alpha:GLUniformLocation;
	
	public function new(gl:GLRenderContext) {
		super(gl);
		
		vertexSrc = [
			'attribute vec2 aVertexPosition;',
			'attribute vec2 aTextureCoord;',
			'attribute vec4 aColor;',
			'uniform mat3 translationMatrix;',
			'uniform vec2 projectionVector;',
			'uniform vec2 offsetVector;',
			
			'varying vec2 vPos;',
			'varying vec4 vColor;',
			
			'void main(void) {',
			//'   vec3 v = translationMatrix * vec3(aVertexPosition , 1.0);',
			'   vec3 v = vec3(aVertexPosition , 1.0);',
			'   v -= offsetVector.xyx;',
			'   gl_Position = vec4( v.x / projectionVector.x -1.0, v.y / -projectionVector.y + 1.0 , 0.0, 1.0);',
			'   vPos = aTextureCoord;',
			'   vColor = aColor;',
			'}',

		];
		
		fragmentSrc = [
			'precision mediump float;',
			'uniform sampler2D sampler;',
			'uniform float alpha;',
			
			'varying vec2 vPos;',
			'varying vec4 vColor;',
			
			'void main(void) {',
			'   vec4 tcol = texture2D(sampler, vPos);',
			'   float a = tcol.a * vColor.a * alpha;',
			'   gl_FragColor = vec4(vec3((tcol.rgb * vColor.rgb) * a), a);',
			'}'
		];
		
		init ();
		
	}
	
	public override function init ():Void {
		
		super.init ();
		
		translationMatrix = gl.getUniformLocation (program, 'translationMatrix');
		projectionVector = gl.getUniformLocation (program, 'projectionVector');
		offsetVector = gl.getUniformLocation (program, 'offsetVector');
		
		sampler = gl.getUniformLocation (program, 'sampler');
		alpha = gl.getUniformLocation (program, 'alpha');
		
		aVertexPosition = gl.getAttribLocation (program, 'aVertexPosition');
		aTextureCoord = gl.getAttribLocation (program, 'aTextureCoord');
		colorAttribute = gl.getAttribLocation (program, 'aColor');
		
		attributes = [aVertexPosition, aTextureCoord, colorAttribute];
		
	}
	
}