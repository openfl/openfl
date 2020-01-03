package openfl._internal.backend.lime_standalone;

#if openfl_html5
import js.html.webgl.UniformLocation in GLUniformLocation;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.Float32Array;

@:forward(DEPTH_BUFFER_BIT, STENCIL_BUFFER_BIT, COLOR_BUFFER_BIT, POINTS, LINES, LINE_LOOP, LINE_STRIP, TRIANGLES, TRIANGLE_STRIP, TRIANGLE_FAN, ZERO, ONE,
	SRC_COLOR, ONE_MINUS_SRC_COLOR, SRC_ALPHA, ONE_MINUS_SRC_ALPHA, DST_ALPHA, ONE_MINUS_DST_ALPHA, DST_COLOR, ONE_MINUS_DST_COLOR, SRC_ALPHA_SATURATE,
	FUNC_ADD, BLEND_EQUATION, BLEND_EQUATION_RGB, BLEND_EQUATION_ALPHA, FUNC_SUBTRACT, FUNC_REVERSE_SUBTRACT, BLEND_DST_RGB, BLEND_SRC_RGB, BLEND_DST_ALPHA,
	BLEND_SRC_ALPHA, CONSTANT_COLOR, ONE_MINUS_CONSTANT_COLOR, CONSTANT_ALPHA, ONE_MINUS_CONSTANT_ALPHA, BLEND_COLOR, ARRAY_BUFFER, ELEMENT_ARRAY_BUFFER,
	ARRAY_BUFFER_BINDING, ELEMENT_ARRAY_BUFFER_BINDING, STREAM_DRAW, STATIC_DRAW, DYNAMIC_DRAW, BUFFER_SIZE, BUFFER_USAGE, CURRENT_VERTEX_ATTRIB, FRONT, BACK,
	FRONT_AND_BACK, CULL_FACE, BLEND, DITHER, STENCIL_TEST, DEPTH_TEST, SCISSOR_TEST, POLYGON_OFFSET_FILL, SAMPLE_ALPHA_TO_COVERAGE, SAMPLE_COVERAGE,
	NO_ERROR, INVALID_ENUM, INVALID_VALUE, INVALID_OPERATION, OUT_OF_MEMORY, CW, CCW, LINE_WIDTH, ALIASED_POINT_SIZE_RANGE, ALIASED_LINE_WIDTH_RANGE,
	CULL_FACE_MODE, FRONT_FACE, DEPTH_RANGE, DEPTH_WRITEMASK, DEPTH_CLEAR_VALUE, DEPTH_FUNC, STENCIL_CLEAR_VALUE, STENCIL_FUNC, STENCIL_FAIL,
	STENCIL_PASS_DEPTH_FAIL, STENCIL_PASS_DEPTH_PASS, STENCIL_REF, STENCIL_VALUE_MASK, STENCIL_WRITEMASK, STENCIL_BACK_FUNC, STENCIL_BACK_FAIL,
	STENCIL_BACK_PASS_DEPTH_FAIL, STENCIL_BACK_PASS_DEPTH_PASS, STENCIL_BACK_REF, STENCIL_BACK_VALUE_MASK, STENCIL_BACK_WRITEMASK, VIEWPORT, SCISSOR_BOX,
	COLOR_CLEAR_VALUE, COLOR_WRITEMASK, UNPACK_ALIGNMENT, PACK_ALIGNMENT, MAX_TEXTURE_SIZE, MAX_VIEWPORT_DIMS, SUBPIXEL_BITS, RED_BITS, GREEN_BITS, BLUE_BITS,
	ALPHA_BITS, DEPTH_BITS, STENCIL_BITS, POLYGON_OFFSET_UNITS, POLYGON_OFFSET_FACTOR, TEXTURE_BINDING_2D, SAMPLE_BUFFERS, SAMPLES, SAMPLE_COVERAGE_VALUE,
	SAMPLE_COVERAGE_INVERT, COMPRESSED_TEXTURE_FORMATS, DONT_CARE, FASTEST, NICEST, GENERATE_MIPMAP_HINT, BYTE, UNSIGNED_BYTE, SHORT, UNSIGNED_SHORT, INT,
	UNSIGNED_INT, FLOAT, DEPTH_COMPONENT, ALPHA, RGB, RGBA, LUMINANCE, LUMINANCE_ALPHA, UNSIGNED_SHORT_4_4_4_4, UNSIGNED_SHORT_5_5_5_1, UNSIGNED_SHORT_5_6_5,
	FRAGMENT_SHADER, VERTEX_SHADER, MAX_VERTEX_ATTRIBS, MAX_VERTEX_UNIFORM_VECTORS, MAX_VARYING_VECTORS, MAX_COMBINED_TEXTURE_IMAGE_UNITS,
	MAX_VERTEX_TEXTURE_IMAGE_UNITS, MAX_TEXTURE_IMAGE_UNITS, MAX_FRAGMENT_UNIFORM_VECTORS, SHADER_TYPE, DELETE_STATUS, LINK_STATUS, VALIDATE_STATUS,
	ATTACHED_SHADERS, ACTIVE_UNIFORMS, ACTIVE_ATTRIBUTES, SHADING_LANGUAGE_VERSION, CURRENT_PROGRAM, NEVER, LESS, EQUAL, LEQUAL, GREATER, NOTEQUAL, GEQUAL,
	ALWAYS, KEEP, REPLACE, INCR, DECR, INVERT, INCR_WRAP, DECR_WRAP, VENDOR, RENDERER, VERSION, NEAREST, LINEAR, NEAREST_MIPMAP_NEAREST,
	LINEAR_MIPMAP_NEAREST, NEAREST_MIPMAP_LINEAR, LINEAR_MIPMAP_LINEAR, TEXTURE_MAG_FILTER, TEXTURE_MIN_FILTER, TEXTURE_WRAP_S, TEXTURE_WRAP_T, TEXTURE_2D,
	TEXTURE, TEXTURE_CUBE_MAP, TEXTURE_BINDING_CUBE_MAP, TEXTURE_CUBE_MAP_POSITIVE_X, TEXTURE_CUBE_MAP_NEGATIVE_X, TEXTURE_CUBE_MAP_POSITIVE_Y,
	TEXTURE_CUBE_MAP_NEGATIVE_Y, TEXTURE_CUBE_MAP_POSITIVE_Z, TEXTURE_CUBE_MAP_NEGATIVE_Z, MAX_CUBE_MAP_TEXTURE_SIZE, TEXTURE0, TEXTURE1, TEXTURE2, TEXTURE3,
	TEXTURE4, TEXTURE5, TEXTURE6, TEXTURE7, TEXTURE8, TEXTURE9, TEXTURE10, TEXTURE11, TEXTURE12, TEXTURE13, TEXTURE14, TEXTURE15, TEXTURE16, TEXTURE17,
	TEXTURE18, TEXTURE19, TEXTURE20, TEXTURE21, TEXTURE22, TEXTURE23, TEXTURE24, TEXTURE25, TEXTURE26, TEXTURE27, TEXTURE28, TEXTURE29, TEXTURE30, TEXTURE31,
	ACTIVE_TEXTURE, REPEAT, CLAMP_TO_EDGE, MIRRORED_REPEAT, FLOAT_VEC2, FLOAT_VEC3, FLOAT_VEC4, INT_VEC2, INT_VEC3, INT_VEC4, BOOL, BOOL_VEC2, BOOL_VEC3,
	BOOL_VEC4, FLOAT_MAT2, FLOAT_MAT3, FLOAT_MAT4, SAMPLER_2D, SAMPLER_CUBE, VERTEX_ATTRIB_ARRAY_ENABLED, VERTEX_ATTRIB_ARRAY_SIZE,
	VERTEX_ATTRIB_ARRAY_STRIDE, VERTEX_ATTRIB_ARRAY_TYPE, VERTEX_ATTRIB_ARRAY_NORMALIZED, VERTEX_ATTRIB_ARRAY_POINTER, VERTEX_ATTRIB_ARRAY_BUFFER_BINDING,
	COMPILE_STATUS, LOW_FLOAT, MEDIUM_FLOAT, HIGH_FLOAT, LOW_INT, MEDIUM_INT, HIGH_INT, FRAMEBUFFER, RENDERBUFFER, RGBA4, RGB5_A1, RGB565, DEPTH_COMPONENT16,
	STENCIL_INDEX, STENCIL_INDEX8, DEPTH_STENCIL, RENDERBUFFER_WIDTH, RENDERBUFFER_HEIGHT, RENDERBUFFER_INTERNAL_FORMAT, RENDERBUFFER_RED_SIZE,
	RENDERBUFFER_GREEN_SIZE, RENDERBUFFER_BLUE_SIZE, RENDERBUFFER_ALPHA_SIZE, RENDERBUFFER_DEPTH_SIZE, RENDERBUFFER_STENCIL_SIZE,
	FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE, FRAMEBUFFER_ATTACHMENT_OBJECT_NAME, FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL,
	FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE, COLOR_ATTACHMENT0, DEPTH_ATTACHMENT, STENCIL_ATTACHMENT, DEPTH_STENCIL_ATTACHMENT, NONE,
	FRAMEBUFFER_COMPLETE, FRAMEBUFFER_INCOMPLETE_ATTACHMENT, FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT, FRAMEBUFFER_INCOMPLETE_DIMENSIONS,
	FRAMEBUFFER_UNSUPPORTED, FRAMEBUFFER_BINDING, RENDERBUFFER_BINDING, MAX_RENDERBUFFER_SIZE, INVALID_FRAMEBUFFER_OPERATION, UNPACK_FLIP_Y_WEBGL,
	UNPACK_PREMULTIPLY_ALPHA_WEBGL, CONTEXT_LOST_WEBGL, UNPACK_COLORSPACE_CONVERSION_WEBGL, BROWSER_DEFAULT_WEBGL, type, version, activeTexture, attachShader,
	bindAttribLocation, bindBuffer, bindFramebuffer, bindRenderbuffer, bindTexture, blendColor, blendEquation, blendEquationSeparate, blendFunc,
	blendFuncSeparate, checkFramebufferStatus, clear, clearColor, clearDepth, clearStencil, colorMask, compileShader, copyTexImage2D, copyTexSubImage2D,
	createBuffer, createFramebuffer, createProgram, createRenderbuffer, createShader, createTexture, cullFace, cullFace, deleteBuffer, deleteFramebuffer,
	deleteProgram, deleteRenderbuffer, deleteShader, deleteTexture, depthFunc, depthMask, depthRange, detachShader, disable, disableVertexAttribArray,
	drawArrays, drawElements, enable, enableVertexAttribArray, finish, flush, framebufferRenderbuffer, framebufferTexture2D, frontFace, generateMipmap,
	getActiveAttrib, getActiveUniform, getAttachedShaders, getAttribLocation, getBufferParameter, getContextAttributes, getError, getExtension,
	getFramebufferAttachmentParameter, getParameter, getProgramInfoLog, getProgramParameter, getRenderbufferParameter, getShaderInfoLog, getShaderParameter,
	getShaderPrecisionFormat, getShaderSource, getSupportedExtensions, getTexParameter, getUniform, getUniformLocation, getVertexAttrib,
	getVertexAttribOffset, hint, isBuffer, isContextLost, isEnabled, isFramebuffer, isProgram, isRenderbuffer, isShader, isTexture, lineWidth, linkProgram,
	pixelStorei, polygonOffset, renderbufferStorage, sampleCoverage, scissor, shaderSource, stencilFunc, stencilFuncSeparate, stencilMask,
	stencilMaskSeparate, stencilOp, stencilOpSeparate, texParameterf, texParameteri, uniform1f, uniform1fv, uniform1i, uniform1iv, uniform2f, uniform2fv,
	uniform2i, uniform2iv, uniform3f, uniform3fv, uniform3i, uniform3iv, uniform4f, uniform4fv, uniform4i, uniform4iv, useProgram, validateProgram,
	vertexAttrib1f, vertexAttrib1fv, vertexAttrib2f, vertexAttrib2fv, vertexAttrib3f, vertexAttrib3fv, vertexAttrib4f, vertexAttrib4fv, vertexAttribPointer,
	viewport)
