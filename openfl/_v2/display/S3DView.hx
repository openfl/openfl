package openfl._v2.display; #if lime_legacy
import openfl.gl.GL;
import openfl.gl.GLFramebuffer;
import openfl.gl.GLRenderbuffer;
import openfl.gl.GLTexture;
import openfl.gl.GLBuffer;
import openfl.gl.GLProgram;
import openfl.gl.GLUniformLocation;
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.geom.Matrix3D;
import openfl.geom.Vector3D;
import openfl.geom.Rectangle;
import openfl.display.OpenGLView;
import openfl.utils.Float32Array;
import openfl.utils.UInt8Array;
import openfl.utils.Int32Array;
import openfl.Assets;
import haxe.Timer;

enum Eye {
	LEFT;
	RIGHT;
	MIDDLE;
}

class S3DView extends OpenGLView {

	// texture/vertex buffers
	private static var texCoordAttribute:Int;
	private static var texCoordBuffer:GLBuffer;
	private static var vertexAttribute:Int;
	private static var vertexBuffer:GLBuffer;

	// uniforms
	private static var leftImageUniform:GLUniformLocation;
	private static var rightImageUniform:GLUniformLocation;
	private static var modelViewMatrixUniform:GLUniformLocation;
	private static var projectionMatrixUniform:GLUniformLocation;
	private static var pixelSizeUniform:GLUniformLocation;
	private static var screenUniform:GLUniformLocation;

	private static var shaderProgram:GLProgram;
	
	// pixelSize maps gl_FragCoord to the range [0.0, 1.0]
	private static var pixelSizeX:Float;
	private static var pixelSizeY:Float;

	// frame/render buffers and eye textures
	private static var frameBuffer:GLFramebuffer;
	private static var leftTexture:GLTexture;
	private static var renderBuffer:GLRenderbuffer;
	private static var rightTexture:GLTexture;

	// dimensions of eye textures
	private static var eyeResolutionX:Float;
	private static var eyeResolutionY:Float;

	// S3D parameters
	public static var separation:Float = 0.01;
	public static var focalLength:Float = 1.0;
	public static var angleDirection:Float = 1;
	public static var setup:Bool = false;

	public function new() {
		super();

		// only perform initialization if the platform supports S3D
		if(S3D.supported) {
			initializeShaders();
		}
	}

	private function initializeShaders ():Void {
		
		// compile vertex shader
		var vertexShaderSource = "
            attribute vec3 aVertexPosition;
            attribute vec2 aTexCoord;
            varying vec2 vTexCoord;

            uniform mat4 uModelViewMatrix;
            uniform mat4 uProjectionMatrix;

            void main(void) {
                vTexCoord = aTexCoord;
                gl_Position = uProjectionMatrix * uModelViewMatrix * vec4 (aVertexPosition, 1.0);
            }
        ";
		var vertexShader = GL.createShader (GL.VERTEX_SHADER);
		GL.shaderSource (vertexShader, vertexShaderSource);
		GL.compileShader (vertexShader);

		if (GL.getShaderParameter (vertexShader, GL.COMPILE_STATUS) == 0) {
			throw "Error compiling fragment shader: " + GL.getShaderInfoLog(vertexShader);
		}
		
		// compile fragment shader
		var fragmentShaderSource = "
            varying vec2 vTexCoord;
            uniform sampler2D uLeft;
            uniform sampler2D uRight;
            uniform vec2 pixelSize;
            uniform vec2 screen;

            void main(void)
            {
                float parity = mod(gl_FragCoord.x, 2.0);
                vec2 sampleCoord = gl_FragCoord.xy * pixelSize.xy * vec2(1.0, 1.0);
                vec4 left = texture2D (uLeft, sampleCoord).rgba;
                vec4 right = texture2D (uRight, sampleCoord).rgba;

                if(parity >= 1.0) {
                    gl_FragColor = right;
                } else {
                    gl_FragColor = left;
                }
            }
		";
		var fragmentShader = GL.createShader (GL.FRAGMENT_SHADER);
		#if mobile
		fragmentShaderSource = "precision highp float;\n" + fragmentShaderSource;
		#end
		GL.shaderSource (fragmentShader, fragmentShaderSource);
		GL.compileShader (fragmentShader);
		
		if (GL.getShaderParameter (fragmentShader, GL.COMPILE_STATUS) == 0) {
			throw "Error compiling fragment shader: " + GL.getShaderInfoLog(fragmentShader);
		}
		
		// link shader program
		shaderProgram = GL.createProgram ();
		GL.attachShader (shaderProgram, vertexShader);
		GL.attachShader (shaderProgram, fragmentShader);
		GL.linkProgram (shaderProgram);
		if (GL.getProgramParameter (shaderProgram, GL.LINK_STATUS) == 0) {
			throw "Unable to initialize the shader program." + GL.getProgramInfoLog(shaderProgram);
		}
		
		// locate attributes and uniforms
		vertexAttribute         = GL.getAttribLocation (shaderProgram, "aVertexPosition");
		texCoordAttribute       = GL.getAttribLocation (shaderProgram, "aTexCoord");
		projectionMatrixUniform = GL.getUniformLocation (shaderProgram, "uProjectionMatrix");
		modelViewMatrixUniform  = GL.getUniformLocation (shaderProgram, "uModelViewMatrix");
		leftImageUniform        = GL.getUniformLocation (shaderProgram, "uLeft");
		rightImageUniform       = GL.getUniformLocation (shaderProgram, "uRight");
		pixelSizeUniform        = GL.getUniformLocation (shaderProgram, "pixelSize");
		screenUniform           = GL.getUniformLocation (shaderProgram, "screen");
	}

