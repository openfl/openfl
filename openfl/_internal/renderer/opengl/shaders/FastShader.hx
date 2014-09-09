package openfl._internal.renderer.opengl.shaders;


import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.GLRenderContext;


class FastShader extends AbstractShader {
	
	
	public var aPositionCoord:Int;
	public var aRotation:Int;
	public var aScale:Int;
	public var dimensions:GLUniformLocation;
	public var offsetVector:GLUniformLocation;
	public var textureCount:Int;
	public var uMatrix:GLUniformLocation;
	public var uSampler:GLUniformLocation;
	
	
	public function new (gl:GLRenderContext) {
		
		super (gl);
		
		fragmentSrc = [
			#if !desktop
			'precision lowp float;',
			#end
			'varying vec2 vTextureCoord;',
			'varying float vColor;',
			'uniform sampler2D uSampler;',
			'void main(void) {',
			'   gl_FragColor = texture2D(uSampler, vTextureCoord) * vColor ;',
			'}'
		];
		
		vertexSrc = [
			'attribute vec2 aVertexPosition;',
			'attribute vec2 aPositionCoord;',
			'attribute vec2 aScale;',
			'attribute float aRotation;',
			'attribute vec2 aTextureCoord;',
			'attribute float aColor;',
			
			'uniform vec2 projectionVector;',
			'uniform vec2 offsetVector;',
			'uniform mat3 uMatrix;',
			
			'varying vec2 vTextureCoord;',
			'varying float vColor;',
			
			'const vec2 center = vec2(-1.0, 1.0);',
			
			'void main(void) {',
			'   vec2 v;',
			'   vec2 sv = aVertexPosition * aScale;',
			'   v.x = (sv.x) * cos(aRotation) - (sv.y) * sin(aRotation);',
			'   v.y = (sv.x) * sin(aRotation) + (sv.y) * cos(aRotation);',
			'   v = ( uMatrix * vec3(v + aPositionCoord , 1.0) ).xy ;',
			'   gl_Position = vec4( ( v / projectionVector) + center , 0.0, 1.0);',
			'   vTextureCoord = aTextureCoord;',
			//  '   vec3 color = mod(vec3(aColor.y/65536.0, aColor.y/256.0, aColor.y), 256.0) / 256.0;',
			'   vColor = aColor;',
			'}'
		];
		
		textureCount = 0;
		
		init ();
		
	}
	
	
	public override function init ():Void {
		
		super.init ();
		
		var gl = this.gl;
		
		uSampler = gl.getUniformLocation (program, 'uSampler');
		
		projectionVector = gl.getUniformLocation (program, 'projectionVector');
		offsetVector = gl.getUniformLocation (program, 'offsetVector');
		dimensions = gl.getUniformLocation (program, 'dimensions');
		uMatrix = gl.getUniformLocation (program, 'uMatrix');
		
		aVertexPosition = gl.getAttribLocation (program, 'aVertexPosition');
		aPositionCoord = gl.getAttribLocation (program, 'aPositionCoord');
		
		aScale = gl.getAttribLocation (program, 'aScale');
		aRotation = gl.getAttribLocation (program, 'aRotation');
		
		aTextureCoord = gl.getAttribLocation (program, 'aTextureCoord');
		colorAttribute = gl.getAttribLocation (program, 'aColor');
		
		if (colorAttribute == -1) {
			
			colorAttribute = 2;
			
		}
		
		attributes = [ aVertexPosition, aPositionCoord, aScale, aRotation, aTextureCoord, colorAttribute ];
		
	}
	
	
}