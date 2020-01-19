package openfl._internal.backend.lime_standalone;

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

@:access(lime.graphics.RenderContext)
@:forward()
abstract WebGL2RenderContext(HTML5WebGL2RenderContext) from HTML5WebGL2RenderContext to HTML5WebGL2RenderContext
{
	public inline function bufferData(target:Int, srcData:Dynamic, usage:Int, ?srcOffset:Int, ?length:Int):Void
	{
		if (srcOffset != null)
		{
			this.bufferData(target, srcData, usage, srcOffset, length);
		}
		else
		{
			this.bufferData(target, srcData, usage);
		}
	}

	public inline function bufferSubData(target:Int, dstByteOffset:Int, srcData:Dynamic, ?srcOffset:Int, ?length:Int):Void
	{
		if (srcOffset != null)
		{
			this.bufferSubData(target, dstByteOffset, srcData, srcOffset, length);
		}
		else
		{
			this.bufferSubData(target, dstByteOffset, srcData);
		}
	}

	public inline function compressedTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, srcData:Dynamic, ?srcOffset:Int,
			?srcLengthOverride:Int):Void
	{
		if (srcOffset != null)
		{
			this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData, srcOffset, srcLengthOverride);
		}
		else
		{
			this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData);
		}
	}

	public inline function compressedTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, srcData:Dynamic,
			?srcOffset:Int, ?srcLengthOverride:Int):Void
	{
		if (srcOffset != null)
		{
			this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData, srcOffset, srcLengthOverride);
		}
		else
		{
			this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData);
		}
	}

	public inline function getBufferSubData(target:Int, srcByteOffset:DataPointer, dstData:Dynamic, ?srcOffset:Dynamic, ?length:Int):Void
	{
		if (srcOffset != null)
		{
			this.getBufferSubData(target, srcByteOffset, dstData, srcOffset, length);
		}
		else
		{
			this.getBufferSubData(target, srcByteOffset, dstData);
		}
	}

	public inline function readPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:Dynamic, ?dstOffset:Int):Void
	{
		if (dstOffset != null)
		{
			this.readPixels(x, y, width, height, format, type, pixels, dstOffset);
		}
		else
		{
			this.readPixels(x, y, width, height, format, type, pixels);
		}
	}

	public inline function texImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Dynamic, ?format:Int, ?type:Int,
			?srcData:Dynamic, ?srcOffset:Int):Void
	{
		if (srcOffset != null)
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

	public inline function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Dynamic, ?type:Int, ?srcData:Dynamic,
			?srcOffset:Int):Void
	{
		if (srcOffset != null)
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

	public inline function uniform1fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform1fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform1fv(location, data);
		}
	}

	public inline function uniform1iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform1iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform1iv(location, data);
		}
	}

	public function uniform2fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform2fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform2fv(location, data);
		}
	}

	public inline function uniform2iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform2iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform2iv(location, data);
		}
	}

	public inline function uniform3fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform3fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform3fv(location, data);
		}
	}

	public inline function uniform3iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform3iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform3iv(location, data);
		}
	}

	public inline function uniform4fv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform4fv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform4fv(location, data);
		}
	}

	public inline function uniform4iv(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniform4iv(location, data, srcOffset, srcLength);
		}
		else
		{
			this.uniform4iv(location, data);
		}
	}

	public inline function uniformMatrix2fv(location:GLUniformLocation, transpose:Bool, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniformMatrix2fv(location, transpose, data, srcOffset, srcLength);
		}
		else
		{
			this.uniformMatrix2fv(location, transpose, data);
		}
	}

	public inline function uniformMatrix3fv(location:GLUniformLocation, transpose:Bool, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniformMatrix3fv(location, transpose, data, srcOffset, srcLength);
		}
		else
		{
			this.uniformMatrix3fv(location, transpose, data);
		}
	}

	public inline function uniformMatrix4fv(location:GLUniformLocation, transpose:Bool, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		if (srcOffset != null)
		{
			this.uniformMatrix4fv(location, transpose, data, srcOffset, srcLength);
		}
		else
		{
			this.uniformMatrix4fv(location, transpose, data);
		}
	}

	@:from private static function fromGL(gl:Class<GL>):WebGL2RenderContext
	{
		return null;
	}

	@:from private static function fromRenderContext(context:RenderContext):WebGL2RenderContext
	{
		return context.webgl2;
	}

	@:from private static function toWebGLRenderContext(gl:WebGLRenderContext):WebGL2RenderContext
	{
		return cast gl;
	}
}

