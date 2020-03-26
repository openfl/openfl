namespace openfl._internal.backend.lime_standalone;

#if openfl_html5
import js.html.webgl.ActiveInfo in GLActiveInfo;
import js.html.webgl.Buffer in GLBuffer;
import js.html.webgl.Program in GLProgram;
import js.html.webgl.Query in GLQuery;
import js.html.webgl.RenderingContext in WebGLRenderingContext;
import js.html.webgl.Sampler in GLSampler;
import js.html.webgl.Sync in GLSync;
import js.html.webgl.Texture in GLTexture;
import js.html.webgl.TransformFeedback in GLTransformFeedback;
import js.html.webgl.UniformLocation in GLUniformLocation;
import js.html.webgl.VertexArrayObject in GLVertexArrayObject;
import openfl._internal.bindings.typedarray.ArrayBuffer;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.Float32Array;
// import openfl._internal.bindings.typedarray.Int32Array;
// import openfl._internal.bindings.typedarray.UInt32Array;
#if haxe4
import js.lib.Int32Array;
import js.html.Uint32Array in UInt32Array;
#else
import js.html.Int32Array;
import js.html.Uint32Array in UInt32Array;
#end

@: access(lime.graphics.RenderContext)
@: forward()
abstract WebGL2RenderContext(HTML5WebGL2RenderContext) from HTML5WebGL2RenderContext to HTML5WebGL2RenderContext
{
	public inline bufferData(target : number, srcData: Dynamic, usage : number, ?srcOffset : number, ?length : number): void
		{
			if(srcOffset != null)
	{
		this.bufferData(target, srcData, usage, srcOffset, length);
	}
		else
	{
		this.bufferData(target, srcData, usage);
	}
}

	public inline bufferSubData(target : number, dstByteOffset : number, srcData: Dynamic, ?srcOffset : number, ?length : number): void
	{
		if(srcOffset != null)
{
	this.bufferSubData(target, dstByteOffset, srcData, srcOffset, length);
}
		else
{
	this.bufferSubData(target, dstByteOffset, srcData);
}
	}

	public inline compressedTexImage2D(target : number, level : number, internalformat : number, width : number, height : number, border : number, srcData: Dynamic, ?srcOffset : number,
			?srcLengthOverride : number): void
	{
		if(srcOffset != null)
{
	this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData, srcOffset, srcLengthOverride);
}
		else
{
	this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData);
}
	}

	public inline compressedTexSubImage2D(target : number, level : number, xoffset : number, yoffset : number, width : number, height : number, format : number, srcData: Dynamic,
			?srcOffset : number, ?srcLengthOverride : number): void
	{
		if(srcOffset != null)
{
	this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData, srcOffset, srcLengthOverride);
}
		else
{
	this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData);
}
	}

	public inline getBufferSubData(target : number, srcByteOffset: DataPointer, dstData: Dynamic, ?srcOffset: Dynamic, ?length : number): void
	{
		if(srcOffset != null)
{
	this.getBufferSubData(target, srcByteOffset, dstData, srcOffset, length);
}
		else
{
	this.getBufferSubData(target, srcByteOffset, dstData);
}
	}

	public inline readPixels(x : number, y : number, width : number, height : number, format : number, type : number, pixels: Dynamic, ?dstOffset : number): void
	{
		if(dstOffset != null)
{
	this.readPixels(x, y, width, height, format, type, pixels, dstOffset);
}
		else
{
	this.readPixels(x, y, width, height, format, type, pixels);
}
	}

	public inline texImage2D(target : number, level : number, internalformat : number, width : number, height : number, border: Dynamic, ?format : number, ?type : number,
			?srcData: Dynamic, ?srcOffset : number): void
	{
		if(srcOffset != null)
{
	this.texImage2D(target, level, internalformat, width, height, border, format, type, srcData, srcOffset);
}
		else if (format != null)
{
	this.texImage2D(target, level, internalformat, width, height, border, format, type, srcData);
}
else
{
	this.texImage2D(target, level, internalformat, width, height, border); // target, level, internalformat, format, type, pixels
}
	}

	public inline texSubImage2D(target : number, level : number, xoffset : number, yoffset : number, width : number, height : number, format: Dynamic, ?type : number, ?srcData: Dynamic,
			?srcOffset : number): void
	{
		if(srcOffset != null)
{
	this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData, srcOffset);
}
		else if (type != null)
{
	this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData);
}
else
{
	this.texSubImage2D(target, level, xoffset, yoffset, width, height, format); // target, level, xoffset, yoffset, format, type, pixels
}
	}

	public inline uniform1fv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform1fv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform1fv(location, data);
}
	}

	public inline uniform1iv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform1iv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform1iv(location, data);
}
	}

	public uniform2fv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform2fv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform2fv(location, data);
}
	}

	public inline uniform2iv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform2iv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform2iv(location, data);
}
	}

	public inline uniform3fv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform3fv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform3fv(location, data);
}
	}

	public inline uniform3iv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform3iv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform3iv(location, data);
}
	}

	public inline uniform4fv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform4fv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform4fv(location, data);
}
	}

	public inline uniform4iv(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniform4iv(location, data, srcOffset, srcLength);
}
		else
{
	this.uniform4iv(location, data);
}
	}

	public inline uniformMatrix2fv(location: GLUniformLocation, transpose : boolean, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniformMatrix2fv(location, transpose, data, srcOffset, srcLength);
}
		else
{
	this.uniformMatrix2fv(location, transpose, data);
}
	}

	public inline uniformMatrix3fv(location: GLUniformLocation, transpose : boolean, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniformMatrix3fv(location, transpose, data, srcOffset, srcLength);
}
		else
{
	this.uniformMatrix3fv(location, transpose, data);
}
	}

	public inline uniformMatrix4fv(location: GLUniformLocation, transpose : boolean, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
	{
		if(srcOffset != null)
{
	this.uniformMatrix4fv(location, transpose, data, srcOffset, srcLength);
}
		else
{
	this.uniformMatrix4fv(location, transpose, data);
}
	}

@: from private static fromGL(gl: Class<GL>): WebGL2RenderContext
	{
		return null;
	}

	@: from private static fromRenderContext(context: RenderContext): WebGL2RenderContext
{
	return context.webgl2;
}

@: from private static toWebGLRenderContext(gl: WebGLRenderContext): WebGL2RenderContext
{
	return cast gl;
}
}

