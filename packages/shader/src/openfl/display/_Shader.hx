package openfl.display;

#if openfl_gl
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import openfl._internal.renderer.ShaderBuffer;
import lime.utils.Float32Array;
import openfl._internal.utils.Log;
import openfl.display3D.Context3D;
import openfl.display3D._Context3D;
import openfl.display.BitmapData;
import openfl.display.Shader;
import openfl.display.ShaderData;
import openfl.display.ShaderInput;
import openfl.display.ShaderParameter;
import openfl.display.ShaderParameterType;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D._Program3D)
@:access(openfl.display.ShaderInput)
@:access(openfl.display._ShaderInput)
@:access(openfl.display.ShaderParameter)
@:access(openfl.display._ShaderParameter)
@:access(openfl.display.Shader)
@:noCompletion
class _Shader
{
	public var context:Context3D;
	public var gl:WebGLRenderContext;
	public var inputBitmapData:Array<ShaderInput<BitmapData>>;
	public var numPasses:Int;
	public var paramBool:Array<ShaderParameter<Bool>>;
	public var paramFloat:Array<ShaderParameter<Float>>;
	public var paramInt:Array<ShaderParameter<Int>>;

	private var shader:Shader;

	public function new(shader:Shader)
	{
		this.shader = shader;
	}

	public function clearUseArray():Void
	{
		for (parameter in paramBool)
		{
			parameter._.useArray = false;
		}

		for (parameter in paramFloat)
		{
			parameter._.useArray = false;
		}

		for (parameter in paramInt)
		{
			parameter._.useArray = false;
		}
	}

	public function createGLShader(source:String, type:Int):GLShader
	{
		var shader = gl.createShader(type);
		gl.shaderSource(shader, source);
		gl.compileShader(shader);

		if (gl.getShaderParameter(shader, GL.COMPILE_STATUS) == 0)
		{
			var message = (type == GL.VERTEX_SHADER) ? "Error compiling vertex shader" : "Error compiling fragment shader";
			message += "\n" + gl.getShaderInfoLog(shader);
			message += "\n" + source;
			Log.error(message);
		}

		return shader;
	}

	public function createGLProgram(vertexSource:String, fragmentSource:String):GLProgram
	{
		var vertexShader = createGLShader(vertexSource, GL.VERTEX_SHADER);
		var fragmentShader = createGLShader(fragmentSource, GL.FRAGMENT_SHADER);

		var program = gl.createProgram();

		// Fix support for drivers that don't draw if attribute 0 is disabled
		for (param in paramFloat)
		{
			if (param.name.indexOf("Position") > -1 && StringTools.startsWith(param.name, "openfl_"))
			{
				gl.bindAttribLocation(program, 0, param.name);
				break;
			}
		}

		gl.attachShader(program, vertexShader);
		gl.attachShader(program, fragmentShader);
		gl.linkProgram(program);

		if (gl.getProgramParameter(program, GL.LINK_STATUS) == 0)
		{
			var message = "Unable to initialize the shader program";
			message += "\n" + gl.getProgramInfoLog(program);
			Log.error(message);
		}

		return program;
	}

	public function disable():Void
	{
		if (shader.program != null)
		{
			disableGL();
		}
	}

	public function disableGL():Void
	{
		var textureCount = 0;

		for (input in inputBitmapData)
		{
			input._.disableGL(context, textureCount);
			textureCount++;
		}

		for (parameter in paramBool)
		{
			parameter._.disableGL(context);
		}

		for (parameter in paramFloat)
		{
			parameter._.disableGL(context);
		}

		for (parameter in paramInt)
		{
			parameter._.disableGL(context);
		}

			(context._ : _Context3D).bindGLArrayBuffer(null);

		#if lime
		if ((context._ : _Context3D).limeContext.type == OPENGL)
		{
			gl.disable(gl.TEXTURE_2D);
		}
		#end
	}

	public function enable():Void
	{
		init();

		if (shader.program != null)
		{
			enableGL();
		}
	}

	public function enableGL():Void
	{
		var textureCount = 0;

		for (input in inputBitmapData)
		{
			gl.uniform1i(input.index, textureCount);
			textureCount++;
		}

		#if lime
		if ((context._ : _Context3D).limeContext.type == OPENGL && textureCount > 0)
		{
			gl.enable(gl.TEXTURE_2D);
		}
		#end
	}