abstract WebGLRenderContext(WebGL2RenderContext)
{
	public function bufferData(target:Int, srcData:#if (!js || !html5 || display) ArrayBufferView #else Dynamic #end, usage:Int):Void
	{
		this.bufferData(target, srcData, usage);
	}

	public inline function bufferSubData(target:Int, offset:Int, srcData:#if (!js || !html5 || display) ArrayBufferView #else Dynamic #end):Void
	{
		this.bufferSubData(target, offset, srcData);
	}

	public function compressedTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int,
			srcData:#if (!js || !html5 || display) ArrayBufferView #else Dynamic #end):Void
	{
		this.compressedTexImage2D(target, level, internalformat, width, height, border, srcData);
	}

	public inline function compressedTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int,
			srcData:#if (!js || !html5 || display) ArrayBufferView #else Dynamic #end):Void
	{
		this.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData);
	}

	public inline function readPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int,
			pixels:#if (!js || !html5 || display) ArrayBufferView #else Dynamic #end):Void
	{
		this.readPixels(x, y, width, height, format, type, pixels);
	}

	#if (!js || !html5 || lime_doc_gen)
	public inline function texImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int,
			srcData:ArrayBufferView):Void
	{
		this.texImage2D(target, level, internalformat, width, height, border, format, type, srcData);
	}
	#else
	// public function texImage2D (target:Int, level:Int, internalformat:Int, format:Int, type:Int, pixels:Dynamic /*ImageBitmap*/):Void {
	// public function texImage2D (target:Int, level:Int, internalformat:Int, format:Int, type:Int, pixels:#if (js && html5) CanvasElement #else Dynamic #end):Void {
	// public function texImage2D (target:Int, level:Int, internalformat:Int, format:Int, type:Int, pixels:#if (js && html5) ImageData #else Dynamic #end):Void {
	// public function texImage2D (target:Int, level:Int, internalformat:Int, format:Int, type:Int, pixels:#if (js && html5) ImageElement #else Dynamic #end):Void {
	// public function texImage2D (target:Int, level:Int, internalformat:Int, format:Int, type:Int, pixels:#if (js && html5) VideoElement #else Dynamic #end):Void {
	// public function texImage2D (target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, srcData:ArrayBufferView):Void {
	public function texImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Dynamic, ?format:Int, ?type:Int, ?srcData:Dynamic):Void
	{
		this.texImage2D(target, level, internalformat, width, height, border, format, type, srcData);
	}
	#end

	#if (!js || !html5 || lime_doc_gen)
	public inline function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int,
			srcData:ArrayBufferView, srcOffset:Int = 0):Void
	{
		this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData, srcOffset);
	}
	#else
	// public function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, pixels:#if (js && html5) CanvasElement #else Dynamic #end):Void {
	// public function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, pixels:Dynamic /*ImageBitmap*/):Void {
	// public function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, pixels:#if (js && html5) ImageData #else Dynamic #end):Void {
	// public function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, pixels:#if (js && html5) ImageElement #else Dynamic #end):Void {
	// public function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, format:Int, type:Int, pixels:#if (js && html5) VideoElement #else Dynamic #end):Void {
	// public function texSubImage2D (target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, srcData:ArrayBufferView):Void {
	public function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Dynamic, ?type:Int, ?srcData:Dynamic):Void
	{
		this.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData);
	}
	#end

	public function uniformMatrix2fv(location:GLUniformLocation, transpose:Bool, v:Float32Array):Void
	{
		this.uniformMatrix2fv(location, transpose, v);
	}

	public function uniformMatrix3fv(location:GLUniformLocation, transpose:Bool, v:Float32Array):Void
	{
		this.uniformMatrix3fv(location, transpose, v);
	}

	public function uniformMatrix4fv(location:GLUniformLocation, transpose:Bool, v:Float32Array):Void
	{
		this.uniformMatrix4fv(location, transpose, v);
	}

	@:from private static function fromWebGL2RenderContext(gl:WebGL2RenderContext):WebGLRenderContext
	{
		return cast gl;
	}

	@:from private static function fromRenderContext(context:RenderContext):WebGLRenderContext
	{
		return context.webgl;
	}

	@:from private static function fromGL(gl:Class<GL>):WebGLRenderContext
	{
		return cast GL.context;
	}

	#if (!doc_gen && lime_opengl)
	@:from private static function fromOpenGLContext(gl:OpenGLRenderContext):WebGLRenderContext
	{
		#if (sys && lime_cffi && lime_opengl)
		return cast gl;
		#else
		return null;
		#end
	}
	#end

	#if (!doc_gen && (lime_opengl || lime_opengles))
	@:from private static function fromOpenGLES2Context(gl:OpenGLES2RenderContext):WebGLRenderContext
	{
		#if (sys && lime_cffi && lime_opengl)
		return cast gl;
		#else
		return null;
		#end
	}
	#end

	#if (!doc_gen && (lime_opengl || lime_opengles))
	@:from private static function fromOpenGLES3Context(gl:OpenGLES3RenderContext):WebGLRenderContext
	{
		#if (sys && lime_cffi && lime_opengl)
		return cast gl;
		#else
		return null;
		#end
	}
	#end
}
#end
