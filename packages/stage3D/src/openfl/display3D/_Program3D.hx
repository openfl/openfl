package openfl.display3D;

#if openfl_gl
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLShader;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import lime.utils.Float32Array;
import openfl.display3D._internal.agal.AGALConverter;
import openfl._internal.renderer.SamplerState;
import openfl._internal.utils.Log;
import openfl.display3D.Context3D;
import openfl.display3D.Program3D;
import openfl.display.ShaderParameterType;
import openfl.errors.IllegalOperationError;
import openfl.utils.ByteArray;
import openfl.Vector;
#if lime
import lime.graphics.OpenGLES2RenderContext;
import lime.utils.BytePointer;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.BytePointer;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D) // TODO: Remove backend references
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D._Program3D) // TODO: Remove backend references
@:access(openfl.display.ShaderInput)
@:access(openfl.display._ShaderInput) // TODO: Remove backend references
@:access(openfl.display.ShaderParameter)
@:access(openfl.display._ShaderParameter) // TODO: Remove backend references
@:access(openfl.display.Stage)
@:noCompletion
class _Program3D
{
	private var agalAlphaSamplerEnabled:Array<Uniform>;
	private var agalAlphaSamplerUniforms:List<Uniform>;
	private var agalFragmentUniformMap:UniformMap;
	private var agalPositionScale:Uniform;
	private var agalSamplerUniforms:List<Uniform>;
	private var agalSamplerUsageMask:Int;
	private var agalUniforms:List<Uniform>;
	private var agalVertexUniformMap:UniformMap;
	private var gl:WebGLRenderContext;
	private var glFragmentShader:GLShader;
	private var glFragmentSource:String;
	private var glProgram:GLProgram;
	private var glslAttribNames:Array<String>;
	private var glslAttribTypes:Array<ShaderParameterType>;
	private var glslSamplerNames:Array<String>;
	private var glslUniformLocations:Array<GLUniformLocation>;
	private var glslUniformNames:Array<String>;
	private var glslUniformTypes:Array<ShaderParameterType>;
	private var glVertexShader:GLShader;
	private var glVertexSource:String;
	// private var memUsage:Int;
	private var parent:Program3D;

	public function new(parent:Program3D)
	{
		this.parent = parent;

		gl = parent.__context._.gl;

		switch (parent.__format)
		{
			case AGAL:
				// memUsage = 0;
				agalSamplerUsageMask = 0;
				agalUniforms = new List<Uniform>();
				agalSamplerUniforms = new List<Uniform>();
				agalAlphaSamplerUniforms = new List<Uniform>();
				agalAlphaSamplerEnabled = new Array<Uniform>();

			case GLSL:
				glslAttribNames = new Array();
				glslAttribTypes = new Array();
				glslSamplerNames = new Array();
				glslUniformLocations = new Array();
				glslUniformNames = new Array();
				glslUniformTypes = new Array();

			default:
		}
	}

	public function dispose():Void
	{
		deleteShaders();
	}

	public function getGLSLAttributeIndex(name:String):Int
	{
		for (i in 0...glslAttribNames.length)
		{
			if (glslAttribNames[i] == name) return i;
		}

		return -1;
	}

	public function getGLSLConstantIndex(name:String):Int
	{
		for (i in 0...glslUniformNames.length)
		{
			if (glslUniformNames[i] == name) return cast glslUniformLocations[i];
		}

		return -1;
	}