	public function init(context3D:Context3D = null):Void
	{
		if (context3D != null)
		{
			this.context = context3D;
			gl = (context._ : _Context3D).gl;
		}

		if (shader._.__data == null)
		{
			shader._.__data = cast new ShaderData(null);
		}

		if (shader._.__glFragmentSource != null
			&& shader._.__glVertexSource != null
			&& (shader.program == null || shader._.__glSourceDirty))
		{
			initGL();
		}
	}

	public function initGL():Void
	{
		if (shader._.__glSourceDirty || paramBool == null)
		{
			shader._.__glSourceDirty = false;
			shader.program = null;

			inputBitmapData = new Array();
			paramBool = new Array();
			paramFloat = new Array();
			paramInt = new Array();

			processGLData(shader._.__glVertexSource, "attribute");
			processGLData(shader._.__glVertexSource, "uniform");
			processGLData(shader._.__glFragmentSource, "uniform");
		}

		if (context != null && shader.program == null)
		{
			var prefix = "#ifdef GL_ES
				"
				+ (shader.precisionHint == FULL ? "#ifdef GL_FRAGMENT_PRECISION_HIGH
				precision highp float;
				#else
				precision mediump float;
				#endif" : "precision lowp float;")
				+ "
				#endif
				";

			var vertex = prefix + shader._.__glVertexSource;
			var fragment = prefix + shader._.__glFragmentSource;

			var id = vertex + fragment;

			if ((context._ : _Context3D).__programs.exists(id))
			{
				shader.program = (context._ : _Context3D).__programs.get(id);
			}
			else
			{
				shader.program = context.createProgram(GLSL);

				// TODO
				// program.uploadSources (vertex, fragment);
				shader.program._.glProgram = createGLProgram(vertex, fragment);

				(context._ : _Context3D).__programs.set(id, shader.program);
			}

			if (shader.program != null)
			{
				shader.glProgram = shader.program._.glProgram;

				for (input in inputBitmapData)
				{
					if (input._.isUniform)
					{
						(input._ : _ShaderInput<BitmapData>).index = gl.getUniformLocation(shader.glProgram, input.name);
					}
					else
					{
						(input._ : _ShaderInput<BitmapData>).index = gl.getAttribLocation(shader.glProgram, input.name);
					}
				}

				for (parameter in paramBool)
				{
					if (parameter._.isUniform)
					{
						(parameter._ : _ShaderParameter<Bool>).index = gl.getUniformLocation(shader.glProgram, parameter.name);
					}
					else
					{
						(parameter._ : _ShaderParameter<Bool>).index = gl.getAttribLocation(shader.glProgram, parameter.name);
					}
				}

				for (parameter in paramFloat)
				{
					if (parameter._.isUniform)
					{
						(parameter._ : _ShaderParameter<Float>).index = gl.getUniformLocation(shader.glProgram, parameter.name);
					}
					else
					{
						(parameter._ : _ShaderParameter<Float>).index = gl.getAttribLocation(shader.glProgram, parameter.name);
					}
				}

				for (parameter in paramInt)
				{
					if (parameter._.isUniform)
					{
						(parameter._ : _ShaderParameter<Int>).index = gl.getUniformLocation(shader.glProgram, parameter.name);
					}
					else
					{
						(parameter._ : _ShaderParameter<Int>).index = gl.getAttribLocation(shader.glProgram, parameter.name);
					}
				}
			}
		}
	}

	public function processGLData(source:String, storageType:String):Void
	{
		var lastMatch = 0, position, regex, name, type;

		if (storageType == "uniform")
		{
			regex = ~/uniform ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
		}
		else
		{
			regex = ~/attribute ([A-Za-z0-9]+) ([A-Za-z0-9_]+)/;
		}

		while (regex.matchSub(source, lastMatch))
		{
			type = regex.matched(1);
			name = regex.matched(2);

			if (StringTools.startsWith(name, "gl_"))
			{
				continue;
			}

			var isUniform = (storageType == "uniform");

			if (StringTools.startsWith(type, "sampler"))
			{
				var input = new ShaderInput<BitmapData>();
				input.name = name;
				input._.isUniform = isUniform;
				inputBitmapData.push(input);

				switch (name)
				{
					case "openfl_AlphaTexture":
						shader._.__alphaTexture = input;
					case "openfl_Texture":
						shader._.__texture = input;
					case "bitmap":
						shader._.__bitmap = input;
					default:
				}

				Reflect.setField(shader._.__data, name, input);
				if (shader._.__isGenerated) Reflect.setField(shader, name, input);
			}
			else if (!Reflect.hasField(shader._.__data, name) || Reflect.field(shader._.__data, name) == null)
			{
				var parameterType:ShaderParameterType = switch (type)
				{
					case "bool": BOOL;
					case "double", "float": FLOAT;
					case "int", "uint": INT;
					case "bvec2": BOOL2;
					case "bvec3": BOOL3;
					case "bvec4": BOOL4;
					case "ivec2", "uvec2": INT2;
					case "ivec3", "uvec3": INT3;
					case "ivec4", "uvec4": INT4;
					case "vec2", "dvec2": FLOAT2;
					case "vec3", "dvec3": FLOAT3;
					case "vec4", "dvec4": FLOAT4;
					case "mat2", "mat2x2": MATRIX2X2;
					case "mat2x3": MATRIX2X3;
					case "mat2x4": MATRIX2X4;
					case "mat3x2": MATRIX3X2;
					case "mat3", "mat3x3": MATRIX3X3;
					case "mat3x4": MATRIX3X4;
					case "mat4x2": MATRIX4X2;
					case "mat4x3": MATRIX4X3;
					case "mat4", "mat4x4": MATRIX4X4;
					default: null;
				}

				var length = switch (parameterType)
				{
					case BOOL2, INT2, FLOAT2: 2;
					case BOOL3, INT3, FLOAT3: 3;
					case BOOL4, INT4, FLOAT4, MATRIX2X2: 4;
					case MATRIX3X3: 9;
					case MATRIX4X4: 16;
					default: 1;
				}

				var arrayLength = switch (parameterType)
				{
					case MATRIX2X2: 2;
					case MATRIX3X3: 3;
					case MATRIX4X4: 4;
					default: 1;
				}

				switch (parameterType)
				{
					case BOOL, BOOL2, BOOL3, BOOL4:
						var parameter = new ShaderParameter<Bool>();
						parameter.name = name;
						parameter._.type = parameterType;
						parameter._.arrayLength = arrayLength;
						parameter._.isBool = true;
						parameter._.isUniform = isUniform;
						parameter._.length = length;
						paramBool.push(parameter);

						if (name == "openfl_HasColorTransform")
						{
							shader._.__hasColorTransform = parameter;
						}

						Reflect.setField(shader._.__data, name, parameter);
						if (shader._.__isGenerated) Reflect.setField(shader, name, parameter);

					case INT, INT2, INT3, INT4:
						var parameter = new ShaderParameter<Int>();
						parameter.name = name;
						parameter._.type = parameterType;
						parameter._.arrayLength = arrayLength;
						parameter._.isInt = true;
						parameter._.isUniform = isUniform;
						parameter._.length = length;
						paramInt.push(parameter);
						Reflect.setField(shader._.__data, name, parameter);
						if (shader._.__isGenerated) Reflect.setField(shader, name, parameter);

					default:
						var parameter = new ShaderParameter<Float>();
						parameter.name = name;
						parameter._.type = parameterType;
						parameter._.arrayLength = arrayLength;
						if (arrayLength > 0) parameter._.uniformMatrix = new Float32Array(arrayLength * arrayLength);
						parameter._.isFloat = true;
						parameter._.isUniform = isUniform;
						parameter._.length = length;
						paramFloat.push(parameter);

						if (StringTools.startsWith(name, "openfl_"))
						{
							switch (name)
							{
								case "openfl_Alpha": shader._.__alpha = parameter;
								case "openfl_AlphaTextureMatrix": shader._.__alphaTextureMatrix = parameter;
								case "openfl_ColorMultiplier": shader._.__colorMultiplier = parameter;
								case "openfl_ColorOffset": shader._.__colorOffset = parameter;
								case "openfl_Matrix": shader._.__matrix = parameter;
								case "openfl_Position": shader._.__position = parameter;
								case "openfl_TextureCoord": shader._.__textureCoord = parameter;
								case "openfl_TextureSize": shader._.__textureSize = parameter;
								default:
							}
						}

						Reflect.setField(shader._.__data, name, parameter);
						if (shader._.__isGenerated) Reflect.setField(shader, name, parameter);
				}
			}

			position = regex.matchedPos();
			lastMatch = position.pos + position.len;
		}
	}

	public function update():Void
	{
		if (shader.program != null)
		{
			updateGL();
		}
	}

	public function updateFromBuffer(shaderBuffer:ShaderBuffer, bufferOffset:Int):Void
	{
		if (shader.program != null)
		{
			updateGLFromBuffer(shaderBuffer, bufferOffset);
		}
	}

	public function updateGL():Void
	{
		var textureCount = 0;

		for (input in inputBitmapData)
		{
			input._.updateGL(context, textureCount);
			textureCount++;
		}

		for (parameter in paramBool)
		{
			parameter._.updateGL(context);
		}

		for (parameter in paramFloat)
		{
			parameter._.updateGL(context);
		}

		for (parameter in paramInt)
		{
			parameter._.updateGL(context);
		}
	}

	public function updateGLFromBuffer(shaderBuffer:ShaderBuffer, bufferOffset:Int):Void
	{
		var textureCount = 0;
		var input, inputData, inputFilter, inputMipFilter, inputWrap;

		for (i in 0...shaderBuffer.inputCount)
		{
			input = shaderBuffer.inputRefs[i];
			inputData = shaderBuffer.inputs[i];
			inputFilter = shaderBuffer.inputFilter[i];
			inputMipFilter = shaderBuffer.inputMipFilter[i];
			inputWrap = shaderBuffer.inputWrap[i];

			if (inputData != null)
			{
				input._.updateGL(context, textureCount, inputData, inputFilter, inputMipFilter, inputWrap);
				textureCount++;
			}
		}

		if (shaderBuffer.paramDataLength > 0)
		{
			if (shaderBuffer.paramDataBuffer == null)
			{
				shaderBuffer.paramDataBuffer = gl.createBuffer();
			}

			// Log.verbose ("bind param data buffer (length: " + shaderBuffer.paramData.length + ") (" + shaderBuffer.paramCount + ")");

			(context._ : _Context3D).bindGLArrayBuffer(shaderBuffer.paramDataBuffer);
			gl.bufferData(GL.ARRAY_BUFFER, shaderBuffer.paramData, GL.DYNAMIC_DRAW);
		}
		else
		{
			// Log.verbose ("bind buffer null");

			(context._ : _Context3D).bindGLArrayBuffer(null);
		}

		var boolIndex = 0;
		var floatIndex = 0;
		var intIndex = 0;

		var boolCount = shaderBuffer.paramBoolCount;
		var floatCount = shaderBuffer.paramFloatCount;
		var paramData = shaderBuffer.paramData;

		var boolRef, floatRef, intRef, hasOverride;
		var overrideBoolValue:Array<Bool> = null,
			overrideFloatValue:Array<Float> = null,
			overrideIntValue:Array<Int> = null;

		for (i in 0...shaderBuffer.paramCount)
		{
			hasOverride = false;

			if (i < boolCount)
			{
				boolRef = shaderBuffer.paramRefs_Bool[boolIndex];

				for (j in 0...shaderBuffer.overrideBoolCount)
				{
					if (boolRef.name == shaderBuffer.overrideBoolNames[j])
					{
						overrideBoolValue = shaderBuffer.overrideBoolValues[j];
						hasOverride = true;
						break;
					}
				}

				if (hasOverride)
				{
					boolRef._.updateGL(context, overrideBoolValue);
				}
				else
				{
					boolRef._.updateGLFromBuffer(context, paramData, shaderBuffer.paramPositions[i], shaderBuffer.paramLengths[i], bufferOffset);
				}

				boolIndex++;
			}
			else if (i < boolCount + floatCount)
			{
				floatRef = shaderBuffer.paramRefs_Float[floatIndex];

				for (j in 0...shaderBuffer.overrideFloatCount)
				{
					if (floatRef.name == shaderBuffer.overrideFloatNames[j])
					{
						overrideFloatValue = shaderBuffer.overrideFloatValues[j];
						hasOverride = true;
						break;
					}
				}

				if (hasOverride)
				{
					floatRef._.updateGL(context, overrideFloatValue);
				}
				else
				{
					floatRef._.updateGLFromBuffer(context, paramData, shaderBuffer.paramPositions[i], shaderBuffer.paramLengths[i], bufferOffset);
				}

				floatIndex++;
			}
			else
			{
				intRef = shaderBuffer.paramRefs_Int[intIndex];

				for (j in 0...shaderBuffer.overrideIntCount)
				{
					if (intRef.name == shaderBuffer.overrideIntNames[j])
					{
						overrideIntValue = cast shaderBuffer.overrideIntValues[j];
						hasOverride = true;
						break;
					}
				}

				if (hasOverride)
				{
					intRef._.updateGL(context, overrideIntValue);
				}
				else
				{
					intRef._.updateGLFromBuffer(context, paramData, shaderBuffer.paramPositions[i], shaderBuffer.paramLengths[i], bufferOffset);
				}

				intIndex++;
			}
		}
	}
}
#end
