package openfl.display.renderer;


import lime.graphics.GLProgram;
import lime.graphics.GLUniformLocation;
import lime.graphics.GLRenderContext;


class OpenGLRenderer /*extends Renderer*/ {
	
	
	public static var background:Int;
	public static var currentProgram:GLProgram;
	public static var height:Int;
	public static var width:Int;
	
	public static var gl:GLRenderContext;
	
	public static var imageUniform:GLUniformLocation;
	public static var modelViewMatrixUniform:GLUniformLocation;
	public static var projectionMatrixUniform:GLUniformLocation;
	public static var texCoordAttribute:Int;
	public static var vertexAttribute:Int;
	
	
	/*public function new () {
		
		super ();
		
	}*/
	
	
	public static function begin ():Void {
		
		initializeShaders ();
		
		var r = ((background >> 16) & 0xFF) / 0xFF;
		var g = ((background >> 8) & 0xFF) / 0xFF;
		var b = (background & 0xFF) / 0xFF;
		var a = ((background >> 24) & 0xFF) / 0xFF;
		
		gl.clearColor (r, g, b, a);
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		vertexAttribute = gl.getAttribLocation (currentProgram, "aVertexPosition");
		texCoordAttribute = gl.getAttribLocation (currentProgram, "aTexCoord");
		projectionMatrixUniform = gl.getUniformLocation (currentProgram, "uProjectionMatrix");
		modelViewMatrixUniform = gl.getUniformLocation (currentProgram, "uModelViewMatrix");
		imageUniform = gl.getUniformLocation (currentProgram, "uImage0");
		
		gl.useProgram (currentProgram);
		gl.enableVertexAttribArray (vertexAttribute);
		gl.enableVertexAttribArray (texCoordAttribute);
		
	}
	
	
	public static function finish ():Void {
		
		gl.disableVertexAttribArray (vertexAttribute);
		gl.disableVertexAttribArray (texCoordAttribute);
		gl.useProgram (null);
		
	}
	
	
	private static function initializeShaders ():Void {
		
		var vertexShaderSource = 
			
			"attribute vec3 aVertexPosition;
			attribute vec2 aTexCoord;
			varying vec2 vTexCoord;
			
			uniform mat4 uModelViewMatrix;
			uniform mat4 uProjectionMatrix;
			
			void main(void) {
				vTexCoord = aTexCoord;
				gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
			}";
		
		var vertexShader = gl.createShader (gl.VERTEX_SHADER);
		gl.shaderSource (vertexShader, vertexShaderSource);
		gl.compileShader (vertexShader);
		
		if (gl.getShaderParameter (vertexShader, gl.COMPILE_STATUS) == 0) {
			
			throw "Error compiling vertex shader";
			
		}
		
		var fragmentShaderSource = 
			
			#if !desktop
			"precision mediump float;" +
			#end
			"varying vec2 vTexCoord;
			uniform sampler2D uImage0;
			
			void main(void)
			{
				gl_FragColor = texture2D (uImage0, vTexCoord);
			}";
		
		var fragmentShader = gl.createShader (gl.FRAGMENT_SHADER);
		gl.shaderSource (fragmentShader, fragmentShaderSource);
		gl.compileShader (fragmentShader);
		
		if (gl.getShaderParameter (fragmentShader, gl.COMPILE_STATUS) == 0) {
			
			throw "Error compiling fragment shader";
			
		}
		
		var shaderProgram = gl.createProgram ();
		gl.attachShader (shaderProgram, vertexShader);
		gl.attachShader (shaderProgram, fragmentShader);
		gl.linkProgram (shaderProgram);
		
		if (gl.getProgramParameter (shaderProgram, gl.LINK_STATUS) == 0) {
			
			throw "Unable to initialize the shader program.";
			
		}
		
		currentProgram = shaderProgram;
		
	}
	
	
	public function render (commands:Dynamic):Void {
		
		/*var positionX = 0;
		var positionY = 0;
		
		var projectionMatrix = new Float32Array ([ 2 / width, 0, 0, 0, 0, 2 / height, 0, 0, 0, 0, -0.0001, 0, -1, -1, 1, 1 ]);
		
		var rotation = 0;
		var scale = 1;
		var theta = rotation * Math.PI / 180;
		var c = Math.cos (theta);
		var s = Math.sin (theta);
		
		var modelViewMatrix = new Float32Array ([ c * scale, -s * scale, 0, 0, s * scale, c * scale, 0, 0, 0, 0, 1, 0, positionX, positionY, 0, 1 ]);
		
		gl.activeTexture (gl.TEXTURE0);
		gl.bindTexture (gl.TEXTURE_2D, texture);
		
		#if desktop
		gl.enable (gl.TEXTURE_2D);
		#end
		
		gl.bindBuffer (gl.ARRAY_BUFFER, vertexBuffer);
		gl.vertexAttribPointer (vertexAttribute, 3, gl.FLOAT, false, 0, 0);
		gl.bindBuffer (gl.ARRAY_BUFFER, texCoordBuffer);
		gl.vertexAttribPointer (texCoordAttribute, 2, gl.FLOAT, false, 0, 0);
		
		gl.uniformMatrix4fv (projectionMatrixUniform, false, projectionMatrix);
		gl.uniformMatrix4fv (modelViewMatrixUniform, false, modelViewMatrix);
		gl.uniform1i (imageUniform, 0);
		
		gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
		
		gl.bindBuffer (gl.ARRAY_BUFFER, null);
		gl.bindTexture (gl.TEXTURE_2D, null);
		
		#if desktop
		gl.disable (gl.TEXTURE_2D);
		#end*/
		
	}
	
	
}