	/**
	 * Set fn as the render callback for the underlying OpenGLView. This works
	 * by wrapping the supplied function in an anonymous function which invokes
	 * the callback once per eye. With S3D disabled, the callback is invoked
	 * only once for the "middle" eye. When S3D is enabled, it is called twice,
	 * once for the left eye and once for the right eye.
	 *
	 * The eye views are composited by rendering to a pair of textures, then interlacing
	 * the resulting images according to the hardware's S3D implementation. Callbacks
	 * are provided with a depth buffer to allow depth testing when desired.
	 */
	public function setRender(fn:Eye->Rectangle->Void) {

		// create anonymous wrapper function
		render = function(r:Rectangle) {

			// bail if S3D is disabled, invoking the normal render callback
			if(S3D.enabled == false) {
				fn(MIDDLE, r);
				return;
			}

			// setup to be run on first frame
			// TODO: this should probably be done whenever the viewport is resized
			if(!setup) {

				setup = true;
				createBuffers(r);

				// TODO: depends on S3D hardware implementation
				eyeResolutionX  = r.width; // / 2;
				eyeResolutionY  = r.height;

				// pixelSize scales gl_FragCoord to NDCs
				pixelSizeX = 1.0 / eyeResolutionX;
				pixelSizeY = 1.0 / eyeResolutionY;

				// texture sizes are the first largest powers of two
				var textureWidth:Int = Math.floor(r.width); // Math.floor(Math.pow(2, 1 + Math.ceil(Math.log(eyeResolutionX) / Math.log(2))));
				var textureHeight:Int = Math.floor(r.height); // Math.floor(Math.pow(2, 1 + Math.ceil(Math.log(eyeResolutionY) / Math.log(2))));

				// create all of our buffers and textures
				frameBuffer = GL.createFramebuffer();
				renderBuffer = GL.createRenderbuffer();
				leftTexture = GL.createTexture();
				rightTexture = GL.createTexture();

				// configure left texture
				GL.bindTexture(GL.TEXTURE_2D, leftTexture);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
				GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, textureWidth, textureHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
				GL.bindTexture(GL.TEXTURE_2D, null);

				// configure right texture
				GL.bindTexture(GL.TEXTURE_2D, rightTexture);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_S, GL.REPEAT);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_WRAP_T, GL.REPEAT);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MAG_FILTER, GL.LINEAR);
				GL.texParameteri (GL.TEXTURE_2D, GL.TEXTURE_MIN_FILTER, GL.LINEAR);
				GL.texImage2D(GL.TEXTURE_2D, 0, GL.RGBA, textureWidth, textureHeight, 0, GL.RGBA, GL.UNSIGNED_BYTE, null);
				GL.bindTexture(GL.TEXTURE_2D, null);

