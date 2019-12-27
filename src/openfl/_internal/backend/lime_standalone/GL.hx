package openfl._internal.backend.lime_standalone;

#if openfl_html5
import haxe.Int64;
import js.html.webgl.ActiveInfo in GLActiveInfo;
import js.html.webgl.Buffer in GLBuffer;
import js.html.webgl.ContextAttributes in GLContextAttributes;
import js.html.webgl.Framebuffer in GLFramebuffer;
import js.html.webgl.Program in GLProgram;
import js.html.webgl.Query in GLQuery;
import js.html.webgl.Renderbuffer in GLRenderbuffer;
import js.html.webgl.Sampler in GLSampler;
import js.html.webgl.Shader in GLShader;
import js.html.webgl.ShaderPrecisionFormat in GLShaderPrecisionFormat;
import js.html.webgl.Sync in GLSync;
import js.html.webgl.Texture in GLTexture;
import js.html.webgl.TransformFeedback in GLTransformFeedback;
import js.html.webgl.UniformLocation in GLUniformLocation;
import js.html.webgl.VertexArrayObject in GLVertexArrayObject;

@:allow(openfl._internal.backend.lime_standalone.Window)
class GL
{
	public static inline var DEPTH_BUFFER_BIT = 0x00000100;
	public static inline var STENCIL_BUFFER_BIT = 0x00000400;
	public static inline var COLOR_BUFFER_BIT = 0x00004000;
	public static inline var POINTS = 0x0000;
	public static inline var LINES = 0x0001;
	public static inline var LINE_LOOP = 0x0002;
	public static inline var LINE_STRIP = 0x0003;
	public static inline var TRIANGLES = 0x0004;
	public static inline var TRIANGLE_STRIP = 0x0005;
	public static inline var TRIANGLE_FAN = 0x0006;
	public static inline var ZERO = 0;
	public static inline var ONE = 1;
	public static inline var SRC_COLOR = 0x0300;
	public static inline var ONE_MINUS_SRC_COLOR = 0x0301;
	public static inline var SRC_ALPHA = 0x0302;
	public static inline var ONE_MINUS_SRC_ALPHA = 0x0303;
	public static inline var DST_ALPHA = 0x0304;
	public static inline var ONE_MINUS_DST_ALPHA = 0x0305;
	public static inline var DST_COLOR = 0x0306;
	public static inline var ONE_MINUS_DST_COLOR = 0x0307;
	public static inline var SRC_ALPHA_SATURATE = 0x0308;
	public static inline var FUNC_ADD = 0x8006;
	public static inline var BLEND_EQUATION = 0x8009;
	public static inline var BLEND_EQUATION_RGB = 0x8009;
	public static inline var BLEND_EQUATION_ALPHA = 0x883D;
	public static inline var FUNC_SUBTRACT = 0x800A;
	public static inline var FUNC_REVERSE_SUBTRACT = 0x800B;
	public static inline var BLEND_DST_RGB = 0x80C8;
	public static inline var BLEND_SRC_RGB = 0x80C9;
	public static inline var BLEND_DST_ALPHA = 0x80CA;
	public static inline var BLEND_SRC_ALPHA = 0x80CB;
	public static inline var CONSTANT_COLOR = 0x8001;
	public static inline var ONE_MINUS_CONSTANT_COLOR = 0x8002;
	public static inline var CONSTANT_ALPHA = 0x8003;
	public static inline var ONE_MINUS_CONSTANT_ALPHA = 0x8004;
	public static inline var BLEND_COLOR = 0x8005;
	public static inline var ARRAY_BUFFER = 0x8892;
	public static inline var ELEMENT_ARRAY_BUFFER = 0x8893;
	public static inline var ARRAY_BUFFER_BINDING = 0x8894;
	public static inline var ELEMENT_ARRAY_BUFFER_BINDING = 0x8895;
	public static inline var STREAM_DRAW = 0x88E0;
	public static inline var STATIC_DRAW = 0x88E4;
	public static inline var DYNAMIC_DRAW = 0x88E8;
	public static inline var BUFFER_SIZE = 0x8764;
	public static inline var BUFFER_USAGE = 0x8765;
	public static inline var CURRENT_VERTEX_ATTRIB = 0x8626;
	public static inline var FRONT = 0x0404;
	public static inline var BACK = 0x0405;
	public static inline var FRONT_AND_BACK = 0x0408;
	public static inline var CULL_FACE = 0x0B44;
	public static inline var BLEND = 0x0BE2;
	public static inline var DITHER = 0x0BD0;
	public static inline var STENCIL_TEST = 0x0B90;
	public static inline var DEPTH_TEST = 0x0B71;
	public static inline var SCISSOR_TEST = 0x0C11;
	public static inline var POLYGON_OFFSET_FILL = 0x8037;
	public static inline var SAMPLE_ALPHA_TO_COVERAGE = 0x809E;
	public static inline var SAMPLE_COVERAGE = 0x80A0;
	public static inline var NO_ERROR = 0;
	public static inline var INVALID_ENUM = 0x0500;
	public static inline var INVALID_VALUE = 0x0501;
	public static inline var INVALID_OPERATION = 0x0502;
	public static inline var OUT_OF_MEMORY = 0x0505;
	public static inline var CW = 0x0900;
	public static inline var CCW = 0x0901;
	public static inline var LINE_WIDTH = 0x0B21;
	public static inline var ALIASED_POINT_SIZE_RANGE = 0x846D;
	public static inline var ALIASED_LINE_WIDTH_RANGE = 0x846E;
	public static inline var CULL_FACE_MODE = 0x0B45;
	public static inline var FRONT_FACE = 0x0B46;
	public static inline var DEPTH_RANGE = 0x0B70;
	public static inline var DEPTH_WRITEMASK = 0x0B72;
	public static inline var DEPTH_CLEAR_VALUE = 0x0B73;
	public static inline var DEPTH_FUNC = 0x0B74;
	public static inline var STENCIL_CLEAR_VALUE = 0x0B91;
	public static inline var STENCIL_FUNC = 0x0B92;
	public static inline var STENCIL_FAIL = 0x0B94;
	public static inline var STENCIL_PASS_DEPTH_FAIL = 0x0B95;
	public static inline var STENCIL_PASS_DEPTH_PASS = 0x0B96;
	public static inline var STENCIL_REF = 0x0B97;
	public static inline var STENCIL_VALUE_MASK = 0x0B93;
	public static inline var STENCIL_WRITEMASK = 0x0B98;
	public static inline var STENCIL_BACK_FUNC = 0x8800;
	public static inline var STENCIL_BACK_FAIL = 0x8801;
	public static inline var STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;
	public static inline var STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;
	public static inline var STENCIL_BACK_REF = 0x8CA3;
	public static inline var STENCIL_BACK_VALUE_MASK = 0x8CA4;
	public static inline var STENCIL_BACK_WRITEMASK = 0x8CA5;
	public static inline var VIEWPORT = 0x0BA2;
	public static inline var SCISSOR_BOX = 0x0C10;
	public static inline var COLOR_CLEAR_VALUE = 0x0C22;
	public static inline var COLOR_WRITEMASK = 0x0C23;
	public static inline var UNPACK_ALIGNMENT = 0x0CF5;
	public static inline var PACK_ALIGNMENT = 0x0D05;
	public static inline var MAX_TEXTURE_SIZE = 0x0D33;
	public static inline var MAX_VIEWPORT_DIMS = 0x0D3A;
	public static inline var SUBPIXEL_BITS = 0x0D50;
	public static inline var RED_BITS = 0x0D52;
	public static inline var GREEN_BITS = 0x0D53;
	public static inline var BLUE_BITS = 0x0D54;
	public static inline var ALPHA_BITS = 0x0D55;
	public static inline var DEPTH_BITS = 0x0D56;
	public static inline var STENCIL_BITS = 0x0D57;
	public static inline var POLYGON_OFFSET_UNITS = 0x2A00;
	public static inline var POLYGON_OFFSET_FACTOR = 0x8038;
	public static inline var TEXTURE_BINDING_2D = 0x8069;
	public static inline var SAMPLE_BUFFERS = 0x80A8;
	public static inline var SAMPLES = 0x80A9;
	public static inline var SAMPLE_COVERAGE_VALUE = 0x80AA;
	public static inline var SAMPLE_COVERAGE_INVERT = 0x80AB;
	public static inline var NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
	public static inline var COMPRESSED_TEXTURE_FORMATS = 0x86A3;
	public static inline var DONT_CARE = 0x1100;
	public static inline var FASTEST = 0x1101;
	public static inline var NICEST = 0x1102;
	public static inline var GENERATE_MIPMAP_HINT = 0x8192;
	public static inline var BYTE = 0x1400;
	public static inline var UNSIGNED_BYTE = 0x1401;
	public static inline var SHORT = 0x1402;
	public static inline var UNSIGNED_SHORT = 0x1403;
	public static inline var INT = 0x1404;
	public static inline var UNSIGNED_INT = 0x1405;
	public static inline var FLOAT = 0x1406;
	public static inline var DEPTH_COMPONENT = 0x1902;
	public static inline var ALPHA = 0x1906;
	public static inline var RGB = 0x1907;
	public static inline var RGBA = 0x1908;
	public static inline var LUMINANCE = 0x1909;
	public static inline var LUMINANCE_ALPHA = 0x190A;
	public static inline var UNSIGNED_SHORT_4_4_4_4 = 0x8033;
	public static inline var UNSIGNED_SHORT_5_5_5_1 = 0x8034;
	public static inline var UNSIGNED_SHORT_5_6_5 = 0x8363;
	public static inline var FRAGMENT_SHADER = 0x8B30;
	public static inline var VERTEX_SHADER = 0x8B31;
	public static inline var MAX_VERTEX_ATTRIBS = 0x8869;
	public static inline var MAX_VERTEX_UNIFORM_VECTORS = 0x8DFB;
	public static inline var MAX_VARYING_VECTORS = 0x8DFC;
	public static inline var MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
	public static inline var MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;
	public static inline var MAX_TEXTURE_IMAGE_UNITS = 0x8872;
	public static inline var MAX_FRAGMENT_UNIFORM_VECTORS = 0x8DFD;
	public static inline var SHADER_TYPE = 0x8B4F;
	public static inline var DELETE_STATUS = 0x8B80;
	public static inline var LINK_STATUS = 0x8B82;
	public static inline var VALIDATE_STATUS = 0x8B83;
	public static inline var ATTACHED_SHADERS = 0x8B85;
	public static inline var ACTIVE_UNIFORMS = 0x8B86;
	public static inline var ACTIVE_ATTRIBUTES = 0x8B89;
	public static inline var SHADING_LANGUAGE_VERSION = 0x8B8C;
	public static inline var CURRENT_PROGRAM = 0x8B8D;
	public static inline var NEVER = 0x0200;
	public static inline var LESS = 0x0201;
	public static inline var EQUAL = 0x0202;
	public static inline var LEQUAL = 0x0203;
	public static inline var GREATER = 0x0204;
	public static inline var NOTEQUAL = 0x0205;
	public static inline var GEQUAL = 0x0206;
	public static inline var ALWAYS = 0x0207;
	public static inline var KEEP = 0x1E00;
	public static inline var REPLACE = 0x1E01;
	public static inline var INCR = 0x1E02;
	public static inline var DECR = 0x1E03;
	public static inline var INVERT = 0x150A;
	public static inline var INCR_WRAP = 0x8507;
	public static inline var DECR_WRAP = 0x8508;
	public static inline var VENDOR = 0x1F00;
	public static inline var RENDERER = 0x1F01;
	public static inline var VERSION = 0x1F02;
	public static inline var EXTENSIONS = 0x1F03;
	public static inline var NEAREST = 0x2600;
	public static inline var LINEAR = 0x2601;
	public static inline var NEAREST_MIPMAP_NEAREST = 0x2700;
	public static inline var LINEAR_MIPMAP_NEAREST = 0x2701;
	public static inline var NEAREST_MIPMAP_LINEAR = 0x2702;
	public static inline var LINEAR_MIPMAP_LINEAR = 0x2703;
	public static inline var TEXTURE_MAG_FILTER = 0x2800;
	public static inline var TEXTURE_MIN_FILTER = 0x2801;
	public static inline var TEXTURE_WRAP_S = 0x2802;
	public static inline var TEXTURE_WRAP_T = 0x2803;
	public static inline var TEXTURE_2D = 0x0DE1;
	public static inline var TEXTURE = 0x1702;
	public static inline var TEXTURE_CUBE_MAP = 0x8513;
	public static inline var TEXTURE_BINDING_CUBE_MAP = 0x8514;
	public static inline var TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;
	public static inline var TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;
	public static inline var TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;
	public static inline var TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;
	public static inline var TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;
	public static inline var TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;
	public static inline var MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;
	public static inline var TEXTURE0 = 0x84C0;
	public static inline var TEXTURE1 = 0x84C1;
	public static inline var TEXTURE2 = 0x84C2;
	public static inline var TEXTURE3 = 0x84C3;
	public static inline var TEXTURE4 = 0x84C4;
	public static inline var TEXTURE5 = 0x84C5;
	public static inline var TEXTURE6 = 0x84C6;
	public static inline var TEXTURE7 = 0x84C7;
	public static inline var TEXTURE8 = 0x84C8;
	public static inline var TEXTURE9 = 0x84C9;
	public static inline var TEXTURE10 = 0x84CA;
	public static inline var TEXTURE11 = 0x84CB;
	public static inline var TEXTURE12 = 0x84CC;
	public static inline var TEXTURE13 = 0x84CD;
	public static inline var TEXTURE14 = 0x84CE;
	public static inline var TEXTURE15 = 0x84CF;
	public static inline var TEXTURE16 = 0x84D0;
	public static inline var TEXTURE17 = 0x84D1;
	public static inline var TEXTURE18 = 0x84D2;
	public static inline var TEXTURE19 = 0x84D3;
	public static inline var TEXTURE20 = 0x84D4;
	public static inline var TEXTURE21 = 0x84D5;
	public static inline var TEXTURE22 = 0x84D6;
	public static inline var TEXTURE23 = 0x84D7;
	public static inline var TEXTURE24 = 0x84D8;
	public static inline var TEXTURE25 = 0x84D9;
	public static inline var TEXTURE26 = 0x84DA;
	public static inline var TEXTURE27 = 0x84DB;
	public static inline var TEXTURE28 = 0x84DC;
	public static inline var TEXTURE29 = 0x84DD;
	public static inline var TEXTURE30 = 0x84DE;
	public static inline var TEXTURE31 = 0x84DF;
	public static inline var ACTIVE_TEXTURE = 0x84E0;
	public static inline var REPEAT = 0x2901;
	public static inline var CLAMP_TO_EDGE = 0x812F;
	public static inline var MIRRORED_REPEAT = 0x8370;
	public static inline var FLOAT_VEC2 = 0x8B50;
	public static inline var FLOAT_VEC3 = 0x8B51;
	public static inline var FLOAT_VEC4 = 0x8B52;
	public static inline var INT_VEC2 = 0x8B53;
	public static inline var INT_VEC3 = 0x8B54;
	public static inline var INT_VEC4 = 0x8B55;
	public static inline var BOOL = 0x8B56;
	public static inline var BOOL_VEC2 = 0x8B57;
	public static inline var BOOL_VEC3 = 0x8B58;
	public static inline var BOOL_VEC4 = 0x8B59;
	public static inline var FLOAT_MAT2 = 0x8B5A;
	public static inline var FLOAT_MAT3 = 0x8B5B;
	public static inline var FLOAT_MAT4 = 0x8B5C;
	public static inline var SAMPLER_2D = 0x8B5E;
	public static inline var SAMPLER_CUBE = 0x8B60;
	public static inline var VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;
	public static inline var VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;
	public static inline var VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;
	public static inline var VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;
	public static inline var VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;
	public static inline var VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;
	public static inline var VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
	public static inline var IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A;
	public static inline var IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;
	public static inline var VERTEX_PROGRAM_POINT_SIZE = 0x8642;
	public static inline var POINT_SPRITE = 0x8861;
	public static inline var COMPILE_STATUS = 0x8B81;
	public static inline var LOW_FLOAT = 0x8DF0;
	public static inline var MEDIUM_FLOAT = 0x8DF1;
	public static inline var HIGH_FLOAT = 0x8DF2;
	public static inline var LOW_INT = 0x8DF3;
	public static inline var MEDIUM_INT = 0x8DF4;
	public static inline var HIGH_INT = 0x8DF5;
	public static inline var FRAMEBUFFER = 0x8D40;
	public static inline var RENDERBUFFER = 0x8D41;
	public static inline var RGBA4 = 0x8056;
	public static inline var RGB5_A1 = 0x8057;
	public static inline var RGB565 = 0x8D62;
	public static inline var DEPTH_COMPONENT16 = 0x81A5;
	public static inline var STENCIL_INDEX = 0x1901;
	public static inline var STENCIL_INDEX8 = 0x8D48;
	public static inline var DEPTH_STENCIL = 0x84F9;
	public static inline var RENDERBUFFER_WIDTH = 0x8D42;
	public static inline var RENDERBUFFER_HEIGHT = 0x8D43;
	public static inline var RENDERBUFFER_INTERNAL_FORMAT = 0x8D44;
	public static inline var RENDERBUFFER_RED_SIZE = 0x8D50;
	public static inline var RENDERBUFFER_GREEN_SIZE = 0x8D51;
	public static inline var RENDERBUFFER_BLUE_SIZE = 0x8D52;
	public static inline var RENDERBUFFER_ALPHA_SIZE = 0x8D53;
	public static inline var RENDERBUFFER_DEPTH_SIZE = 0x8D54;
	public static inline var RENDERBUFFER_STENCIL_SIZE = 0x8D55;
	public static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
	public static inline var FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
	public static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;
	public static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
	public static inline var COLOR_ATTACHMENT0 = 0x8CE0;
	public static inline var DEPTH_ATTACHMENT = 0x8D00;
	public static inline var STENCIL_ATTACHMENT = 0x8D20;
	public static inline var DEPTH_STENCIL_ATTACHMENT = 0x821A;
	public static inline var NONE = 0;
	public static inline var FRAMEBUFFER_COMPLETE = 0x8CD5;
	public static inline var FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
	public static inline var FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
	public static inline var FRAMEBUFFER_INCOMPLETE_DIMENSIONS = 0x8CD9;
	public static inline var FRAMEBUFFER_UNSUPPORTED = 0x8CDD;
	public static inline var FRAMEBUFFER_BINDING = 0x8CA6;
	public static inline var RENDERBUFFER_BINDING = 0x8CA7;
	public static inline var MAX_RENDERBUFFER_SIZE = 0x84E8;
	public static inline var INVALID_FRAMEBUFFER_OPERATION = 0x0506;
	public static inline var UNPACK_FLIP_Y_WEBGL = 0x9240;
	public static inline var UNPACK_PREMULTIPLY_ALPHA_WEBGL = 0x9241;
	public static inline var CONTEXT_LOST_WEBGL = 0x9242;
	public static inline var UNPACK_COLORSPACE_CONVERSION_WEBGL = 0x9243;
	public static inline var BROWSER_DEFAULT_WEBGL = 0x9244;
	public static inline var READ_BUFFER = 0x0C02;
	public static inline var UNPACK_ROW_LENGTH = 0x0CF2;
	public static inline var UNPACK_SKIP_ROWS = 0x0CF3;
	public static inline var UNPACK_SKIP_PIXELS = 0x0CF4;
	public static inline var PACK_ROW_LENGTH = 0x0D02;
	public static inline var PACK_SKIP_ROWS = 0x0D03;
	public static inline var PACK_SKIP_PIXELS = 0x0D04;
	public static inline var TEXTURE_BINDING_3D = 0x806A;
	public static inline var UNPACK_SKIP_IMAGES = 0x806D;
	public static inline var UNPACK_IMAGE_HEIGHT = 0x806E;
	public static inline var MAX_3D_TEXTURE_SIZE = 0x8073;
	public static inline var MAX_ELEMENTS_VERTICES = 0x80E8;
	public static inline var MAX_ELEMENTS_INDICES = 0x80E9;
	public static inline var MAX_TEXTURE_LOD_BIAS = 0x84FD;
	public static inline var MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
	public static inline var MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;
	public static inline var MAX_ARRAY_TEXTURE_LAYERS = 0x88FF;
	public static inline var MIN_PROGRAM_TEXEL_OFFSET = 0x8904;
	public static inline var MAX_PROGRAM_TEXEL_OFFSET = 0x8905;
	public static inline var MAX_VARYING_COMPONENTS = 0x8B4B;
	public static inline var FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;
	public static inline var RASTERIZER_DISCARD = 0x8C89;
	public static inline var VERTEX_ARRAY_BINDING = 0x85B5;
	public static inline var MAX_VERTEX_OUTPUT_COMPONENTS = 0x9122;
	public static inline var MAX_FRAGMENT_INPUT_COMPONENTS = 0x9125;
	public static inline var MAX_SERVER_WAIT_TIMEOUT = 0x9111;
	public static inline var MAX_ELEMENT_INDEX = 0x8D6B;
	public static inline var RED = 0x1903;
	public static inline var RGB8 = 0x8051;
	public static inline var RGBA8 = 0x8058;
	public static inline var RGB10_A2 = 0x8059;
	public static inline var TEXTURE_3D = 0x806F;
	public static inline var TEXTURE_WRAP_R = 0x8072;
	public static inline var TEXTURE_MIN_LOD = 0x813A;
	public static inline var TEXTURE_MAX_LOD = 0x813B;
	public static inline var TEXTURE_BASE_LEVEL = 0x813C;
	public static inline var TEXTURE_MAX_LEVEL = 0x813D;
	public static inline var TEXTURE_COMPARE_MODE = 0x884C;
	public static inline var TEXTURE_COMPARE_FUNC = 0x884D;
	public static inline var SRGB = 0x8C40;
	public static inline var SRGB8 = 0x8C41;
	public static inline var SRGB8_ALPHA8 = 0x8C43;
	public static inline var COMPARE_REF_TO_TEXTURE = 0x884E;
	public static inline var RGBA32F = 0x8814;
	public static inline var RGB32F = 0x8815;
	public static inline var RGBA16F = 0x881A;
	public static inline var RGB16F = 0x881B;
	public static inline var TEXTURE_2D_ARRAY = 0x8C1A;
	public static inline var TEXTURE_BINDING_2D_ARRAY = 0x8C1D;
	public static inline var R11F_G11F_B10F = 0x8C3A;
	public static inline var RGB9_E5 = 0x8C3D;
	public static inline var RGBA32UI = 0x8D70;
	public static inline var RGB32UI = 0x8D71;
	public static inline var RGBA16UI = 0x8D76;
	public static inline var RGB16UI = 0x8D77;
	public static inline var RGBA8UI = 0x8D7C;
	public static inline var RGB8UI = 0x8D7D;
	public static inline var RGBA32I = 0x8D82;
	public static inline var RGB32I = 0x8D83;
	public static inline var RGBA16I = 0x8D88;
	public static inline var RGB16I = 0x8D89;
	public static inline var RGBA8I = 0x8D8E;
	public static inline var RGB8I = 0x8D8F;
	public static inline var RED_INTEGER = 0x8D94;
	public static inline var RGB_INTEGER = 0x8D98;
	public static inline var RGBA_INTEGER = 0x8D99;
	public static inline var R8 = 0x8229;
	public static inline var RG8 = 0x822B;
	public static inline var R16F = 0x822D;
	public static inline var R32F = 0x822E;
	public static inline var RG16F = 0x822F;
	public static inline var RG32F = 0x8230;
	public static inline var R8I = 0x8231;
	public static inline var R8UI = 0x8232;
	public static inline var R16I = 0x8233;
	public static inline var R16UI = 0x8234;
	public static inline var R32I = 0x8235;
	public static inline var R32UI = 0x8236;
	public static inline var RG8I = 0x8237;
	public static inline var RG8UI = 0x8238;
	public static inline var RG16I = 0x8239;
	public static inline var RG16UI = 0x823A;
	public static inline var RG32I = 0x823B;
	public static inline var RG32UI = 0x823C;
	public static inline var R8_SNORM = 0x8F94;
	public static inline var RG8_SNORM = 0x8F95;
	public static inline var RGB8_SNORM = 0x8F96;
	public static inline var RGBA8_SNORM = 0x8F97;
	public static inline var RGB10_A2UI = 0x906F;
	public static inline var TEXTURE_IMMUTABLE_FORMAT = 0x912F;
	public static inline var TEXTURE_IMMUTABLE_LEVELS = 0x82DF;
	public static inline var UNSIGNED_INT_2_10_10_10_REV = 0x8368;
	public static inline var UNSIGNED_INT_10F_11F_11F_REV = 0x8C3B;
	public static inline var UNSIGNED_INT_5_9_9_9_REV = 0x8C3E;
	public static inline var FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD;
	public static inline var UNSIGNED_INT_24_8 = 0x84FA;
	public static inline var HALF_FLOAT = 0x140B;
	public static inline var RG = 0x8227;
	public static inline var RG_INTEGER = 0x8228;
	public static inline var INT_2_10_10_10_REV = 0x8D9F;
	public static inline var CURRENT_QUERY = 0x8865;
	public static inline var QUERY_RESULT = 0x8866;
	public static inline var QUERY_RESULT_AVAILABLE = 0x8867;
	public static inline var ANY_SAMPLES_PASSED = 0x8C2F;
	public static inline var ANY_SAMPLES_PASSED_CONSERVATIVE = 0x8D6A;
	public static inline var MAX_DRAW_BUFFERS = 0x8824;
	public static inline var DRAW_BUFFER0 = 0x8825;
	public static inline var DRAW_BUFFER1 = 0x8826;
	public static inline var DRAW_BUFFER2 = 0x8827;
	public static inline var DRAW_BUFFER3 = 0x8828;
	public static inline var DRAW_BUFFER4 = 0x8829;
	public static inline var DRAW_BUFFER5 = 0x882A;
	public static inline var DRAW_BUFFER6 = 0x882B;
	public static inline var DRAW_BUFFER7 = 0x882C;
	public static inline var DRAW_BUFFER8 = 0x882D;
	public static inline var DRAW_BUFFER9 = 0x882E;
	public static inline var DRAW_BUFFER10 = 0x882F;
	public static inline var DRAW_BUFFER11 = 0x8830;
	public static inline var DRAW_BUFFER12 = 0x8831;
	public static inline var DRAW_BUFFER13 = 0x8832;
	public static inline var DRAW_BUFFER14 = 0x8833;
	public static inline var DRAW_BUFFER15 = 0x8834;
	public static inline var MAX_COLOR_ATTACHMENTS = 0x8CDF;
	public static inline var COLOR_ATTACHMENT1 = 0x8CE1;
	public static inline var COLOR_ATTACHMENT2 = 0x8CE2;
	public static inline var COLOR_ATTACHMENT3 = 0x8CE3;
	public static inline var COLOR_ATTACHMENT4 = 0x8CE4;
	public static inline var COLOR_ATTACHMENT5 = 0x8CE5;
	public static inline var COLOR_ATTACHMENT6 = 0x8CE6;
	public static inline var COLOR_ATTACHMENT7 = 0x8CE7;
	public static inline var COLOR_ATTACHMENT8 = 0x8CE8;
	public static inline var COLOR_ATTACHMENT9 = 0x8CE9;
	public static inline var COLOR_ATTACHMENT10 = 0x8CEA;
	public static inline var COLOR_ATTACHMENT11 = 0x8CEB;
	public static inline var COLOR_ATTACHMENT12 = 0x8CEC;
	public static inline var COLOR_ATTACHMENT13 = 0x8CED;
	public static inline var COLOR_ATTACHMENT14 = 0x8CEE;
	public static inline var COLOR_ATTACHMENT15 = 0x8CEF;
	public static inline var SAMPLER_3D = 0x8B5F;
	public static inline var SAMPLER_2D_SHADOW = 0x8B62;
	public static inline var SAMPLER_2D_ARRAY = 0x8DC1;
	public static inline var SAMPLER_2D_ARRAY_SHADOW = 0x8DC4;
	public static inline var SAMPLER_CUBE_SHADOW = 0x8DC5;
	public static inline var INT_SAMPLER_2D = 0x8DCA;
	public static inline var INT_SAMPLER_3D = 0x8DCB;
	public static inline var INT_SAMPLER_CUBE = 0x8DCC;
	public static inline var INT_SAMPLER_2D_ARRAY = 0x8DCF;
	public static inline var UNSIGNED_INT_SAMPLER_2D = 0x8DD2;
	public static inline var UNSIGNED_INT_SAMPLER_3D = 0x8DD3;
	public static inline var UNSIGNED_INT_SAMPLER_CUBE = 0x8DD4;
	public static inline var UNSIGNED_INT_SAMPLER_2D_ARRAY = 0x8DD7;
	public static inline var MAX_SAMPLES = 0x8D57;
	public static inline var SAMPLER_BINDING = 0x8919;
	public static inline var PIXEL_PACK_BUFFER = 0x88EB;
	public static inline var PIXEL_UNPACK_BUFFER = 0x88EC;
	public static inline var PIXEL_PACK_BUFFER_BINDING = 0x88ED;
	public static inline var PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
	public static inline var COPY_READ_BUFFER = 0x8F36;
	public static inline var COPY_WRITE_BUFFER = 0x8F37;
	public static inline var COPY_READ_BUFFER_BINDING = 0x8F36;
	public static inline var COPY_WRITE_BUFFER_BINDING = 0x8F37;
	public static inline var FLOAT_MAT2x3 = 0x8B65;
	public static inline var FLOAT_MAT2x4 = 0x8B66;
	public static inline var FLOAT_MAT3x2 = 0x8B67;
	public static inline var FLOAT_MAT3x4 = 0x8B68;
	public static inline var FLOAT_MAT4x2 = 0x8B69;
	public static inline var FLOAT_MAT4x3 = 0x8B6A;
	public static inline var UNSIGNED_INT_VEC2 = 0x8DC6;
	public static inline var UNSIGNED_INT_VEC3 = 0x8DC7;
	public static inline var UNSIGNED_INT_VEC4 = 0x8DC8;
	public static inline var UNSIGNED_NORMALIZED = 0x8C17;
	public static inline var SIGNED_NORMALIZED = 0x8F9C;
	public static inline var VERTEX_ATTRIB_ARRAY_INTEGER = 0x88FD;
	public static inline var VERTEX_ATTRIB_ARRAY_DIVISOR = 0x88FE;
	public static inline var TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F;
	public static inline var MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80;
	public static inline var TRANSFORM_FEEDBACK_VARYINGS = 0x8C83;
	public static inline var TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84;
	public static inline var TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85;
	public static inline var TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88;
	public static inline var MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A;
	public static inline var MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B;
	public static inline var INTERLEAVED_ATTRIBS = 0x8C8C;
	public static inline var SEPARATE_ATTRIBS = 0x8C8D;
	public static inline var TRANSFORM_FEEDBACK_BUFFER = 0x8C8E;
	public static inline var TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F;
	public static inline var TRANSFORM_FEEDBACK = 0x8E22;
	public static inline var TRANSFORM_FEEDBACK_PAUSED = 0x8E23;
	public static inline var TRANSFORM_FEEDBACK_ACTIVE = 0x8E24;
	public static inline var TRANSFORM_FEEDBACK_BINDING = 0x8E25;
	public static inline var FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;
	public static inline var FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;
	public static inline var FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;
	public static inline var FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;
	public static inline var FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;
	public static inline var FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;
	public static inline var FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;
	public static inline var FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;
	public static inline var FRAMEBUFFER_DEFAULT = 0x8218;
	public static inline var DEPTH24_STENCIL8 = 0x88F0;
	public static inline var DRAW_FRAMEBUFFER_BINDING = 0x8CA6;
	public static inline var READ_FRAMEBUFFER = 0x8CA8;
	public static inline var DRAW_FRAMEBUFFER = 0x8CA9;
	public static inline var READ_FRAMEBUFFER_BINDING = 0x8CAA;
	public static inline var RENDERBUFFER_SAMPLES = 0x8CAB;
	public static inline var FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;
	public static inline var FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;
	public static inline var UNIFORM_BUFFER = 0x8A11;
	public static inline var UNIFORM_BUFFER_BINDING = 0x8A28;
	public static inline var UNIFORM_BUFFER_START = 0x8A29;
	public static inline var UNIFORM_BUFFER_SIZE = 0x8A2A;
	public static inline var MAX_VERTEX_UNIFORM_BLOCKS = 0x8A2B;
	public static inline var MAX_FRAGMENT_UNIFORM_BLOCKS = 0x8A2D;
	public static inline var MAX_COMBINED_UNIFORM_BLOCKS = 0x8A2E;
	public static inline var MAX_UNIFORM_BUFFER_BINDINGS = 0x8A2F;
	public static inline var MAX_UNIFORM_BLOCK_SIZE = 0x8A30;
	public static inline var MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;
	public static inline var MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;
	public static inline var UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;
	public static inline var ACTIVE_UNIFORM_BLOCKS = 0x8A36;
	public static inline var UNIFORM_TYPE = 0x8A37;
	public static inline var UNIFORM_SIZE = 0x8A38;
	public static inline var UNIFORM_BLOCK_INDEX = 0x8A3A;
	public static inline var UNIFORM_OFFSET = 0x8A3B;
	public static inline var UNIFORM_ARRAY_STRIDE = 0x8A3C;
	public static inline var UNIFORM_MATRIX_STRIDE = 0x8A3D;
	public static inline var UNIFORM_IS_ROW_MAJOR = 0x8A3E;
	public static inline var UNIFORM_BLOCK_BINDING = 0x8A3F;
	public static inline var UNIFORM_BLOCK_DATA_SIZE = 0x8A40;
	public static inline var UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42;
	public static inline var UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;
	public static inline var UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;
	public static inline var UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
	public static inline var OBJECT_TYPE = 0x9112;
	public static inline var SYNC_CONDITION = 0x9113;
	public static inline var SYNC_STATUS = 0x9114;
	public static inline var SYNC_FLAGS = 0x9115;
	public static inline var SYNC_FENCE = 0x9116;
	public static inline var SYNC_GPU_COMMANDS_COMPLETE = 0x9117;
	public static inline var UNSIGNALED = 0x9118;
	public static inline var SIGNALED = 0x9119;
	public static inline var ALREADY_SIGNALED = 0x911A;
	public static inline var TIMEOUT_EXPIRED = 0x911B;
	public static inline var CONDITION_SATISFIED = 0x911C;
	public static inline var WAIT_FAILED = 0x911D;
	public static inline var SYNC_FLUSH_COMMANDS_BIT = 0x00000001;
	public static inline var COLOR = 0x1800;
	public static inline var DEPTH = 0x1801;
	public static inline var STENCIL = 0x1802;
	public static inline var MIN = 0x8007;
	public static inline var MAX = 0x8008;
	public static inline var DEPTH_COMPONENT24 = 0x81A6;
	public static inline var STREAM_READ = 0x88E1;
	public static inline var STREAM_COPY = 0x88E2;
	public static inline var STATIC_READ = 0x88E5;
	public static inline var STATIC_COPY = 0x88E6;
	public static inline var DYNAMIC_READ = 0x88E9;
	public static inline var DYNAMIC_COPY = 0x88EA;
	public static inline var DEPTH_COMPONENT32F = 0x8CAC;
	public static inline var DEPTH32F_STENCIL8 = 0x8CAD;
	public static inline var INVALID_INDEX = 0xFFFFFFFF;
	public static inline var TIMEOUT_IGNORED = -1;
	public static inline var MAX_CLIENT_WAIT_TIMEOUT_WEBGL = 0x9247;
	public static var context(default, null):WebGL2RenderContext;
	public static var type(default, null):RenderContextType;
	public static var version(default, null):Float;

