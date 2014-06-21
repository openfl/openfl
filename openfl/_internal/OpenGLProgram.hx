package openfl._internal;


import lime.graphics.GLProgram;
import lime.graphics.GLRenderContext;
import lime.graphics.GLShader;
import lime.graphics.GLUniformLocation;
import lime.utils.Float32Array;


class OpenGLProgram {
	
	
	public var textureAttribute:Int;
	public var vertexAttribute:Int;
	
	private var contextVersion:Int;
	private var fragmentShader:GLShader;
	private var fragmentShaderSource:String;
	private var gl:GLRenderContext;
	private var program:GLProgram;
	private var vertexShader:GLShader;
	private var vertexShaderSource:String;
	
	private var imageUniform:GLUniformLocation;
	private var modelViewMatrixUniform:GLUniformLocation;
	private var projectionMatrixUniform:GLUniformLocation;
	
	
	public function new (gl:GLRenderContext, vertexShaderSource:String, fragmentShaderSource:String) {
		
		this.gl = gl;
		this.vertexShaderSource = vertexShaderSource;
		this.fragmentShaderSource = fragmentShaderSource;
		
		recreate ();
		
	}
	
	
	public function bind ():Bool {
		
		if (HardwareRenderer.textureContextVersion != contextVersion) {
			
			recreate ();
			
		}
		
		if (program == null) {
			
			return false;
			
		}
		
		gl.useProgram (program);
		return true;
		
	}
	
	
	public static function create (gl:GLRenderContext, id:Int):OpenGLProgram {
		
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
		
		return new OpenGLProgram (gl, vertexShaderSource, fragmentShaderSource);
		
	}
	
	
	public function disableSlots ():Void {
		
		if (vertexAttribute > -1) {
			
			gl.disableVertexAttribArray (vertexAttribute);
			
		}
		
		if (textureAttribute > -1) {
			
			gl.disableVertexAttribArray (textureAttribute);
			
		}
		
	}
	
	
	public function getTextureSlot ():GLUniformLocation {
		
		return imageUniform;
		
	}
	
	
	public function recreate ():Void {
		
		contextVersion = HardwareRenderer.textureContextVersion;
		
		vertexShader = gl.createShader (gl.VERTEX_SHADER);
		gl.shaderSource (vertexShader, vertexShaderSource);
		gl.compileShader (vertexShader);
		
		if (gl.getShaderParameter (vertexShader, gl.COMPILE_STATUS) == 0) {
			
			throw "Error compiling vertex shader";
			
		}
		
		fragmentShader = gl.createShader (gl.FRAGMENT_SHADER);
		gl.shaderSource (fragmentShader, fragmentShaderSource);
		gl.compileShader (fragmentShader);
		
		if (gl.getShaderParameter (fragmentShader, gl.COMPILE_STATUS) == 0) {
			
			throw "Error compiling fragment shader";
			
		}
		
		program = gl.createProgram ();
		gl.attachShader (program, vertexShader);
		gl.attachShader (program, fragmentShader);
		gl.linkProgram (program);
		
		if (gl.getProgramParameter (program, gl.LINK_STATUS) == 0) {
			
			throw "Unable to initialize the shader program.";
			
		}
		
		vertexAttribute = gl.getAttribLocation (program, "aVertexPosition");
		textureAttribute = gl.getAttribLocation (program, "aTexCoord");
		
		projectionMatrixUniform = gl.getUniformLocation (program, "uProjectionMatrix");
		modelViewMatrixUniform = gl.getUniformLocation (program, "uModelViewMatrix");
		imageUniform = gl.getUniformLocation (program, "uImage0");
		
	}
	
	
	public function setModelViewMatrix (matrix:Float32Array):Void {
		
		gl.uniformMatrix4fv (modelViewMatrixUniform, false, matrix);
		
	}
	
	
	public function setProjectionMatrix (matrix:Float32Array):Void {
		
		gl.uniformMatrix4fv (projectionMatrixUniform, false, matrix);
		
	}
	
	
}