@: native("WebGL2RenderingContext")
extern class HTML5WebGL2RenderContext extends WebGLRenderingContext
{
	public DEPTH_BUFFER_BIT: number;
	public STENCIL_BUFFER_BIT: number;
	public COLOR_BUFFER_BIT: number;
	public POINTS: number;
	public LINES: number;
	public LINE_LOOP: number;
	public LINE_STRIP: number;
	public TRIANGLES: number;
	public TRIANGLE_STRIP: number;
	public TRIANGLE_FAN: number;
	public ZERO: number;
	public ONE: number;
	public SRC_COLOR: number;
	public ONE_MINUS_SRC_COLOR: number;
	public SRC_ALPHA: number;
	public ONE_MINUS_SRC_ALPHA: number;
	public DST_ALPHA: number;
	public ONE_MINUS_DST_ALPHA: number;
	public DST_COLOR: number;
	public ONE_MINUS_DST_COLOR: number;
	public SRC_ALPHA_SATURATE: number;
	public FUNC_ADD: number;
	public BLEND_EQUATION: number;
	public BLEND_EQUATION_RGB: number;
	public BLEND_EQUATION_ALPHA: number;
	public FUNC_SUBTRACT: number;
	public FUNC_REVERSE_SUBTRACT: number;
	public BLEND_DST_RGB: number;
	public BLEND_SRC_RGB: number;
	public BLEND_DST_ALPHA: number;
	public BLEND_SRC_ALPHA: number;
	public CONSTANT_COLOR: number;
	public ONE_MINUS_CONSTANT_COLOR: number;
	public CONSTANT_ALPHA: number;
	public ONE_MINUS_CONSTANT_ALPHA: number;
	public BLEND_COLOR: number;
	public ARRAY_BUFFER: number;
	public ELEMENT_ARRAY_BUFFER: number;
	public ARRAY_BUFFER_BINDING: number;
	public ELEMENT_ARRAY_BUFFER_BINDING: number;
	public STREAM_DRAW: number;
	public STATIC_DRAW: number;
	public DYNAMIC_DRAW: number;
	public BUFFER_SIZE: number;
	public BUFFER_USAGE: number;
	public CURRENT_VERTEX_ATTRIB: number;
	public FRONT: number;
	public BACK: number;
	public FRONT_AND_BACK: number;
	public CULL_FACE: number;
	public BLEND: number;
	public DITHER: number;
	public STENCIL_TEST: number;
	public DEPTH_TEST: number;
	public SCISSOR_TEST: number;
	public POLYGON_OFFSET_FILL: number;
	public SAMPLE_ALPHA_TO_COVERAGE: number;
	public SAMPLE_COVERAGE: number;
	public NO_ERROR: number;
	public INVALID_ENUM: number;
	public INVALID_VALUE: number;
	public INVALID_OPERATION: number;
	public OUT_OF_MEMORY: number;
	public CW: number;
	public CCW: number;
	public LINE_WIDTH: number;
	public ALIASED_POINT_SIZE_RANGE: number;
	public ALIASED_LINE_WIDTH_RANGE: number;
	public CULL_FACE_MODE: number;
	public FRONT_FACE: number;
	public DEPTH_RANGE: number;
	public DEPTH_WRITEMASK: number;
	public DEPTH_CLEAR_VALUE: number;
	public DEPTH_FUNC: number;
	public STENCIL_CLEAR_VALUE: number;
	public STENCIL_FUNC: number;
	public STENCIL_FAIL: number;
	public STENCIL_PASS_DEPTH_FAIL: number;
	public STENCIL_PASS_DEPTH_PASS: number;
	public STENCIL_REF: number;
	public STENCIL_VALUE_MASK: number;
	public STENCIL_WRITEMASK: number;
	public STENCIL_BACK_FUNC: number;
	public STENCIL_BACK_FAIL: number;
	public STENCIL_BACK_PASS_DEPTH_FAIL: number;
	public STENCIL_BACK_PASS_DEPTH_PASS: number;
	public STENCIL_BACK_REF: number;
	public STENCIL_BACK_VALUE_MASK: number;
	public STENCIL_BACK_WRITEMASK: number;
	public VIEWPORT: number;
	public SCISSOR_BOX: number;
	public COLOR_CLEAR_VALUE: number;
	public COLOR_WRITEMASK: number;
	public UNPACK_ALIGNMENT: number;
	public PACK_ALIGNMENT: number;
	public MAX_TEXTURE_SIZE: number;
	public MAX_VIEWPORT_DIMS: number;
	public SUBPIXEL_BITS: number;
	public RED_BITS: number;
	public GREEN_BITS: number;
	public BLUE_BITS: number;
	public ALPHA_BITS: number;
	public DEPTH_BITS: number;
	public STENCIL_BITS: number;
	public POLYGON_OFFSET_UNITS: number;
	public POLYGON_OFFSET_FACTOR: number;
	public TEXTURE_BINDING_2D: number;
	public SAMPLE_BUFFERS: number;
	public SAMPLES: number;
	public SAMPLE_COVERAGE_VALUE: number;
	public SAMPLE_COVERAGE_INVERT: number;
	public COMPRESSED_TEXTURE_FORMATS: number;
	public DONT_CARE: number;
	public FASTEST: number;
	public NICEST: number;
	public GENERATE_MIPMAP_HINT: number;
	public BYTE: number;
	public UNSIGNED_BYTE: number;
	public SHORT: number;
	public UNSIGNED_SHORT: number;
	public INT: number;
	public UNSIGNED_INT: number;
	public FLOAT: number;
	public DEPTH_COMPONENT: number;
	public ALPHA: number;
	public RGB: number;
	public RGBA: number;
	public LUMINANCE: number;
	public LUMINANCE_ALPHA: number;
	public UNSIGNED_SHORT_4_4_4_4: number;
	public UNSIGNED_SHORT_5_5_5_1: number;
	public UNSIGNED_SHORT_5_6_5: number;
	public FRAGMENT_SHADER: number;
	public VERTEX_SHADER: number;
	public MAX_VERTEX_ATTRIBS: number;
	public MAX_VERTEX_UNIFORM_VECTORS: number;
	public MAX_VARYING_VECTORS: number;
	public MAX_COMBINED_TEXTURE_IMAGE_UNITS: number;
	public MAX_VERTEX_TEXTURE_IMAGE_UNITS: number;
	public MAX_TEXTURE_IMAGE_UNITS: number;
	public MAX_FRAGMENT_UNIFORM_VECTORS: number;
	public SHADER_TYPE: number;
	public DELETE_STATUS: number;
	public LINK_STATUS: number;
	public VALIDATE_STATUS: number;
	public ATTACHED_SHADERS: number;
	public ACTIVE_UNIFORMS: number;
	public ACTIVE_ATTRIBUTES: number;
	public SHADING_LANGUAGE_VERSION: number;
	public CURRENT_PROGRAM: number;
	public NEVER: number;
	public LESS: number;
	public EQUAL: number;
	public LEQUAL: number;
	public GREATER: number;
	public NOTEQUAL: number;
	public GEQUAL: number;
	public ALWAYS: number;
	public KEEP: number;
	public REPLACE: number;
	public INCR: number;
	public DECR: number;
	public INVERT: number;
	public INCR_WRAP: number;
	public DECR_WRAP: number;
	public VENDOR: number;
	public RENDERER: number;
	public VERSION: number;
	public NEAREST: number;
	public LINEAR: number;
	public NEAREST_MIPMAP_NEAREST: number;
	public LINEAR_MIPMAP_NEAREST: number;
	public NEAREST_MIPMAP_LINEAR: number;
	public LINEAR_MIPMAP_LINEAR: number;
	public TEXTURE_MAG_FILTER: number;
	public TEXTURE_MIN_FILTER: number;
	public TEXTURE_WRAP_S: number;
	public TEXTURE_WRAP_T: number;
	public TEXTURE_2D: number;
	public TEXTURE: number;
	public TEXTURE_CUBE_MAP: number;
	public TEXTURE_BINDING_CUBE_MAP: number;
	public TEXTURE_CUBE_MAP_POSITIVE_X: number;
	public TEXTURE_CUBE_MAP_NEGATIVE_X: number;
	public TEXTURE_CUBE_MAP_POSITIVE_Y: number;
	public TEXTURE_CUBE_MAP_NEGATIVE_Y: number;
	public TEXTURE_CUBE_MAP_POSITIVE_Z: number;
	public TEXTURE_CUBE_MAP_NEGATIVE_Z: number;
	public MAX_CUBE_MAP_TEXTURE_SIZE: number;
	public TEXTURE0: number;
	public TEXTURE1: number;
	public TEXTURE2: number;
	public TEXTURE3: number;
	public TEXTURE4: number;
	public TEXTURE5: number;
	public TEXTURE6: number;
	public TEXTURE7: number;
	public TEXTURE8: number;
	public TEXTURE9: number;
	public TEXTURE10: number;
	public TEXTURE11: number;
	public TEXTURE12: number;
	public TEXTURE13: number;
	public TEXTURE14: number;
	public TEXTURE15: number;
	public TEXTURE16: number;
	public TEXTURE17: number;
	public TEXTURE18: number;
	public TEXTURE19: number;
	public TEXTURE20: number;
	public TEXTURE21: number;
	public TEXTURE22: number;
	public TEXTURE23: number;
	public TEXTURE24: number;
	public TEXTURE25: number;
	public TEXTURE26: number;
	public TEXTURE27: number;
	public TEXTURE28: number;
	public TEXTURE29: number;
	public TEXTURE30: number;
	public TEXTURE31: number;
	public ACTIVE_TEXTURE: number;
	public REPEAT: number;
	public CLAMP_TO_EDGE: number;
	public MIRRORED_REPEAT: number;
	public FLOAT_VEC2: number;
	public FLOAT_VEC3: number;
	public FLOAT_VEC4: number;
	public INT_VEC2: number;
	public INT_VEC3: number;
	public INT_VEC4: number;
	public BOOL: number;
	public BOOL_VEC2: number;
	public BOOL_VEC3: number;
	public BOOL_VEC4: number;
	public FLOAT_MAT2: number;
	public FLOAT_MAT3: number;
	public FLOAT_MAT4: number;
	public SAMPLER_2D: number;
	public SAMPLER_CUBE: number;
	public VERTEX_ATTRIB_ARRAY_ENABLED: number;
	public VERTEX_ATTRIB_ARRAY_SIZE: number;
	public VERTEX_ATTRIB_ARRAY_STRIDE: number;
	public VERTEX_ATTRIB_ARRAY_TYPE: number;
	public VERTEX_ATTRIB_ARRAY_NORMALIZED: number;
	public VERTEX_ATTRIB_ARRAY_POINTER: number;
	public VERTEX_ATTRIB_ARRAY_BUFFER_BINDING: number;
	public COMPILE_STATUS: number;
	public LOW_FLOAT: number;
	public MEDIUM_FLOAT: number;
	public HIGH_FLOAT: number;
	public LOW_INT: number;
	public MEDIUM_INT: number;
	public HIGH_INT: number;
	public FRAMEBUFFER: number;
	public RENDERBUFFER: number;
	public RGBA4: number;
	public RGB5_A1: number;
	public RGB565: number;
	public DEPTH_COMPONENT16: number;
	public STENCIL_INDEX: number;
	public STENCIL_INDEX8: number;
	public DEPTH_STENCIL: number;
	public RENDERBUFFER_WIDTH: number;
	public RENDERBUFFER_HEIGHT: number;
	public RENDERBUFFER_INTERNAL_FORMAT: number;
	public RENDERBUFFER_RED_SIZE: number;
	public RENDERBUFFER_GREEN_SIZE: number;
	public RENDERBUFFER_BLUE_SIZE: number;
	public RENDERBUFFER_ALPHA_SIZE: number;
	public RENDERBUFFER_DEPTH_SIZE: number;
	public RENDERBUFFER_STENCIL_SIZE: number;
	public FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE: number;
	public FRAMEBUFFER_ATTACHMENT_OBJECT_NAME: number;
	public FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL: number;
	public FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE: number;
	public COLOR_ATTACHMENT0: number;
	public DEPTH_ATTACHMENT: number;
	public STENCIL_ATTACHMENT: number;
	public DEPTH_STENCIL_ATTACHMENT: number;
	public NONE: number;
	public FRAMEBUFFER_COMPLETE: number;
	public FRAMEBUFFER_INCOMPLETE_ATTACHMENT: number;
	public FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT: number;
	public FRAMEBUFFER_INCOMPLETE_DIMENSIONS: number;
	public FRAMEBUFFER_UNSUPPORTED: number;
	public FRAMEBUFFER_BINDING: number;
	public RENDERBUFFER_BINDING: number;
	public MAX_RENDERBUFFER_SIZE: number;
	public INVALID_FRAMEBUFFER_OPERATION: number;
	public UNPACK_FLIP_Y_WEBGL: number;
	public UNPACK_PREMULTIPLY_ALPHA_WEBGL: number;
	public CONTEXT_LOST_WEBGL: number;
	public UNPACK_COLORSPACE_CONVERSION_WEBGL: number;
	public BROWSER_DEFAULT_WEBGL: number;
	public READ_BUFFER: number;
	public UNPACK_ROW_LENGTH: number;
	public UNPACK_SKIP_ROWS: number;
	public UNPACK_SKIP_PIXELS: number;
	public PACK_ROW_LENGTH: number;
	public PACK_SKIP_ROWS: number;
	public PACK_SKIP_PIXELS: number;
	public TEXTURE_BINDING_3D: number;
	public UNPACK_SKIP_IMAGES: number;
	public UNPACK_IMAGE_HEIGHT: number;
	public MAX_3D_TEXTURE_SIZE: number;
	public MAX_ELEMENTS_VERTICES: number;
	public MAX_ELEMENTS_INDICES: number;
	public MAX_TEXTURE_LOD_BIAS: number;
	public MAX_FRAGMENT_UNIFORM_COMPONENTS: number;
	public MAX_VERTEX_UNIFORM_COMPONENTS: number;
	public MAX_ARRAY_TEXTURE_LAYERS: number;
	public MIN_PROGRAM_TEXEL_OFFSET: number;
	public MAX_PROGRAM_TEXEL_OFFSET: number;
	public MAX_VARYING_COMPONENTS: number;
	public FRAGMENT_SHADER_DERIVATIVE_HINT: number;
	public RASTERIZER_DISCARD: number;
	public VERTEX_ARRAY_BINDING: number;
	public MAX_VERTEX_OUTPUT_COMPONENTS: number;
	public MAX_FRAGMENT_INPUT_COMPONENTS: number;
	public MAX_SERVER_WAIT_TIMEOUT: number;
	public MAX_ELEMENT_INDEX: number;
	public RED: number;
	public RGB8: number;
	public RGBA8: number;
	public RGB10_A2: number;
	public TEXTURE_3D: number;
	public TEXTURE_WRAP_R: number;
	public TEXTURE_MIN_LOD: number;
	public TEXTURE_MAX_LOD: number;
	public TEXTURE_BASE_LEVEL: number;
	public TEXTURE_MAX_LEVEL: number;
	public TEXTURE_COMPARE_MODE: number;
	public TEXTURE_COMPARE_FUNC: number;
	public SRGB: number;
	public SRGB8: number;
	public SRGB8_ALPHA8: number;
	public COMPARE_REF_TO_TEXTURE: number;
	public RGBA32F: number;
	public RGB32F: number;
	public RGBA16F: number;
	public RGB16F: number;
	public TEXTURE_2D_ARRAY: number;
	public TEXTURE_BINDING_2D_ARRAY: number;
	public R11F_G11F_B10F: number;
	public RGB9_E5: number;
	public RGBA32UI: number;
	public RGB32UI: number;
	public RGBA16UI: number;
	public RGB16UI: number;
	public RGBA8UI: number;
	public RGB8UI: number;
	public RGBA32I: number;
	public RGB32I: number;
	public RGBA16I: number;
	public RGB16I: number;
	public RGBA8I: number;
	public RGB8I: number;
	public RED_INTEGER: number;
	public RGB_INTEGER: number;
	public RGBA_INTEGER: number;
	public R8: number;
	public RG8: number;
	public R16F: number;
	public R32F: number;
	public RG16F: number;
	public RG32F: number;
	public R8I: number;
	public R8UI: number;
	public R16I: number;
	public R16UI: number;
	public R32I: number;
	public R32UI: number;
	public RG8I: number;
	public RG8UI: number;
	public RG16I: number;
	public RG16UI: number;
	public RG32I: number;
	public RG32UI: number;
	public R8_SNORM: number;
	public RG8_SNORM: number;
	public RGB8_SNORM: number;
	public RGBA8_SNORM: number;
	public RGB10_A2UI: number;
	public TEXTURE_IMMUTABLE_FORMAT: number;
	public TEXTURE_IMMUTABLE_LEVELS: number;
	public UNSIGNED_INT_2_10_10_10_REV: number;
	public UNSIGNED_INT_10F_11F_11F_REV: number;
	public UNSIGNED_INT_5_9_9_9_REV: number;
	public FLOAT_32_UNSIGNED_INT_24_8_REV: number;
	public UNSIGNED_INT_24_8: number;
	public HALF_FLOAT: number;
	public RG: number;
	public RG_INTEGER: number;
	public INT_2_10_10_10_REV: number;
	public CURRENT_QUERY: number;
	public QUERY_RESULT: number;
	public QUERY_RESULT_AVAILABLE: number;
	public ANY_SAMPLES_PASSED: number;
	public ANY_SAMPLES_PASSED_CONSERVATIVE: number;
	public MAX_DRAW_BUFFERS: number;
	public DRAW_BUFFER0: number;
	public DRAW_BUFFER1: number;
	public DRAW_BUFFER2: number;
	public DRAW_BUFFER3: number;
	public DRAW_BUFFER4: number;
	public DRAW_BUFFER5: number;
	public DRAW_BUFFER6: number;
	public DRAW_BUFFER7: number;
	public DRAW_BUFFER8: number;
	public DRAW_BUFFER9: number;
	public DRAW_BUFFER10: number;
	public DRAW_BUFFER11: number;
	public DRAW_BUFFER12: number;
	public DRAW_BUFFER13: number;
	public DRAW_BUFFER14: number;
	public DRAW_BUFFER15: number;
	public MAX_COLOR_ATTACHMENTS: number;
	public COLOR_ATTACHMENT1: number;
	public COLOR_ATTACHMENT2: number;
	public COLOR_ATTACHMENT3: number;
	public COLOR_ATTACHMENT4: number;
	public COLOR_ATTACHMENT5: number;
	public COLOR_ATTACHMENT6: number;
	public COLOR_ATTACHMENT7: number;
	public COLOR_ATTACHMENT8: number;
	public COLOR_ATTACHMENT9: number;
	public COLOR_ATTACHMENT10: number;
	public COLOR_ATTACHMENT11: number;
	public COLOR_ATTACHMENT12: number;
	public COLOR_ATTACHMENT13: number;
	public COLOR_ATTACHMENT14: number;
	public COLOR_ATTACHMENT15: number;
	public SAMPLER_3D: number;
	public SAMPLER_2D_SHADOW: number;
	public SAMPLER_2D_ARRAY: number;
	public SAMPLER_2D_ARRAY_SHADOW: number;
	public SAMPLER_CUBE_SHADOW: number;
	public INT_SAMPLER_2D: number;
	public INT_SAMPLER_3D: number;
	public INT_SAMPLER_CUBE: number;
	public INT_SAMPLER_2D_ARRAY: number;
	public UNSIGNED_INT_SAMPLER_2D: number;
	public UNSIGNED_INT_SAMPLER_3D: number;
	public UNSIGNED_INT_SAMPLER_CUBE: number;
	public UNSIGNED_INT_SAMPLER_2D_ARRAY: number;
	public MAX_SAMPLES: number;
	public SAMPLER_BINDING: number;
	public PIXEL_PACK_BUFFER: number;
	public PIXEL_UNPACK_BUFFER: number;
	public PIXEL_PACK_BUFFER_BINDING: number;
	public PIXEL_UNPACK_BUFFER_BINDING: number;
	public COPY_READ_BUFFER: number;
	public COPY_WRITE_BUFFER: number;
	public COPY_READ_BUFFER_BINDING: number;
	public COPY_WRITE_BUFFER_BINDING: number;
	public FLOAT_MAT2x3: number;
	public FLOAT_MAT2x4: number;
	public FLOAT_MAT3x2: number;
	public FLOAT_MAT3x4: number;
	public FLOAT_MAT4x2: number;
	public FLOAT_MAT4x3: number;
	public UNSIGNED_INT_VEC2: number;
	public UNSIGNED_INT_VEC3: number;
	public UNSIGNED_INT_VEC4: number;
	public UNSIGNED_NORMALIZED: number;
	public SIGNED_NORMALIZED: number;
	public VERTEX_ATTRIB_ARRAY_INTEGER: number;
	public VERTEX_ATTRIB_ARRAY_DIVISOR: number;
	public TRANSFORM_FEEDBACK_BUFFER_MODE: number;
	public MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS: number;
	public TRANSFORM_FEEDBACK_VARYINGS: number;
	public TRANSFORM_FEEDBACK_BUFFER_START: number;
	public TRANSFORM_FEEDBACK_BUFFER_SIZE: number;
	public TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN: number;
	public MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS: number;
	public MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS: number;
	public INTERLEAVED_ATTRIBS: number;
	public SEPARATE_ATTRIBS: number;
	public TRANSFORM_FEEDBACK_BUFFER: number;
	public TRANSFORM_FEEDBACK_BUFFER_BINDING: number;
	public TRANSFORM_FEEDBACK: number;
	public TRANSFORM_FEEDBACK_PAUSED: number;
	public TRANSFORM_FEEDBACK_ACTIVE: number;
	public TRANSFORM_FEEDBACK_BINDING: number;
	public FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING: number;
	public FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE: number;
	public FRAMEBUFFER_ATTACHMENT_RED_SIZE: number;
	public FRAMEBUFFER_ATTACHMENT_GREEN_SIZE: number;
	public FRAMEBUFFER_ATTACHMENT_BLUE_SIZE: number;
	public FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE: number;
	public FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE: number;
	public FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE: number;
	public FRAMEBUFFER_DEFAULT: number;
	public DEPTH24_STENCIL8: number;
	public DRAW_FRAMEBUFFER_BINDING: number;
	public READ_FRAMEBUFFER: number;
	public DRAW_FRAMEBUFFER: number;
	public READ_FRAMEBUFFER_BINDING: number;
	public RENDERBUFFER_SAMPLES: number;
	public FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER: number;
	public FRAMEBUFFER_INCOMPLETE_MULTISAMPLE: number;
	public UNIFORM_BUFFER: number;
	public UNIFORM_BUFFER_BINDING: number;
	public UNIFORM_BUFFER_START: number;
	public UNIFORM_BUFFER_SIZE: number;
	public MAX_VERTEX_UNIFORM_BLOCKS: number;
	public MAX_FRAGMENT_UNIFORM_BLOCKS: number;
	public MAX_COMBINED_UNIFORM_BLOCKS: number;
	public MAX_UNIFORM_BUFFER_BINDINGS: number;
	public MAX_UNIFORM_BLOCK_SIZE: number;
	public MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS: number;
	public MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS: number;
	public UNIFORM_BUFFER_OFFSET_ALIGNMENT: number;
	public ACTIVE_UNIFORM_BLOCKS: number;
	public UNIFORM_TYPE: number;
	public UNIFORM_SIZE: number;
	public UNIFORM_BLOCK_INDEX: number;
	public UNIFORM_OFFSET: number;
	public UNIFORM_ARRAY_STRIDE: number;
	public UNIFORM_MATRIX_STRIDE: number;
	public UNIFORM_IS_ROW_MAJOR: number;
	public UNIFORM_BLOCK_BINDING: number;
	public UNIFORM_BLOCK_DATA_SIZE: number;
	public UNIFORM_BLOCK_ACTIVE_UNIFORMS: number;
	public UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES: number;
	public UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER: number;
	public UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER: number;
	public OBJECT_TYPE: number;
	public SYNC_CONDITION: number;
	public SYNC_STATUS: number;
	public SYNC_FLAGS: number;
	public SYNC_FENCE: number;
	public SYNC_GPU_COMMANDS_COMPLETE: number;
	public UNSIGNALED: number;
	public SIGNALED: number;
	public ALREADY_SIGNALED: number;
	public TIMEOUT_EXPIRED: number;
	public CONDITION_SATISFIED: number;
	public WAIT_FAILED: number;
	public SYNC_FLUSH_COMMANDS_BIT: number;
	public COLOR: number;
	public DEPTH: number;
	public STENCIL: number;
	public MIN: number;
	public MAX: number;
	public DEPTH_COMPONENT24: number;
	public STREAM_READ: number;
	public STREAM_COPY: number;
	public STATIC_READ: number;
	public STATIC_COPY: number;
	public DYNAMIC_READ: number;
	public DYNAMIC_COPY: number;
	public DEPTH_COMPONENT32F: number;
	public DEPTH32F_STENCIL8: number;
	public INVALID_INDEX: number;
	public TIMEOUT_IGNORED: number;
	public MAX_CLIENT_WAIT_TIMEOUT_WEBGL: number;
	public beginQuery(target: number, query: GLQuery): void;
	public beginTransformFeedback(primitiveNode: number): void;
	public bindBufferBase(target: number, index: number, buffer: GLBuffer): void;
	public bindBufferRange(target: number, index: number, buffer: GLBuffer, offset: DataPointer, size: DataPointer): void;
	public bindSampler(unit: number, sampler: GLSampler): void;
	public bindTransformFeedback(target: number, transformFeedback: GLTransformFeedback): void;
	public bindVertexArray(vertexArray: GLVertexArrayObject): void;
	public blitFramebuffer(srcX0: number, srcY0: number, srcX1: number, srcY1: number, dstX0: number, dstY0: number, dstX1: number, dstY1: number, mask: number, filter: number): void;
	@: overload(function (target: number, data: ArrayBufferView, usage: number, srcOffset: number, ?length: number): void { })
@: overload(function (target: number, size: number, usage: number): void { })
@: overload(function (target: number, data: ArrayBufferView, usage: number): void { })
@: overload(function (target: number, data: ArrayBuffer, usage: number): void { })
override bufferData(target : number, data: Dynamic /*MISSING SharedArrayBuffer*/, usage : number): void;
@: overload(function (target: number, dstByteOffset: number, srcData: ArrayBufferView, srcOffset: number, ?length: number): void { })
@: overload(function (target: number, offset: number, data: ArrayBufferView): void { })
@: overload(function (target: number, offset: number, data: ArrayBuffer): void { })
override bufferSubData(target : number, offset : number, data: Dynamic /*MISSING SharedArrayBuffer*/): void;
public clearBufferfi(buffer : number, drawbuffer : number, depth : number, stencil : number): void;
@: overload(function (buffer: number, drawbuffer: number, values: Float32Array, ?srcOffset: number): void { })
@: overload(function (buffer: number, drawbuffer: number, depth: number, stencil: number): void { })
public clearBufferfv(buffer : number, drawbuffer : number, values: Array < Float >, ?srcOffset : number): void;
@: overload(function (buffer: number, drawbuffer: number, values: Float32Array, ?srcOffset: number): void { })
@: overload(function (buffer: number, drawbuffer: number, depth: number, stencil: number): void { })
public clearBufferiv(buffer : number, drawbuffer : number, values: Array < Int >, ?srcOffset : number): void;
@: overload(function (buffer: number, drawbuffer: number, values: number32Array, ?srcOffset: number): void { })
@: overload(function (buffer: number, drawbuffer: number, depth: number, stencil: number): void { })
public clearBufferuiv(buffer : number, drawbuffer : number, values: Array < Int >, ?srcOffset : number): void;
public clientWaitSync(sync: GLSync, flags : number, timeout: Dynamic /*Int64*/) : number;
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, offset: number): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, srcData: ArrayBufferView, ?srcOffset: number,
		?srcLengthOverride: number): void { })