	public static inline function activeTexture(texture:Int):Void
	{
		context.activeTexture(texture);
	}

	public static inline function attachShader(program:GLProgram, shader:GLShader):Void
	{
		context.attachShader(program, shader);
	}

	public static inline function beginQuery(target:Int, query:GLQuery):Void
	{
		context.beginQuery(target, query);
	}

	public static inline function beginTransformFeedback(primitiveNode:Int):Void
	{
		context.beginTransformFeedback(primitiveNode);
	}

	public static inline function bindAttribLocation(program:GLProgram, index:Int, name:String):Void
	{
		context.bindAttribLocation(program, index, name);
	}

	public static inline function bindBuffer(target:Int, buffer:GLBuffer):Void
	{
		context.bindBuffer(target, buffer);
	}

	public static inline function bindBufferBase(target:Int, index:Int, buffer:GLBuffer):Void
	{
		context.bindBufferBase(target, index, buffer);
	}

	public static inline function bindBufferRange(target:Int, index:Int, buffer:GLBuffer, offset:DataPointer, size:Int):Void
	{
		context.bindBufferRange(target, index, buffer, offset, size);
	}

	public static inline function bindFramebuffer(target:Int, framebuffer:GLFramebuffer):Void
	{
		context.bindFramebuffer(target, framebuffer);
	}