				// create depth buffer
				GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
				GL.bindFramebuffer(GL.FRAMEBUFFER, frameBuffer);
				GL.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, textureWidth, textureHeight);
				GL.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, renderBuffer);
			}

			var err:Int;

			GL.bindTexture(GL.TEXTURE_2D, null);
			GL.bindFramebuffer(GL.FRAMEBUFFER, frameBuffer);
			GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
			GL.bindTexture(GL.TEXTURE_2D, rightTexture);
			GL.framebufferTexture2D(
				GL.FRAMEBUFFER,
				GL.COLOR_ATTACHMENT0,
				GL.TEXTURE_2D, rightTexture, 0);

			// err = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
			// if(err != GL.FRAMEBUFFER_COMPLETE) {
			// 	throw err;
			// }

			GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
			fn(RIGHT, r);

			GL.bindTexture(GL.TEXTURE_2D, null);
			GL.bindFramebuffer(GL.FRAMEBUFFER, frameBuffer);
			GL.bindRenderbuffer(GL.RENDERBUFFER, renderBuffer);
			GL.bindTexture(GL.TEXTURE_2D, leftTexture);
			GL.framebufferTexture2D(
				GL.FRAMEBUFFER,
				GL.COLOR_ATTACHMENT0,
				GL.TEXTURE_2D, leftTexture, 0);
			// err = GL.checkFramebufferStatus(GL.FRAMEBUFFER);
			// if(err != GL.FRAMEBUFFER_COMPLETE) {
			// 	throw err;
			// }

			GL.clear(GL.DEPTH_BUFFER_BIT | GL.COLOR_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
			fn(LEFT, r);

			// unbind our buffers
			GL.bindFramebuffer(GL.FRAMEBUFFER, null);
			GL.bindRenderbuffer(GL.RENDERBUFFER, null);

			// perform actual image compositing
			compositeS3D(r);
		}
	}

	/**
	 * Utility function for calculating the approriate view matrix given the
	 * user's default (or middle-eye) view matrix and the eye being rendered
	 * for.
	 */
	public static function getEyeViewMatrix(m:Matrix3D, eye:Eye) {
		var theta = Math.atan(separation / focalLength);
		var result = new Matrix3D();
		var separationDirection = -1;

		if(eye == LEFT) {
			separationDirection *= -1;
			theta *= -1;
		} else if(eye == MIDDLE) {
			separationDirection = 0;
			theta = 0;
		}

		// TODO: this math seems a bit backwards. I think it won't work when the
		// camera is not on the origin
		result.append(m);
		result.appendTranslation(separationDirection * separation, 0, 0);
		result.appendRotation(angleDirection * theta / (Math.PI * 2) * 360, new Vector3D(0, 1.0, 0));
		return result;
	}

	private function createBuffers(r:Rectangle) {
		var vertices = [
			
			r.width, r.height, 0,
			      0, r.height, 0,
			r.width,        0, 0,
			      0,        0, 0
			
		];
		
		vertexBuffer = GL.createBuffer ();
		GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast vertices), GL.STATIC_DRAW);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		
		var texCoords = [
			
			0, 1, 
			1, 1, 
			0, 0, 
			1, 0, 
			
		];
		
		texCoordBuffer = GL.createBuffer ();
		GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);	
		GL.bufferData (GL.ARRAY_BUFFER, new Float32Array (cast texCoords), GL.STATIC_DRAW);
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
	}

	/**
	 * Composite the left and right eye images into a final image. All we're
	 * doing here is rendering a full-screen quad and shading it with our
	 * multiplexing shader program, passing in each eye as input.
	 */
	private function compositeS3D(rect:Rectangle) {

		// clear and configure viewport
		GL.viewport (Std.int (rect.x), Std.int (rect.y), Std.int (rect.width), Std.int (rect.height));
		GL.clearColor (0.0, 0.0, 1.0, 1.0);
		GL.clear (GL.COLOR_BUFFER_BIT | GL.DEPTH_BUFFER_BIT | GL.STENCIL_BUFFER_BIT);
		
		// TODO: these should all be NDCs
		var projectionMatrix = Matrix3D.createOrtho (0, rect.width, rect.height, 0, 1000, -1000);
		var modelViewMatrix = new Matrix3D();

		// use the multiplexing shader
		GL.useProgram (shaderProgram);
		GL.enableVertexAttribArray (vertexAttribute);
		GL.enableVertexAttribArray (texCoordAttribute);
		
		#if desktop
		GL.enable (GL.TEXTURE_2D);
		#end
		
		GL.bindBuffer (GL.ARRAY_BUFFER, vertexBuffer);
		GL.vertexAttribPointer (vertexAttribute, 3, GL.FLOAT, false, 0, 0);

		GL.bindBuffer (GL.ARRAY_BUFFER, texCoordBuffer);
		GL.vertexAttribPointer (texCoordAttribute, 2, GL.FLOAT, false, 0, 0);

		// bind left eye texture
		GL.activeTexture (GL.TEXTURE0);
		GL.bindTexture (GL.TEXTURE_2D, leftTexture);
		GL.uniform1i (leftImageUniform, 0);
		
		// bind right eye texture
		GL.activeTexture (GL.TEXTURE1);
		GL.bindTexture (GL.TEXTURE_2D, rightTexture);
		GL.uniform1i (rightImageUniform, 1);

		// supply our matrices and screen info
		GL.uniformMatrix3D (projectionMatrixUniform, false, projectionMatrix);
		GL.uniformMatrix3D (modelViewMatrixUniform, false, modelViewMatrix);
		GL.uniform2f(pixelSizeUniform, 1/rect.width, 1/rect.height);
		GL.uniform2f(screenUniform, rect.width, rect.height);
		
		// here's where the magic happens
		GL.drawArrays (GL.TRIANGLE_STRIP, 0, 4);
		
		#if desktop
		GL.disable (GL.TEXTURE_2D);
		#end

		// clean up
		GL.bindBuffer (GL.ARRAY_BUFFER, null);
		GL.bindTexture (GL.TEXTURE_2D, null);
		GL.disableVertexAttribArray (vertexAttribute);
		GL.disableVertexAttribArray (texCoordAttribute);
		GL.useProgram (null);
	}
}


#end