override compressedTexImage2D(target : number, level : number, internalformat : number, width : number, height : number, border : number, data: ArrayBufferView): void;
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, offset: number): void { })
public compressedTexImage3D(target : number, level : number, internalformat : number, width : number, height : number, depth : number, border : number, srcData: ArrayBufferView,
		?srcOffset : number, ?srcLengthOverride : number): void;
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, offset: number): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, srcData: ArrayBufferView, ?srcOffset: number,
		?srcLengthOverride: number): void { })
override compressedTexSubImage2D(target : number, level : number, xoffset : number, yoffset : number, width : number, height : number, format : number, data: ArrayBufferView): void;
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, offset: number): void { })
public compressedTexSubImage3D(target : number, level : number, xoffset : number, yoffset : number, zoffset : number, width : number, height : number, depth : number, format : number,
	srcData: ArrayBufferView, ?srcOffset : number, ?srcLengthOverride : number): void;
public copySubBufferData(readTarget : number, writeTarget : number, readOffset: DataPointer, writeOffset: DataPointer, size : number): void;
public copyTexSubImage3D(target : number, level : number, xoffset : number, yoffset : number, zoffset : number, x : number, y : number, width : number, height : number): void;
public createQuery(): GLQuery;
public createSampler(): GLSampler;
public createTransformFeedback(): GLTransformFeedback;
public createVertexArray(): GLVertexArrayObject;
public deleteQuery(query: GLQuery): void;
public deleteSampler(sampler: GLSampler): void;
public deleteSync(sync: GLSync): void;
public deleteTransformFeedback(transformFeedback: GLTransformFeedback): void;
public deleteVertexArray(vertexArray: GLVertexArrayObject): void;
public drawArraysInstanced(mode : number, first : number, count : number, instanceCount : number): void;
public drawBuffers(buffers: Array<Int>): void;
public drawElementsInstanced(mode : number, count : number, type : number, offset: DataPointer, instanceCount : number): void;
public drawRangeElements(mode : number, start : number, end : number, count : number, type : number, offset: DataPointer): void;
public endQuery(target : number): void;
public endTransformFeedback(): void;
public fenceSync(condition : number, flags : number): GLSync;
public framebufferTextureLayer(target : number, attachment : number, texture: GLTexture, level : number, layer : number): void;
public getActiveUniformBlockName(program: GLProgram, uniformBlockIndex : number): string;
public getActiveUniformBlockParameter(program: GLProgram, uniformBlockIndex : number, pname : number): Dynamic;
public getActiveUniforms(program: GLProgram, uniformIndices: Array < Int >, pname : number): Dynamic;
@: overload(function (target: number, srcByteOffset: DataPointer, dstData: ArrayBuffer, ?srcOffset: number, ?length: number): void { })
public getBufferSubData(target : number, srcByteOffset: DataPointer, dstData: Dynamic /*SharedArrayBuffer*/, ?srcOffset : number, ?length : number): void;
public getFragDataLocation(program: GLProgram, name: string) : number;
public getIndexedParameter(target : number, index : number): Dynamic;
public getInternalformatParameter(target : number, internalformat : number, pname : number): Dynamic;
public getQuery(target : number, pname : number): GLQuery;
public getQueryParameter(query: GLQuery, pname : number): Dynamic;
public getSamplerParameter(sampler: GLSampler, pname : number): Dynamic;
public getSyncParameter(sync: GLSync, pname : number): Dynamic;
public getTransformFeedbackVarying(program: GLProgram, index : number): GLActiveInfo;
public getUniformBlockIndex(program: GLProgram, uniformBlockName: string) : number;
@: overload(function (program: GLProgram, uniformNames: string): Array<Int> { })
public getUniformIndices(program: GLProgram, uniformNames: Array<string>): Array<Int>;
public invalidateFramebuffer(target : number, attachments: Array<Int>): void;
public invalidateSubFramebuffer(target : number, attachments: Array < Int >, x : number, y : number, width : number, height : number): void;
public isQuery(query: GLQuery) : boolean;
public isSampler(sampler: GLSampler) : boolean;
public isSync(sync: GLSync) : boolean;
public isTransformFeedback(transformFeedback: GLTransformFeedback) : boolean;
public isVertexArray(vertexArray: GLVertexArrayObject) : boolean;
public pauseTransformFeedback(): void;
public readBuffer(src : number): void;
@: overload(function (x: number, y: number, width: number, height: number, format: number, type: number, pixels: ArrayBufferView): void { })
@: overload(function (x: number, y: number, width: number, height: number, format: number, type: number, offset: number): void { })
@: overload(function (x: number, y: number, width: number, height: number, format: number, type: number, pixels: ArrayBufferView, dstOffset: number): void { })
override readPixels(x : number, y : number, width : number, height : number, format : number, type : number, pixels: ArrayBufferView): void;
public renderbufferStorageMultisample(target : number, samples : number, internalFormat : number, width : number, height : number): void;
public resumeTransformFeedback(): void;
public samplerParameterf(sampler: GLSampler, pname : number, param : number): void;
public samplerParameteri(sampler: GLSampler, pname : number, param : number): void;
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number, offset: DataPointer): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number, srcData: ArrayBufferView,
	srcOffset: number): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number,
	source: Dynamic /*js.html.ImageBitmap*/): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number, source: js.html.ImageData): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number,
	source: js.html.ImageElement): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number,
	source: js.html.CanvasElement): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number,
	source: js.html.VideoElement): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, border: number, format: number, type: number, pixels: ArrayBufferView): void { })