	public static inline function bindRenderbuffer(target:Int, renderbuffer:GLRenderbuffer):Void
	{
		context.bindRenderbuffer(target, renderbuffer);
	}

	public static inline function bindSampler(unit:Int, sampler:GLSampler):Void
	{
		context.bindSampler(unit, sampler);
	}

	public static inline function bindTexture(target:Int, texture:GLTexture):Void
	{
		context.bindTexture(target, texture);
	}

	public static inline function bindTransformFeedback(target:Int, transformFeedback:GLTransformFeedback):Void
	{
		context.bindTransformFeedback(target, transformFeedback);
	}

	public static inline function bindVertexArray(vertexArray:GLVertexArrayObject):Void
	{
		context.bindVertexArray(vertexArray);
	}

	public static inline function blitFramebuffer(srcX0:Int, srcY0:Int, srcX1:Int, srcY1:Int, dstX0:Int, dstY0:Int, dstX1:Int, dstY1:Int, mask:Int,
			filter:Int):Void
	{
		context.blitFramebuffer(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
	}

	public static inline function blendColor(red:Float, green:Float, blue:Float, alpha:Float):Void
	{
		context.blendColor(red, green, blue, alpha);
	}

	public static inline function blendEquation(mode:Int):Void
	{
		context.blendEquation(mode);
	}

	public static inline function blendEquationSeparate(modeRGB:Int, modeAlpha:Int):Void
	{
		context.blendEquationSeparate(modeRGB, modeAlpha);
	}

	public static inline function blendFunc(sfactor:Int, dfactor:Int):Void
	{
		context.blendFunc(sfactor, dfactor);
	}

	public static inline function blendFuncSeparate(srcRGB:Int, dstRGB:Int, srcAlpha:Int, dstAlpha:Int):Void
	{
		context.blendFuncSeparate(srcRGB, dstRGB, srcAlpha, dstAlpha);
	}

	#if (lime_opengl || lime_opengles)
	public static inline function bufferData(target:Int, size:Int, srcData:DataPointer, usage:Int):Void
	{
		context.bufferData(target, size, srcData, usage);
	}
	#end

	public static inline function bufferDataWEBGL(target:Int, srcData:Dynamic, usage:Int, ?srcOffset:Int, ?length:Int):Void
	{
		context.bufferData(target, srcData, usage, srcOffset, length);
	}

	public static inline function bufferSubDataWEBGL(target:Int, dstByteOffset:Int, srcData:Dynamic, ?srcOffset:Int, ?length:Int):Void
	{
		context.bufferSubData(target, dstByteOffset, srcData, srcOffset, length);
	}

	public static inline function checkFramebufferStatus(target:Int):Int
	{
		return context.checkFramebufferStatus(target);
	}

	public static inline function clear(mask:Int):Void
	{
		context.clear(mask);
	}

	public static inline function clearBufferfi(buffer:Int, drawbuffer:Int, depth:Float, stencil:Int):Void
	{
		context.clearBufferfi(buffer, drawbuffer, depth, stencil);
	}

	public static inline function clearBufferfvWEBGL(buffer:Int, drawbuffer:Int, values:Dynamic, ?srcOffset:Int):Void
	{
		context.clearBufferfv(buffer, drawbuffer, values, srcOffset);
	}

	public static inline function clearBufferivWEBGL(buffer:Int, drawbuffer:Int, values:Dynamic, ?srcOffset:Int):Void
	{
		context.clearBufferiv(buffer, drawbuffer, values, srcOffset);
	}

	public static inline function clearBufferuivWEBGL(buffer:Int, drawbuffer:Int, values:Dynamic, ?srcOffset:Int):Void
	{
		context.clearBufferuiv(buffer, drawbuffer, values, srcOffset);
	}

	public static inline function clearColor(red:Float, green:Float, blue:Float, alpha:Float):Void
	{
		context.clearColor(red, green, blue, alpha);
	}

	public static inline function clearDepth(depth:Float):Void
	{
		context.clearDepth(depth);
	}

	public static inline function clearStencil(s:Int):Void
	{
		context.clearStencil(s);
	}

	public static inline function clientWaitSync(sync:GLSync, flags:Int, timeout:#if (!js || !html5 || doc_gen) Int64 #else Dynamic #end):Int
	{
		return context.clientWaitSync(sync, flags, timeout);
	}

	public static inline function colorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void
	{
		context.colorMask(red, green, blue, alpha);
	}

	public static inline function compileShader(shader:GLShader):Void
	{
		context.compileShader(shader);
	}

	public static inline function compressedTexImage2DWEBGL(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Int, srcData:Dynamic,
			?srcOffset:Int, ?srcLengthOverride:Int):Void
	{
		context.compressedTexImage2D(target, level, internalformat, width, height, border, srcData, srcOffset, srcLengthOverride);
	}

	public static inline function compressedTexImage3DWEBGL(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int,
			srcData:Dynamic, ?srcOffset:Int, ?srcLengthOverride:Int):Void
	{
		context.compressedTexImage3D(target, level, internalformat, width, height, depth, border, srcData, srcOffset, srcLengthOverride);
	}

	public static inline function compressedTexSubImage2DWEBGL(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Int,
			srcData:Dynamic, ?srcOffset:Int, ?srcLengthOverride:Int):Void
	{
		context.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData, srcOffset, srcLengthOverride);
	}

	public static inline function compressedTexSubImage3DWEBGL(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int,
			format:Int, srcData:Dynamic, ?srcOffset:Int, ?srcLengthOverride:Int):Void
	{
		context.compressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, srcData, srcOffset, srcLengthOverride);
	}