@:native("WebGL2RenderingContext")
extern class HTML5WebGL2RenderContext extends WebGLRenderingContext
{
	public var DEPTH_BUFFER_BIT:Int;
	public var STENCIL_BUFFER_BIT:Int;
	public var COLOR_BUFFER_BIT:Int;
	public var POINTS:Int;
	public var LINES:Int;
	public var LINE_LOOP:Int;
	public var LINE_STRIP:Int;
	public var TRIANGLES:Int;
	public var TRIANGLE_STRIP:Int;
	public var TRIANGLE_FAN:Int;
	public var ZERO:Int;
	public var ONE:Int;
	public var SRC_COLOR:Int;
	public var ONE_MINUS_SRC_COLOR:Int;
	public var SRC_ALPHA:Int;
	public var ONE_MINUS_SRC_ALPHA:Int;
	public var DST_ALPHA:Int;
	public var ONE_MINUS_DST_ALPHA:Int;
	public var DST_COLOR:Int;
	public var ONE_MINUS_DST_COLOR:Int;
	public var SRC_ALPHA_SATURATE:Int;
	public var FUNC_ADD:Int;
	public var BLEND_EQUATION:Int;
	public var BLEND_EQUATION_RGB:Int;
	public var BLEND_EQUATION_ALPHA:Int;
	public var FUNC_SUBTRACT:Int;
	public var FUNC_REVERSE_SUBTRACT:Int;
	public var BLEND_DST_RGB:Int;
	public var BLEND_SRC_RGB:Int;
	public var BLEND_DST_ALPHA:Int;
	public var BLEND_SRC_ALPHA:Int;
	public var CONSTANT_COLOR:Int;
	public var ONE_MINUS_CONSTANT_COLOR:Int;
	public var CONSTANT_ALPHA:Int;
	public var ONE_MINUS_CONSTANT_ALPHA:Int;
	public var BLEND_COLOR:Int;
	public var ARRAY_BUFFER:Int;
	public var ELEMENT_ARRAY_BUFFER:Int;
	public var ARRAY_BUFFER_BINDING:Int;
	public var ELEMENT_ARRAY_BUFFER_BINDING:Int;
	public var STREAM_DRAW:Int;
	public var STATIC_DRAW:Int;
	public var DYNAMIC_DRAW:Int;
	public var BUFFER_SIZE:Int;
	public var BUFFER_USAGE:Int;
	public var CURRENT_VERTEX_ATTRIB:Int;
	public var FRONT:Int;
	public var BACK:Int;
	public var FRONT_AND_BACK:Int;
	public var CULL_FACE:Int;
	public var BLEND:Int;
	public var DITHER:Int;
	public var STENCIL_TEST:Int;
	public var DEPTH_TEST:Int;
	public var SCISSOR_TEST:Int;
	public var POLYGON_OFFSET_FILL:Int;
	public var SAMPLE_ALPHA_TO_COVERAGE:Int;
	public var SAMPLE_COVERAGE:Int;
	public var NO_ERROR:Int;
	public var INVALID_ENUM:Int;
	public var INVALID_VALUE:Int;
	public var INVALID_OPERATION:Int;
	public var OUT_OF_MEMORY:Int;
	public var CW:Int;
	public var CCW:Int;
	public var LINE_WIDTH:Int;
	public var ALIASED_POINT_SIZE_RANGE:Int;
	public var ALIASED_LINE_WIDTH_RANGE:Int;
	public var CULL_FACE_MODE:Int;
	public var FRONT_FACE:Int;
	public var DEPTH_RANGE:Int;
	public var DEPTH_WRITEMASK:Int;
	public var DEPTH_CLEAR_VALUE:Int;
	public var DEPTH_FUNC:Int;
	public var STENCIL_CLEAR_VALUE:Int;
	public var STENCIL_FUNC:Int;
	public var STENCIL_FAIL:Int;
	public var STENCIL_PASS_DEPTH_FAIL:Int;
	public var STENCIL_PASS_DEPTH_PASS:Int;
	public var STENCIL_REF:Int;
	public var STENCIL_VALUE_MASK:Int;
	public var STENCIL_WRITEMASK:Int;
	public var STENCIL_BACK_FUNC:Int;
	public var STENCIL_BACK_FAIL:Int;
	public var STENCIL_BACK_PASS_DEPTH_FAIL:Int;
	public var STENCIL_BACK_PASS_DEPTH_PASS:Int;
	public var STENCIL_BACK_REF:Int;
	public var STENCIL_BACK_VALUE_MASK:Int;
	public var STENCIL_BACK_WRITEMASK:Int;
	public var VIEWPORT:Int;
	public var SCISSOR_BOX:Int;
	public var COLOR_CLEAR_VALUE:Int;
	public var COLOR_WRITEMASK:Int;
	public var UNPACK_ALIGNMENT:Int;
	public var PACK_ALIGNMENT:Int;
	public var MAX_TEXTURE_SIZE:Int;
	public var MAX_VIEWPORT_DIMS:Int;
	public var SUBPIXEL_BITS:Int;
	public var RED_BITS:Int;
	public var GREEN_BITS:Int;
	public var BLUE_BITS:Int;
	public var ALPHA_BITS:Int;
	public var DEPTH_BITS:Int;
	public var STENCIL_BITS:Int;
	public var POLYGON_OFFSET_UNITS:Int;
	public var POLYGON_OFFSET_FACTOR:Int;
	public var TEXTURE_BINDING_2D:Int;
	public var SAMPLE_BUFFERS:Int;
	public var SAMPLES:Int;
	public var SAMPLE_COVERAGE_VALUE:Int;
	public var SAMPLE_COVERAGE_INVERT:Int;
	public var COMPRESSED_TEXTURE_FORMATS:Int;
	public var DONT_CARE:Int;
	public var FASTEST:Int;
	public var NICEST:Int;
	public var GENERATE_MIPMAP_HINT:Int;
	public var BYTE:Int;
	public var UNSIGNED_BYTE:Int;
	public var SHORT:Int;
	public var UNSIGNED_SHORT:Int;
	public var INT:Int;
	public var UNSIGNED_INT:Int;
	public var FLOAT:Int;
	public var DEPTH_COMPONENT:Int;
	public var ALPHA:Int;
	public var RGB:Int;
	public var RGBA:Int;
	public var LUMINANCE:Int;
	public var LUMINANCE_ALPHA:Int;
	public var UNSIGNED_SHORT_4_4_4_4:Int;
	public var UNSIGNED_SHORT_5_5_5_1:Int;
	public var UNSIGNED_SHORT_5_6_5:Int;
	public var FRAGMENT_SHADER:Int;
	public var VERTEX_SHADER:Int;
	public var MAX_VERTEX_ATTRIBS:Int;
	public var MAX_VERTEX_UNIFORM_VECTORS:Int;
	public var MAX_VARYING_VECTORS:Int;
	public var MAX_COMBINED_TEXTURE_IMAGE_UNITS:Int;
	public var MAX_VERTEX_TEXTURE_IMAGE_UNITS:Int;
	public var MAX_TEXTURE_IMAGE_UNITS:Int;
	public var MAX_FRAGMENT_UNIFORM_VECTORS:Int;
	public var SHADER_TYPE:Int;
	public var DELETE_STATUS:Int;
	public var LINK_STATUS:Int;
	public var VALIDATE_STATUS:Int;
	public var ATTACHED_SHADERS:Int;
	public var ACTIVE_UNIFORMS:Int;
	public var ACTIVE_ATTRIBUTES:Int;
	public var SHADING_LANGUAGE_VERSION:Int;
	public var CURRENT_PROGRAM:Int;
	public var NEVER:Int;
	public var LESS:Int;
	public var EQUAL:Int;
	public var LEQUAL:Int;
	public var GREATER:Int;
	public var NOTEQUAL:Int;
	public var GEQUAL:Int;
	public var ALWAYS:Int;
	public var KEEP:Int;
	public var REPLACE:Int;
	public var INCR:Int;
	public var DECR:Int;
	public var INVERT:Int;
	public var INCR_WRAP:Int;
	public var DECR_WRAP:Int;
	public var VENDOR:Int;
	public var RENDERER:Int;
	public var VERSION:Int;
	public var NEAREST:Int;
	public var LINEAR:Int;
	public var NEAREST_MIPMAP_NEAREST:Int;
	public var LINEAR_MIPMAP_NEAREST:Int;
	public var NEAREST_MIPMAP_LINEAR:Int;
	public var LINEAR_MIPMAP_LINEAR:Int;
	public var TEXTURE_MAG_FILTER:Int;
	public var TEXTURE_MIN_FILTER:Int;
	public var TEXTURE_WRAP_S:Int;
	public var TEXTURE_WRAP_T:Int;
	public var TEXTURE_2D:Int;
	public var TEXTURE:Int;
	public var TEXTURE_CUBE_MAP:Int;
	public var TEXTURE_BINDING_CUBE_MAP:Int;
	public var TEXTURE_CUBE_MAP_POSITIVE_X:Int;
	public var TEXTURE_CUBE_MAP_NEGATIVE_X:Int;
	public var TEXTURE_CUBE_MAP_POSITIVE_Y:Int;
	public var TEXTURE_CUBE_MAP_NEGATIVE_Y:Int;
	public var TEXTURE_CUBE_MAP_POSITIVE_Z:Int;
	public var TEXTURE_CUBE_MAP_NEGATIVE_Z:Int;
	public var MAX_CUBE_MAP_TEXTURE_SIZE:Int;
	public var TEXTURE0:Int;
	public var TEXTURE1:Int;
	public var TEXTURE2:Int;
	public var TEXTURE3:Int;
	public var TEXTURE4:Int;
	public var TEXTURE5:Int;
	public var TEXTURE6:Int;
	public var TEXTURE7:Int;
	public var TEXTURE8:Int;
	public var TEXTURE9:Int;
	public var TEXTURE10:Int;
	public var TEXTURE11:Int;
	public var TEXTURE12:Int;
	public var TEXTURE13:Int;
	public var TEXTURE14:Int;
	public var TEXTURE15:Int;
	public var TEXTURE16:Int;
	public var TEXTURE17:Int;
	public var TEXTURE18:Int;
	public var TEXTURE19:Int;
	public var TEXTURE20:Int;
	public var TEXTURE21:Int;
	public var TEXTURE22:Int;
	public var TEXTURE23:Int;
	public var TEXTURE24:Int;
	public var TEXTURE25:Int;
	public var TEXTURE26:Int;
	public var TEXTURE27:Int;
	public var TEXTURE28:Int;
	public var TEXTURE29:Int;
	public var TEXTURE30:Int;
	public var TEXTURE31:Int;
	public var ACTIVE_TEXTURE:Int;
	public var REPEAT:Int;
	public var CLAMP_TO_EDGE:Int;
	public var MIRRORED_REPEAT:Int;
	public var FLOAT_VEC2:Int;
	public var FLOAT_VEC3:Int;
	public var FLOAT_VEC4:Int;
	public var INT_VEC2:Int;
	public var INT_VEC3:Int;
	public var INT_VEC4:Int;
	public var BOOL:Int;
	public var BOOL_VEC2:Int;
	public var BOOL_VEC3:Int;
	public var BOOL_VEC4:Int;
	public var FLOAT_MAT2:Int;
	public var FLOAT_MAT3:Int;
	public var FLOAT_MAT4:Int;
	public var SAMPLER_2D:Int;
	public var SAMPLER_CUBE:Int;
	public var VERTEX_ATTRIB_ARRAY_ENABLED:Int;
	public var VERTEX_ATTRIB_ARRAY_SIZE:Int;
	public var VERTEX_ATTRIB_ARRAY_STRIDE:Int;
	public var VERTEX_ATTRIB_ARRAY_TYPE:Int;
	public var VERTEX_ATTRIB_ARRAY_NORMALIZED:Int;
	public var VERTEX_ATTRIB_ARRAY_POINTER:Int;
	public var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING:Int;
	public var COMPILE_STATUS:Int;
	public var LOW_FLOAT:Int;
	public var MEDIUM_FLOAT:Int;
	public var HIGH_FLOAT:Int;
	public var LOW_INT:Int;
	public var MEDIUM_INT:Int;
	public var HIGH_INT:Int;
	public var FRAMEBUFFER:Int;
	public var RENDERBUFFER:Int;
	public var RGBA4:Int;
	public var RGB5_A1:Int;
	public var RGB565:Int;
	public var DEPTH_COMPONENT16:Int;
	public var STENCIL_INDEX:Int;
	public var STENCIL_INDEX8:Int;
	public var DEPTH_STENCIL:Int;
	public var RENDERBUFFER_WIDTH:Int;
	public var RENDERBUFFER_HEIGHT:Int;
	public var RENDERBUFFER_INTERNAL_FORMAT:Int;
	public var RENDERBUFFER_RED_SIZE:Int;
	public var RENDERBUFFER_GREEN_SIZE:Int;
	public var RENDERBUFFER_BLUE_SIZE:Int;
	public var RENDERBUFFER_ALPHA_SIZE:Int;
	public var RENDERBUFFER_DEPTH_SIZE:Int;
	public var RENDERBUFFER_STENCIL_SIZE:Int;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE:Int;
	public var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME:Int;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL:Int;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE:Int;
	public var COLOR_ATTACHMENT0:Int;
	public var DEPTH_ATTACHMENT:Int;
	public var STENCIL_ATTACHMENT:Int;
	public var DEPTH_STENCIL_ATTACHMENT:Int;
	public var NONE:Int;
	public var FRAMEBUFFER_COMPLETE:Int;
	public var FRAMEBUFFER_INCOMPLETE_ATTACHMENT:Int;
	public var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:Int;
	public var FRAMEBUFFER_INCOMPLETE_DIMENSIONS:Int;
	public var FRAMEBUFFER_UNSUPPORTED:Int;
	public var FRAMEBUFFER_BINDING:Int;
	public var RENDERBUFFER_BINDING:Int;
	public var MAX_RENDERBUFFER_SIZE:Int;
	public var INVALID_FRAMEBUFFER_OPERATION:Int;
	public var UNPACK_FLIP_Y_WEBGL:Int;
	public var UNPACK_PREMULTIPLY_ALPHA_WEBGL:Int;
	public var CONTEXT_LOST_WEBGL:Int;
	public var UNPACK_COLORSPACE_CONVERSION_WEBGL:Int;
	public var BROWSER_DEFAULT_WEBGL:Int;
	public var READ_BUFFER:Int;
	public var UNPACK_ROW_LENGTH:Int;
	public var UNPACK_SKIP_ROWS:Int;
	public var UNPACK_SKIP_PIXELS:Int;
	public var PACK_ROW_LENGTH:Int;
	public var PACK_SKIP_ROWS:Int;
	public var PACK_SKIP_PIXELS:Int;
	public var TEXTURE_BINDING_3D:Int;
	public var UNPACK_SKIP_IMAGES:Int;
	public var UNPACK_IMAGE_HEIGHT:Int;
	public var MAX_3D_TEXTURE_SIZE:Int;
	public var MAX_ELEMENTS_VERTICES:Int;
	public var MAX_ELEMENTS_INDICES:Int;
	public var MAX_TEXTURE_LOD_BIAS:Int;
	public var MAX_FRAGMENT_UNIFORM_COMPONENTS:Int;
	public var MAX_VERTEX_UNIFORM_COMPONENTS:Int;
	public var MAX_ARRAY_TEXTURE_LAYERS:Int;
	public var MIN_PROGRAM_TEXEL_OFFSET:Int;
	public var MAX_PROGRAM_TEXEL_OFFSET:Int;
	public var MAX_VARYING_COMPONENTS:Int;
	public var FRAGMENT_SHADER_DERIVATIVE_HINT:Int;
	public var RASTERIZER_DISCARD:Int;
	public var VERTEX_ARRAY_BINDING:Int;
	public var MAX_VERTEX_OUTPUT_COMPONENTS:Int;
	public var MAX_FRAGMENT_INPUT_COMPONENTS:Int;
	public var MAX_SERVER_WAIT_TIMEOUT:Int;
	public var MAX_ELEMENT_INDEX:Int;
	public var RED:Int;
	public var RGB8:Int;
	public var RGBA8:Int;
	public var RGB10_A2:Int;
	public var TEXTURE_3D:Int;
	public var TEXTURE_WRAP_R:Int;
	public var TEXTURE_MIN_LOD:Int;
	public var TEXTURE_MAX_LOD:Int;
	public var TEXTURE_BASE_LEVEL:Int;
	public var TEXTURE_MAX_LEVEL:Int;
	public var TEXTURE_COMPARE_MODE:Int;
	public var TEXTURE_COMPARE_FUNC:Int;
	public var SRGB:Int;
	public var SRGB8:Int;
	public var SRGB8_ALPHA8:Int;
	public var COMPARE_REF_TO_TEXTURE:Int;
	public var RGBA32F:Int;
	public var RGB32F:Int;
	public var RGBA16F:Int;
	public var RGB16F:Int;
	public var TEXTURE_2D_ARRAY:Int;
	public var TEXTURE_BINDING_2D_ARRAY:Int;
	public var R11F_G11F_B10F:Int;
	public var RGB9_E5:Int;
	public var RGBA32UI:Int;
	public var RGB32UI:Int;
	public var RGBA16UI:Int;
	public var RGB16UI:Int;
	public var RGBA8UI:Int;
	public var RGB8UI:Int;
	public var RGBA32I:Int;
	public var RGB32I:Int;
	public var RGBA16I:Int;
	public var RGB16I:Int;
	public var RGBA8I:Int;
	public var RGB8I:Int;
	public var RED_INTEGER:Int;
	public var RGB_INTEGER:Int;
	public var RGBA_INTEGER:Int;
	public var R8:Int;
	public var RG8:Int;
	public var R16F:Int;
	public var R32F:Int;
	public var RG16F:Int;
	public var RG32F:Int;
	public var R8I:Int;
	public var R8UI:Int;
	public var R16I:Int;
	public var R16UI:Int;
	public var R32I:Int;
	public var R32UI:Int;
	public var RG8I:Int;
	public var RG8UI:Int;
	public var RG16I:Int;
	public var RG16UI:Int;
	public var RG32I:Int;
	public var RG32UI:Int;
	public var R8_SNORM:Int;
	public var RG8_SNORM:Int;
	public var RGB8_SNORM:Int;
	public var RGBA8_SNORM:Int;
	public var RGB10_A2UI:Int;
	public var TEXTURE_IMMUTABLE_FORMAT:Int;
	public var TEXTURE_IMMUTABLE_LEVELS:Int;
	public var UNSIGNED_INT_2_10_10_10_REV:Int;
	public var UNSIGNED_INT_10F_11F_11F_REV:Int;
	public var UNSIGNED_INT_5_9_9_9_REV:Int;
	public var FLOAT_32_UNSIGNED_INT_24_8_REV:Int;
	public var UNSIGNED_INT_24_8:Int;
	public var HALF_FLOAT:Int;
	public var RG:Int;
	public var RG_INTEGER:Int;
	public var INT_2_10_10_10_REV:Int;
	public var CURRENT_QUERY:Int;
	public var QUERY_RESULT:Int;
	public var QUERY_RESULT_AVAILABLE:Int;
	public var ANY_SAMPLES_PASSED:Int;
	public var ANY_SAMPLES_PASSED_CONSERVATIVE:Int;
	public var MAX_DRAW_BUFFERS:Int;
	public var DRAW_BUFFER0:Int;
	public var DRAW_BUFFER1:Int;
	public var DRAW_BUFFER2:Int;
	public var DRAW_BUFFER3:Int;
	public var DRAW_BUFFER4:Int;
	public var DRAW_BUFFER5:Int;
	public var DRAW_BUFFER6:Int;
	public var DRAW_BUFFER7:Int;
	public var DRAW_BUFFER8:Int;
	public var DRAW_BUFFER9:Int;
	public var DRAW_BUFFER10:Int;
	public var DRAW_BUFFER11:Int;
	public var DRAW_BUFFER12:Int;
	public var DRAW_BUFFER13:Int;
	public var DRAW_BUFFER14:Int;
	public var DRAW_BUFFER15:Int;
	public var MAX_COLOR_ATTACHMENTS:Int;
	public var COLOR_ATTACHMENT1:Int;
	public var COLOR_ATTACHMENT2:Int;
	public var COLOR_ATTACHMENT3:Int;
	public var COLOR_ATTACHMENT4:Int;
	public var COLOR_ATTACHMENT5:Int;
	public var COLOR_ATTACHMENT6:Int;
	public var COLOR_ATTACHMENT7:Int;
	public var COLOR_ATTACHMENT8:Int;
	public var COLOR_ATTACHMENT9:Int;
	public var COLOR_ATTACHMENT10:Int;
	public var COLOR_ATTACHMENT11:Int;
	public var COLOR_ATTACHMENT12:Int;
	public var COLOR_ATTACHMENT13:Int;
	public var COLOR_ATTACHMENT14:Int;
	public var COLOR_ATTACHMENT15:Int;
	public var SAMPLER_3D:Int;
	public var SAMPLER_2D_SHADOW:Int;
	public var SAMPLER_2D_ARRAY:Int;
	public var SAMPLER_2D_ARRAY_SHADOW:Int;
	public var SAMPLER_CUBE_SHADOW:Int;
	public var INT_SAMPLER_2D:Int;
	public var INT_SAMPLER_3D:Int;
	public var INT_SAMPLER_CUBE:Int;
	public var INT_SAMPLER_2D_ARRAY:Int;
	public var UNSIGNED_INT_SAMPLER_2D:Int;
	public var UNSIGNED_INT_SAMPLER_3D:Int;
	public var UNSIGNED_INT_SAMPLER_CUBE:Int;
	public var UNSIGNED_INT_SAMPLER_2D_ARRAY:Int;
	public var MAX_SAMPLES:Int;
	public var SAMPLER_BINDING:Int;
	public var PIXEL_PACK_BUFFER:Int;
	public var PIXEL_UNPACK_BUFFER:Int;
	public var PIXEL_PACK_BUFFER_BINDING:Int;
	public var PIXEL_UNPACK_BUFFER_BINDING:Int;
	public var COPY_READ_BUFFER:Int;
	public var COPY_WRITE_BUFFER:Int;
	public var COPY_READ_BUFFER_BINDING:Int;
	public var COPY_WRITE_BUFFER_BINDING:Int;
	public var FLOAT_MAT2x3:Int;
	public var FLOAT_MAT2x4:Int;
	public var FLOAT_MAT3x2:Int;
	public var FLOAT_MAT3x4:Int;
	public var FLOAT_MAT4x2:Int;
	public var FLOAT_MAT4x3:Int;
	public var UNSIGNED_INT_VEC2:Int;
	public var UNSIGNED_INT_VEC3:Int;
	public var UNSIGNED_INT_VEC4:Int;
	public var UNSIGNED_NORMALIZED:Int;
	public var SIGNED_NORMALIZED:Int;
	public var VERTEX_ATTRIB_ARRAY_INTEGER:Int;
	public var VERTEX_ATTRIB_ARRAY_DIVISOR:Int;
	public var TRANSFORM_FEEDBACK_BUFFER_MODE:Int;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS:Int;
	public var TRANSFORM_FEEDBACK_VARYINGS:Int;
	public var TRANSFORM_FEEDBACK_BUFFER_START:Int;
	public var TRANSFORM_FEEDBACK_BUFFER_SIZE:Int;
	public var TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN:Int;
	public var MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS:Int;
	public var MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS:Int;
	public var INTERLEAVED_ATTRIBS:Int;
	public var SEPARATE_ATTRIBS:Int;
	public var TRANSFORM_FEEDBACK_BUFFER:Int;
	public var TRANSFORM_FEEDBACK_BUFFER_BINDING:Int;
	public var TRANSFORM_FEEDBACK:Int;
	public var TRANSFORM_FEEDBACK_PAUSED:Int;
	public var TRANSFORM_FEEDBACK_ACTIVE:Int;
	public var TRANSFORM_FEEDBACK_BINDING:Int;
	public var FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING:Int;
	public var FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE:Int;
	public var FRAMEBUFFER_ATTACHMENT_RED_SIZE:Int;
	public var FRAMEBUFFER_ATTACHMENT_GREEN_SIZE:Int;
	public var FRAMEBUFFER_ATTACHMENT_BLUE_SIZE:Int;
	public var FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE:Int;
	public var FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE:Int;
	public var FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE:Int;
	public var FRAMEBUFFER_DEFAULT:Int;
	public var DEPTH24_STENCIL8:Int;
	public var DRAW_FRAMEBUFFER_BINDING:Int;
	public var READ_FRAMEBUFFER:Int;
	public var DRAW_FRAMEBUFFER:Int;
	public var READ_FRAMEBUFFER_BINDING:Int;
	public var RENDERBUFFER_SAMPLES:Int;
	public var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER:Int;
	public var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE:Int;
	public var UNIFORM_BUFFER:Int;
	public var UNIFORM_BUFFER_BINDING:Int;
	public var UNIFORM_BUFFER_START:Int;
	public var UNIFORM_BUFFER_SIZE:Int;
	public var MAX_VERTEX_UNIFORM_BLOCKS:Int;
	public var MAX_FRAGMENT_UNIFORM_BLOCKS:Int;
	public var MAX_COMBINED_UNIFORM_BLOCKS:Int;
	public var MAX_UNIFORM_BUFFER_BINDINGS:Int;
	public var MAX_UNIFORM_BLOCK_SIZE:Int;
	public var MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS:Int;
	public var MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS:Int;
	public var UNIFORM_BUFFER_OFFSET_ALIGNMENT:Int;
	public var ACTIVE_UNIFORM_BLOCKS:Int;
	public var UNIFORM_TYPE:Int;
	public var UNIFORM_SIZE:Int;
	public var UNIFORM_BLOCK_INDEX:Int;
	public var UNIFORM_OFFSET:Int;
	public var UNIFORM_ARRAY_STRIDE:Int;
	public var UNIFORM_MATRIX_STRIDE:Int;
	public var UNIFORM_IS_ROW_MAJOR:Int;
	public var UNIFORM_BLOCK_BINDING:Int;
	public var UNIFORM_BLOCK_DATA_SIZE:Int;
	public var UNIFORM_BLOCK_ACTIVE_UNIFORMS:Int;
	public var UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES:Int;
	public var UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER:Int;
	public var UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER:Int;
	public var OBJECT_TYPE:Int;
	public var SYNC_CONDITION:Int;
	public var SYNC_STATUS:Int;
	public var SYNC_FLAGS:Int;
	public var SYNC_FENCE:Int;
	public var SYNC_GPU_COMMANDS_COMPLETE:Int;
	public var UNSIGNALED:Int;
	public var SIGNALED:Int;
	public var ALREADY_SIGNALED:Int;
	public var TIMEOUT_EXPIRED:Int;
	public var CONDITION_SATISFIED:Int;
	public var WAIT_FAILED:Int;
	public var SYNC_FLUSH_COMMANDS_BIT:Int;
	public var COLOR:Int;
	public var DEPTH:Int;
	public var STENCIL:Int;
	public var MIN:Int;
	public var MAX:Int;
	public var DEPTH_COMPONENT24:Int;
	public var STREAM_READ:Int;
	public var STREAM_COPY:Int;
	public var STATIC_READ:Int;
	public var STATIC_COPY:Int;
	public var DYNAMIC_READ:Int;
	public var DYNAMIC_COPY:Int;
	public var DEPTH_COMPONENT32F:Int;
	public var DEPTH32F_STENCIL8:Int;
	public var INVALID_INDEX:Int;
	public var TIMEOUT_IGNORED:Int;
	public var MAX_CLIENT_WAIT_TIMEOUT_WEBGL:Int;
	public function beginQuery(target:Int, query:GLQuery):Void;
	public function beginTransformFeedback(primitiveNode:Int):Void;
	public function bindBufferBase(target:Int, index:Int, buffer:GLBuffer):Void;
	public function bindBufferRange(target:Int, index:Int, buffer:GLBuffer, offset:DataPointer, size:DataPointer):Void;
	public function bindSampler(unit:Int, sampler:GLSampler):Void;
	public function bindTransformFeedback(target:Int, transformFeedback:GLTransformFeedback):Void;
	public function bindVertexArray(vertexArray:GLVertexArrayObject):Void;
	public function blitFramebuffer(srcX0:Int, srcY0:Int, srcX1:Int, srcY1:Int, dstX0:Int, dstY0:Int, dstX1:Int, dstY1:Int, mask:Int, filter:Int):Void;
	@:overload(function(target:Int, data:ArrayBufferView, usage:Int, srcOffset:Int, ?length:Int):Void {})
	@:overload(function(target:Int, size:Int, usage:Int):Void {})
	@:overload(function(target:Int, data:ArrayBufferView, usage:Int):Void {})
	@:overload(function(target:Int, data:ArrayBuffer, usage:Int):Void {})
	override function bufferData(target:Int, data:Dynamic /*MISSING SharedArrayBuffer*/, usage:Int):Void;
	@:overload(function(target:Int, dstByteOffset:Int, srcData:ArrayBufferView, srcOffset:Int, ?length:Int):Void {})
	@:overload(function(target:Int, offset:Int, data:ArrayBufferView):Void {})
	@:overload(function(target:Int, offset:Int, data:ArrayBuffer):Void {})
	override function bufferSubData(target:Int, offset:Int, data:Dynamic /*MISSING SharedArrayBuffer*/):Void;
	public function clearBufferfi(buffer:Int, drawbuffer:Int, depth:Float, stencil:Int):Void;
	@:overload(function(buffer:Int, drawbuffer:Int, values:Float32Array, ?srcOffset:Int):Void {})
	@:overload(function(buffer:Int, drawbuffer:Int, depth:Float, stencil:Int):Void {})
	public function clearBufferfv(buffer:Int, drawbuffer:Int, values:Array<Float>, ?srcOffset:Int):Void;
	@:overload(function(buffer:Int, drawbuffer:Int, values:Int32Array, ?srcOffset:Int):Void {})
	@:overload(function(buffer:Int, drawbuffer:Int, depth:Float, stencil:Int):Void {})
	public function clearBufferiv(buffer:Int, drawbuffer:Int, values:Array<Int>, ?srcOffset:Int):Void;
	@:overload(function(buffer:Int, drawbuffer:Int, values:UInt32Array, ?srcOffset:Int):Void {})
	@:overload(function(buffer:Int, drawbuffer:Int, depth:Float, stencil:Int):Void {})
	public function clearBufferuiv(buffer:Int, drawbuffer:Int, values:Array<Int>, ?srcOffset:Int):Void;
	public function clientWaitSync(sync:GLSync, flags:Int, timeout:Dynamic /*Int64*/):Int;
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, offset:Int):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, srcData:ArrayBufferView, ?srcOffset:Int,
		?srcLengthOverride:Int):Void {})
	override function compressedTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, data:ArrayBufferView):Void;
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, offset:Int):Void {})
	public function compressedTexImage3D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, srcData:ArrayBufferView,
		?srcOffset:Int, ?srcLengthOverride:Int):Void;
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, offset:Int):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, srcData:ArrayBufferView, ?srcOffset:Int,
		?srcLengthOverride:Int):Void {})
	override function compressedTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, data:ArrayBufferView):Void;
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, offset:Int):Void {})
	public function compressedTexSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int,
		srcData:ArrayBufferView, ?srcOffset:Int, ?srcLengthOverride:Int):Void;
	public function copySubBufferData(readTarget:Int, writeTarget:Int, readOffset:DataPointer, writeOffset:DataPointer, size:Int):Void;
	public function copyTexSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, x:Int, y:Int, width:Int, height:Int):Void;
	public function createQuery():GLQuery;
	public function createSampler():GLSampler;
	public function createTransformFeedback():GLTransformFeedback;
	public function createVertexArray():GLVertexArrayObject;
	public function deleteQuery(query:GLQuery):Void;
	public function deleteSampler(sampler:GLSampler):Void;
	public function deleteSync(sync:GLSync):Void;
	public function deleteTransformFeedback(transformFeedback:GLTransformFeedback):Void;
	public function deleteVertexArray(vertexArray:GLVertexArrayObject):Void;
	public function drawArraysInstanced(mode:Int, first:Int, count:Int, instanceCount:Int):Void;
	public function drawBuffers(buffers:Array<Int>):Void;
	public function drawElementsInstanced(mode:Int, count:Int, type:Int, offset:DataPointer, instanceCount:Int):Void;
	public function drawRangeElements(mode:Int, start:Int, end:Int, count:Int, type:Int, offset:DataPointer):Void;
	public function endQuery(target:Int):Void;
	public function endTransformFeedback():Void;
	public function fenceSync(condition:Int, flags:Int):GLSync;
	public function framebufferTextureLayer(target:Int, attachment:Int, texture:GLTexture, level:Int, layer:Int):Void;
	public function getActiveUniformBlockName(program:GLProgram, uniformBlockIndex:Int):String;
	public function getActiveUniformBlockParameter(program:GLProgram, uniformBlockIndex:Int, pname:Int):Dynamic;
	public function getActiveUniforms(program:GLProgram, uniformIndices:Array<Int>, pname:Int):Dynamic;
	@:overload(function(target:Int, srcByteOffset:DataPointer, dstData:ArrayBuffer, ?srcOffset:Int, ?length:Int):Void {})
	public function getBufferSubData(target:Int, srcByteOffset:DataPointer, dstData:Dynamic /*SharedArrayBuffer*/, ?srcOffset:Int, ?length:Int):Void;
	public function getFragDataLocation(program:GLProgram, name:String):Int;
	public function getIndexedParameter(target:Int, index:Int):Dynamic;
	public function getInternalformatParameter(target:Int, internalformat:Int, pname:Int):Dynamic;
	public function getQuery(target:Int, pname:Int):GLQuery;
	public function getQueryParameter(query:GLQuery, pname:Int):Dynamic;
	public function getSamplerParameter(sampler:GLSampler, pname:Int):Dynamic;
	public function getSyncParameter(sync:GLSync, pname:Int):Dynamic;
	public function getTransformFeedbackVarying(program:GLProgram, index:Int):GLActiveInfo;
	public function getUniformBlockIndex(program:GLProgram, uniformBlockName:String):Int;
	@:overload(function(program:GLProgram, uniformNames:String):Array<Int> {})
	public function getUniformIndices(program:GLProgram, uniformNames:Array<String>):Array<Int>;
	public function invalidateFramebuffer(target:Int, attachments:Array<Int>):Void;
	public function invalidateSubFramebuffer(target:Int, attachments:Array<Int>, x:Int, y:Int, width:Int, height:Int):Void;
	public function isQuery(query:GLQuery):Bool;
	public function isSampler(sampler:GLSampler):Bool;
	public function isSync(sync:GLSync):Bool;
	public function isTransformFeedback(transformFeedback:GLTransformFeedback):Bool;
	public function isVertexArray(vertexArray:GLVertexArrayObject):Bool;
	public function pauseTransformFeedback():Void;
	public function readBuffer(src:Int):Void;
	@:overload(function(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:ArrayBufferView):Void {})
	@:overload(function(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, offset:Int):Void {})
	@:overload(function(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:ArrayBufferView, dstOffset:Int):Void {})
	override function readPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:ArrayBufferView):Void;
	public function renderbufferStorageMultisample(target:Int, samples:Int, internalFormat:Int, width:Int, height:Int):Void;
	public function resumeTransformFeedback():Void;
	public function samplerParameterf(sampler:GLSampler, pname:Int, param:Float):Void;
	public function samplerParameteri(sampler:GLSampler, pname:Int, param:Int):Void;
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, offset:DataPointer):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, srcData:ArrayBufferView,
		srcOffset:Int):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int,
		source:Dynamic /*js.html.ImageBitmap*/):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, source:js.html.ImageData):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int,
		source:js.html.ImageElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int,
		source:js.html.CanvasElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int,
		source:js.html.VideoElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, pixels:ArrayBufferView):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, format:Int, type:Int, pixels:js.html.ImageData):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, format:Int, type:Int, image:js.html.ImageElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, format:Int, type:Int, canvas:js.html.CanvasElement):Void {})
	override function texImage2D(target:Int, level:Int, internalformat:Int, format:Int, type:Int, video:js.html.VideoElement):Void;
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		source:js.html.CanvasElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		source:js.html.ImageElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		source:js.html.VideoElement):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		source:Dynamic /*js.html.ImageBitmap*/):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		source:js.html.ImageData):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		source:ArrayBufferView):Void {})
	@:overload(function(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		offset:DataPointer):Void {})
	public function texImage3D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int, type:Int,
		srcData:ArrayBufferView, ?srcOffset:Int):Void;
	public function texStorage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int):Void;
	public function texStorage3D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int):Void;
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, srcData:ArrayBufferView,
		srcOffset:Int):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, offset:DataPointer):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, source:js.html.ImageData):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, source:js.html.ImageElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, source:js.html.CanvasElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, source:js.html.VideoElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, source:Dynamic /*ImageBitmap*/):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, pixels:ArrayBufferView):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, pixels:js.html.ImageData):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, image:js.html.ImageElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, canvas:js.html.CanvasElement):Void {})
	override function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, video:js.html.VideoElement):Void;
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		offset:DataPointer):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		source:js.html.ImageData):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		source:js.html.ImageElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		source:js.html.CanvasElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		source:js.html.VideoElement):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		source:Dynamic /*ImageBitmap*/):Void {})
	@:overload(function(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		pixels:ArrayBufferView, ?srcOffset:Int):Void {})
	public function texSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int, format:Int, type:Int,
		video:js.html.VideoElement):Void;
	public function transformFeedbackVaryings(program:GLProgram, varyings:Array<String>, bufferMode:Int):Void;
	public function uniform1ui(location:GLUniformLocation, v0:Int):Void;
	public function uniform2ui(location:GLUniformLocation, v0:Int, v1:Int):Void;
	public function uniform3ui(location:GLUniformLocation, v0:Int, v1:Int, v2:Int):Void;
	public function uniform4ui(location:GLUniformLocation, v0:Int, v1:Int, v2:Int, v3:Int):Void;
	@:overload(function(location:GLUniformLocation, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform1fv(location:GLUniformLocation, data:Array<Float>):Void;
	@:overload(function(location:GLUniformLocation, data:Int32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Int>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform1iv(location:GLUniformLocation, data:Array<Int>):Void;
	public function uniform1uiv(location:GLUniformLocation, data:UInt32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	@:overload(function(location:GLUniformLocation, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform2fv(location:GLUniformLocation, data:Array<Float>):Void;
	@:overload(function(location:GLUniformLocation, data:Int32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Int>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform2iv(location:GLUniformLocation, data:Array<Int>):Void;
	public function uniform2uiv(location:GLUniformLocation, data:UInt32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	@:overload(function(location:GLUniformLocation, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform3fv(location:GLUniformLocation, data:Array<Float>):Void;
	@:overload(function(location:GLUniformLocation, data:Int32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Int>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform3iv(location:GLUniformLocation, data:Array<Int>):Void;
	public function uniform3uiv(location:GLUniformLocation, data:UInt32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	@:overload(function(location:GLUniformLocation, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform4fv(location:GLUniformLocation, data:Array<Float>):Void;
	@:overload(function(location:GLUniformLocation, data:Int32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, data:Array<Int>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniform4iv(location:GLUniformLocation, data:Array<Int>):Void;
	public function uniform4uiv(location:GLUniformLocation, data:UInt32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	public function uniformBlockBinding(program:GLProgram, uniformBlockIndex:Int, uniformBlockBinding:Int):Void;
	@:overload(function(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, transpose:Bool, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniformMatrix2fv(location:GLUniformLocation, transpose:Bool, data:Array<Float>):Void;
	public function uniformMatrix2x3fv(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	public function uniformMatrix2x4fv(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	@:overload(function(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, transpose:Bool, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniformMatrix3fv(location:GLUniformLocation, transpose:Bool, data:Array<Float>):Void;
	public function uniformMatrix3x2fv(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	public function uniformMatrix3x4fv(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	@:overload(function(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void {})
	@:overload(function(location:GLUniformLocation, transpose:Bool, data:Array<Float>, ?srcOffset:Int, ?srcLength:Int):Void {})
	override function uniformMatrix4fv(location:GLUniformLocation, transpose:Bool, data:Array<Float>):Void;
	public function uniformMatrix4x2fv(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	public function uniformMatrix4x3fv(location:GLUniformLocation, transpose:Bool, data:Float32Array, ?srcOffset:Int, ?srcLength:Int):Void;
	public function vertexAttribDivisor(index:Int, divisor:Int):Void;
	public function vertexAttribI4i(index:Int, v0:Int, v1:Int, v2:Int, v3:Int):Void;
	public function vertexAttribI4ui(index:Int, v0:Int, v1:Int, v2:Int, v3:Int):Void;
	@:overload(function(index:Int, value:Int32Array):Void {})
	public function vertexAttribI4iv(index:Int, value:Array<Int>):Void;
	@:overload(function(index:Int, value:UInt32Array):Void {})
	public function vertexAttribI4uiv(index:Int, value:Array<Int>):Void;
	public function vertexAttribIPointer(index:Int, size:Int, type:Int, stride:Int, offset:DataPointer):Void;
	public function waitSync(sync:GLSync, flags:Int, timeout:Dynamic /*int64*/):Void;
}
#end
