package openfl._internal.renderer.context3D.batcher;

import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.WebGLRenderContext;
import lime.utils.Float32Array;
import lime.utils.Int32Array;
import lime.utils.Log;

@SuppressWarnings("checkstyle:FieldDocComment")
class MultiTextureShader
{
	private var program:GLProgram;
	private var gl:WebGLRenderContext;

	public var maxTextures(default, null):Int;
	public var positionScale(default, null):Float32Array;

	public var aVertexPosition(default, null):Int;
	public var aTextureCoord(default, null):Int;
	public var aTextureId(default, null):Int;
	public var aColorOffset(default, null):Int;
	public var aColorMultiplier(default, null):Int;
	public var aPremultipliedAlpha(default, null):Int;

	private var uProjMatrix:GLUniformLocation;
	private var uPositionScale:GLUniformLocation;

	// x, y, u, v, texId, alpha, colorMult, colorOfs
	public static inline var FLOATS_PER_VERTEX = 2 + 2 + 1 + 4 + 4 + 1;

	public function new(gl:WebGLRenderContext)
	{
		this.gl = gl;

		var maxTextures = gl.getParameter(gl.MAX_TEXTURE_IMAGE_UNITS);
		while (maxTextures >= 1)
		{
			var fsSource = generateMultiTextureFragmentShaderSource(maxTextures);

			trace(fsSource);
			trace(vsSource);

			program = createProgram(gl, vsSource, fsSource);
			if (program == null)
			{
				Log.warn("Couldn't compile multi-texture program for " + maxTextures + " samplers, trying twice as less...");
				maxTextures = Std.int(maxTextures / 2);
			}
			else
			{
				break;
			}
		}
		if (program == null)
		{
			throw "Could not compile a multi-texture shader for any number of textures, something must be horribly broken!";
		}
		this.maxTextures = maxTextures;
		this.positionScale = new Float32Array([1.0, 1.0, 1.0, 1.0]);

		aVertexPosition = gl.getAttribLocation(program, 'aVertexPosition');
		aTextureCoord = gl.getAttribLocation(program, 'aTextureCoord');
		aTextureId = gl.getAttribLocation(program, 'aTextureId');
		aColorOffset = gl.getAttribLocation(program, 'aColorOffset');
		aColorMultiplier = gl.getAttribLocation(program, 'aColorMultiplier');
		aPremultipliedAlpha = gl.getAttribLocation(program, 'aPremultipliedAlpha');
		uProjMatrix = gl.getUniformLocation(program, "uProjMatrix");
		uPositionScale = gl.getUniformLocation(program, "uPostionScale");

		gl.useProgram(program);
		gl.uniform1iv(gl.getUniformLocation(program, 'uSamplers'), new Int32Array([for (i in 0...maxTextures) i]));
	}

	public function enable(projectionMatrix:Float32Array):Void
	{
		gl.useProgram(program);

		gl.enableVertexAttribArray(aVertexPosition);
		gl.enableVertexAttribArray(aTextureCoord);
		gl.enableVertexAttribArray(aTextureId);
		gl.enableVertexAttribArray(aColorOffset);
		gl.enableVertexAttribArray(aColorMultiplier);
		gl.enableVertexAttribArray(aPremultipliedAlpha);

		gl.uniformMatrix4fv(uProjMatrix, false, projectionMatrix);
		gl.uniform4fv(uPositionScale, positionScale);
	}

	private static function compileShader(gl:WebGLRenderContext, source:String, type:Int):Null<GLShader>
	{
		var shader = gl.createShader(type);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);

		if (gl.getShaderParameter(shader, gl.COMPILE_STATUS) == 0)
		{
			var message = gl.getShaderInfoLog(shader);
			gl.deleteShader(shader);
			Log.warn(message);
			return null;
		}

		return shader;
	}

	private static function createProgram(gl:WebGLRenderContext, vertexSource:String, fragmentSource:String):Null<GLProgram>
	{
		var vertexShader = compileShader(gl, vertexSource, gl.VERTEX_SHADER);
		if (vertexShader == null)
		{
			return null;
		}

		var fragmentShader = compileShader(gl, fragmentSource, gl.FRAGMENT_SHADER);
		if (fragmentShader == null)
		{
			gl.deleteShader(vertexShader);
			return null;
		}

		var program = gl.createProgram();
		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (gl.getProgramParameter(program, gl.LINK_STATUS) == 0)
		{
			var message = gl.getProgramInfoLog(program);
			Log.warn(message);
			gl.deleteProgram(program);
			gl.deleteShader(vertexShader);
			gl.deleteShader(fragmentShader);
			return null;
		}

		return program;
	}

	private static function generateMultiTextureFragmentShaderSource(numTextures:Int):String
	{
		var select = [];
		if (numTextures > 1)
		{
			select.push('\t\t\t\tvec4 color;');
			select.push('\t\t\t\tfloat textureId = floor(vTextureId+0.5);');
			for (i in 0...numTextures)
			{
				var cond = if (i > 0) "else " else "";
				if (i < numTextures - 1) cond += 'if (textureId == $i.0) ';
				select.push('\t\t\t\t${cond}color = texture2D(uSamplers[$i], vTextureCoord);');
			}
		}
		else
		{
			select.push('\t\t\t\tvec4 color = texture2D(uSamplers[0], vTextureCoord);');
		}
		return '
			#ifdef GL_ES
			#ifdef GL_FRAGMENT_PRECISION_HIGH
			precision highp float;
			#else
			precision mediump float;
			#endif
			#endif

			varying vec2 vTextureCoord;
			varying float vTextureId;
			varying vec4 vColorMultiplier;
			varying vec4 vColorOffset;
			varying float vPremultipliedAlpha;

			uniform sampler2D uSamplers[$numTextures];

			void main(void) {
${select.join("\n")}

				gl_FragColor = color;

				return;
				if (color.a == 0.0) {

					gl_FragColor = vec4 (0.0, 0.0, 0.0, 0.0);

				} else {
						/** mix is a linear interpolation function that interpolates between first and second
						*   parameter, controlled by the third one. The function looks like this:
						*
						*   mix (x, y, a) = x * (1.0 - a) + y * a
						*
						*  As vPremultipliedAlpha is 0.0 or 1.0 we basically switch on/off first or the second paramter
						*  respectively
						*/

						color = vec4 (color.rgb / mix (1.0, color.a, vPremultipliedAlpha), color.a);

						color = vColorOffset + (color * vColorMultiplier);

						gl_FragColor = vec4 (color.rgb * mix (1.0, color.a, vPremultipliedAlpha), color.a);

				}

			}
		';

	}

	private static inline var vsSource:String = '
		attribute vec2 aVertexPosition;
		attribute vec2 aTextureCoord;
		attribute float aTextureId;
		attribute vec4 aColorMultiplier;
		attribute vec4 aColorOffset;
		attribute float aPremultipliedAlpha;

		uniform mat4 uProjMatrix;
		uniform vec4 uPostionScale;

		varying vec2 vTextureCoord;
		varying float vTextureId;
		varying vec4 vColorMultiplier;
		varying vec4 vColorOffset;
		varying float vPremultipliedAlpha;

		void main(void) {
			gl_Position = uProjMatrix * vec4(aVertexPosition, 0, 1) * uPostionScale;
			vTextureCoord = aTextureCoord;
			vTextureId = aTextureId;
			vColorMultiplier = aColorMultiplier;
			vColorOffset = aColorOffset;
			vPremultipliedAlpha = aPremultipliedAlpha;
		}
	';
}