	public static inline function copyTexImage2D(target:Int, level:Int, internalformat:Int, x:Int, y:Int, width:Int, height:Int, border:Int):Void
	{
		context.copyTexImage2D(target, level, internalformat, x, y, width, height, border);
	}

	public static inline function copyTexSubImage2D(target:Int, level:Int, xoffset:Int, yoffset:Int, x:Int, y:Int, width:Int, height:Int):Void
	{
		context.copyTexSubImage2D(target, level, xoffset, yoffset, x, y, width, height);
	}

	public static inline function copyTexSubImage3D(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, x:Int, y:Int, width:Int, height:Int):Void
	{
		context.copyTexSubImage3D(target, level, xoffset, yoffset, zoffset, x, y, width, height);
	}

	public static inline function createBuffer():GLBuffer
	{
		return context.createBuffer();
	}

	public static inline function createFramebuffer():GLFramebuffer
	{
		return context.createFramebuffer();
	}

	public static inline function createProgram():GLProgram
	{
		return context.createProgram();
	}

	public static inline function createQuery():GLQuery
	{
		return context.createQuery();
	}

	public static inline function createRenderbuffer():GLRenderbuffer
	{
		return context.createRenderbuffer();
	}

	public static inline function createSampler():GLSampler
	{
		return context.createSampler();
	}

