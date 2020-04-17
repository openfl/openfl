package openfl.display3D;

#if !flash
import openfl._internal.renderer.SamplerState;
import openfl.utils.ByteArray;

/**
	The Program3D class represents a pair of rendering programs (also called "shaders")
	uploaded to the rendering context.

	Programs managed by a Program3D object control the entire rendering of triangles
	during a Context3D drawTriangles() call. Upload the binary bytecode to the rendering
	context using the upload method. (Once uploaded, the program in the original byte
	array is no longer referenced; changing or discarding the source byte array does
	not change the program.)

	Programs always consist of two linked parts: A vertex and a fragment program.

	1. The vertex program operates on data defined in VertexBuffer3D objects and is
	responsible for projecting vertices into clip space and passing any required vertex
	data, such as color, to the fragment shader.
	2. The fragment shader operates on the attributes passed to it by the vertex program
	and produces a color for every rasterized fragment of a triangle, resulting in pixel
	colors. Note that fragment programs have several names in 3D programming literature,
	including fragment shader and pixel shader.

	Designate which program pair to use for subsequent rendering operations by passing the
	corresponding Program3D instance to the Context3D `setProgram()` method.

	You cannot create a Program3D object directly; use the Context3D `createProgram()`
	method instead.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class Program3D
{
	@:noCompletion private var _:_Program3D;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __format:Context3DProgramFormat;
	@:noCompletion private var __samplerStates:Array<SamplerState>;

	@:noCompletion private function new(context3D:Context3D, format:Context3DProgramFormat)
	{
		__context = context3D;
		__format = format;

		__samplerStates = new Array<SamplerState>();

		_ = new _Program3D(this);
	}

	/**
		Frees all resources associated with this object. After disposing a
		Program3D object, calling `upload()` and rendering using this object will fail.
	**/
	public function dispose():Void
	{
		_.dispose();
	}

	/**
		**BETA**

		Get the index for the specified shader attribute.

		@returns	The index, or -1 if the attribute is not bound or
		was not found in the shader sources
	**/
	public function getAttributeIndex(name:String):Int
	{
		switch (__format)
		{
			case AGAL:
				// TODO: Validate that it exists in the current program
				if (StringTools.startsWith(name, "va"))
				{
					return Std.parseInt(name.substring(2));
				}
				else
				{
					return -1;
				}

			#if openfl_gl
			case GLSL:
				return _.getGLSLAttributeIndex(name);
			#end

			default:
				return -1;
		}
	}

	/**
		**BETA**

		Get the index for the specified shader constant.

		@returns	The index, or -1 if the constant is not bound or
		was not found in the shader sources
	**/
	public function getConstantIndex(name:String):Int
	{
		switch (__format)
		{
			case AGAL:
				// TODO: Validate that it exists in the current program
				if (StringTools.startsWith(name, "vc"))
				{
					return Std.parseInt(name.substring(2));
				}
				else if (StringTools.startsWith(name, "fc"))
				{
					return Std.parseInt(name.substring(2));
				}
				else
				{
					return -1;
				}

			#if openfl_gl
			case GLSL:
				return _.getGLSLConstantIndex(name);
			#end

			default:
				return -1;
		}
	}

	/**
		Uploads a pair of rendering programs expressed in AGAL (Adobe Graphics Assembly
		Language) bytecode.

		Program bytecode can be created using the Pixel Bender 3D offline tools. It can
		also be created dynamically. The AGALMiniAssembler class is a utility class
		that compiles AGAL assembly language programs to AGAL bytecode. The class is not
		part of the runtime. When you upload the shader programs, the bytecode is
		compiled into the native shader language for the current device (for example,
		OpenGL or Direct3D). The runtime validates the bytecode on upload.

		The programs run whenever the Context3D `drawTriangles()` method is invoked. The
		vertex program is executed once for each vertex in the list of triangles to be
		drawn. The fragment program is executed once for each pixel on a triangle surface.

		The "variables" used by a shader program are called registers. The following
		registers are defined:

		| Name | Number per Fragment program | Number per Vertex program | Purpose |
		| --- | --- | --- | --- |
		| Attribute | n/a | 8 | Vertex shader input; read from a vertex buffer specified using `Context3D.setVertexBufferAt()`. |
		| Constant | 28 | 128 | Shader input; set using the `Context3D.setProgramConstants()` family of functions. |
		| Temporary | 8 | 8 | Temporary register for computation, not accessible outside program. |
		| Output | 1 | 1 | Shader output: in a vertex program, the output is the clipspace position; in a fragment program, the output is a color. |
		| Varying | 8 | 8 | Transfer interpolated data between vertex and fragment shaders. The varying registers from the vertex program are applied as input to the fragment program. Values are interpolated according to the distance from the triangle vertices. |
		| Sampler | 8 | n/a | Fragment shader input; read from a texture specified using `Context3D.setTextureAt()` |

		A vertex program receives input from two sources: vertex buffers and constant
		registers. Specify which vertex data to use for a particular vertex attribute
		register using the Context3D `setVertexBufferAt()` method. You can define up to
		eight input registers for vertex attributes. The vertex attribute values are read
		from the vertex buffer for each vertex in the triangle list and placed in the
		attribute register. Specify constant registers using the Context3D
		`setProgramConstantsFromMatrix()` or `setProgramConstantsFromVector()`
		methods. Constant registers retain the same value for every vertex in the
		triangle list. (You can only modify the constant values between calls to
		`drawTriangles().`)

		The vertex program is responsible for projecting the triangle vertices into
		clip space (the canonical viewing area within ±1 on the x and y axes and 0-1 on
		the z axis) and placing the transformed coordinates in its output register.
		(Typically, the appropriate projection matrix is provided to the shader in a set
		of constant registers.) The vertex program must also copy any vertex attributes
		or computed values needed by the fragment program to a special set of variables
		called varying registers. When a fragment shader runs, the value supplied in a
		varying register is linearly interpolated according to the distance of the
		current fragment from each triangle vertex.

		A fragment program receives input from the varying registers and from a separate
		set of constant registers (set with `setProgramConstantsFromMatrix()` or
		`setProgramConstantsFromVector()`). You can also read texture data from textures
		uploaded to the rendering context using sampler registers. Specify which texture
		to access with a particular sampler register using the Context3D `setTextureAt()`
		method. The fragment program is responsible for setting its output register to a
		color value.

		@param	vertexProgram	AGAL bytecode for the Vertex program. The ByteArray object
		must use the little endian format.
		@param	fragmentProgram	AGAL bytecode for the Fragment program. The ByteArray
		object must use the little endian format.
		@throws	TypeError	Null Pointer Error: if vertexProgram or fragmentProgram is
		`null`.
		@throws	Error	Object Disposed: if the Program3D object was disposed either
		directly by a call to `dispose()`, or indirectly by calling the Context3D
		`dispose()` or because the rendering context was disposed because of device loss.
		@throws	ArgumentError	Agal Program Too Small: when either program code array
		is smaller than 31 bytes length. This is the size of the shader bytecode of a
		one-instruction program.
		@throws	ArgumentError	Program Must Be Little Endian: if either of the program
		byte code arrays is not little endian.
		@throws	Error	Native Shader Compilation Failed: if the output of the AGAL
		translator is not a compilable native shader language program. This error is only
		thrown in release players.
		@throws	Error	Native Shader Compilation Failed OpenGL: if the output of the
		AGAL translator is not a compilable OpengGL shader language program, and
		includes compilation diagnostics. This error is only thrown in debug players.
		@throws	Error	Native Shader Compilation Failed D3D9: if the output of the AGAL
		translator is not a compilable Direct3D shader language program, and includes
		compilation diagnostics. This error is only thrown in debug players.

		The following errors are thrown when the AGAL bytecode validation fails:

		@throws	Error	Not An Agal Program: if the header "magic byte" is wrong. The
		first byte of the bytecode must be 0xa0. This error can indicate that the byte
		array is set to the wrong endian order.
		@throws	Error	Bad Agal Version: if the AGAL version is not supported by the
		current SWF version. The AGAL version must be set to 1 for SWF version 13.
		@throws	Error	Bad Agal Program Type: if the AGAL program type identifier is
		not valid. The third byte in the byte code must be 0xa1. This error can indicates
		that the byte array is set to the wrong endian order.
		@throws	Error	Bad Agal Shader Type: if the shader type code is not either
		fragment or vertex (1 or 0).
		@throws	Error	Invalid Agal Opcode Out Of Range: if an invalid opcode is
		encountered in the token stream.
		@throws	Error	Invalid Agal Opcode Not Implemented: if an invalid opcode is
		encountered in the token stream.
		@throws	Error	Agal Opcode Only Allowed In Fragment Program: if an opcode is
		encountered in the token stream of the vertex program that is only allowed in fragment programs, such as KIL or TEX.
		@throws	Error	Bad Agal Source Operands: if both source operands are constant
		registers. You must compute the result outside the shader program and pass it
		in using a single constant register.
		@throws	Error	Both Operands Are Indirect Reads: if both operands are indirect
		reads.
		@throws	Error	Opcode Destination Must Be All Zero: if a token with an opcode
		(such as KIL) that has no destination sets a non-zero value for the destination
		register.
		@throws	Error	Opcode Destination Must Use Mask: if an opcode that produces
		only a 3 component result is used without masking.
		@throws	Error	Too Many Tokens: if there are too many tokens (more than 200) in
		an AGAL program.
		@throws	Error	Fragment Shader Type: if the fragment program type (byte 6 of
		fragmentProgram parameter) is not set to 1.
		@throws	Error	Vertex Shader Type: if the vertex program type (byte 6 of
		vertexProgram parameter) is not set to 0.
		@throws	Error	Varying Read But Not Written To: if the fragment shader reads a
		varying register that was never written to by the vertex shader.
		@throws	Error	Varying Partial Write: if a varying register is only partially
		written to. All components of a varying register must be written to.
		@throws	Error	Fragment Write All Components: if a fragment color output is only
		partially written to. All four components of the color output must be written to.
		@throws	Error	Vertex Write All Components: if a vertex clip space output is only
		partially written to. All components of the vertex clip space output must be
		written to.
		@throws	Error	Unused Operand: if an unused operand in a token is not set to all
		zero.
		@throws	Error	Sampler Register Only In Fragment: if a texture sampler register
		is used in a vertex program.
		@throws	Error	Sampler Register Second Operand: if a sampler register is used
		as a destination or first operand of an AGAL token.
		@throws	Error	Indirect Only Allowed In Vertex: if indirect addressing is used
		in a fragment program.
		@throws	Error	Indirect Only Into Constant Registers: if indirect addressing
		is used on a non-constant register.
		@throws	Error	Indirect Source Type: if the indirect source type is not
		attribute, constant or temporary register.
		@throws	Error	Indirect Addressing Fields Must Be Zero: if not all indirect
		addressing fields are zero for direct addressing.
		@throws	Error	Varying Registers Only Read In Fragment: if a varying register is
		read in a vertex program. Varying registers can only be written in vertex
		programs and read in fragment programs.
		@throws	Error	Attribute Registers Only Read In Vertex: if an attribute
		registers is read in a fragment program. Attribute registers can only be read
		in vertex programs.
		@throws	Error	Can Not Read Output Register: if an output (position or color)
		register is read. Output registers can only be written to, not read.
		@throws	Error	Temp Register Read Without Write: if a temporary register is read
		without being written to earlier.
		@throws	Error	Temp Register Component Read Without Write: if a specific
		temporary register component is read without being written to earlier.
		@throws	Error	Sampler Register Cannot Be Written To: if a sampler register is
		written to. Sampler registers can only be read, not written to.
		@throws	Error	Varying Registers Write: if a varying register is written to in
		a fragment program. Varying registers can only be written in vertex programs and
		read in fragment programs.
		@throws	Error	Attribute Register Cannot Be Written To: if an attribute
		register is written to. Attribute registers are read-only.
		@throws	Error	Constant Register Cannot Be Written To: if a constant register
		is written to inside a shader program.
		@throws	Error	Destination Writemask Is Zero: if a destination writemask is
		zero. All components of an output register must be set.
		@throws	Error	AGAL Reserved Bits Should Be Zero: if any reserved bits in a
		token are not zero. This indicates an error in creating the bytecode (or
		malformed bytecode).
		@throws	Error	Unknown Register Type: if an invalid register type index is used.
		@throws	Error	Sampler Register Out Of Bounds: if an invalid sampler register
		index is used.
		@throws	Error	Varying Register Out Of Bounds: if an invalid varying register
		index is used.
		@throws	Error	Attribute Register Out Of Bounds: if an invalid attribute
		register index is used.
		@throws	Error	Constant Register Out Of Bounds: if an invalid constant
		register index is used.
		@throws	Error	Output Register Out Of Bounds: if an invalid output register
		index is used.
		@throws	Error	Temporary Register Out Of Bounds: if an invalid temporary
		register index is used.
		@throws	Error	Cube Map Sampler Must Use Clamp: if a cube map sampler does not
		set the wrap mode to clamp.
		@throws	Error	Unknown Sampler Dimension: if a sample uses an unknown sampler
		dimension. (Only 2D and cube textures are supported.)
		@throws	Error	Unknown Filter Mode: if a sampler uses an unknown filter mode.
		(Only nearest neighbor and linear filtering are supported.)
		@throws	Error	Unknown Mipmap Mode: if a sampler uses an unknown mipmap mode.
		(Only none, nearest neighbor, and linear mipmap modes are supported.)
		@throws	Error	Unknown Wrapping Mode if a sampler uses an unknown wrapping mode.
		(Only clamp and repeat wrapping modes are supported.)
		@throws	Error	Unknown Special Flag: if a sampler uses an unknown special flag.
		@throws	Error	Output Color Not Maskable: You cannot mask the color output
		register in a fragment program. All components of the color register must be set.
		@throws	Error	Second Operand Must Be Sampler Register: The AGAL tex opcode must
		have a sampler as the second source operand.
		@throws	Error	Indirect Not Allowed: indirect addressing used where not allowed.
		@throws	Error	Swizzle Must Be Scalar: swizzling error.
		@throws	Error	Cant Swizzle 2nd Source: swizzling error.
		@throws	Error	Second Use Of Sampler Must Have Same Params: all samplers that
		access the same texture must use the same dimension, wrap, filter, special, and
		mipmap settings.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function upload(vertexProgram:ByteArray, fragmentProgram:ByteArray):Void
	{
		_.upload(vertexProgram, fragmentProgram);
	}

	/**
		**BETA**

		Uploads a pair of rendering programs expressed in GLSL (GL Shader Language).
	**/
	public function uploadSources(vertexSource:String, fragmentSource:String):Void
	{
		_.uploadSources(vertexSource, fragmentSource);
	}

	@:noCompletion private function __getSamplerState(sampler:Int):SamplerState
	{
		return __samplerStates[sampler];
	}

	@:noCompletion private function __markDirty(isVertex:Bool, index:Int, count:Int):Void
	{
		_.markDirty(isVertex, index, count);
	}

	private function __setSamplerState(sampler:Int, state:SamplerState):Void
	{
		__samplerStates[sampler] = state;
	}
}
#else
typedef Program3D = flash.display3D.Program3D;
#end
