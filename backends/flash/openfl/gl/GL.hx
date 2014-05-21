package openfl.gl;
#if display


import flash.display.BitmapData;
import flash.utils.ByteArray;
import flash.geom.Matrix3D;
import openfl.utils.ArrayBuffer;
import openfl.utils.ArrayBufferView;
import openfl.utils.Float32Array;
import openfl.utils.Int32Array;
//import native.Lib;
//import native.Loader;


extern class GL {
	
	
	/* ClearBufferMask */
	static inline var DEPTH_BUFFER_BIT               = 0x00000100;
	static inline var STENCIL_BUFFER_BIT             = 0x00000400;
	static inline var COLOR_BUFFER_BIT               = 0x00004000;

	/* BeginMode */
	static inline var POINTS                         = 0x0000;
	static inline var LINES                          = 0x0001;
	static inline var LINE_LOOP                      = 0x0002;
	static inline var LINE_STRIP                     = 0x0003;
	static inline var TRIANGLES                      = 0x0004;
	static inline var TRIANGLE_STRIP                 = 0x0005;
	static inline var TRIANGLE_FAN                   = 0x0006;

	/* AlphaFunction(not supported in ES20) */
	/*      NEVER */
	/*      LESS */
	/*      EQUAL */
	/*      LEQUAL */
	/*      GREATER */
	/*      NOTEQUAL */
	/*      GEQUAL */
	/*      ALWAYS */

	/* BlendingFactorDest */
	static inline var ZERO                           = 0;
	static inline var ONE                            = 1;
	static inline var SRC_COLOR                      = 0x0300;
	static inline var ONE_MINUS_SRC_COLOR            = 0x0301;
	static inline var SRC_ALPHA                      = 0x0302;
	static inline var ONE_MINUS_SRC_ALPHA            = 0x0303;
	static inline var DST_ALPHA                      = 0x0304;
	static inline var ONE_MINUS_DST_ALPHA            = 0x0305;

	/* BlendingFactorSrc */
	/*      ZERO */
	/*      ONE */
	static inline var DST_COLOR                      = 0x0306;
	static inline var ONE_MINUS_DST_COLOR            = 0x0307;
	static inline var SRC_ALPHA_SATURATE             = 0x0308;
	/*      SRC_ALPHA */
	/*      ONE_MINUS_SRC_ALPHA */
	/*      DST_ALPHA */
	/*      ONE_MINUS_DST_ALPHA */

	/* BlendEquationSeparate */
	static inline var FUNC_ADD                       = 0x8006;
	static inline var BLEND_EQUATION                 = 0x8009;
	static inline var BLEND_EQUATION_RGB             = 0x8009;   /* same as BLEND_EQUATION */
	static inline var BLEND_EQUATION_ALPHA           = 0x883D;

	/* BlendSubtract */
	static inline var FUNC_SUBTRACT                  = 0x800A;
	static inline var FUNC_REVERSE_SUBTRACT          = 0x800B;

	/* Separate Blend Functions */
	static inline var BLEND_DST_RGB                  = 0x80C8;
	static inline var BLEND_SRC_RGB                  = 0x80C9;
	static inline var BLEND_DST_ALPHA                = 0x80CA;
	static inline var BLEND_SRC_ALPHA                = 0x80CB;
	static inline var CONSTANT_COLOR                 = 0x8001;
	static inline var ONE_MINUS_CONSTANT_COLOR       = 0x8002;
	static inline var CONSTANT_ALPHA                 = 0x8003;
	static inline var ONE_MINUS_CONSTANT_ALPHA       = 0x8004;
	static inline var BLEND_COLOR                    = 0x8005;

	/* GLBuffer Objects */
	static inline var ARRAY_BUFFER                   = 0x8892;
	static inline var ELEMENT_ARRAY_BUFFER           = 0x8893;
	static inline var ARRAY_BUFFER_BINDING           = 0x8894;
	static inline var ELEMENT_ARRAY_BUFFER_BINDING   = 0x8895;

	static inline var STREAM_DRAW                    = 0x88E0;
	static inline var STATIC_DRAW                    = 0x88E4;
	static inline var DYNAMIC_DRAW                   = 0x88E8;

	static inline var BUFFER_SIZE                    = 0x8764;
	static inline var BUFFER_USAGE                   = 0x8765;

	static inline var CURRENT_VERTEX_ATTRIB          = 0x8626;

	/* CullFaceMode */
	static inline var FRONT                          = 0x0404;
	static inline var BACK                           = 0x0405;
	static inline var FRONT_AND_BACK                 = 0x0408;

	/* DepthFunction */
	/*      NEVER */
	/*      LESS */
	/*      EQUAL */
	/*      LEQUAL */
	/*      GREATER */
	/*      NOTEQUAL */
	/*      GEQUAL */
	/*      ALWAYS */

	/* EnableCap */
	/* TEXTURE_2D */
	static inline var CULL_FACE                      = 0x0B44;
	static inline var BLEND                          = 0x0BE2;
	static inline var DITHER                         = 0x0BD0;
	static inline var STENCIL_TEST                   = 0x0B90;
	static inline var DEPTH_TEST                     = 0x0B71;
	static inline var SCISSOR_TEST                   = 0x0C11;
	static inline var POLYGON_OFFSET_FILL            = 0x8037;
	static inline var SAMPLE_ALPHA_TO_COVERAGE       = 0x809E;
	static inline var SAMPLE_COVERAGE                = 0x80A0;

	/* ErrorCode */
	static inline var NO_ERROR                       = 0;
	static inline var INVALID_ENUM                   = 0x0500;
	static inline var INVALID_VALUE                  = 0x0501;
	static inline var INVALID_OPERATION              = 0x0502;
	static inline var OUT_OF_MEMORY                  = 0x0505;

	/* FrontFaceDirection */
	static inline var CW                             = 0x0900;
	static inline var CCW                            = 0x0901;

	/* GetPName */
	static inline var LINE_WIDTH                     = 0x0B21;
	static inline var ALIASED_POINT_SIZE_RANGE       = 0x846D;
	static inline var ALIASED_LINE_WIDTH_RANGE       = 0x846E;
	static inline var CULL_FACE_MODE                 = 0x0B45;
	static inline var FRONT_FACE                     = 0x0B46;
	static inline var DEPTH_RANGE                    = 0x0B70;
	static inline var DEPTH_WRITEMASK                = 0x0B72;
	static inline var DEPTH_CLEAR_VALUE              = 0x0B73;
	static inline var DEPTH_FUNC                     = 0x0B74;
	static inline var STENCIL_CLEAR_VALUE            = 0x0B91;
	static inline var STENCIL_FUNC                   = 0x0B92;
	static inline var STENCIL_FAIL                   = 0x0B94;
	static inline var STENCIL_PASS_DEPTH_FAIL        = 0x0B95;
	static inline var STENCIL_PASS_DEPTH_PASS        = 0x0B96;
	static inline var STENCIL_REF                    = 0x0B97;
	static inline var STENCIL_VALUE_MASK             = 0x0B93;
	static inline var STENCIL_WRITEMASK              = 0x0B98;
	static inline var STENCIL_BACK_FUNC              = 0x8800;
	static inline var STENCIL_BACK_FAIL              = 0x8801;
	static inline var STENCIL_BACK_PASS_DEPTH_FAIL   = 0x8802;
	static inline var STENCIL_BACK_PASS_DEPTH_PASS   = 0x8803;
	static inline var STENCIL_BACK_REF               = 0x8CA3;
	static inline var STENCIL_BACK_VALUE_MASK        = 0x8CA4;
	static inline var STENCIL_BACK_WRITEMASK         = 0x8CA5;
	static inline var VIEWPORT                       = 0x0BA2;
	static inline var SCISSOR_BOX                    = 0x0C10;
	/*      SCISSOR_TEST */
	static inline var COLOR_CLEAR_VALUE              = 0x0C22;
	static inline var COLOR_WRITEMASK                = 0x0C23;
	static inline var UNPACK_ALIGNMENT               = 0x0CF5;
	static inline var PACK_ALIGNMENT                 = 0x0D05;
	static inline var MAX_TEXTURE_SIZE               = 0x0D33;
	static inline var MAX_VIEWPORT_DIMS              = 0x0D3A;
	static inline var SUBPIXEL_BITS                  = 0x0D50;
	static inline var RED_BITS                       = 0x0D52;
	static inline var GREEN_BITS                     = 0x0D53;
	static inline var BLUE_BITS                      = 0x0D54;
	static inline var ALPHA_BITS                     = 0x0D55;
	static inline var DEPTH_BITS                     = 0x0D56;
	static inline var STENCIL_BITS                   = 0x0D57;
	static inline var POLYGON_OFFSET_UNITS           = 0x2A00;
	/*      POLYGON_OFFSET_FILL */
	static inline var POLYGON_OFFSET_FACTOR          = 0x8038;
	static inline var TEXTURE_BINDING_2D             = 0x8069;
	static inline var SAMPLE_BUFFERS                 = 0x80A8;
	static inline var SAMPLES                        = 0x80A9;
	static inline var SAMPLE_COVERAGE_VALUE          = 0x80AA;
	static inline var SAMPLE_COVERAGE_INVERT         = 0x80AB;

	/* GetTextureParameter */
	/*      TEXTURE_MAG_FILTER */
	/*      TEXTURE_MIN_FILTER */
	/*      TEXTURE_WRAP_S */
	/*      TEXTURE_WRAP_T */

	static inline var COMPRESSED_TEXTURE_FORMATS     = 0x86A3;

	/* HintMode */
	static inline var DONT_CARE                      = 0x1100;
	static inline var FASTEST                        = 0x1101;
	static inline var NICEST                         = 0x1102;

	/* HintTarget */
	static inline var GENERATE_MIPMAP_HINT            = 0x8192;

	/* DataType */
	static inline var BYTE                           = 0x1400;
	static inline var UNSIGNED_BYTE                  = 0x1401;
	static inline var SHORT                          = 0x1402;
	static inline var UNSIGNED_SHORT                 = 0x1403;
	static inline var INT                            = 0x1404;
	static inline var UNSIGNED_INT                   = 0x1405;
	static inline var FLOAT                          = 0x1406;

	/* PixelFormat */
	static inline var DEPTH_COMPONENT                = 0x1902;
	static inline var ALPHA                          = 0x1906;
	static inline var RGB                            = 0x1907;
	static inline var RGBA                           = 0x1908;
	static inline var LUMINANCE                      = 0x1909;
	static inline var LUMINANCE_ALPHA                = 0x190A;

	/* PixelType */
	/*      UNSIGNED_BYTE */
	static inline var UNSIGNED_SHORT_4_4_4_4         = 0x8033;
	static inline var UNSIGNED_SHORT_5_5_5_1         = 0x8034;
	static inline var UNSIGNED_SHORT_5_6_5           = 0x8363;

	/* Shaders */
	static inline var FRAGMENT_SHADER                  = 0x8B30;
	static inline var VERTEX_SHADER                    = 0x8B31;
	static inline var MAX_VERTEX_ATTRIBS               = 0x8869;
	static inline var MAX_VERTEX_UNIFORM_VECTORS       = 0x8DFB;
	static inline var MAX_VARYING_VECTORS              = 0x8DFC;
	static inline var MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
	static inline var MAX_VERTEX_TEXTURE_IMAGE_UNITS   = 0x8B4C;
	static inline var MAX_TEXTURE_IMAGE_UNITS          = 0x8872;
	static inline var MAX_FRAGMENT_UNIFORM_VECTORS     = 0x8DFD;
	static inline var SHADER_TYPE                      = 0x8B4F;
	static inline var DELETE_STATUS                    = 0x8B80;
	static inline var LINK_STATUS                      = 0x8B82;
	static inline var VALIDATE_STATUS                  = 0x8B83;
	static inline var ATTACHED_SHADERS                 = 0x8B85;
	static inline var ACTIVE_UNIFORMS                  = 0x8B86;
	static inline var ACTIVE_ATTRIBUTES                = 0x8B89;
	static inline var SHADING_LANGUAGE_VERSION         = 0x8B8C;
	static inline var CURRENT_PROGRAM                  = 0x8B8D;

	/* StencilFunction */
	static inline var NEVER                          = 0x0200;
	static inline var LESS                           = 0x0201;
	static inline var EQUAL                          = 0x0202;
	static inline var LEQUAL                         = 0x0203;
	static inline var GREATER                        = 0x0204;
	static inline var NOTEQUAL                       = 0x0205;
	static inline var GEQUAL                         = 0x0206;
	static inline var ALWAYS                         = 0x0207;

	/* StencilOp */
	/*      ZERO */
	static inline var KEEP                           = 0x1E00;
	static inline var REPLACE                        = 0x1E01;
	static inline var INCR                           = 0x1E02;
	static inline var DECR                           = 0x1E03;
	static inline var INVERT                         = 0x150A;
	static inline var INCR_WRAP                      = 0x8507;
	static inline var DECR_WRAP                      = 0x8508;

	/* StringName */
	static inline var VENDOR                         = 0x1F00;
	static inline var RENDERER                       = 0x1F01;
	static inline var VERSION                        = 0x1F02;

	/* TextureMagFilter */
	static inline var NEAREST                        = 0x2600;
	static inline var LINEAR                         = 0x2601;

	/* TextureMinFilter */
	/*      NEAREST */
	/*      LINEAR */
	static inline var NEAREST_MIPMAP_NEAREST         = 0x2700;
	static inline var LINEAR_MIPMAP_NEAREST          = 0x2701;
	static inline var NEAREST_MIPMAP_LINEAR          = 0x2702;
	static inline var LINEAR_MIPMAP_LINEAR           = 0x2703;

	/* TextureParameterName */
	static inline var TEXTURE_MAG_FILTER             = 0x2800;
	static inline var TEXTURE_MIN_FILTER             = 0x2801;
	static inline var TEXTURE_WRAP_S                 = 0x2802;
	static inline var TEXTURE_WRAP_T                 = 0x2803;

	/* TextureTarget */
	static inline var TEXTURE_2D                     = 0x0DE1;
	static inline var TEXTURE                        = 0x1702;

	static inline var TEXTURE_CUBE_MAP               = 0x8513;
	static inline var TEXTURE_BINDING_CUBE_MAP       = 0x8514;
	static inline var TEXTURE_CUBE_MAP_POSITIVE_X    = 0x8515;
	static inline var TEXTURE_CUBE_MAP_NEGATIVE_X    = 0x8516;
	static inline var TEXTURE_CUBE_MAP_POSITIVE_Y    = 0x8517;
	static inline var TEXTURE_CUBE_MAP_NEGATIVE_Y    = 0x8518;
	static inline var TEXTURE_CUBE_MAP_POSITIVE_Z    = 0x8519;
	static inline var TEXTURE_CUBE_MAP_NEGATIVE_Z    = 0x851A;
	static inline var MAX_CUBE_MAP_TEXTURE_SIZE      = 0x851C;

	/* TextureUnit */
	static inline var TEXTURE0                       = 0x84C0;
	static inline var TEXTURE1                       = 0x84C1;
	static inline var TEXTURE2                       = 0x84C2;
	static inline var TEXTURE3                       = 0x84C3;
	static inline var TEXTURE4                       = 0x84C4;
	static inline var TEXTURE5                       = 0x84C5;
	static inline var TEXTURE6                       = 0x84C6;
	static inline var TEXTURE7                       = 0x84C7;
	static inline var TEXTURE8                       = 0x84C8;
	static inline var TEXTURE9                       = 0x84C9;
	static inline var TEXTURE10                      = 0x84CA;
	static inline var TEXTURE11                      = 0x84CB;
	static inline var TEXTURE12                      = 0x84CC;
	static inline var TEXTURE13                      = 0x84CD;
	static inline var TEXTURE14                      = 0x84CE;
	static inline var TEXTURE15                      = 0x84CF;
	static inline var TEXTURE16                      = 0x84D0;
	static inline var TEXTURE17                      = 0x84D1;
	static inline var TEXTURE18                      = 0x84D2;
	static inline var TEXTURE19                      = 0x84D3;
	static inline var TEXTURE20                      = 0x84D4;
	static inline var TEXTURE21                      = 0x84D5;
	static inline var TEXTURE22                      = 0x84D6;
	static inline var TEXTURE23                      = 0x84D7;
	static inline var TEXTURE24                      = 0x84D8;
	static inline var TEXTURE25                      = 0x84D9;
	static inline var TEXTURE26                      = 0x84DA;
	static inline var TEXTURE27                      = 0x84DB;
	static inline var TEXTURE28                      = 0x84DC;
	static inline var TEXTURE29                      = 0x84DD;
	static inline var TEXTURE30                      = 0x84DE;
	static inline var TEXTURE31                      = 0x84DF;
	static inline var ACTIVE_TEXTURE                 = 0x84E0;

	/* TextureWrapMode */
	static inline var REPEAT                         = 0x2901;
	static inline var CLAMP_TO_EDGE                  = 0x812F;
	static inline var MIRRORED_REPEAT                = 0x8370;

	/* Uniform Types */
	static inline var FLOAT_VEC2                     = 0x8B50;
	static inline var FLOAT_VEC3                     = 0x8B51;
	static inline var FLOAT_VEC4                     = 0x8B52;
	static inline var INT_VEC2                       = 0x8B53;
	static inline var INT_VEC3                       = 0x8B54;
	static inline var INT_VEC4                       = 0x8B55;
	static inline var BOOL                           = 0x8B56;
	static inline var BOOL_VEC2                      = 0x8B57;
	static inline var BOOL_VEC3                      = 0x8B58;
	static inline var BOOL_VEC4                      = 0x8B59;
	static inline var FLOAT_MAT2                     = 0x8B5A;
	static inline var FLOAT_MAT3                     = 0x8B5B;
	static inline var FLOAT_MAT4                     = 0x8B5C;
	static inline var SAMPLER_2D                     = 0x8B5E;
	static inline var SAMPLER_CUBE                   = 0x8B60;

	/* Vertex Arrays */
	static inline var VERTEX_ATTRIB_ARRAY_ENABLED        = 0x8622;
	static inline var VERTEX_ATTRIB_ARRAY_SIZE           = 0x8623;
	static inline var VERTEX_ATTRIB_ARRAY_STRIDE         = 0x8624;
	static inline var VERTEX_ATTRIB_ARRAY_TYPE           = 0x8625;
	static inline var VERTEX_ATTRIB_ARRAY_NORMALIZED     = 0x886A;
	static inline var VERTEX_ATTRIB_ARRAY_POINTER        = 0x8645;
	static inline var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
	
	/* Point Size */
	static inline var VERTEX_PROGRAM_POINT_SIZE       = 0x8642;
	static inline var POINT_SPRITE                    = 0x8861;

	/* GLShader Source */
	static inline var COMPILE_STATUS                 = 0x8B81;

	/* GLShader Precision-Specified Types */
	static inline var LOW_FLOAT                      = 0x8DF0;
	static inline var MEDIUM_FLOAT                   = 0x8DF1;
	static inline var HIGH_FLOAT                     = 0x8DF2;
	static inline var LOW_INT                        = 0x8DF3;
	static inline var MEDIUM_INT                     = 0x8DF4;
	static inline var HIGH_INT                       = 0x8DF5;

	/* GLFramebuffer Object. */
	static inline var FRAMEBUFFER                    = 0x8D40;
	static inline var RENDERBUFFER                   = 0x8D41;

	static inline var RGBA4                          = 0x8056;
	static inline var RGB5_A1                        = 0x8057;
	static inline var RGB565                         = 0x8D62;
	static inline var DEPTH_COMPONENT16              = 0x81A5;
	static inline var STENCIL_INDEX                  = 0x1901;
	static inline var STENCIL_INDEX8                 = 0x8D48;
	static inline var DEPTH_STENCIL                  = 0x84F9;

	static inline var RENDERBUFFER_WIDTH             = 0x8D42;
	static inline var RENDERBUFFER_HEIGHT            = 0x8D43;
	static inline var RENDERBUFFER_INTERNAL_FORMAT   = 0x8D44;
	static inline var RENDERBUFFER_RED_SIZE          = 0x8D50;
	static inline var RENDERBUFFER_GREEN_SIZE        = 0x8D51;
	static inline var RENDERBUFFER_BLUE_SIZE         = 0x8D52;
	static inline var RENDERBUFFER_ALPHA_SIZE        = 0x8D53;
	static inline var RENDERBUFFER_DEPTH_SIZE        = 0x8D54;
	static inline var RENDERBUFFER_STENCIL_SIZE      = 0x8D55;

	static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE           = 0x8CD0;
	static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME           = 0x8CD1;
	static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL         = 0x8CD2;
	static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;

	static inline var COLOR_ATTACHMENT0              = 0x8CE0;
	static inline var DEPTH_ATTACHMENT               = 0x8D00;
	static inline var STENCIL_ATTACHMENT             = 0x8D20;
	static inline var DEPTH_STENCIL_ATTACHMENT       = 0x821A;

	static inline var NONE                           = 0;

	static inline var FRAMEBUFFER_COMPLETE                      = 0x8CD5;
	static inline var FRAMEBUFFER_INCOMPLETE_ATTACHMENT         = 0x8CD6;
	static inline var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
	static inline var FRAMEBUFFER_INCOMPLETE_DIMENSIONS         = 0x8CD9;
	static inline var FRAMEBUFFER_UNSUPPORTED                   = 0x8CDD;

	static inline var FRAMEBUFFER_BINDING            = 0x8CA6;
	static inline var RENDERBUFFER_BINDING           = 0x8CA7;
	static inline var MAX_RENDERBUFFER_SIZE          = 0x84E8;

	static inline var INVALID_FRAMEBUFFER_OPERATION  = 0x0506;

	/* WebGL-specific enums */
	static inline var UNPACK_FLIP_Y_WEBGL            = 0x9240;
	static inline var UNPACK_PREMULTIPLY_ALPHA_WEBGL = 0x9241;
	static inline var CONTEXT_LOST_WEBGL             = 0x9242;
	static inline var UNPACK_COLORSPACE_CONVERSION_WEBGL = 0x9243;
	static inline var BROWSER_DEFAULT_WEBGL          = 0x9244;
	
	
	static var drawingBufferHeight(get_drawingBufferHeight, null):Int;
	static var drawingBufferWidth(get_drawingBufferWidth, null):Int;
	static var version(get_version, null):Int;
	
	
	static function activeTexture(texture:Int):Void;
	static function attachShader(program:GLProgram, shader:GLShader):Void;
	static function bindAttribLocation(program:GLProgram, index:Int, name:String):Void;
	static function bindBitmapDataTexture(texture:BitmapData):Void;
	static function bindBuffer(target:Int, buffer:GLBuffer):Void;
	static function bindFramebuffer(target:Int, framebuffer:GLFramebuffer):Void;
	static function bindRenderbuffer(target:Int, renderbuffer:GLRenderbuffer):Void;
	static function bindTexture(target:Int, texture:GLTexture):Void;
	static function blendColor(red:Float, green:Float, blue:Float, alpha:Float):Void;
	static function blendEquation(mode:Int):Void;
	static function blendEquationSeparate(modeRGB:Int, modeAlpha:Int):Void;
	static function blendFunc(sfactor:Int, dfactor:Int):Void;
	static function blendFuncSeparate(srcRGB:Int, dstRGB:Int, srcAlpha:Int, dstAlpha:Int):Void;
	static function bufferData(target:Int, data:ArrayBufferView, usage:Int):Void;
	static function bufferSubData(target:Int, offset:Int, data:ArrayBufferView):Void;
	static function checkFramebufferStatus(target:Int):Int;
	static function clear(mask:Int):Void;
	static function clearColor(red:Float, green:Float, blue:Float, alpha:Float):Void;
	static function clearDepth(depth:Float):Void;
	static function clearStencil(s:Int):Void;
	static function colorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void;
	static function compileShader(shader:GLShader):Void;
	static function compressedTexImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, data:ArrayBufferView):Void;
	static function compressedTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, data:ArrayBufferView):Void;
	static function copyTexImage2D(target:Int, level:Int, internalformat:Int, x:Int, y:Int, width:Int, height:Int, border:Int):Void;
	static function copyTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, x:Int, y:Int, width:Int, height:Int):Void;
	static function createBuffer():GLBuffer;
	static function createFramebuffer():GLFramebuffer;
	static function createProgram():GLProgram;
	static function createRenderbuffer():GLRenderbuffer;
	static function createShader(type:Int):GLShader;
	static function createTexture():GLTexture;
	static function cullFace(mode:Int):Void;
	static function deleteBuffer(buffer:GLBuffer):Void;
	static function deleteFramebuffer(framebuffer:GLFramebuffer):Void;
	static function deleteProgram(program:GLProgram):Void;
	static function deleteRenderbuffer(renderbuffer:GLRenderbuffer):Void;
	static function deleteShader(shader:GLShader):Void;
	static function deleteTexture(texture:GLTexture):Void;
	static function depthFunc(func:Int):Void;
	static function depthMask(flag:Bool):Void;
	static function depthRange(zNear:Float, zFar:Float):Void;
	static function detachShader(program:GLProgram, shader:GLShader):Void;
	static function disable(cap:Int):Void;
	static function disableVertexAttribArray(index:Int):Void;
	static function drawArrays(mode:Int, first:Int, count:Int):Void;
	static function drawElements(mode:Int, count:Int, type:Int, offset:Int):Void;
	static function enable(cap:Int):Void;
	static function enableVertexAttribArray(index:Int):Void;
	static function finish():Void;
	static function flush():Void;
	static function framebufferRenderbuffer(target:Int, attachment:Int, renderbuffertarget:Int, renderbuffer:GLRenderbuffer):Void;
	static function framebufferTexture2D(target:Int, attachment:Int, textarget:Int, texture:GLTexture, level:Int):Void;
	static function frontFace(mode:Int):Void;
	static function generateMipmap(target:Int):Void;
	static function getActiveAttrib(program:GLProgram, index:Int):GLActiveInfo;
	static function getActiveUniform(program:GLProgram, index:Int):GLActiveInfo;
	static function getAttachedShaders(program:GLProgram):Array<GLShader>;
	static function getAttribLocation(program:GLProgram, name:String):Int;
	static function getBufferParameter(target:Int, pname:Int):Dynamic;
	static function getContextAttributes():GLContextAttributes;
	static function getError():Int;
	static function getExtension(name:String):Dynamic;
	static function getFramebufferAttachmentParameter(target:Int, attachment:Int, pname:Int):Dynamic;
	static function getParameter(pname:Int):Dynamic;
	static function getProgramInfoLog(program:GLProgram):String;
	static function getProgramParameter(program:GLProgram, pname:Int):Int;
	static function getRenderbufferParameter(target:Int, pname:Int):Dynamic;
	static function getShaderInfoLog(shader:GLShader):String;
	static function getShaderParameter(shader:GLShader, pname:Int):Int;
	static function getShaderPrecisionFormat(shadertype:Int, precisiontype:Int):ShaderPrecisionFormat;
	static function getShaderSource(shader:GLShader):String;
	static function getSupportedExtensions():Array<String>;
	static function getTexParameter(target:Int, pname:Int):Dynamic;
	static function getUniform(program:GLProgram, location:GLUniformLocation):Dynamic;
	static function getUniformLocation(program:GLProgram, name:String):GLUniformLocation;
	static function getVertexAttrib(index:Int, pname:Int):Dynamic;
	static function getVertexAttribOffset(index:Int, pname:Int):Int;
	static function hint(target:Int, mode:Int):Void;
	static function isBuffer(buffer:GLBuffer):Bool;
	// function isContextLost():Bool;
	static function isEnabled(cap:Int):Bool;
	static function isFramebuffer(framebuffer:GLFramebuffer):Bool;
	static function isProgram(program:GLProgram):Bool;
	static function isRenderbuffer(renderbuffer:GLRenderbuffer):Bool;
	static function isShader(shader:GLShader):Bool;
	static function isTexture(texture:GLTexture):Bool;
	static function lineWidth(width:Float):Void;
	static function linkProgram(program:GLProgram):Void;
	static function pixelStorei(pname:Int, param:Int):Void;
	static function polygonOffset(factor:Float, units:Float):Void;
	static function readPixels(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:ByteArray):Void;
	static function renderbufferStorage(target:Int, internalformat:Int, width:Int, height:Int):Void;
	static function sampleCoverage(value:Float, invert:Bool):Void;
	static function scissor(x:Int, y:Int, width:Int, height:Int):Void;
	static function shaderSource(shader:GLShader, source:String):Void;
	static function stencilFunc(func:Int, ref:Int, mask:Int):Void;
	static function stencilFuncSeparate(face:Int, func:Int, ref:Int, mask:Int):Void;
	static function stencilMask(mask:Int):Void;
	static function stencilMaskSeparate(face:Int, mask:Int):Void;
	static function stencilOp(fail:Int, zfail:Int, zpass:Int):Void;
	static function stencilOpSeparate(face:Int, fail:Int, zfail:Int, zpass:Int):Void;
	static function texImage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, format:Int, type:Int, pixels:ArrayBufferView):Void;
	static function texParameterf(target:Int, pname:Int, param:Float):Void;
	static function texParameteri(target:Int, pname:Int, param:Int):Void;
	static function texSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int, type:Int, pixels:ByteArray):Void;
	static function uniform1f(location:GLUniformLocation, x:Float):Void;
	static function uniform1fv(location:GLUniformLocation, x:Float32Array):Void;
	static function uniform1i(location:GLUniformLocation, x:Int):Void;
	static function uniform1iv(location:GLUniformLocation, v:Int32Array):Void;
	static function uniform2f(location:GLUniformLocation, x:Float, y:Float):Void;
	static function uniform2fv(location:GLUniformLocation, v:Float32Array):Void;
	static function uniform2i(location:GLUniformLocation, x:Int, y:Int):Void;
	static function uniform2iv(location:GLUniformLocation, v:Int32Array):Void;
	static function uniform3f(location:GLUniformLocation, x:Float, y:Float, z:Float):Void;
	static function uniform3fv(location:GLUniformLocation, v:Float32Array):Void;
	static function uniform3i(location:GLUniformLocation, x:Int, y:Int, z:Int):Void;
	static function uniform3iv(location:GLUniformLocation, v:Int32Array):Void;
	static function uniform4f(location:GLUniformLocation, x:Float, y:Float, z:Float, w:Float):Void;
	static function uniform4fv(location:GLUniformLocation, v:Float32Array):Void;
	static function uniform4i(location:GLUniformLocation, x:Int, y:Int, z:Int, w:Int):Void;
	static function uniform4iv(location:GLUniformLocation, v:Int32Array):Void;
	static function uniformMatrix2fv(location:GLUniformLocation, transpose:Bool, v:Float32Array):Void;
	static function uniformMatrix3fv(location:GLUniformLocation, transpose:Bool, v:Float32Array):Void;
	static function uniformMatrix4fv(location:GLUniformLocation, transpose:Bool, v:Float32Array):Void;
	static function uniformMatrix3D(location:GLUniformLocation, transpose:Bool, matrix:Matrix3D):Void;
	static function useProgram(program:GLProgram):Void;
	static function validateProgram(program:GLProgram):Void;
	static function vertexAttrib1f(indx:Int, x:Float):Void;
	static function vertexAttrib1fv(indx:Int, values:Float32Array):Void;
	static function vertexAttrib2f(indx:Int, x:Float, y:Float):Void;
	static function vertexAttrib2fv(indx:Int, values:Float32Array):Void;
	static function vertexAttrib3f(indx:Int, x:Float, y:Float, z:Float):Void;
	static function vertexAttrib3fv(indx:Int, values:Float32Array):Void;
	static function vertexAttrib4f(indx:Int, x:Float, y:Float, z:Float, w:Float):Void;
	static function vertexAttrib4fv(indx:Int, values:Float32Array):Void;
	static function vertexAttribPointer(indx:Int, size:Int, type:Int, normalized:Bool, stride:Int, offset:Int):Void;
	static function viewport(x:Int, y:Int, width:Int, height:Int):Void;
	
   
}


typedef ShaderPrecisionFormat = {
	
   rangeMin : Int,
   rangeMax : Int,
   precision : Int,
   
};


#end