	public static inline function createShader(type:Int):GLShader
	{
		return context.createShader(type);
	}

	public static inline function createTexture():GLTexture
	{
		return context.createTexture();
	}

	public static inline function createTransformFeedback():GLTransformFeedback
	{
		return context.createTransformFeedback();
	}

	public static inline function createVertexArray():GLVertexArrayObject
	{
		return context.createVertexArray();
	}

	public static inline function cullFace(mode:Int):Void
	{
		context.cullFace(mode);
	}

	public static inline function deleteBuffer(buffer:GLBuffer):Void
	{
		context.deleteBuffer(buffer);
	}

	public static inline function deleteFramebuffer(framebuffer:GLFramebuffer):Void
	{
		context.deleteFramebuffer(framebuffer);
	}

	public static inline function deleteProgram(program:GLProgram):Void
	{
		context.deleteProgram(program);
	}

	public static inline function deleteQuery(query:GLQuery):Void
	{
		context.deleteQuery(query);
	}

	public static inline function deleteRenderbuffer(renderbuffer:GLRenderbuffer):Void
	{
		context.deleteRenderbuffer(renderbuffer);
	}

	public static inline function deleteSampler(sampler:GLSampler):Void
	{
		context.deleteSampler(sampler);
	}

	public static inline function deleteShader(shader:GLShader):Void
	{
		context.deleteShader(shader);
	}