@: overload(function (target: number, level: number, internalformat: number, format: number, type: number, pixels: js.html.ImageData): void { })
@: overload(function (target: number, level: number, internalformat: number, format: number, type: number, image: js.html.ImageElement): void { })
@: overload(function (target: number, level: number, internalformat: number, format: number, type: number, canvas: js.html.CanvasElement): void { })
override texImage2D(target : number, level : number, internalformat : number, format : number, type : number, video: js.html.VideoElement): void;
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	source: js.html.CanvasElement): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	source: js.html.ImageElement): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	source: js.html.VideoElement): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	source: Dynamic /*js.html.ImageBitmap*/): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	source: js.html.ImageData): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	source: ArrayBufferView): void { })
@: overload(function (target: number, level: number, internalformat: number, width: number, height: number, depth: number, border: number, format: number, type: number,
	offset: DataPointer): void { })
public texImage3D(target : number, level : number, internalformat : number, width : number, height : number, depth : number, border : number, format : number, type : number,
		srcData: ArrayBufferView, ?srcOffset : number): void;
public texStorage2D(target : number, level : number, internalformat : number, width : number, height : number): void;
public texStorage3D(target : number, level : number, internalformat : number, width : number, height : number, depth : number): void;
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, srcData: ArrayBufferView,
	srcOffset: number): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, offset: DataPointer): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, source: js.html.ImageData): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, source: js.html.ImageElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, source: js.html.CanvasElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, source: js.html.VideoElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, source: Dynamic /*ImageBitmap*/): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, width: number, height: number, format: number, type: number, pixels: ArrayBufferView): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, format: number, type: number, pixels: js.html.ImageData): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, format: number, type: number, image: js.html.ImageElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, format: number, type: number, canvas: js.html.CanvasElement): void { })
