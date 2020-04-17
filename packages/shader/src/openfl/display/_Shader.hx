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
	private var context:Context3D;
	private var gl:WebGLRenderContext;
	private var inputBitmapData:Array<ShaderInput<BitmapData>>;
	private var numPasses:Int;
	private var paramBool:Array<ShaderParameter<Bool>>;
	private var paramFloat:Array<ShaderParameter<Float>>;
	private var paramInt:Array<ShaderParameter<Int>>;
	private var parent:Shader;

	public function new(parent:Shader)
	{
		this.parent = parent;
	}

	private function clearUseArray():Void
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

	private function createGLShader(source:String, type:Int):GLShader
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

	private function createGLProgram(vertexSource:String, fragmentSource:String):GLProgram
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

	private function disable():Void
	{
		if (parent.program != null)
		{
			disableGL();
		}
	}

	private function disableGL():Void
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

		context._.bindGLArrayBuffer(null);

		#if lime
		if (context._.limeContext.type == OPENGL)
		{
			gl.disable(gl.TEXTURE_2D);
		}
		#end
	}

	private function enable():Void
	{
		init();

		if (parent.program != null)
		{
			enableGL();
		}
	}

	private function enableGL():Void
	{
		var textureCount = 0;

		for (input in inputBitmapData)
		{
			gl.uniform1i(input.index, textureCount);
			textureCount++;
		}

		#if lime
		if (context._.limeContext.type == OPENGL && textureCount > 0)
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
			gl = context._.gl;
		}

		if (parent.__data == null)
		{
			parent.__data = cast new ShaderData(null);
		}

		if (parent.__glFragmentSource != null && parent.__glVertexSource != null && (parent.program == null || parent.__glSourceDirty))
		{
			initGL();
		}
	}

	private function initGL():Void
	{
		if (parent.__glSourceDirty || paramBool == null)
		{
			parent.__glSourceDirty = false;
			parent.program = null;

			inputBitmapData = new Array();
			paramBool = new Array();
			paramFloat = new Array();
			paramInt = new Array();

			processGLData(parent.__glVertexSource, "attribute");
			processGLData(parent.__glVertexSource, "uniform");
			processGLData(parent.__glFragmentSource, "uniform");
		}

		if (context != null && parent.program == null)
		{
			var prefix = "#ifdef GL_ES
				"
				+ (parent.precisionHint == FULL ? "#ifdef GL_FRAGMENT_PRECISION_HIGH
				precision highp float;
				#else
				precision mediump float;
				#endif" : "precision lowp float;")
				+ "
				#endif
				";

			var vertex = prefix + parent.__glVertexSource;
			var fragment = prefix + parent.__glFragmentSource;

			var id = vertex + fragment;

			if (context.__programs.exists(id))
			{
				parent.program = context.__programs.get(id);
			}
			else
			{
				parent.program = context.createProgram(GLSL);

				// TODO
				// program.uploadSources (vertex, fragment);
				parent.program._.glProgram = createGLProgram(vertex, fragment);

				context.__programs.set(id, parent.program);
			}

			if (parent.program != null)
			{
				parent.glProgram = parent.program._.glProgram;

				for (input in inputBitmapData)
				{
					if (input._.isUniform)
					{
						input.index = gl.getUniformLocation(parent.glProgram, input.name);
					}
					else
					{
						input.index = gl.getAttribLocation(parent.glProgram, input.name);
					}
				}

				for (parameter in paramBool)
				{
					if (parameter._.isUniform)
					{
						parameter.index = gl.getUniformLocation(parent.glProgram, parameter.name);
					}
					else
					{
						parameter.index = gl.getAttribLocation(parent.glProgram, parameter.name);
					}
				}

				for (parameter in paramFloat)
				{
					if (parameter._.isUniform)
					{
						parameter.index = gl.getUniformLocation(parent.glProgram, parameter.name);
					}
					else
					{
						parameter.index = gl.getAttribLocation(parent.glProgram, parameter.name);
					}
				}

				for (parameter in paramInt)
				{
					if (parameter._.isUniform)
					{
						parameter.index = gl.getUniformLocation(parent.glProgram, parameter.name);
					}
					else
					{
						parameter.index = gl.getAttribLocation(parent.glProgram, parameter.name);
					}
				}
			}
		}
	}

	private function processGLData(source:String, storageType:String):Void
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
						parent.__alphaTexture = input;
					case "openfl_Texture":
						parent.__texture = input;
					case "bitmap":
						parent.__bitmap = input;
					default:
				}

				Reflect.setField(parent.__data, name, input);
				if (parent.__isGenerated) Reflect.setField(parent, name, input);
			}
			else if (!Reflect.hasField(parent.__data, name) || Reflect.field(parent.__data, name) == null)
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
						parameter.type = parameterType;
						parameter._.arrayLength = arrayLength;
						parameter._.isBool = true;
						parameter._.isUniform = isUniform;
						parameter._.length = length;
						paramBool.push(parameter);

						if (name == "openfl_HasColorTransform")
						{
							parent.__hasColorTransform = parameter;
						}

						Reflect.setField(parent.__data, name, parameter);
						if (parent.__isGenerated) Reflect.setField(parent, name, parameter);

					case INT, INT2, INT3, INT4:
						var parameter = new ShaderParameter<Int>();
						parameter.name = name;
						parameter.type = parameterType;
						parameter._.arrayLength = arrayLength;
						parameter._.isInt = true;
						parameter._.isUniform = isUniform;
						parameter._.length = length;
						paramInt.push(parameter);
						Reflect.setField(parent.__data, name, parameter);
						if (parent.__isGenerated) Reflect.setField(parent, name, parameter);

					default:
						var parameter = new ShaderParameter<Float>();
						parameter.name = name;
						parameter.type = parameterType;
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
								case "openfl_Alpha": parent.__alpha = parameter;
								case "openfl_AlphaTextureMatrix": parent.__alphaTextureMatrix = parameter;
								case "openfl_ColorMultiplier": parent.__colorMultiplier = parameter;
								case "openfl_ColorOffset": parent.__colorOffset = parameter;
								case "openfl_Matrix": parent.__matrix = parameter;
								case "openfl_Position": parent.__position = parameter;
								case "openfl_TextureCoord": parent.__textureCoord = parameter;
								case "openfl_TextureSize": parent.__textureSize = parameter;
								default:
							}
						}

						Reflect.setField(parent.__data, name, parameter);
						if (parent.__isGenerated) Reflect.setField(parent, name, parameter);
				}
			}

			position = regex.matchedPos();
			lastMatch = position.pos + position.len;
		}
	}

	public function update():Void
	{
		if (parent.program != null)
		{
			updateGL();
		}
	}

	private function updateFromBuffer(shaderBuffer:ShaderBuffer, bufferOffset:Int):Void
	{
		if (parent.program != null)
		{
			updateGLFromBuffer(shaderBuffer, bufferOffset);
		}
	}

	private function updateGL():Void
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

	private function updateGLFromBuffer(shaderBuffer:ShaderBuffer, bufferOffset:Int):Void
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

			context._.bindGLArrayBuffer(shaderBuffer.paramDataBuffer);
			gl.bufferData(GL.ARRAY_BUFFER, shaderBuffer.paramData, GL.DYNAMIC_DRAW);
		}
		else
		{
			// Log.verbose ("bind buffer null");

			context._.bindGLArrayBuffer(null);
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