	public static inline function deleteSync(sync:GLSync):Void
	{
		context.deleteSync(sync);
	}

	public static inline function deleteTexture(texture:GLTexture):Void
	{
		context.deleteTexture(texture);
	}

	public static inline function deleteTransformFeedback(transformFeedback:GLTransformFeedback):Void
	{
		context.deleteTransformFeedback(transformFeedback);
	}

	public static inline function deleteVertexArray(vertexArray:GLVertexArrayObject):Void
	{
		context.deleteVertexArray(vertexArray);
	}

	public static inline function depthFunc(func:Int):Void
	{
		context.depthFunc(func);
	}

	public static inline function depthMask(flag:Bool):Void
	{
		context.depthMask(flag);
	}

	public static inline function depthRange(zNear:Float, zFar:Float):Void
	{
		context.depthRange(zNear, zFar);
	}

	public static inline function detachShader(program:GLProgram, shader:GLShader):Void
	{
		context.detachShader(program, shader);
	}

	public static inline function disable(cap:Int):Void
	{
		context.disable(cap);
	}

	public static inline function disableVertexAttribArray(index:Int):Void
	{
		context.disableVertexAttribArray(index);
	}

	public static inline function drawArrays(mode:Int, first:Int, count:Int):Void
	{
		context.drawArrays(mode, first, count);
	}

	public static inline function drawArraysInstanced(mode:Int, first:Int, count:Int, instanceCount:Int):Void
	{
		context.drawArraysInstanced(mode, first, count, instanceCount);
	}

	public static inline function drawBuffers(buffers:Array<Int>):Void
	{
		context.drawBuffers(buffers);
	}

	public static inline function drawElements(mode:Int, count:Int, type:Int, offset:Int):Void
	{
		context.drawElements(mode, count, type, offset);
	}

	public static inline function drawElementsInstanced(mode:Int, count:Int, type:Int, offset:DataPointer, instanceCount:Int):Void
	{
		context.drawElementsInstanced(mode, count, type, offset, instanceCount);
	}

	public static inline function drawRangeElements(mode:Int, start:Int, end:Int, count:Int, type:Int, offset:DataPointer):Void
	{
		context.drawRangeElements(mode, start, end, count, type, offset);
	}

	public static inline function enable(cap:Int):Void
	{
		context.enable(cap);
	}

	public static inline function enableVertexAttribArray(index:Int):Void
	{
		context.enableVertexAttribArray(index);
	}

	public static inline function endQuery(target:Int):Void
	{
		context.endQuery(target);
	}

	public static inline function endTransformFeedback():Void
	{
		context.endTransformFeedback();
	}

	public static inline function fenceSync(condition:Int, flags:Int):GLSync
	{
		return context.fenceSync(condition, flags);
	}

	public static inline function finish():Void
	{
		context.finish();
	}

	public static inline function flush():Void
	{
		context.flush();
	}