override texSubImage2D(target : number, level : number, xoffset : number, yoffset : number, format : number, type : number, video: js.html.VideoElement): void;
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	offset: DataPointer): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	source: js.html.ImageData): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	source: js.html.ImageElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	source: js.html.CanvasElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	source: js.html.VideoElement): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	source: Dynamic /*ImageBitmap*/): void { })
@: overload(function (target: number, level: number, xoffset: number, yoffset: number, zoffset: number, width: number, height: number, depth: number, format: number, type: number,
	pixels: ArrayBufferView, ?srcOffset: number): void { })
public texSubImage3D(target : number, level : number, xoffset : number, yoffset : number, zoffset : number, width : number, height : number, depth : number, format : number, type : number,
		video: js.html.VideoElement): void;
public transformFeedbackVaryings(program: GLProgram, varyings: Array < String >, bufferMode : number): void;
public uniform1ui(location: GLUniformLocation, v0 : number): void;
public uniform2ui(location: GLUniformLocation, v0 : number, v1 : number): void;
public uniform3ui(location: GLUniformLocation, v0 : number, v1 : number, v2 : number): void;
public uniform4ui(location: GLUniformLocation, v0 : number, v1 : number, v2 : number, v3 : number): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniform1fv(location: GLUniformLocation, data: Array<Float>): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Int>, ?srcOffset: number, ?srcLength: number): void { })
override uniform1iv(location: GLUniformLocation, data: Array<Int>): void;
public uniform1uiv(location: GLUniformLocation, data: number32Array, ?srcOffset : number, ?srcLength : number): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniform2fv(location: GLUniformLocation, data: Array<Float>): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Int>, ?srcOffset: number, ?srcLength: number): void { })
override uniform2iv(location: GLUniformLocation, data: Array<Int>): void;
public uniform2uiv(location: GLUniformLocation, data: number32Array, ?srcOffset : number, ?srcLength : number): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniform3fv(location: GLUniformLocation, data: Array<Float>): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Int>, ?srcOffset: number, ?srcLength: number): void { })
override uniform3iv(location: GLUniformLocation, data: Array<Int>): void;
public uniform3uiv(location: GLUniformLocation, data: number32Array, ?srcOffset : number, ?srcLength : number): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniform4fv(location: GLUniformLocation, data: Array<Float>): void;
@: overload(function (location: GLUniformLocation, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, data: Array<Int>, ?srcOffset: number, ?srcLength: number): void { })
override uniform4iv(location: GLUniformLocation, data: Array<Int>): void;
public uniform4uiv(location: GLUniformLocation, data: number32Array, ?srcOffset : number, ?srcLength : number): void;
public uniformBlockBinding(program: GLProgram, uniformBlockIndex : number, uniformBlockBinding : number): void;
@: overload(function (location: GLUniformLocation, transpose: boolean, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, transpose: boolean, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniformMatrix2fv(location: GLUniformLocation, transpose : boolean, data: Array<Float>): void;
public uniformMatrix2x3fv(location: GLUniformLocation, transpose : boolean, data : Float32Array, ?srcOffset : number, ?srcLength : number): void;
public uniformMatrix2x4fv(location: GLUniformLocation, transpose : boolean, data : Float32Array, ?srcOffset : number, ?srcLength : number): void;
@: overload(function (location: GLUniformLocation, transpose: boolean, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, transpose: boolean, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniformMatrix3fv(location: GLUniformLocation, transpose : boolean, data: Array<Float>): void;
public uniformMatrix3x2fv(location: GLUniformLocation, transpose : boolean, data : Float32Array, ?srcOffset : number, ?srcLength : number): void;
public uniformMatrix3x4fv(location: GLUniformLocation, transpose : boolean, data : Float32Array, ?srcOffset : number, ?srcLength : number): void;
@: overload(function (location: GLUniformLocation, transpose: boolean, data: Float32Array, ?srcOffset: number, ?srcLength: number): void { })
@: overload(function (location: GLUniformLocation, transpose: boolean, data: Array<Float>, ?srcOffset: number, ?srcLength: number): void { })
override uniformMatrix4fv(location: GLUniformLocation, transpose : boolean, data: Array<Float>): void;
public uniformMatrix4x2fv(location: GLUniformLocation, transpose : boolean, data : Float32Array, ?srcOffset : number, ?srcLength : number): void;
public uniformMatrix4x3fv(location: GLUniformLocation, transpose : boolean, data : Float32Array, ?srcOffset : number, ?srcLength : number): void;
public vertexAttribDivisor(index : number, divisor : number): void;
public vertexAttribI4i(index : number, v0 : number, v1 : number, v2 : number, v3 : number): void;
public vertexAttribI4ui(index : number, v0 : number, v1 : number, v2 : number, v3 : number): void;
@: overload(function (index: number, value: Float32Array): void { })
public vertexAttribI4iv(index : number, value: Array<Int>): void;
@: overload(function (index: number, value: number32Array): void { })
public vertexAttribI4uiv(index : number, value: Array<Int>): void;
public vertexAttribIPointer(index : number, size : number, type : number, stride : number, offset: DataPointer): void;
public waitSync(sync: GLSync, flags : number, timeout: Dynamic /*int64*/): void;
}
#end