	public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray):Void
	{
		if (parent.__format != AGAL) return;

		// var samplerStates = new Vector<SamplerState> (Context3D.MAX_SAMPLERS);
		var samplerStates = new Array<SamplerState>();

		var glslVertex = AGALConverter.convertToGLSL(parent, vertexProgram, null);
		var glslFragment = AGALConverter.convertToGLSL(parent, fragmentProgram, samplerStates);

		if (Log.level == LogLevel.VERBOSE)
		{
			Log.info(glslVertex);
			Log.info(glslFragment);
		}

		deleteShaders();
		uploadFromGLSL(glslVertex, glslFragment);
		buildAGALUniformList();

		for (i in 0...samplerStates.length)
		{
			parent.__samplerStates[i] = samplerStates[i];
		}
	}

	public function uploadSources(vertexSource:String, fragmentSource:String):Void
	{
		if (parent.__format != GLSL) return;

		// TODO: Precision hint?

		var prefix = "#ifdef GL_ES
			#ifdef GL_FRAGMENT_PRECISION_HIGH
			precision highp float;
			#else
			precision mediump float;
			#endif
			#endif
			";

		var vertex = prefix + vertexSource;
		var fragment = prefix + fragmentSource;

		if (vertex == glVertexSource && fragment == glFragmentSource) return;

		processGLSLData(vertexSource, "attribute");
		processGLSLData(vertexSource, "uniform");
		processGLSLData(fragmentSource, "uniform");

		deleteShaders();
		uploadFromGLSL(vertex, fragment);

		// Sort by index

		var samplerNames = glslSamplerNames;
		var attribNames = glslAttribNames;
		var attribTypes = glslAttribTypes;
		var uniformNames = glslUniformNames;

		glslSamplerNames = new Array();
		glslAttribNames = new Array();
		glslAttribTypes = new Array();
		glslUniformLocations = new Array();

		var index:Int, location;

		for (name in samplerNames)
		{
			index = cast gl.getUniformLocation(glProgram, name);
			glslSamplerNames[index] = name;
		}

		for (i in 0...attribNames.length)
		{
			index = gl.getAttribLocation(glProgram, attribNames[i]);
			glslAttribNames[index] = attribNames[i];
			glslAttribTypes[index] = attribTypes[i];
		}

		for (i in 0...uniformNames.length)
		{
			location = gl.getUniformLocation(glProgram, uniformNames[i]);
			glslUniformLocations[i] = location;
		}
	}

	private function buildAGALUniformList():Void
	{
		if (parent.__format == GLSL) return;

		agalUniforms.clear();
		agalSamplerUniforms.clear();
		agalAlphaSamplerUniforms.clear();
		agalAlphaSamplerEnabled = [];

		agalSamplerUsageMask = 0;

		var numActive = 0;
		numActive = gl.getProgramParameter(glProgram, GL.ACTIVE_UNIFORMS);

		var vertexUniforms = new List<Uniform>();
		var fragmentUniforms = new List<Uniform>();

		for (i in 0...numActive)
		{
			var info = gl.getActiveUniform(glProgram, i);
			var name = info.name;
			var size = info.size;
			var uniformType = info.type;

			var uniform = new Uniform(parent.__context);
			uniform.name = name;
			uniform.size = size;
			uniform.type = uniformType;

			uniform.location = gl.getUniformLocation(glProgram, uniform.name);

			var indexBracket = uniform.name.indexOf("[");

			if (indexBracket >= 0)
			{
				uniform.name = uniform.name.substring(0, indexBracket);
			}

			switch (uniform.type)
			{
				case GL.FLOAT_MAT2:
					uniform.regCount = 2;
				case GL.FLOAT_MAT3:
					uniform.regCount = 3;
				case GL.FLOAT_MAT4:
					uniform.regCount = 4;
				default:
					uniform.regCount = 1;
			}

			uniform.regCount *= uniform.size;

			agalUniforms.add(uniform);

			if (uniform.name == "vcPositionScale")
			{
				agalPositionScale = uniform;
			}
			else if (StringTools.startsWith(uniform.name, "vc"))
			{
				uniform.regIndex = Std.parseInt(uniform.name.substring(2));
				uniform.regData = parent.__context.__vertexConstants;
				vertexUniforms.add(uniform);
			}
			else if (StringTools.startsWith(uniform.name, "fc"))
			{
				uniform.regIndex = Std.parseInt(uniform.name.substring(2));
				uniform.regData = parent.__context.__fragmentConstants;
				fragmentUniforms.add(uniform);
			}
			else if (StringTools.startsWith(uniform.name, "sampler") && uniform.name.indexOf("alpha") == -1)
			{
				uniform.regIndex = Std.parseInt(uniform.name.substring(7));
				agalSamplerUniforms.add(uniform);

				for (reg in 0...uniform.regCount)
				{
					agalSamplerUsageMask |= (1 << (uniform.regIndex + reg));
				}
			}
			else if (StringTools.startsWith(uniform.name, "sampler") && StringTools.endsWith(uniform.name, "_alpha"))
			{
				var len = uniform.name.indexOf("_") - 7;
				uniform.regIndex = Std.parseInt(uniform.name.substring(7, 7 + len)) + 4;
				agalAlphaSamplerUniforms.add(uniform);
			}
			else if (StringTools.startsWith(uniform.name, "sampler") && StringTools.endsWith(uniform.name, "_alphaEnabled"))
			{
				uniform.regIndex = Std.parseInt(uniform.name.substring(7));
				agalAlphaSamplerEnabled[uniform.regIndex] = uniform;
			}

			if (Log.level == LogLevel.VERBOSE)
			{
				Log.verbose('${i} name:${uniform.name} type:${uniform.type} size:${uniform.size} location:${uniform.location}');
			}
		}

		agalVertexUniformMap = new UniformMap(Lambda.array(vertexUniforms));
		agalFragmentUniformMap = new UniformMap(Lambda.array(fragmentUniforms));
	}

	private function deleteShaders():Void
	{
		if (glProgram != null)
		{
			glProgram = null;
		}

		if (glVertexShader != null)
		{
			gl.deleteShader(glVertexShader);
			glVertexShader = null;
		}

		if (glFragmentShader != null)
		{
			gl.deleteShader(glFragmentShader);
			glFragmentShader = null;
		}
	}

	private function disable():Void
	{
		if (parent.__format == GLSL)
		{
			// var textureCount = 0;

			// for (input in __glslInputBitmapData) {

			// 	input.__disableGL (__context, textureCount);
			// 	textureCount++;

			// }

			// for (parameter in __glslParamBool) {

			// 	parameter.__disableGL (__context);

			// }

			// for (parameter in __glslParamFloat) {

			// 	parameter.__disableGL (__context);

			// }

			// for (parameter in __glslParamInt) {

			// 	parameter.__disableGL (__context);

			// }

			// // __context.__bindGLArrayBuffer (null);

			// if (__context.__context.type == OPENGL) {

			// 	gl.disable (gl.TEXTURE_2D);

			// }
		}
	}

	private function enable():Void
	{
		gl.useProgram(glProgram);

		if (parent.__format == AGAL)
		{
			agalVertexUniformMap.markAllDirty();
			agalFragmentUniformMap.markAllDirty();

			for (sampler in agalSamplerUniforms)
			{
				if (sampler.regCount == 1)
				{
					gl.uniform1i(sampler.location, sampler.regIndex);
				}
				else
				{
					throw new IllegalOperationError("!!! TODO: uniform location on webgl");
				}
			}

			for (sampler in agalAlphaSamplerUniforms)
			{
				if (sampler.regCount == 1)
				{
					gl.uniform1i(sampler.location, sampler.regIndex);
				}
				else
				{
					throw new IllegalOperationError("!!! TODO: uniform location on webgl");
				}
			}
		}
		else
		{
			// var textureCount = 0;

			// for (input in __glslInputBitmapData) {

			// 	gl.uniform1i (input.index, textureCount);
			// 	textureCount++;

			// }

			// if (__context.__context.type == OPENGL && textureCount > 0) {

			// 	gl.enable (gl.TEXTURE_2D);

			// }
		}
	}

	private function flush():Void
	{
		if (parent.__format == AGAL)
		{
			agalVertexUniformMap.flush();
			agalFragmentUniformMap.flush();
		}
		else
		{
			// TODO
			return;

			// var textureCount = 0;

			// for (input in __glslInputBitmapData) {

			// 	input.__updateGL (__context, textureCount);
			// 	textureCount++;

			// }

			// for (parameter in __glslParamBool) {

			// 	parameter.__updateGL (__context);

			// }

			// for (parameter in __glslParamFloat) {

			// 	parameter.__updateGL (__context);

			// }

			// for (parameter in __glslParamInt) {

			// 	parameter.__updateGL (__context);

			// }
		}
	}

	public function markDirty(isVertex:Bool, index:Int, count:Int):Void
	{
		if (parent.__format != AGAL) return;

		if (isVertex)
		{
			agalVertexUniformMap.markDirty(index, count);
		}
		else
		{
			agalFragmentUniformMap.markDirty(index, count);
		}
	}

	private function processGLSLData(source:String, storageType:String):Void
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

			if (StringTools.startsWith(type, "sampler"))
			{
				glslSamplerNames.push(name);
			}
			else
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

				if (storageType == "uniform")
				{
					glslUniformNames.push(name);
					glslUniformTypes.push(parameterType);
				}
				else
				{
					glslAttribNames.push(name);
					glslAttribTypes.push(parameterType);
				}
			}

			position = regex.matchedPos();
			lastMatch = position.pos + position.len;
		}
	}

	private function setPositionScale(positionScale:Float32Array):Void
	{
		if (parent.__format == GLSL) return;

		if (agalPositionScale != null)
		{
			gl.uniform4fv(agalPositionScale.location, positionScale);
		}
	}

	private function uploadFromGLSL(vertexShaderSource:String, fragmentShaderSource:String):Void
	{
		glVertexSource = vertexShaderSource;
		glFragmentSource = fragmentShaderSource;

		glVertexShader = gl.createShader(GL.VERTEX_SHADER);
		gl.shaderSource(glVertexShader, vertexShaderSource);
		gl.compileShader(glVertexShader);

		if (gl.getShaderParameter(glVertexShader, GL.COMPILE_STATUS) == 0)
		{
			var message = "Error compiling vertex shader";
			message += "\n" + gl.getShaderInfoLog(glVertexShader);
			message += "\n" + vertexShaderSource;
			Log.error(message);
		}

		glFragmentShader = gl.createShader(GL.FRAGMENT_SHADER);
		gl.shaderSource(glFragmentShader, fragmentShaderSource);
		gl.compileShader(glFragmentShader);

		if (gl.getShaderParameter(glFragmentShader, GL.COMPILE_STATUS) == 0)
		{
			var message = "Error compiling fragment shader";
			message += "\n" + gl.getShaderInfoLog(glFragmentShader);
			message += "\n" + fragmentShaderSource;
			Log.error(message);
		}

		glProgram = gl.createProgram();

		if (parent.__format == AGAL)
		{
			// TODO: AGAL version specific number of attributes?
			for (i in 0...16)
			{
				// for (i in 0...Context3D.MAX_ATTRIBUTES) {

				var name = "va" + i;

				if (vertexShaderSource.indexOf(" " + name) != -1)
				{
					gl.bindAttribLocation(glProgram, i, name);
				}
			}
		}
		else
		{
			// Fix support for drivers that don't draw if attribute 0 is disabled
			for (name in glslAttribNames)
			{
				if (name.indexOf("Position") > -1 && StringTools.startsWith(name, "openfl_"))
				{
					gl.bindAttribLocation(glProgram, 0, name);
					break;
				}
			}
		}

		gl.attachShader(glProgram, glVertexShader);
		gl.attachShader(glProgram, glFragmentShader);
		gl.linkProgram(glProgram);

		if (gl.getProgramParameter(glProgram, GL.LINK_STATUS) == 0)
		{
			var message = "Unable to initialize the shader program";
			message += "\n" + gl.getProgramInfoLog(glProgram);
			Log.error(message);
		}
	}
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D) // TODO: Remove backend references
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) class Uniform
{
	public var name:String;
	public var location:GLUniformLocation;
	public var type:Int;
	public var size:Int;
	public var regData:Float32Array;
	public var regIndex:Int;
	public var regCount:Int;
	public var isDirty:Bool;
	public var context:Context3D;

	#if (lime && !openfl_html5)
	private var gl:OpenGLES2RenderContext;
	private var regDataPointer:BytePointer;
	#else
	private var gl:WebGLRenderContext;
	#end

	public function new(context:Context3D)
	{
		this.context = context;
		#if (lime && !openfl_html5)
		gl = context._.limeContext.gles2;
		regDataPointer = new BytePointer();
		#else
		gl = context._.gl;
		#end

		isDirty = true;
	}

	public function flush():Void
	{
		var index:Int = regIndex * 4;
		switch (type)
		{
			#if openfl_html5
			case GL.FLOAT_MAT2:
				gl.uniformMatrix2fv(location, false, __getUniformRegisters(index, size * 2 * 2));
			case GL.FLOAT_MAT3:
				gl.uniformMatrix3fv(location, false, __getUniformRegisters(index, size * 3 * 3));
			case GL.FLOAT_MAT4:
				gl.uniformMatrix4fv(location, false, __getUniformRegisters(index, size * 4 * 4));
			case GL.FLOAT_VEC2:
				gl.uniform2fv(location, __getUniformRegisters(index, regCount * 2));
			case GL.FLOAT_VEC3:
				gl.uniform3fv(location, __getUniformRegisters(index, regCount * 3));
			case GL.FLOAT_VEC4:
				gl.uniform4fv(location, __getUniformRegisters(index, regCount * 4));
			default:
				gl.uniform4fv(location, __getUniformRegisters(index, regCount * 4));
			#else
			case GL.FLOAT_MAT2:
				gl.uniformMatrix2fv(location, size, false, __getUniformRegisters(index, size * 2 * 2));
			case GL.FLOAT_MAT3:
				gl.uniformMatrix3fv(location, size, false, __getUniformRegisters(index, size * 3 * 3));
			case GL.FLOAT_MAT4:
				gl.uniformMatrix4fv(location, size, false, __getUniformRegisters(index, size * 4 * 4));
			case GL.FLOAT_VEC2:
				gl.uniform2fv(location, regCount, __getUniformRegisters(index, regCount * 2));
			case GL.FLOAT_VEC3:
				gl.uniform3fv(location, regCount, __getUniformRegisters(index, regCount * 3));
			case GL.FLOAT_VEC4:
				gl.uniform4fv(location, regCount, __getUniformRegisters(index, regCount * 4));
			default:
				gl.uniform4fv(location, regCount, __getUniformRegisters(index, regCount * 4));
			#end
		}
	}

	#if openfl_html5
	private inline function __getUniformRegisters(index:Int, size:Int):Float32Array
	{
		return regData.subarray(index, index + size);
	}
	#elseif lime
	private inline function __getUniformRegisters(index:Int, size:Int):BytePointer
	{
		regDataPointer.set(regData, index * 4);
		return regDataPointer;
	}
	#else
	private inline function __getUniformRegisters(index:Int, size:Int):Dynamic
	{
		return regData.subarray(index, index + size);
	}
	#end
}

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@SuppressWarnings("checkstyle:FieldDocComment")
@:dox(hide) class UniformMap
{
	// TODO: it would be better to use a bitmask with a dirty bit per uniform, but not super important now
	private var allDirty:Bool;
	private var anyDirty:Bool;
	private var registerLookup:Vector<Uniform>;
	private var uniforms:Array<Uniform>;

	public function new(list:Array<Uniform>)
	{
		uniforms = list;

		uniforms.sort(function(a, b):Int
		{
			return Reflect.compare(a.regIndex, b.regIndex);
		});

		var total = 0;

		for (uniform in uniforms)
		{
			if (uniform.regIndex + uniform.regCount > total)
			{
				total = uniform.regIndex + uniform.regCount;
			}
		}

		registerLookup = new Vector<Uniform>(total);

		for (uniform in uniforms)
		{
			for (i in 0...uniform.regCount)
			{
				registerLookup[uniform.regIndex + i] = uniform;
			}
		}

		anyDirty = allDirty = true;
	}

	public function flush():Void
	{
		if (anyDirty)
		{
			for (uniform in uniforms)
			{
				if (allDirty || uniform.isDirty)
				{
					uniform.flush();
					uniform.isDirty = false;
				}
			}

			anyDirty = allDirty = false;
		}
	}

	public function markAllDirty():Void
	{
		allDirty = true;
		anyDirty = true;
	}

	public function markDirty(start:Int, count:Int):Void
	{
		if (allDirty)
		{
			return;
		}

		var end = start + count;

		if (end > registerLookup.length)
		{
			end = registerLookup.length;
		}

		var index = start;

		while (index < end)
		{
			var uniform = registerLookup[index];

			if (uniform != null)
			{
				uniform.isDirty = true;
				anyDirty = true;

				index = uniform.regIndex + uniform.regCount;
			}
			else
			{
				index++;
			}
		}
	}
}
#end