	public static inline function framebufferRenderbuffer(target:Int, attachment:Int, renderbuffertarget:Int, renderbuffer:GLRenderbuffer):Void
	{
		context.framebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer);
	}

	public static inline function framebufferTexture2D(target:Int, attachment:Int, textarget:Int, texture:GLTexture, level:Int):Void
	{
		context.framebufferTexture2D(target, attachment, textarget, texture, level);
	}

	public static inline function framebufferTextureLayer(target:Int, attachment:Int, texture:GLTexture, level:Int, layer:Int):Void
	{
		context.framebufferTextureLayer(target, attachment, texture, level, layer);
	}

	public static inline function frontFace(mode:Int):Void
	{
		context.frontFace(mode);
	}

	public static inline function generateMipmap(target:Int):Void
	{
		context.generateMipmap(target);
	}

	public static inline function getActiveAttrib(program:GLProgram, index:Int):GLActiveInfo
	{
		return context.getActiveAttrib(program, index);
	}

	public static inline function getActiveUniform(program:GLProgram, index:Int):GLActiveInfo
	{
		return context.getActiveUniform(program, index);
	}

	public static inline function getActiveUniformBlockName(program:GLProgram, uniformBlockIndex:Int):String
	{
		return context.getActiveUniformBlockName(program, uniformBlockIndex);
	}

	public static inline function getActiveUniformBlockParameter(program:GLProgram, uniformBlockIndex:Int, pname:Int):Dynamic
	{
		return context.getActiveUniformBlockParameter(program, uniformBlockIndex, pname);
	}

	public static inline function getActiveUniforms(program:GLProgram, uniformIndices:Array<Int>, pname:Int):Dynamic
	{
		return context.getActiveUniforms(program, uniformIndices, pname);
	}

	public static inline function getAttachedShaders(program:GLProgram):Array<GLShader>
	{
		return context.getAttachedShaders(program);
	}

	public static inline function getAttribLocation(program:GLProgram, name:String):Int
	{
		return context.getAttribLocation(program, name);
	}

	public static inline function getBufferParameter(target:Int, pname:Int):Dynamic
	{
		return context.getBufferParameter(target, pname);
	}

	public static inline function getBufferSubDataWEBGL(target:Int, srcByteOffset:DataPointer, dstData:Dynamic, ?srcOffset:Dynamic, ?length:Int):Void
	{
		context.getBufferSubData(target, srcByteOffset, dstData, srcOffset, length);
	}

	public static inline function getContextAttributes():GLContextAttributes
	{
		return context.getContextAttributes();
	}

	public static inline function getError():Int
	{
		return context.getError();
	}

	public static inline function getExtension(name:String):Dynamic
	{
		return context.getExtension(name);
	}

	public static inline function getFragDataLocation(program:GLProgram, name:String):Int
	{
		return context.getFragDataLocation(program, name);
	}

	public static inline function getFramebufferAttachmentParameter(target:Int, attachment:Int, pname:Int):Dynamic
	{
		return context.getFramebufferAttachmentParameter(target, attachment, pname);
	}

	public static inline function getIndexedParameter(target:Int, index:Int):Dynamic
	{
		return context.getIndexedParameter(target, index);
	}

	public static inline function getInternalformatParameter(target:Int, internalformat:Int, pname:Int):Dynamic
	{
		return context.getInternalformatParameter(target, internalformat, pname);
	}

	public static inline function getParameter(pname:Int):Dynamic
	{
		return context.getParameter(pname);
	}

	public static inline function getProgramInfoLog(program:GLProgram):String
	{
		return context.getProgramInfoLog(program);
	}

	public static inline function getProgramParameter(program:GLProgram, pname:Int):Dynamic
	{
		return context.getProgramParameter(program, pname);
	}

	public static inline function getQuery(target:Int, pname:Int):GLQuery
	{
		return context.getQuery(target, pname);
	}

	public static inline function getQueryParameter(query:GLQuery, pname:Int):Dynamic
	{
		return context.getQueryParameter(query, pname);
	}

	public static inline function getRenderbufferParameter(target:Int, pname:Int):Dynamic
	{
		return context.getRenderbufferParameter(target, pname);
	}

	public static inline function getSamplerParameter(sampler:GLSampler, pname:Int):Dynamic
	{
		return context.getSamplerParameter(sampler, pname);
	}

	public static inline function getShaderInfoLog(shader:GLShader):String
	{
		return context.getShaderInfoLog(shader);
	}

	public static inline function getShaderParameter(shader:GLShader, pname:Int):Dynamic
	{
		return context.getShaderParameter(shader, pname);
	}

	public static inline function getShaderPrecisionFormat(shadertype:Int, precisiontype:Int):GLShaderPrecisionFormat
	{
		return context.getShaderPrecisionFormat(shadertype, precisiontype);
	}

	public static inline function getShaderSource(shader:GLShader):String
	{
		return context.getShaderSource(shader);
	}

	public static inline function getSupportedExtensions():Array<String>
	{
		return context.getSupportedExtensions();
	}

	public static inline function getSyncParameter(sync:GLSync, pname:Int):Dynamic
	{
		return context.getSyncParameter(sync, pname);
	}

	public static inline function getTexParameter(target:Int, pname:Int):Dynamic
	{
		return context.getTexParameter(target, pname);
	}

	public static inline function getTransformFeedbackVarying(program:GLProgram, index:Int):GLActiveInfo
	{
		return context.getTransformFeedbackVarying(program, index);
	}

	public static inline function getUniform(program:GLProgram, location:GLUniformLocation):Dynamic
	{
		return context.getUniform(program, location);
	}

	public static inline function getUniformBlockIndex(program:GLProgram, uniformBlockName:String):Int
	{
		return context.getUniformBlockIndex(program, uniformBlockName);
	}

	public static inline function getUniformIndices(program:GLProgram, uniformNames:Array<String>):Array<Int>
	{
		return context.getUniformIndices(program, uniformNames);
	}

	public static inline function getUniformLocation(program:GLProgram, name:String):GLUniformLocation
	{
		return context.getUniformLocation(program, name);
	}

	public static inline function getVertexAttrib(index:Int, pname:Int):Dynamic
	{
		return context.getVertexAttrib(index, pname);
	}

	public static inline function getVertexAttribOffset(index:Int, pname:Int):DataPointer
	{
		return context.getVertexAttribOffset(index, pname);
	}

	public static inline function hint(target:Int, mode:Int):Void
	{
		context.hint(target, mode);
	}

	public static inline function invalidateFramebuffer(target:Int, attachments:Array<Int>):Void
	{
		context.invalidateFramebuffer(target, attachments);
	}

	public static inline function invalidateSubFramebuffer(target:Int, attachments:Array<Int>, x:Int, y:Int, width:Int, height:Int):Void
	{
		context.invalidateSubFramebuffer(target, attachments, x, y, width, height);
	}

	public static inline function isBuffer(buffer:GLBuffer):Bool
	{
		return context.isBuffer(buffer);
	}

	public static inline function isContextLost():Bool
	{
		return context.isContextLost();
	}

	public static inline function isEnabled(cap:Int):Bool
	{
		return context.isEnabled(cap);
	}

	public static inline function isFramebuffer(framebuffer:GLFramebuffer):Bool
	{
		return context.isFramebuffer(framebuffer);
	}

	public static inline function isProgram(program:GLProgram):Bool
	{
		return context.isProgram(program);
	}

	public static inline function isQuery(query:GLQuery):Bool
	{
		return context.isQuery(query);
	}

	public static inline function isRenderbuffer(renderbuffer:GLRenderbuffer):Bool
	{
		return context.isRenderbuffer(renderbuffer);
	}

	public static inline function isSampler(sampler:GLSampler):Bool
	{
		return context.isSampler(sampler);
	}

	public static inline function isShader(shader:GLShader):Bool
	{
		return context.isShader(shader);
	}

	public static inline function isSync(sync:GLSync):Bool
	{
		return context.isSync(sync);
	}

	public static inline function isTexture(texture:GLTexture):Bool
	{
		return context.isTexture(texture);
	}

	public static inline function isTransformFeedback(transformFeedback:GLTransformFeedback):Bool
	{
		return context.isTransformFeedback(transformFeedback);
	}

	public static inline function isVertexArray(vertexArray:GLVertexArrayObject):Bool
	{
		return context.isVertexArray(vertexArray);
	}

	public static inline function lineWidth(width:Float):Void
	{
		context.lineWidth(width);
	}

	public static inline function linkProgram(program:GLProgram):Void
	{
		context.linkProgram(program);
	}

	public static inline function pauseTransformFeedback():Void
	{
		context.pauseTransformFeedback();
	}

	public static inline function pixelStorei(pname:Int, param:Int):Void
	{
		context.pixelStorei(pname, param);
	}

	public static inline function polygonOffset(factor:Float, units:Float):Void
	{
		context.polygonOffset(factor, units);
	}

	public static inline function readBuffer(src:Int):Void
	{
		context.readBuffer(src);
	}

	public static inline function readPixelsWEBGL(x:Int, y:Int, width:Int, height:Int, format:Int, type:Int, pixels:Dynamic, ?dstOffset:Int):Void
	{
		context.readPixels(x, y, width, height, format, type, pixels, dstOffset);
	}

	public static inline function renderbufferStorage(target:Int, internalformat:Int, width:Int, height:Int):Void
	{
		context.renderbufferStorage(target, internalformat, width, height);
	}

	public static inline function renderbufferStorageMultisample(target:Int, samples:Int, internalformat:Int, width:Int, height:Int):Void
	{
		context.renderbufferStorageMultisample(target, samples, internalformat, width, height);
	}

	public static inline function resumeTransformFeedback():Void
	{
		context.resumeTransformFeedback();
	}

	public static inline function sampleCoverage(value:Float, invert:Bool):Void
	{
		context.sampleCoverage(value, invert);
	}

	public static inline function samplerParameterf(sampler:GLSampler, pname:Int, param:Float):Void
	{
		context.samplerParameterf(sampler, pname, param);
	}

	public static inline function samplerParameteri(sampler:GLSampler, pname:Int, param:Int):Void
	{
		context.samplerParameteri(sampler, pname, param);
	}

	public static inline function scissor(x:Int, y:Int, width:Int, height:Int):Void
	{
		context.scissor(x, y, width, height);
	}

	public static inline function shaderSource(shader:GLShader, source:String):Void
	{
		context.shaderSource(shader, source);
	}

	public static inline function stencilFunc(func:Int, ref:Int, mask:Int):Void
	{
		context.stencilFunc(func, ref, mask);
	}

	public static inline function stencilFuncSeparate(face:Int, func:Int, ref:Int, mask:Int):Void
	{
		context.stencilFuncSeparate(face, func, ref, mask);
	}

	public static inline function stencilMask(mask:Int):Void
	{
		context.stencilMask(mask);
	}

	public static inline function stencilMaskSeparate(face:Int, mask:Int):Void
	{
		context.stencilMaskSeparate(face, mask);
	}

	public static inline function stencilOp(fail:Int, zfail:Int, zpass:Int):Void
	{
		context.stencilOp(fail, zfail, zpass);
	}

	public static inline function stencilOpSeparate(face:Int, fail:Int, zfail:Int, zpass:Int):Void
	{
		context.stencilOpSeparate(face, fail, zfail, zpass);
	}

	public static inline function texImage2DWEBGL(target:Int, level:Int, internalformat:Int, width:Int, height:Int, border:Dynamic, ?format:Int, ?type:Int,
			?srcData:Dynamic, ?srcOffset:Int):Void
	{
		context.texImage2D(target, level, internalformat, width, height, border, format, type, srcData, srcOffset);
	}

	public static inline function texImage3DWEBGL(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int, border:Int, format:Int,
			type:Int, srcData:Dynamic, ?srcOffset:Int):Void
	{
		context.texImage3D(target, level, internalformat, width, height, depth, border, format, type, srcData, srcOffset);
	}

	public static inline function texStorage2D(target:Int, level:Int, internalformat:Int, width:Int, height:Int):Void
	{
		context.texStorage2D(target, level, internalformat, width, height);
	}

	public static inline function texStorage3D(target:Int, level:Int, internalformat:Int, width:Int, height:Int, depth:Int):Void
	{
		context.texStorage3D(target, level, internalformat, width, height, depth);
	}

	public static inline function texParameterf(target:Int, pname:Int, param:Float):Void
	{
		context.texParameterf(target, pname, param);
	}

	public static inline function texParameteri(target:Int, pname:Int, param:Int):Void
	{
		context.texParameteri(target, pname, param);
	}

	public static inline function texSubImage2DWEBGL(target:Int, level:Int, xoffset:Int, yoffset:Int, width:Int, height:Int, format:Dynamic, ?type:Int,
			?srcData:Dynamic, ?srcOffset:Int):Void
	{
		context.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData, srcOffset);
	}

	public static inline function texSubImage3DWEBGL(target:Int, level:Int, xoffset:Int, yoffset:Int, zoffset:Int, width:Int, height:Int, depth:Int,
			format:Int, type:Int, source:Dynamic, ?srcOffset:Int):Void
	{
		context.texSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, source, srcOffset);
	}

	public static inline function transformFeedbackVaryings(program:GLProgram, varyings:Array<String>, bufferMode:Int):Void
	{
		context.transformFeedbackVaryings(program, varyings, bufferMode);
	}

	public static inline function uniform1f(location:GLUniformLocation, v0:Float):Void
	{
		context.uniform1f(location, v0);
	}

	public static inline function uniform1fvWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform1fv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform1i(location:GLUniformLocation, v0:Int):Void
	{
		context.uniform1i(location, v0);
	}

	public static inline function uniform1ivWEBGL(location:GLUniformLocation, ?data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform1iv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform1ui(location:GLUniformLocation, v0:Int):Void
	{
		context.uniform1ui(location, v0);
	}

	public static inline function uniform1uivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform1uiv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform2f(location:GLUniformLocation, v0:Float, v1:Float):Void
	{
		context.uniform2f(location, v0, v1);
	}

	public static inline function uniform2fvWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform2fv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform2i(location:GLUniformLocation, x:Int, y:Int):Void
	{
		context.uniform2i(location, x, y);
	}

	public static inline function uniform2ivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform2iv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform2ui(location:GLUniformLocation, x:Int, y:Int):Void
	{
		context.uniform2ui(location, x, y);
	}

	public static inline function uniform2uivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform2uiv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform3f(location:GLUniformLocation, v0:Float, v1:Float, v2:Float):Void
	{
		context.uniform3f(location, v0, v1, v2);
	}

	public static inline function uniform3fvWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform3fv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform3i(location:GLUniformLocation, v0:Int, v1:Int, v2:Int):Void
	{
		context.uniform3i(location, v0, v1, v2);
	}

	public static inline function uniform3ivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform3iv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform3ui(location:GLUniformLocation, v0:Int, v1:Int, v2:Int):Void
	{
		context.uniform3ui(location, v0, v1, v2);
	}

	public static inline function uniform3uivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform3uiv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform4f(location:GLUniformLocation, v0:Float, v1:Float, v2:Float, v3:Float):Void
	{
		context.uniform4f(location, v0, v1, v2, v3);
	}

	public static inline function uniform4fvWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform4fv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform4i(location:GLUniformLocation, v0:Int, v1:Int, v2:Int, v3:Int):Void
	{
		context.uniform4i(location, v0, v1, v2, v3);
	}

	public static inline function uniform4ivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform4iv(location, data, srcOffset, srcLength);
	}

	public static inline function uniform4ui(location:GLUniformLocation, v0:Int, v1:Int, v2:Int, v3:Int):Void
	{
		context.uniform4ui(location, v0, v1, v2, v3);
	}

	public static inline function uniform4uivWEBGL(location:GLUniformLocation, data:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniform4uiv(location, data, srcOffset, srcLength);
	}

	public static inline function uniformBlockBinding(program:GLProgram, uniformBlockIndex:Int, uniformBlockBinding:Int):Void
	{
		context.uniformBlockBinding(program, uniformBlockIndex, uniformBlockBinding);
	}

	public static inline function uniformMatrix2fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix2fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix2x3fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix2x3fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix2x4fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix2x4fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix3fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix3fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix3x2fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix3x2fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix3x4fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix3x4fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix4fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix4fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix4x2fvWEBGL(location:GLUniformLocation, transpose:Bool, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix4x2fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function uniformMatrix4x3fvWEBGL(location:GLUniformLocation, transpose:Dynamic, v:Dynamic, ?srcOffset:Int, ?srcLength:Int):Void
	{
		context.uniformMatrix4x3fv(location, transpose, v, srcOffset, srcLength);
	}

	public static inline function useProgram(program:GLProgram):Void
	{
		context.useProgram(program);
	}

	public static inline function validateProgram(program:GLProgram):Void
	{
		context.validateProgram(program);
	}

	public static inline function vertexAttrib1f(index:Int, v0:Float):Void
	{
		context.vertexAttrib1f(index, v0);
	}

	public static inline function vertexAttrib1fv(index:Int, v:#if (!js || !html5 || doc_gen) DataPointer #else Dynamic #end):Void
	{
		#if !doc_gen
		context.vertexAttrib1fv(index, v);
		#end
	}

	public static inline function vertexAttrib1fvWEBGL(index:Int, v:Dynamic):Void
	{
		context.vertexAttrib1fv(index, v);
	}

	public static inline function vertexAttrib2f(index:Int, v0:Float, v1:Float):Void
	{
		context.vertexAttrib2f(index, v0, v1);
	}

	public static inline function vertexAttrib2fv(index:Int, v:#if (!js || !html5 || doc_gen) DataPointer #else Dynamic #end):Void
	{
		context.vertexAttrib2fv(index, v);
	}

	public static inline function vertexAttrib2fvWEBGL(index:Int, v:Dynamic):Void
	{
		context.vertexAttrib2fv(index, v);
	}

	public static inline function vertexAttrib3f(index:Int, v0:Float, v1:Float, v2:Float):Void
	{
		context.vertexAttrib3f(index, v0, v1, v2);
	}

	public static inline function vertexAttrib3fv(index:Int, v:#if (!js || !html5 || doc_gen) DataPointer #else Dynamic #end):Void
	{
		context.vertexAttrib3fv(index, v);
	}

	public static inline function vertexAttrib3fvWEBGL(index:Int, v:Dynamic):Void
	{
		context.vertexAttrib3fv(index, v);
	}

	public static inline function vertexAttrib4f(index:Int, v0:Float, v1:Float, v2:Float, v3:Float):Void
	{
		context.vertexAttrib4f(index, v0, v1, v2, v3);
	}

	public static inline function vertexAttrib4fv(index:Int, v:#if (!js || !html5 || doc_gen) DataPointer #else Dynamic #end):Void
	{
		context.vertexAttrib4fv(index, v);
	}

	public static inline function vertexAttrib4fvWEBGL(index:Int, v:Dynamic):Void
	{
		context.vertexAttrib4fv(index, v);
	}

	public static inline function vertexAttribDivisor(index:Int, divisor:Int):Void
	{
		context.vertexAttribDivisor(index, divisor);
	}

	public static inline function vertexAttribI4i(index:Int, v0:Int, v1:Int, v2:Int, v3:Int):Void
	{
		context.vertexAttribI4i(index, v0, v1, v2, v3);
	}

	public static inline function vertexAttribI4iv(index:Int, v:#if (!js || !html5 || doc_gen) DataPointer #else Dynamic #end):Void
	{
		context.vertexAttribI4iv(index, v);
	}

	public static inline function vertexAttribI4ivWEBGL(index:Int, v:Dynamic):Void
	{
		context.vertexAttribI4iv(index, v);
	}

	public static inline function vertexAttribI4ui(index:Int, v0:Int, v1:Int, v2:Int, v3:Int):Void
	{
		context.vertexAttribI4ui(index, v0, v1, v2, v3);
	}

	public static inline function vertexAttribI4uiv(index:Int, v:#if (!js || !html5 || doc_gen) DataPointer #else Dynamic #end):Void
	{
		context.vertexAttribI4uiv(index, v);
	}

	public static inline function vertexAttribI4uivWEBGL(index:Int, v:Dynamic):Void
	{
		context.vertexAttribI4uiv(index, v);
	}

	public static inline function vertexAttribIPointer(index:Int, size:Int, type:Int, stride:Int, offset:DataPointer):Void
	{
		context.vertexAttribIPointer(index, size, type, stride, offset);
	}

	public static inline function vertexAttribPointer(index:Int, size:Int, type:Int, normalized:Bool, stride:Int, offset:DataPointer):Void
	{
		context.vertexAttribPointer(index, size, type, normalized, stride, offset);
	}

	public static inline function viewport(x:Int, y:Int, width:Int, height:Int):Void
	{
		context.viewport(x, y, width, height);
	}

	public static inline function waitSync(sync:GLSync, flags:Int, timeout:#if (!js || !html5 || doc_gen) Int64 #else Dynamic #end):Void
	{
		context.waitSync(sync, flags, timeout);
	}

	private static inline function __getObjectID(object:#if (!js || !html5 || doc_gen) GLObject #else Dynamic #end):Int
	{
		return (object == null) ? 0 : @:privateAccess object.id;
	}
}
#end
