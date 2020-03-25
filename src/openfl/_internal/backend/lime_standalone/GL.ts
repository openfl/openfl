namespace openfl._internal.backend.lime_standalone;

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

@: allow(openfl._internal.backend.lime_standalone.Window)
class GL
{
	public static readonly DEPTH_BUFFER_BIT = 0x00000100;
	public static readonly STENCIL_BUFFER_BIT = 0x00000400;
	public static readonly COLOR_BUFFER_BIT = 0x00004000;
	public static readonly POINTS = 0x0000;
	public static readonly LINES = 0x0001;
	public static readonly LINE_LOOP = 0x0002;
	public static readonly LINE_STRIP = 0x0003;
	public static readonly TRIANGLES = 0x0004;
	public static readonly TRIANGLE_STRIP = 0x0005;
	public static readonly TRIANGLE_FAN = 0x0006;
	public static readonly ZERO = 0;
	public static readonly ONE = 1;
	public static readonly SRC_COLOR = 0x0300;
	public static readonly ONE_MINUS_SRC_COLOR = 0x0301;
	public static readonly SRC_ALPHA = 0x0302;
	public static readonly ONE_MINUS_SRC_ALPHA = 0x0303;
	public static readonly DST_ALPHA = 0x0304;
	public static readonly ONE_MINUS_DST_ALPHA = 0x0305;
	public static readonly DST_COLOR = 0x0306;
	public static readonly ONE_MINUS_DST_COLOR = 0x0307;
	public static readonly SRC_ALPHA_SATURATE = 0x0308;
	public static readonly FUNC_ADD = 0x8006;
	public static readonly BLEND_EQUATION = 0x8009;
	public static readonly BLEND_EQUATION_RGB = 0x8009;
	public static readonly BLEND_EQUATION_ALPHA = 0x883D;
	public static readonly FUNC_SUBTRACT = 0x800A;
	public static readonly FUNC_REVERSE_SUBTRACT = 0x800B;
	public static readonly BLEND_DST_RGB = 0x80C8;
	public static readonly BLEND_SRC_RGB = 0x80C9;
	public static readonly BLEND_DST_ALPHA = 0x80CA;
	public static readonly BLEND_SRC_ALPHA = 0x80CB;
	public static readonly CONSTANT_COLOR = 0x8001;
	public static readonly ONE_MINUS_CONSTANT_COLOR = 0x8002;
	public static readonly CONSTANT_ALPHA = 0x8003;
	public static readonly ONE_MINUS_CONSTANT_ALPHA = 0x8004;
	public static readonly BLEND_COLOR = 0x8005;
	public static readonly ARRAY_BUFFER = 0x8892;
	public static readonly ELEMENT_ARRAY_BUFFER = 0x8893;
	public static readonly ARRAY_BUFFER_BINDING = 0x8894;
	public static readonly ELEMENT_ARRAY_BUFFER_BINDING = 0x8895;
	public static readonly STREAM_DRAW = 0x88E0;
	public static readonly STATIC_DRAW = 0x88E4;
	public static readonly DYNAMIC_DRAW = 0x88E8;
	public static readonly BUFFER_SIZE = 0x8764;
	public static readonly BUFFER_USAGE = 0x8765;
	public static readonly CURRENT_VERTEX_ATTRIB = 0x8626;
	public static readonly FRONT = 0x0404;
	public static readonly BACK = 0x0405;
	public static readonly FRONT_AND_BACK = 0x0408;
	public static readonly CULL_FACE = 0x0B44;
	public static readonly BLEND = 0x0BE2;
	public static readonly DITHER = 0x0BD0;
	public static readonly STENCIL_TEST = 0x0B90;
	public static readonly DEPTH_TEST = 0x0B71;
	public static readonly SCISSOR_TEST = 0x0C11;
	public static readonly POLYGON_OFFSET_FILL = 0x8037;
	public static readonly SAMPLE_ALPHA_TO_COVERAGE = 0x809E;
	public static readonly SAMPLE_COVERAGE = 0x80A0;
	public static readonly NO_ERROR = 0;
	public static readonly INVALID_ENUM = 0x0500;
	public static readonly INVALID_VALUE = 0x0501;
	public static readonly INVALID_OPERATION = 0x0502;
	public static readonly OUT_OF_MEMORY = 0x0505;
	public static readonly CW = 0x0900;
	public static readonly CCW = 0x0901;
	public static readonly LINE_WIDTH = 0x0B21;
	public static readonly ALIASED_POINT_SIZE_RANGE = 0x846D;
	public static readonly ALIASED_LINE_WIDTH_RANGE = 0x846E;
	public static readonly CULL_FACE_MODE = 0x0B45;
	public static readonly FRONT_FACE = 0x0B46;
	public static readonly DEPTH_RANGE = 0x0B70;
	public static readonly DEPTH_WRITEMASK = 0x0B72;
	public static readonly DEPTH_CLEAR_VALUE = 0x0B73;
	public static readonly DEPTH_FUNC = 0x0B74;
	public static readonly STENCIL_CLEAR_VALUE = 0x0B91;
	public static readonly STENCIL_FUNC = 0x0B92;
	public static readonly STENCIL_FAIL = 0x0B94;
	public static readonly STENCIL_PASS_DEPTH_FAIL = 0x0B95;
	public static readonly STENCIL_PASS_DEPTH_PASS = 0x0B96;
	public static readonly STENCIL_REF = 0x0B97;
	public static readonly STENCIL_VALUE_MASK = 0x0B93;
	public static readonly STENCIL_WRITEMASK = 0x0B98;
	public static readonly STENCIL_BACK_FUNC = 0x8800;
	public static readonly STENCIL_BACK_FAIL = 0x8801;
	public static readonly STENCIL_BACK_PASS_DEPTH_FAIL = 0x8802;
	public static readonly STENCIL_BACK_PASS_DEPTH_PASS = 0x8803;
	public static readonly STENCIL_BACK_REF = 0x8CA3;
	public static readonly STENCIL_BACK_VALUE_MASK = 0x8CA4;
	public static readonly STENCIL_BACK_WRITEMASK = 0x8CA5;
	public static readonly VIEWPORT = 0x0BA2;
	public static readonly SCISSOR_BOX = 0x0C10;
	public static readonly COLOR_CLEAR_VALUE = 0x0C22;
	public static readonly COLOR_WRITEMASK = 0x0C23;
	public static readonly UNPACK_ALIGNMENT = 0x0CF5;
	public static readonly PACK_ALIGNMENT = 0x0D05;
	public static readonly MAX_TEXTURE_SIZE = 0x0D33;
	public static readonly MAX_VIEWPORT_DIMS = 0x0D3A;
	public static readonly SUBPIXEL_BITS = 0x0D50;
	public static readonly RED_BITS = 0x0D52;
	public static readonly GREEN_BITS = 0x0D53;
	public static readonly BLUE_BITS = 0x0D54;
	public static readonly ALPHA_BITS = 0x0D55;
	public static readonly DEPTH_BITS = 0x0D56;
	public static readonly STENCIL_BITS = 0x0D57;
	public static readonly POLYGON_OFFSET_UNITS = 0x2A00;
	public static readonly POLYGON_OFFSET_FACTOR = 0x8038;
	public static readonly TEXTURE_BINDING_2D = 0x8069;
	public static readonly SAMPLE_BUFFERS = 0x80A8;
	public static readonly SAMPLES = 0x80A9;
	public static readonly SAMPLE_COVERAGE_VALUE = 0x80AA;
	public static readonly SAMPLE_COVERAGE_INVERT = 0x80AB;
	public static readonly NUM_COMPRESSED_TEXTURE_FORMATS = 0x86A2;
	public static readonly COMPRESSED_TEXTURE_FORMATS = 0x86A3;
	public static readonly DONT_CARE = 0x1100;
	public static readonly FASTEST = 0x1101;
	public static readonly NICEST = 0x1102;
	public static readonly GENERATE_MIPMAP_HINT = 0x8192;
	public static readonly BYTE = 0x1400;
	public static readonly UNSIGNED_BYTE = 0x1401;
	public static readonly SHORT = 0x1402;
	public static readonly UNSIGNED_SHORT = 0x1403;
	public static readonly INT = 0x1404;
	public static readonly UNSIGNED_INT = 0x1405;
	public static readonly FLOAT = 0x1406;
	public static readonly DEPTH_COMPONENT = 0x1902;
	public static readonly ALPHA = 0x1906;
	public static readonly RGB = 0x1907;
	public static readonly RGBA = 0x1908;
	public static readonly LUMINANCE = 0x1909;
	public static readonly LUMINANCE_ALPHA = 0x190A;
	public static readonly UNSIGNED_SHORT_4_4_4_4 = 0x8033;
	public static readonly UNSIGNED_SHORT_5_5_5_1 = 0x8034;
	public static readonly UNSIGNED_SHORT_5_6_5 = 0x8363;
	public static readonly FRAGMENT_SHADER = 0x8B30;
	public static readonly VERTEX_SHADER = 0x8B31;
	public static readonly MAX_VERTEX_ATTRIBS = 0x8869;
	public static readonly MAX_VERTEX_UNIFORM_VECTORS = 0x8DFB;
	public static readonly MAX_VARYING_VECTORS = 0x8DFC;
	public static readonly MAX_COMBINED_TEXTURE_IMAGE_UNITS = 0x8B4D;
	public static readonly MAX_VERTEX_TEXTURE_IMAGE_UNITS = 0x8B4C;
	public static readonly MAX_TEXTURE_IMAGE_UNITS = 0x8872;
	public static readonly MAX_FRAGMENT_UNIFORM_VECTORS = 0x8DFD;
	public static readonly SHADER_TYPE = 0x8B4F;
	public static readonly DELETE_STATUS = 0x8B80;
	public static readonly LINK_STATUS = 0x8B82;
	public static readonly VALIDATE_STATUS = 0x8B83;
	public static readonly ATTACHED_SHADERS = 0x8B85;
	public static readonly ACTIVE_UNIFORMS = 0x8B86;
	public static readonly ACTIVE_ATTRIBUTES = 0x8B89;
	public static readonly SHADING_LANGUAGE_VERSION = 0x8B8C;
	public static readonly CURRENT_PROGRAM = 0x8B8D;
	public static readonly NEVER = 0x0200;
	public static readonly LESS = 0x0201;
	public static readonly EQUAL = 0x0202;
	public static readonly LEQUAL = 0x0203;
	public static readonly GREATER = 0x0204;
	public static readonly NOTEQUAL = 0x0205;
	public static readonly GEQUAL = 0x0206;
	public static readonly ALWAYS = 0x0207;
	public static readonly KEEP = 0x1E00;
	public static readonly REPLACE = 0x1E01;
	public static readonly INCR = 0x1E02;
	public static readonly DECR = 0x1E03;
	public static readonly INVERT = 0x150A;
	public static readonly INCR_WRAP = 0x8507;
	public static readonly DECR_WRAP = 0x8508;
	public static readonly VENDOR = 0x1F00;
	public static readonly RENDERER = 0x1F01;
	public static readonly VERSION = 0x1F02;
	public static readonly EXTENSIONS = 0x1F03;
	public static readonly NEAREST = 0x2600;
	public static readonly LINEAR = 0x2601;
	public static readonly NEAREST_MIPMAP_NEAREST = 0x2700;
	public static readonly LINEAR_MIPMAP_NEAREST = 0x2701;
	public static readonly NEAREST_MIPMAP_LINEAR = 0x2702;
	public static readonly LINEAR_MIPMAP_LINEAR = 0x2703;
	public static readonly TEXTURE_MAG_FILTER = 0x2800;
	public static readonly TEXTURE_MIN_FILTER = 0x2801;
	public static readonly TEXTURE_WRAP_S = 0x2802;
	public static readonly TEXTURE_WRAP_T = 0x2803;
	public static readonly TEXTURE_2D = 0x0DE1;
	public static readonly TEXTURE = 0x1702;
	public static readonly TEXTURE_CUBE_MAP = 0x8513;
	public static readonly TEXTURE_BINDING_CUBE_MAP = 0x8514;
	public static readonly TEXTURE_CUBE_MAP_POSITIVE_X = 0x8515;
	public static readonly TEXTURE_CUBE_MAP_NEGATIVE_X = 0x8516;
	public static readonly TEXTURE_CUBE_MAP_POSITIVE_Y = 0x8517;
	public static readonly TEXTURE_CUBE_MAP_NEGATIVE_Y = 0x8518;
	public static readonly TEXTURE_CUBE_MAP_POSITIVE_Z = 0x8519;
	public static readonly TEXTURE_CUBE_MAP_NEGATIVE_Z = 0x851A;
	public static readonly MAX_CUBE_MAP_TEXTURE_SIZE = 0x851C;
	public static readonly TEXTURE0 = 0x84C0;
	public static readonly TEXTURE1 = 0x84C1;
	public static readonly TEXTURE2 = 0x84C2;
	public static readonly TEXTURE3 = 0x84C3;
	public static readonly TEXTURE4 = 0x84C4;
	public static readonly TEXTURE5 = 0x84C5;
	public static readonly TEXTURE6 = 0x84C6;
	public static readonly TEXTURE7 = 0x84C7;
	public static readonly TEXTURE8 = 0x84C8;
	public static readonly TEXTURE9 = 0x84C9;
	public static readonly TEXTURE10 = 0x84CA;
	public static readonly TEXTURE11 = 0x84CB;
	public static readonly TEXTURE12 = 0x84CC;
	public static readonly TEXTURE13 = 0x84CD;
	public static readonly TEXTURE14 = 0x84CE;
	public static readonly TEXTURE15 = 0x84CF;
	public static readonly TEXTURE16 = 0x84D0;
	public static readonly TEXTURE17 = 0x84D1;
	public static readonly TEXTURE18 = 0x84D2;
	public static readonly TEXTURE19 = 0x84D3;
	public static readonly TEXTURE20 = 0x84D4;
	public static readonly TEXTURE21 = 0x84D5;
	public static readonly TEXTURE22 = 0x84D6;
	public static readonly TEXTURE23 = 0x84D7;
	public static readonly TEXTURE24 = 0x84D8;
	public static readonly TEXTURE25 = 0x84D9;
	public static readonly TEXTURE26 = 0x84DA;
	public static readonly TEXTURE27 = 0x84DB;
	public static readonly TEXTURE28 = 0x84DC;
	public static readonly TEXTURE29 = 0x84DD;
	public static readonly TEXTURE30 = 0x84DE;
	public static readonly TEXTURE31 = 0x84DF;
	public static readonly ACTIVE_TEXTURE = 0x84E0;
	public static readonly REPEAT = 0x2901;
	public static readonly CLAMP_TO_EDGE = 0x812F;
	public static readonly MIRRORED_REPEAT = 0x8370;
	public static readonly FLOAT_VEC2 = 0x8B50;
	public static readonly FLOAT_VEC3 = 0x8B51;
	public static readonly FLOAT_VEC4 = 0x8B52;
	public static readonly INT_VEC2 = 0x8B53;
	public static readonly INT_VEC3 = 0x8B54;
	public static readonly INT_VEC4 = 0x8B55;
	public static readonly BOOL = 0x8B56;
	public static readonly BOOL_VEC2 = 0x8B57;
	public static readonly BOOL_VEC3 = 0x8B58;
	public static readonly BOOL_VEC4 = 0x8B59;
	public static readonly FLOAT_MAT2 = 0x8B5A;
	public static readonly FLOAT_MAT3 = 0x8B5B;
	public static readonly FLOAT_MAT4 = 0x8B5C;
	public static readonly SAMPLER_2D = 0x8B5E;
	public static readonly SAMPLER_CUBE = 0x8B60;
	public static readonly VERTEX_ATTRIB_ARRAY_ENABLED = 0x8622;
	public static readonly VERTEX_ATTRIB_ARRAY_SIZE = 0x8623;
	public static readonly VERTEX_ATTRIB_ARRAY_STRIDE = 0x8624;
	public static readonly VERTEX_ATTRIB_ARRAY_TYPE = 0x8625;
	public static readonly VERTEX_ATTRIB_ARRAY_NORMALIZED = 0x886A;
	public static readonly VERTEX_ATTRIB_ARRAY_POINTER = 0x8645;
	public static readonly VERTEX_ATTRIB_ARRAY_BUFFER_BINDING = 0x889F;
	public static readonly IMPLEMENTATION_COLOR_READ_TYPE = 0x8B9A;
	public static readonly IMPLEMENTATION_COLOR_READ_FORMAT = 0x8B9B;
	public static readonly VERTEX_PROGRAM_POINT_SIZE = 0x8642;
	public static readonly POINT_SPRITE = 0x8861;
	public static readonly COMPILE_STATUS = 0x8B81;
	public static readonly LOW_FLOAT = 0x8DF0;
	public static readonly MEDIUM_FLOAT = 0x8DF1;
	public static readonly HIGH_FLOAT = 0x8DF2;
	public static readonly LOW_INT = 0x8DF3;
	public static readonly MEDIUM_INT = 0x8DF4;
	public static readonly HIGH_INT = 0x8DF5;
	public static readonly FRAMEBUFFER = 0x8D40;
	public static readonly RENDERBUFFER = 0x8D41;
	public static readonly RGBA4 = 0x8056;
	public static readonly RGB5_A1 = 0x8057;
	public static readonly RGB565 = 0x8D62;
	public static readonly DEPTH_COMPONENT16 = 0x81A5;
	public static readonly STENCIL_INDEX = 0x1901;
	public static readonly STENCIL_INDEX8 = 0x8D48;
	public static readonly DEPTH_STENCIL = 0x84F9;
	public static readonly RENDERBUFFER_WIDTH = 0x8D42;
	public static readonly RENDERBUFFER_HEIGHT = 0x8D43;
	public static readonly RENDERBUFFER_INTERNAL_FORMAT = 0x8D44;
	public static readonly RENDERBUFFER_RED_SIZE = 0x8D50;
	public static readonly RENDERBUFFER_GREEN_SIZE = 0x8D51;
	public static readonly RENDERBUFFER_BLUE_SIZE = 0x8D52;
	public static readonly RENDERBUFFER_ALPHA_SIZE = 0x8D53;
	public static readonly RENDERBUFFER_DEPTH_SIZE = 0x8D54;
	public static readonly RENDERBUFFER_STENCIL_SIZE = 0x8D55;
	public static readonly FRAMEBUFFER_ATTACHMENT_OBJECT_TYPE = 0x8CD0;
	public static readonly FRAMEBUFFER_ATTACHMENT_OBJECT_NAME = 0x8CD1;
	public static readonly FRAMEBUFFER_ATTACHMENT_TEXTURE_LEVEL = 0x8CD2;
	public static readonly FRAMEBUFFER_ATTACHMENT_TEXTURE_CUBE_MAP_FACE = 0x8CD3;
	public static readonly COLOR_ATTACHMENT0 = 0x8CE0;
	public static readonly DEPTH_ATTACHMENT = 0x8D00;
	public static readonly STENCIL_ATTACHMENT = 0x8D20;
	public static readonly DEPTH_STENCIL_ATTACHMENT = 0x821A;
	public static readonly NONE = 0;
	public static readonly FRAMEBUFFER_COMPLETE = 0x8CD5;
	public static readonly FRAMEBUFFER_INCOMPLETE_ATTACHMENT = 0x8CD6;
	public static readonly FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT = 0x8CD7;
	public static readonly FRAMEBUFFER_INCOMPLETE_DIMENSIONS = 0x8CD9;
	public static readonly FRAMEBUFFER_UNSUPPORTED = 0x8CDD;
	public static readonly FRAMEBUFFER_BINDING = 0x8CA6;
	public static readonly RENDERBUFFER_BINDING = 0x8CA7;
	public static readonly MAX_RENDERBUFFER_SIZE = 0x84E8;
	public static readonly INVALID_FRAMEBUFFER_OPERATION = 0x0506;
	public static readonly UNPACK_FLIP_Y_WEBGL = 0x9240;
	public static readonly UNPACK_PREMULTIPLY_ALPHA_WEBGL = 0x9241;
	public static readonly CONTEXT_LOST_WEBGL = 0x9242;
	public static readonly UNPACK_COLORSPACE_CONVERSION_WEBGL = 0x9243;
	public static readonly BROWSER_DEFAULT_WEBGL = 0x9244;
	public static readonly READ_BUFFER = 0x0C02;
	public static readonly UNPACK_ROW_LENGTH = 0x0CF2;
	public static readonly UNPACK_SKIP_ROWS = 0x0CF3;
	public static readonly UNPACK_SKIP_PIXELS = 0x0CF4;
	public static readonly PACK_ROW_LENGTH = 0x0D02;
	public static readonly PACK_SKIP_ROWS = 0x0D03;
	public static readonly PACK_SKIP_PIXELS = 0x0D04;
	public static readonly TEXTURE_BINDING_3D = 0x806A;
	public static readonly UNPACK_SKIP_IMAGES = 0x806D;
	public static readonly UNPACK_IMAGE_HEIGHT = 0x806E;
	public static readonly MAX_3D_TEXTURE_SIZE = 0x8073;
	public static readonly MAX_ELEMENTS_VERTICES = 0x80E8;
	public static readonly MAX_ELEMENTS_INDICES = 0x80E9;
	public static readonly MAX_TEXTURE_LOD_BIAS = 0x84FD;
	public static readonly MAX_FRAGMENT_UNIFORM_COMPONENTS = 0x8B49;
	public static readonly MAX_VERTEX_UNIFORM_COMPONENTS = 0x8B4A;
	public static readonly MAX_ARRAY_TEXTURE_LAYERS = 0x88FF;
	public static readonly MIN_PROGRAM_TEXEL_OFFSET = 0x8904;
	public static readonly MAX_PROGRAM_TEXEL_OFFSET = 0x8905;
	public static readonly MAX_VARYING_COMPONENTS = 0x8B4B;
	public static readonly FRAGMENT_SHADER_DERIVATIVE_HINT = 0x8B8B;
	public static readonly RASTERIZER_DISCARD = 0x8C89;
	public static readonly VERTEX_ARRAY_BINDING = 0x85B5;
	public static readonly MAX_VERTEX_OUTPUT_COMPONENTS = 0x9122;
	public static readonly MAX_FRAGMENT_INPUT_COMPONENTS = 0x9125;
	public static readonly MAX_SERVER_WAIT_TIMEOUT = 0x9111;
	public static readonly MAX_ELEMENT_INDEX = 0x8D6B;
	public static readonly RED = 0x1903;
	public static readonly RGB8 = 0x8051;
	public static readonly RGBA8 = 0x8058;
	public static readonly RGB10_A2 = 0x8059;
	public static readonly TEXTURE_3D = 0x806F;
	public static readonly TEXTURE_WRAP_R = 0x8072;
	public static readonly TEXTURE_MIN_LOD = 0x813A;
	public static readonly TEXTURE_MAX_LOD = 0x813B;
	public static readonly TEXTURE_BASE_LEVEL = 0x813C;
	public static readonly TEXTURE_MAX_LEVEL = 0x813D;
	public static readonly TEXTURE_COMPARE_MODE = 0x884C;
	public static readonly TEXTURE_COMPARE_FUNC = 0x884D;
	public static readonly SRGB = 0x8C40;
	public static readonly SRGB8 = 0x8C41;
	public static readonly SRGB8_ALPHA8 = 0x8C43;
	public static readonly COMPARE_REF_TO_TEXTURE = 0x884E;
	public static readonly RGBA32F = 0x8814;
	public static readonly RGB32F = 0x8815;
	public static readonly RGBA16F = 0x881A;
	public static readonly RGB16F = 0x881B;
	public static readonly TEXTURE_2D_ARRAY = 0x8C1A;
	public static readonly TEXTURE_BINDING_2D_ARRAY = 0x8C1D;
	public static readonly R11F_G11F_B10F = 0x8C3A;
	public static readonly RGB9_E5 = 0x8C3D;
	public static readonly RGBA32UI = 0x8D70;
	public static readonly RGB32UI = 0x8D71;
	public static readonly RGBA16UI = 0x8D76;
	public static readonly RGB16UI = 0x8D77;
	public static readonly RGBA8UI = 0x8D7C;
	public static readonly RGB8UI = 0x8D7D;
	public static readonly RGBA32I = 0x8D82;
	public static readonly RGB32I = 0x8D83;
	public static readonly RGBA16I = 0x8D88;
	public static readonly RGB16I = 0x8D89;
	public static readonly RGBA8I = 0x8D8E;
	public static readonly RGB8I = 0x8D8F;
	public static readonly RED_INTEGER = 0x8D94;
	public static readonly RGB_INTEGER = 0x8D98;
	public static readonly RGBA_INTEGER = 0x8D99;
	public static readonly R8 = 0x8229;
	public static readonly RG8 = 0x822B;
	public static readonly R16F = 0x822D;
	public static readonly R32F = 0x822E;
	public static readonly RG16F = 0x822F;
	public static readonly RG32F = 0x8230;
	public static readonly R8I = 0x8231;
	public static readonly R8UI = 0x8232;
	public static readonly R16I = 0x8233;
	public static readonly R16UI = 0x8234;
	public static readonly R32I = 0x8235;
	public static readonly R32UI = 0x8236;
	public static readonly RG8I = 0x8237;
	public static readonly RG8UI = 0x8238;
	public static readonly RG16I = 0x8239;
	public static readonly RG16UI = 0x823A;
	public static readonly RG32I = 0x823B;
	public static readonly RG32UI = 0x823C;
	public static readonly R8_SNORM = 0x8F94;
	public static readonly RG8_SNORM = 0x8F95;
	public static readonly RGB8_SNORM = 0x8F96;
	public static readonly RGBA8_SNORM = 0x8F97;
	public static readonly RGB10_A2UI = 0x906F;
	public static readonly TEXTURE_IMMUTABLE_FORMAT = 0x912F;
	public static readonly TEXTURE_IMMUTABLE_LEVELS = 0x82DF;
	public static readonly UNSIGNED_INT_2_10_10_10_REV = 0x8368;
	public static readonly UNSIGNED_INT_10F_11F_11F_REV = 0x8C3B;
	public static readonly UNSIGNED_INT_5_9_9_9_REV = 0x8C3E;
	public static readonly FLOAT_32_UNSIGNED_INT_24_8_REV = 0x8DAD;
	public static readonly UNSIGNED_INT_24_8 = 0x84FA;
	public static readonly HALF_FLOAT = 0x140B;
	public static readonly RG = 0x8227;
	public static readonly RG_INTEGER = 0x8228;
	public static readonly INT_2_10_10_10_REV = 0x8D9F;
	public static readonly CURRENT_QUERY = 0x8865;
	public static readonly QUERY_RESULT = 0x8866;
	public static readonly QUERY_RESULT_AVAILABLE = 0x8867;
	public static readonly ANY_SAMPLES_PASSED = 0x8C2F;
	public static readonly ANY_SAMPLES_PASSED_CONSERVATIVE = 0x8D6A;
	public static readonly MAX_DRAW_BUFFERS = 0x8824;
	public static readonly DRAW_BUFFER0 = 0x8825;
	public static readonly DRAW_BUFFER1 = 0x8826;
	public static readonly DRAW_BUFFER2 = 0x8827;
	public static readonly DRAW_BUFFER3 = 0x8828;
	public static readonly DRAW_BUFFER4 = 0x8829;
	public static readonly DRAW_BUFFER5 = 0x882A;
	public static readonly DRAW_BUFFER6 = 0x882B;
	public static readonly DRAW_BUFFER7 = 0x882C;
	public static readonly DRAW_BUFFER8 = 0x882D;
	public static readonly DRAW_BUFFER9 = 0x882E;
	public static readonly DRAW_BUFFER10 = 0x882F;
	public static readonly DRAW_BUFFER11 = 0x8830;
	public static readonly DRAW_BUFFER12 = 0x8831;
	public static readonly DRAW_BUFFER13 = 0x8832;
	public static readonly DRAW_BUFFER14 = 0x8833;
	public static readonly DRAW_BUFFER15 = 0x8834;
	public static readonly MAX_COLOR_ATTACHMENTS = 0x8CDF;
	public static readonly COLOR_ATTACHMENT1 = 0x8CE1;
	public static readonly COLOR_ATTACHMENT2 = 0x8CE2;
	public static readonly COLOR_ATTACHMENT3 = 0x8CE3;
	public static readonly COLOR_ATTACHMENT4 = 0x8CE4;
	public static readonly COLOR_ATTACHMENT5 = 0x8CE5;
	public static readonly COLOR_ATTACHMENT6 = 0x8CE6;
	public static readonly COLOR_ATTACHMENT7 = 0x8CE7;
	public static readonly COLOR_ATTACHMENT8 = 0x8CE8;
	public static readonly COLOR_ATTACHMENT9 = 0x8CE9;
	public static readonly COLOR_ATTACHMENT10 = 0x8CEA;
	public static readonly COLOR_ATTACHMENT11 = 0x8CEB;
	public static readonly COLOR_ATTACHMENT12 = 0x8CEC;
	public static readonly COLOR_ATTACHMENT13 = 0x8CED;
	public static readonly COLOR_ATTACHMENT14 = 0x8CEE;
	public static readonly COLOR_ATTACHMENT15 = 0x8CEF;
	public static readonly SAMPLER_3D = 0x8B5F;
	public static readonly SAMPLER_2D_SHADOW = 0x8B62;
	public static readonly SAMPLER_2D_ARRAY = 0x8DC1;
	public static readonly SAMPLER_2D_ARRAY_SHADOW = 0x8DC4;
	public static readonly SAMPLER_CUBE_SHADOW = 0x8DC5;
	public static readonly INT_SAMPLER_2D = 0x8DCA;
	public static readonly INT_SAMPLER_3D = 0x8DCB;
	public static readonly INT_SAMPLER_CUBE = 0x8DCC;
	public static readonly INT_SAMPLER_2D_ARRAY = 0x8DCF;
	public static readonly UNSIGNED_INT_SAMPLER_2D = 0x8DD2;
	public static readonly UNSIGNED_INT_SAMPLER_3D = 0x8DD3;
	public static readonly UNSIGNED_INT_SAMPLER_CUBE = 0x8DD4;
	public static readonly UNSIGNED_INT_SAMPLER_2D_ARRAY = 0x8DD7;
	public static readonly MAX_SAMPLES = 0x8D57;
	public static readonly SAMPLER_BINDING = 0x8919;
	public static readonly PIXEL_PACK_BUFFER = 0x88EB;
	public static readonly PIXEL_UNPACK_BUFFER = 0x88EC;
	public static readonly PIXEL_PACK_BUFFER_BINDING = 0x88ED;
	public static readonly PIXEL_UNPACK_BUFFER_BINDING = 0x88EF;
	public static readonly COPY_READ_BUFFER = 0x8F36;
	public static readonly COPY_WRITE_BUFFER = 0x8F37;
	public static readonly COPY_READ_BUFFER_BINDING = 0x8F36;
	public static readonly COPY_WRITE_BUFFER_BINDING = 0x8F37;
	public static readonly FLOAT_MAT2x3 = 0x8B65;
	public static readonly FLOAT_MAT2x4 = 0x8B66;
	public static readonly FLOAT_MAT3x2 = 0x8B67;
	public static readonly FLOAT_MAT3x4 = 0x8B68;
	public static readonly FLOAT_MAT4x2 = 0x8B69;
	public static readonly FLOAT_MAT4x3 = 0x8B6A;
	public static readonly UNSIGNED_INT_VEC2 = 0x8DC6;
	public static readonly UNSIGNED_INT_VEC3 = 0x8DC7;
	public static readonly UNSIGNED_INT_VEC4 = 0x8DC8;
	public static readonly UNSIGNED_NORMALIZED = 0x8C17;
	public static readonly SIGNED_NORMALIZED = 0x8F9C;
	public static readonly VERTEX_ATTRIB_ARRAY_INTEGER = 0x88FD;
	public static readonly VERTEX_ATTRIB_ARRAY_DIVISOR = 0x88FE;
	public static readonly TRANSFORM_FEEDBACK_BUFFER_MODE = 0x8C7F;
	public static readonly MAX_TRANSFORM_FEEDBACK_SEPARATE_COMPONENTS = 0x8C80;
	public static readonly TRANSFORM_FEEDBACK_VARYINGS = 0x8C83;
	public static readonly TRANSFORM_FEEDBACK_BUFFER_START = 0x8C84;
	public static readonly TRANSFORM_FEEDBACK_BUFFER_SIZE = 0x8C85;
	public static readonly TRANSFORM_FEEDBACK_PRIMITIVES_WRITTEN = 0x8C88;
	public static readonly MAX_TRANSFORM_FEEDBACK_INTERLEAVED_COMPONENTS = 0x8C8A;
	public static readonly MAX_TRANSFORM_FEEDBACK_SEPARATE_ATTRIBS = 0x8C8B;
	public static readonly INTERLEAVED_ATTRIBS = 0x8C8C;
	public static readonly SEPARATE_ATTRIBS = 0x8C8D;
	public static readonly TRANSFORM_FEEDBACK_BUFFER = 0x8C8E;
	public static readonly TRANSFORM_FEEDBACK_BUFFER_BINDING = 0x8C8F;
	public static readonly TRANSFORM_FEEDBACK = 0x8E22;
	public static readonly TRANSFORM_FEEDBACK_PAUSED = 0x8E23;
	public static readonly TRANSFORM_FEEDBACK_ACTIVE = 0x8E24;
	public static readonly TRANSFORM_FEEDBACK_BINDING = 0x8E25;
	public static readonly FRAMEBUFFER_ATTACHMENT_COLOR_ENCODING = 0x8210;
	public static readonly FRAMEBUFFER_ATTACHMENT_COMPONENT_TYPE = 0x8211;
	public static readonly FRAMEBUFFER_ATTACHMENT_RED_SIZE = 0x8212;
	public static readonly FRAMEBUFFER_ATTACHMENT_GREEN_SIZE = 0x8213;
	public static readonly FRAMEBUFFER_ATTACHMENT_BLUE_SIZE = 0x8214;
	public static readonly FRAMEBUFFER_ATTACHMENT_ALPHA_SIZE = 0x8215;
	public static readonly FRAMEBUFFER_ATTACHMENT_DEPTH_SIZE = 0x8216;
	public static readonly FRAMEBUFFER_ATTACHMENT_STENCIL_SIZE = 0x8217;
	public static readonly FRAMEBUFFER_DEFAULT = 0x8218;
	public static readonly DEPTH24_STENCIL8 = 0x88F0;
	public static readonly DRAW_FRAMEBUFFER_BINDING = 0x8CA6;
	public static readonly READ_FRAMEBUFFER = 0x8CA8;
	public static readonly DRAW_FRAMEBUFFER = 0x8CA9;
	public static readonly READ_FRAMEBUFFER_BINDING = 0x8CAA;
	public static readonly RENDERBUFFER_SAMPLES = 0x8CAB;
	public static readonly FRAMEBUFFER_ATTACHMENT_TEXTURE_LAYER = 0x8CD4;
	public static readonly FRAMEBUFFER_INCOMPLETE_MULTISAMPLE = 0x8D56;
	public static readonly UNIFORM_BUFFER = 0x8A11;
	public static readonly UNIFORM_BUFFER_BINDING = 0x8A28;
	public static readonly UNIFORM_BUFFER_START = 0x8A29;
	public static readonly UNIFORM_BUFFER_SIZE = 0x8A2A;
	public static readonly MAX_VERTEX_UNIFORM_BLOCKS = 0x8A2B;
	public static readonly MAX_FRAGMENT_UNIFORM_BLOCKS = 0x8A2D;
	public static readonly MAX_COMBINED_UNIFORM_BLOCKS = 0x8A2E;
	public static readonly MAX_UNIFORM_BUFFER_BINDINGS = 0x8A2F;
	public static readonly MAX_UNIFORM_BLOCK_SIZE = 0x8A30;
	public static readonly MAX_COMBINED_VERTEX_UNIFORM_COMPONENTS = 0x8A31;
	public static readonly MAX_COMBINED_FRAGMENT_UNIFORM_COMPONENTS = 0x8A33;
	public static readonly UNIFORM_BUFFER_OFFSET_ALIGNMENT = 0x8A34;
	public static readonly ACTIVE_UNIFORM_BLOCKS = 0x8A36;
	public static readonly UNIFORM_TYPE = 0x8A37;
	public static readonly UNIFORM_SIZE = 0x8A38;
	public static readonly UNIFORM_BLOCK_INDEX = 0x8A3A;
	public static readonly UNIFORM_OFFSET = 0x8A3B;
	public static readonly UNIFORM_ARRAY_STRIDE = 0x8A3C;
	public static readonly UNIFORM_MATRIX_STRIDE = 0x8A3D;
	public static readonly UNIFORM_IS_ROW_MAJOR = 0x8A3E;
	public static readonly UNIFORM_BLOCK_BINDING = 0x8A3F;
	public static readonly UNIFORM_BLOCK_DATA_SIZE = 0x8A40;
	public static readonly UNIFORM_BLOCK_ACTIVE_UNIFORMS = 0x8A42;
	public static readonly UNIFORM_BLOCK_ACTIVE_UNIFORM_INDICES = 0x8A43;
	public static readonly UNIFORM_BLOCK_REFERENCED_BY_VERTEX_SHADER = 0x8A44;
	public static readonly UNIFORM_BLOCK_REFERENCED_BY_FRAGMENT_SHADER = 0x8A46;
	public static readonly OBJECT_TYPE = 0x9112;
	public static readonly SYNC_CONDITION = 0x9113;
	public static readonly SYNC_STATUS = 0x9114;
	public static readonly SYNC_FLAGS = 0x9115;
	public static readonly SYNC_FENCE = 0x9116;
	public static readonly SYNC_GPU_COMMANDS_COMPLETE = 0x9117;
	public static readonly UNSIGNALED = 0x9118;
	public static readonly SIGNALED = 0x9119;
	public static readonly ALREADY_SIGNALED = 0x911A;
	public static readonly TIMEOUT_EXPIRED = 0x911B;
	public static readonly CONDITION_SATISFIED = 0x911C;
	public static readonly WAIT_FAILED = 0x911D;
	public static readonly SYNC_FLUSH_COMMANDS_BIT = 0x00000001;
	public static readonly COLOR = 0x1800;
	public static readonly DEPTH = 0x1801;
	public static readonly STENCIL = 0x1802;
	public static readonly MIN = 0x8007;
	public static readonly MAX = 0x8008;
	public static readonly DEPTH_COMPONENT24 = 0x81A6;
	public static readonly STREAM_READ = 0x88E1;
	public static readonly STREAM_COPY = 0x88E2;
	public static readonly STATIC_READ = 0x88E5;
	public static readonly STATIC_COPY = 0x88E6;
	public static readonly DYNAMIC_READ = 0x88E9;
	public static readonly DYNAMIC_COPY = 0x88EA;
	public static readonly DEPTH_COMPONENT32F = 0x8CAC;
	public static readonly DEPTH32F_STENCIL8 = 0x8CAD;
	public static readonly INVALID_INDEX = 0xFFFFFFFF;
	public static readonly TIMEOUT_IGNORED = -1;
	public static readonly MAX_CLIENT_WAIT_TIMEOUT_WEBGL = 0x9247;
	public static context(default , null): WebGL2RenderContext;
	public static type(default , null): RenderContextType;
	public static version(default , null): number;

	public static readonly activeTexture(texture: number): void
	{
		context.activeTexture(texture);
	}

	public static readonly attachShader(program: GLProgram, shader: GLShader): void
	{
		context.attachShader(program, shader);
	}

	public static readonly beginQuery(target: number, query: GLQuery): void
	{
		context.beginQuery(target, query);
	}

	public static readonly beginTransformFeedback(primitiveNode: number): void
	{
		context.beginTransformFeedback(primitiveNode);
	}

	public static readonly bindAttribLocation(program: GLProgram, index: number, name: string): void
	{
		context.bindAttribLocation(program, index, name);
	}

	public static readonly bindBuffer(target: number, buffer: GLBuffer): void
	{
		context.bindBuffer(target, buffer);
	}

	public static readonly bindBufferBase(target: number, index: number, buffer: GLBuffer): void
	{
		context.bindBufferBase(target, index, buffer);
	}

	public static readonly bindBufferRange(target: number, index: number, buffer: GLBuffer, offset: DataPointer, size: number): void
	{
		context.bindBufferRange(target, index, buffer, offset, size);
	}

	public static readonly bindFramebuffer(target: number, framebuffer: GLFramebuffer): void
	{
		context.bindFramebuffer(target, framebuffer);
	}

	public static readonly bindRenderbuffer(target: number, renderbuffer: GLRenderbuffer): void
	{
		context.bindRenderbuffer(target, renderbuffer);
	}

	public static readonly bindSampler(unit: number, sampler: GLSampler): void
	{
		context.bindSampler(unit, sampler);
	}

	public static readonly bindTexture(target: number, texture: GLTexture): void
	{
		context.bindTexture(target, texture);
	}

	public static readonly bindTransformFeedback(target: number, transformFeedback: GLTransformFeedback): void
	{
		context.bindTransformFeedback(target, transformFeedback);
	}

	public static readonly bindVertexArray(vertexArray: GLVertexArrayObject): void
	{
		context.bindVertexArray(vertexArray);
	}

	public static readonly blitFramebuffer(srcX0: number, srcY0: number, srcX1: number, srcY1: number, dstX0: number, dstY0: number, dstX1: number, dstY1: number, mask: number,
		filter: number): void
	{
		context.blitFramebuffer(srcX0, srcY0, srcX1, srcY1, dstX0, dstY0, dstX1, dstY1, mask, filter);
	}

	public static readonly blendColor(red: number, green: number, blue: number, alpha: number): void
	{
		context.blendColor(red, green, blue, alpha);
	}

	public static readonly blendEquation(mode: number): void
	{
		context.blendEquation(mode);
	}

	public static readonly blendEquationSeparate(modeRGB: number, modeAlpha: number): void
	{
		context.blendEquationSeparate(modeRGB, modeAlpha);
	}

	public static readonly blendFunc(sfactor: number, dfactor: number): void
	{
		context.blendFunc(sfactor, dfactor);
	}

	public static readonly blendFuncSeparate(srcRGB: number, dstRGB: number, srcAlpha: number, dstAlpha: number): void
	{
		context.blendFuncSeparate(srcRGB, dstRGB, srcAlpha, dstAlpha);
	}

	#if(lime_opengl || lime_opengles)
	public static readonly bufferData(target : number, size : number, srcData: DataPointer, usage : number): void
	{
		context.bufferData(target, size, srcData, usage);
	}
	#end

	public static readonly bufferDataWEBGL(target : number, srcData: Dynamic, usage : number, ?srcOffset : number, ?length : number): void
	{
		context.bufferData(target, srcData, usage, srcOffset, length);
	}

	public static readonly bufferSubDataWEBGL(target : number, dstByteOffset : number, srcData: Dynamic, ?srcOffset : number, ?length : number): void
	{
		context.bufferSubData(target, dstByteOffset, srcData, srcOffset, length);
	}

	public static readonly checkFramebufferStatus(target : number) : number
{
	return context.checkFramebufferStatus(target);
}

	public static readonly clear(mask : number): void
	{
		context.clear(mask);
	}

	public static readonly clearBufferfi(buffer : number, drawbuffer : number, depth : number, stencil : number): void
	{
		context.clearBufferfi(buffer, drawbuffer, depth, stencil);
	}

	public static readonly clearBufferfvWEBGL(buffer : number, drawbuffer : number, values: Dynamic, ?srcOffset : number): void
	{
		context.clearBufferfv(buffer, drawbuffer, values, srcOffset);
	}

	public static readonly clearBufferivWEBGL(buffer : number, drawbuffer : number, values: Dynamic, ?srcOffset : number): void
	{
		context.clearBufferiv(buffer, drawbuffer, values, srcOffset);
	}

	public static readonly clearBufferuivWEBGL(buffer : number, drawbuffer : number, values: Dynamic, ?srcOffset : number): void
	{
		context.clearBufferuiv(buffer, drawbuffer, values, srcOffset);
	}

	public static readonly clearColor(red : number, green : number, blue : number, alpha : number): void
	{
		context.clearColor(red, green, blue, alpha);
	}

	public static readonly clearDepth(depth : number): void
	{
		context.clearDepth(depth);
	}

	public static readonly clearStencil(s : number): void
	{
		context.clearStencil(s);
	}

	public static readonly clientWaitSync(sync: GLSync, flags : number, timeout: #if(!js || !html5 || doc_gen) Int64 #else Dynamic #end) : number
{
	return context.clientWaitSync(sync, flags, timeout);
}

	public static readonly colorMask(red : boolean, green : boolean, blue : boolean, alpha : boolean): void
	{
		context.colorMask(red, green, blue, alpha);
	}

	public static readonly compileShader(shader: GLShader): void
	{
		context.compileShader(shader);
	}

	public static readonly compressedTexImage2DWEBGL(target : number, level : number, internalformat : number, width : number, height : number, border : number, srcData: Dynamic,
			?srcOffset : number, ?srcLengthOverride : number): void
	{
		context.compressedTexImage2D(target, level, internalformat, width, height, border, srcData, srcOffset, srcLengthOverride);
	}

	public static readonly compressedTexImage3DWEBGL(target : number, level : number, internalformat : number, width : number, height : number, depth : number, border : number,
		srcData: Dynamic, ?srcOffset : number, ?srcLengthOverride : number): void
			{
				context.compressedTexImage3D(target, level, internalformat, width, height, depth, border, srcData, srcOffset, srcLengthOverride);
			}

	public static readonly compressedTexSubImage2DWEBGL(target : number, level : number, xoffset : number, yoffset : number, width : number, height : number, format : number,
				srcData: Dynamic, ?srcOffset : number, ?srcLengthOverride : number): void
					{
						context.compressedTexSubImage2D(target, level, xoffset, yoffset, width, height, format, srcData, srcOffset, srcLengthOverride);
					}

	public static readonly compressedTexSubImage3DWEBGL(target : number, level : number, xoffset : number, yoffset : number, zoffset : number, width : number, height : number, depth : number,
						format : number, srcData: Dynamic, ?srcOffset : number, ?srcLengthOverride : number): void
							{
								context.compressedTexSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, srcData, srcOffset, srcLengthOverride);
							}

	public static readonly copyTexImage2D(target : number, level : number, internalformat : number, x : number, y : number, width : number, height : number, border : number): void
	{
		context.copyTexImage2D(target, level, internalformat, x, y, width, height, border);
	}

	public static readonly copyTexSubImage2D(target : number, level : number, xoffset : number, yoffset : number, x : number, y : number, width : number, height : number): void
	{
		context.copyTexSubImage2D(target, level, xoffset, yoffset, x, y, width, height);
	}

	public static readonly copyTexSubImage3D(target : number, level : number, xoffset : number, yoffset : number, zoffset : number, x : number, y : number, width : number, height : number): void
	{
		context.copyTexSubImage3D(target, level, xoffset, yoffset, zoffset, x, y, width, height);
	}

	public static readonly createBuffer(): GLBuffer
{
	return context.createBuffer();
}

	public static readonly createFramebuffer(): GLFramebuffer
{
	return context.createFramebuffer();
}

	public static readonly createProgram(): GLProgram
{
	return context.createProgram();
}

	public static readonly createQuery(): GLQuery
{
	return context.createQuery();
}

	public static readonly createRenderbuffer(): GLRenderbuffer
{
	return context.createRenderbuffer();
}

	public static readonly createSampler(): GLSampler
{
	return context.createSampler();
}

	public static readonly createShader(type : number): GLShader
{
	return context.createShader(type);
}

	public static readonly createTexture(): GLTexture
{
	return context.createTexture();
}

	public static readonly createTransformFeedback(): GLTransformFeedback
{
	return context.createTransformFeedback();
}

	public static readonly createVertexArray(): GLVertexArrayObject
{
	return context.createVertexArray();
}

	public static readonly cullFace(mode : number): void
	{
		context.cullFace(mode);
	}

	public static readonly deleteBuffer(buffer: GLBuffer): void
	{
		context.deleteBuffer(buffer);
	}

	public static readonly deleteFramebuffer(framebuffer: GLFramebuffer): void
	{
		context.deleteFramebuffer(framebuffer);
	}

	public static readonly deleteProgram(program: GLProgram): void
	{
		context.deleteProgram(program);
	}

	public static readonly deleteQuery(query: GLQuery): void
	{
		context.deleteQuery(query);
	}

	public static readonly deleteRenderbuffer(renderbuffer: GLRenderbuffer): void
	{
		context.deleteRenderbuffer(renderbuffer);
	}

	public static readonly deleteSampler(sampler: GLSampler): void
	{
		context.deleteSampler(sampler);
	}

	public static readonly deleteShader(shader: GLShader): void
	{
		context.deleteShader(shader);
	}

	public static readonly deleteSync(sync: GLSync): void
	{
		context.deleteSync(sync);
	}

	public static readonly deleteTexture(texture: GLTexture): void
	{
		context.deleteTexture(texture);
	}

	public static readonly deleteTransformFeedback(transformFeedback: GLTransformFeedback): void
	{
		context.deleteTransformFeedback(transformFeedback);
	}

	public static readonly deleteVertexArray(vertexArray: GLVertexArrayObject): void
	{
		context.deleteVertexArray(vertexArray);
	}

	public static readonly depthFunc(func : number): void
	{
		context.depthFunc(func);
	}

	public static readonly depthMask(flag : boolean): void
	{
		context.depthMask(flag);
	}

	public static readonly depthRange(zNear : number, zFar : number): void
	{
		context.depthRange(zNear, zFar);
	}

	public static readonly detachShader(program: GLProgram, shader: GLShader): void
	{
		context.detachShader(program, shader);
	}

	public static readonly disable(cap : number): void
	{
		context.disable(cap);
	}

	public static readonly disableVertexAttribArray(index : number): void
	{
		context.disableVertexAttribArray(index);
	}

	public static readonly drawArrays(mode : number, first : number, count : number): void
	{
		context.drawArrays(mode, first, count);
	}

	public static readonly drawArraysInstanced(mode : number, first : number, count : number, instanceCount : number): void
	{
		context.drawArraysInstanced(mode, first, count, instanceCount);
	}

	public static readonly drawBuffers(buffers: Array<Int>): void
		{
			context.drawBuffers(buffers);
		}

	public static readonly drawElements(mode : number, count : number, type : number, offset : number): void
	{
		context.drawElements(mode, count, type, offset);
	}

	public static readonly drawElementsInstanced(mode : number, count : number, type : number, offset: DataPointer, instanceCount : number): void
	{
		context.drawElementsInstanced(mode, count, type, offset, instanceCount);
	}

	public static readonly drawRangeElements(mode : number, start : number, end : number, count : number, type : number, offset: DataPointer): void
	{
		context.drawRangeElements(mode, start, end, count, type, offset);
	}

	public static readonly enable(cap : number): void
	{
		context.enable(cap);
	}

	public static readonly enableVertexAttribArray(index : number): void
	{
		context.enableVertexAttribArray(index);
	}

	public static readonly endQuery(target : number): void
	{
		context.endQuery(target);
	}

	public static readonly endTransformFeedback(): void
	{
		context.endTransformFeedback();
	}

	public static readonly fenceSync(condition : number, flags : number): GLSync
{
			return context.fenceSync(condition, flags);
		}

	public static readonly finish(): void
	{
		context.finish();
	}

	public static readonly flush(): void
	{
		context.flush();
	}

	public static readonly framebufferRenderbuffer(target : number, attachment : number, renderbuffertarget : number, renderbuffer: GLRenderbuffer): void
	{
		context.framebufferRenderbuffer(target, attachment, renderbuffertarget, renderbuffer);
	}

	public static readonly framebufferTexture2D(target : number, attachment : number, textarget : number, texture: GLTexture, level : number): void
	{
		context.framebufferTexture2D(target, attachment, textarget, texture, level);
	}

	public static readonly framebufferTextureLayer(target : number, attachment : number, texture: GLTexture, level : number, layer : number): void
	{
		context.framebufferTextureLayer(target, attachment, texture, level, layer);
	}

	public static readonly frontFace(mode : number): void
	{
		context.frontFace(mode);
	}

	public static readonly generateMipmap(target : number): void
	{
		context.generateMipmap(target);
	}

	public static readonly getActiveAttrib(program: GLProgram, index : number): GLActiveInfo
{
			return context.getActiveAttrib(program, index);
		}

	public static readonly getActiveUniform(program: GLProgram, index : number): GLActiveInfo
{
			return context.getActiveUniform(program, index);
		}

	public static readonly getActiveUniformBlockName(program: GLProgram, uniformBlockIndex : number): string
{
			return context.getActiveUniformBlockName(program, uniformBlockIndex);
		}

	public static readonly getActiveUniformBlockParameter(program: GLProgram, uniformBlockIndex : number, pname : number): Dynamic
{
			return context.getActiveUniformBlockParameter(program, uniformBlockIndex, pname);
		}

	public static readonly getActiveUniforms(program: GLProgram, uniformIndices: Array < Int >, pname : number): Dynamic
{
			return context.getActiveUniforms(program, uniformIndices, pname);
		}

	public static readonly getAttachedShaders(program: GLProgram): Array < GLShader >
	{
		return context.getAttachedShaders(program);
	}

	public static readonly getAttribLocation(program: GLProgram, name: string) : number
{
			return context.getAttribLocation(program, name);
		}

	public static readonly getBufferParameter(target : number, pname : number): Dynamic
{
			return context.getBufferParameter(target, pname);
		}

	public static readonly getBufferSubDataWEBGL(target : number, srcByteOffset: DataPointer, dstData: Dynamic, ?srcOffset: Dynamic, ?length : number): void
	{
		context.getBufferSubData(target, srcByteOffset, dstData, srcOffset, length);
	}

	public static readonly getContextAttributes(): GLContextAttributes
{
			return context.getContextAttributes();
		}

	public static readonly getError() : number
{
			return context.getError();
		}

	public static readonly getExtension(name: string): Dynamic
{
			return context.getExtension(name);
		}

	public static readonly getFragDataLocation(program: GLProgram, name: string) : number
{
			return context.getFragDataLocation(program, name);
		}

	public static readonly getFramebufferAttachmentParameter(target : number, attachment : number, pname : number): Dynamic
{
			return context.getFramebufferAttachmentParameter(target, attachment, pname);
		}

	public static readonly getIndexedParameter(target : number, index : number): Dynamic
{
			return context.getIndexedParameter(target, index);
		}

	public static readonly getInternalformatParameter(target : number, internalformat : number, pname : number): Dynamic
{
			return context.getInternalformatParameter(target, internalformat, pname);
		}

	public static readonly getParameter(pname : number): Dynamic
{
			return context.getParameter(pname);
		}

	public static readonly getProgramInfoLog(program: GLProgram): string
{
			return context.getProgramInfoLog(program);
		}

	public static readonly getProgramParameter(program: GLProgram, pname : number): Dynamic
{
			return context.getProgramParameter(program, pname);
		}

	public static readonly getQuery(target : number, pname : number): GLQuery
{
			return context.getQuery(target, pname);
		}

	public static readonly getQueryParameter(query: GLQuery, pname : number): Dynamic
{
			return context.getQueryParameter(query, pname);
		}

	public static readonly getRenderbufferParameter(target : number, pname : number): Dynamic
{
			return context.getRenderbufferParameter(target, pname);
		}

	public static readonly getSamplerParameter(sampler: GLSampler, pname : number): Dynamic
{
			return context.getSamplerParameter(sampler, pname);
		}

	public static readonly getShaderInfoLog(shader: GLShader): string
{
			return context.getShaderInfoLog(shader);
		}

	public static readonly getShaderParameter(shader: GLShader, pname : number): Dynamic
{
			return context.getShaderParameter(shader, pname);
		}

	public static readonly getShaderPrecisionFormat(shadertype : number, precisiontype : number): GLShaderPrecisionFormat
{
			return context.getShaderPrecisionFormat(shadertype, precisiontype);
		}

	public static readonly getShaderSource(shader: GLShader): string
{
			return context.getShaderSource(shader);
		}

	public static readonly getSupportedExtensions(): Array < String >
	{
		return context.getSupportedExtensions();
	}

	public static readonly getSyncParameter(sync: GLSync, pname : number): Dynamic
{
			return context.getSyncParameter(sync, pname);
		}

	public static readonly getTexParameter(target : number, pname : number): Dynamic
{
			return context.getTexParameter(target, pname);
		}

	public static readonly getTransformFeedbackVarying(program: GLProgram, index : number): GLActiveInfo
{
			return context.getTransformFeedbackVarying(program, index);
		}

	public static readonly getUniform(program: GLProgram, location: GLUniformLocation): Dynamic
{
			return context.getUniform(program, location);
		}

	public static readonly getUniformBlockIndex(program: GLProgram, uniformBlockName: string) : number
{
			return context.getUniformBlockIndex(program, uniformBlockName);
		}

	public static readonly getUniformIndices(program: GLProgram, uniformNames: Array<string>): Array < Int >
		{
			return context.getUniformIndices(program, uniformNames);
		}

	public static readonly getUniformLocation(program: GLProgram, name: string): GLUniformLocation
{
				return context.getUniformLocation(program, name);
			}

	public static readonly getVertexAttrib(index : number, pname : number): Dynamic
{
				return context.getVertexAttrib(index, pname);
			}

	public static readonly getVertexAttribOffset(index : number, pname : number): DataPointer
{
				return context.getVertexAttribOffset(index, pname);
			}

	public static readonly hint(target : number, mode : number): void
		{
			context.hint(target, mode);
		}

	public static readonly invalidateFramebuffer(target : number, attachments: Array<Int>): void
			{
				context.invalidateFramebuffer(target, attachments);
			}

	public static readonly invalidateSubFramebuffer(target : number, attachments: Array < Int >, x : number, y : number, width : number, height : number): void
		{
			context.invalidateSubFramebuffer(target, attachments, x, y, width, height);
		}

	public static readonly isBuffer(buffer: GLBuffer) : boolean
{
				return context.isBuffer(buffer);
			}

	public static readonly isContextLost() : boolean
{
				return context.isContextLost();
			}

	public static readonly isEnabled(cap : number) : boolean
{
				return context.isEnabled(cap);
			}

	public static readonly isFramebuffer(framebuffer: GLFramebuffer) : boolean
{
				return context.isFramebuffer(framebuffer);
			}

	public static readonly isProgram(program: GLProgram) : boolean
{
				return context.isProgram(program);
			}

	public static readonly isQuery(query: GLQuery) : boolean
{
				return context.isQuery(query);
			}

	public static readonly isRenderbuffer(renderbuffer: GLRenderbuffer) : boolean
{
				return context.isRenderbuffer(renderbuffer);
			}

	public static readonly isSampler(sampler: GLSampler) : boolean
{
				return context.isSampler(sampler);
			}

	public static readonly isShader(shader: GLShader) : boolean
{
				return context.isShader(shader);
			}

	public static readonly isSync(sync: GLSync) : boolean
{
				return context.isSync(sync);
			}

	public static readonly isTexture(texture: GLTexture) : boolean
{
				return context.isTexture(texture);
			}

	public static readonly isTransformFeedback(transformFeedback: GLTransformFeedback) : boolean
{
				return context.isTransformFeedback(transformFeedback);
			}

	public static readonly isVertexArray(vertexArray: GLVertexArrayObject) : boolean
{
				return context.isVertexArray(vertexArray);
			}

	public static readonly lineWidth(width : number): void
		{
			context.lineWidth(width);
		}

	public static readonly linkProgram(program: GLProgram): void
		{
			context.linkProgram(program);
		}

	public static readonly pauseTransformFeedback(): void
		{
			context.pauseTransformFeedback();
		}

	public static readonly pixelStorei(pname : number, param : number): void
		{
			context.pixelStorei(pname, param);
		}

	public static readonly polygonOffset(factor : number, units : number): void
		{
			context.polygonOffset(factor, units);
		}

	public static readonly readBuffer(src : number): void
		{
			context.readBuffer(src);
		}

	public static readonly readPixelsWEBGL(x : number, y : number, width : number, height : number, format : number, type : number, pixels: Dynamic, ?dstOffset : number): void
		{
			context.readPixels(x, y, width, height, format, type, pixels, dstOffset);
		}

	public static readonly renderbufferStorage(target : number, internalformat : number, width : number, height : number): void
		{
			context.renderbufferStorage(target, internalformat, width, height);
		}

	public static readonly renderbufferStorageMultisample(target : number, samples : number, internalformat : number, width : number, height : number): void
		{
			context.renderbufferStorageMultisample(target, samples, internalformat, width, height);
		}

	public static readonly resumeTransformFeedback(): void
		{
			context.resumeTransformFeedback();
		}

	public static readonly sampleCoverage(value : number, invert : boolean): void
		{
			context.sampleCoverage(value, invert);
		}

	public static readonly samplerParameterf(sampler: GLSampler, pname : number, param : number): void
		{
			context.samplerParameterf(sampler, pname, param);
		}

	public static readonly samplerParameteri(sampler: GLSampler, pname : number, param : number): void
		{
			context.samplerParameteri(sampler, pname, param);
		}

	public static readonly scissor(x : number, y : number, width : number, height : number): void
		{
			context.scissor(x, y, width, height);
		}

	public static readonly shaderSource(shader: GLShader, source: string): void
		{
			context.shaderSource(shader, source);
		}

	public static readonly stencilFunc(func : number, ref : number, mask : number): void
		{
			context.stencilFunc(func, ref, mask);
		}

	public static readonly stencilFuncSeparate(face : number, func : number, ref : number, mask : number): void
		{
			context.stencilFuncSeparate(face, func, ref, mask);
		}

	public static readonly stencilMask(mask : number): void
		{
			context.stencilMask(mask);
		}

	public static readonly stencilMaskSeparate(face : number, mask : number): void
		{
			context.stencilMaskSeparate(face, mask);
		}

	public static readonly stencilOp(fail : number, zfail : number, zpass : number): void
		{
			context.stencilOp(fail, zfail, zpass);
		}

	public static readonly stencilOpSeparate(face : number, fail : number, zfail : number, zpass : number): void
		{
			context.stencilOpSeparate(face, fail, zfail, zpass);
		}

	public static readonly texImage2DWEBGL(target : number, level : number, internalformat : number, width : number, height : number, border: Dynamic, ?format : number, ?type : number,
			?srcData: Dynamic, ?srcOffset : number): void
		{
			context.texImage2D(target, level, internalformat, width, height, border, format, type, srcData, srcOffset);
		}

	public static readonly texImage3DWEBGL(target : number, level : number, internalformat : number, width : number, height : number, depth : number, border : number, format : number,
			type : number, srcData: Dynamic, ?srcOffset : number): void
		{
			context.texImage3D(target, level, internalformat, width, height, depth, border, format, type, srcData, srcOffset);
		}

	public static readonly texStorage2D(target : number, level : number, internalformat : number, width : number, height : number): void
		{
			context.texStorage2D(target, level, internalformat, width, height);
		}

	public static readonly texStorage3D(target : number, level : number, internalformat : number, width : number, height : number, depth : number): void
		{
			context.texStorage3D(target, level, internalformat, width, height, depth);
		}

	public static readonly texParameterf(target : number, pname : number, param : number): void
		{
			context.texParameterf(target, pname, param);
		}

	public static readonly texParameteri(target : number, pname : number, param : number): void
		{
			context.texParameteri(target, pname, param);
		}

	public static readonly texSubImage2DWEBGL(target : number, level : number, xoffset : number, yoffset : number, width : number, height : number, format: Dynamic, ?type : number,
			?srcData: Dynamic, ?srcOffset : number): void
		{
			context.texSubImage2D(target, level, xoffset, yoffset, width, height, format, type, srcData, srcOffset);
		}

	public static readonly texSubImage3DWEBGL(target : number, level : number, xoffset : number, yoffset : number, zoffset : number, width : number, height : number, depth : number,
			format : number, type : number, source: Dynamic, ?srcOffset : number): void
		{
			context.texSubImage3D(target, level, xoffset, yoffset, zoffset, width, height, depth, format, type, source, srcOffset);
		}

	public static readonly transformFeedbackVaryings(program: GLProgram, varyings: Array < String >, bufferMode : number): void
		{
			context.transformFeedbackVaryings(program, varyings, bufferMode);
		}

	public static readonly uniform1f(location: GLUniformLocation, v0 : number): void
		{
			context.uniform1f(location, v0);
		}

	public static readonly uniform1fvWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform1fv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform1i(location: GLUniformLocation, v0 : number): void
		{
			context.uniform1i(location, v0);
		}

	public static readonly uniform1ivWEBGL(location: GLUniformLocation, ?data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform1iv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform1ui(location: GLUniformLocation, v0 : number): void
		{
			context.uniform1ui(location, v0);
		}

	public static readonly uniform1uivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform1uiv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform2f(location: GLUniformLocation, v0 : number, v1 : number): void
		{
			context.uniform2f(location, v0, v1);
		}

	public static readonly uniform2fvWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform2fv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform2i(location: GLUniformLocation, x : number, y : number): void
		{
			context.uniform2i(location, x, y);
		}

	public static readonly uniform2ivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform2iv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform2ui(location: GLUniformLocation, x : number, y : number): void
		{
			context.uniform2ui(location, x, y);
		}

	public static readonly uniform2uivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform2uiv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform3f(location: GLUniformLocation, v0 : number, v1 : number, v2 : number): void
		{
			context.uniform3f(location, v0, v1, v2);
		}

	public static readonly uniform3fvWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform3fv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform3i(location: GLUniformLocation, v0 : number, v1 : number, v2 : number): void
		{
			context.uniform3i(location, v0, v1, v2);
		}

	public static readonly uniform3ivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform3iv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform3ui(location: GLUniformLocation, v0 : number, v1 : number, v2 : number): void
		{
			context.uniform3ui(location, v0, v1, v2);
		}

	public static readonly uniform3uivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform3uiv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform4f(location: GLUniformLocation, v0 : number, v1 : number, v2 : number, v3 : number): void
		{
			context.uniform4f(location, v0, v1, v2, v3);
		}

	public static readonly uniform4fvWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform4fv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform4i(location: GLUniformLocation, v0 : number, v1 : number, v2 : number, v3 : number): void
		{
			context.uniform4i(location, v0, v1, v2, v3);
		}

	public static readonly uniform4ivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform4iv(location, data, srcOffset, srcLength);
		}

	public static readonly uniform4ui(location: GLUniformLocation, v0 : number, v1 : number, v2 : number, v3 : number): void
		{
			context.uniform4ui(location, v0, v1, v2, v3);
		}

	public static readonly uniform4uivWEBGL(location: GLUniformLocation, data: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniform4uiv(location, data, srcOffset, srcLength);
		}

	public static readonly uniformBlockBinding(program: GLProgram, uniformBlockIndex : number, uniformBlockBinding : number): void
		{
			context.uniformBlockBinding(program, uniformBlockIndex, uniformBlockBinding);
		}

	public static readonly uniformMatrix2fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix2fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix2x3fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix2x3fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix2x4fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix2x4fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix3fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix3fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix3x2fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix3x2fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix3x4fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix3x4fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix4fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix4fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix4x2fvWEBGL(location: GLUniformLocation, transpose : boolean, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix4x2fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly uniformMatrix4x3fvWEBGL(location: GLUniformLocation, transpose: Dynamic, v: Dynamic, ?srcOffset : number, ?srcLength : number): void
		{
			context.uniformMatrix4x3fv(location, transpose, v, srcOffset, srcLength);
		}

	public static readonly useProgram(program: GLProgram): void
		{
			context.useProgram(program);
		}

	public static readonly validateProgram(program: GLProgram): void
		{
			context.validateProgram(program);
		}

	public static readonly vertexAttrib1f(index : number, v0 : number): void
		{
			context.vertexAttrib1f(index, v0);
		}

	public static readonly vertexAttrib1fv(index : number, v: #if(!js || !html5 || doc_gen) DataPointer #else Dynamic #end): void
		{
			#if!doc_gen
	context.vertexAttrib1fv(index, v);
			#end
}

	public static readonly vertexAttrib1fvWEBGL(index : number, v: Dynamic): void
		{
			context.vertexAttrib1fv(index, v);
		}

	public static readonly vertexAttrib2f(index : number, v0 : number, v1 : number): void
		{
			context.vertexAttrib2f(index, v0, v1);
		}

	public static readonly vertexAttrib2fv(index : number, v: #if(!js || !html5 || doc_gen) DataPointer #else Dynamic #end): void
		{
			context.vertexAttrib2fv(index, v);
		}

	public static readonly vertexAttrib2fvWEBGL(index : number, v: Dynamic): void
		{
			context.vertexAttrib2fv(index, v);
		}

	public static readonly vertexAttrib3f(index : number, v0 : number, v1 : number, v2 : number): void
		{
			context.vertexAttrib3f(index, v0, v1, v2);
		}

	public static readonly vertexAttrib3fv(index : number, v: #if(!js || !html5 || doc_gen) DataPointer #else Dynamic #end): void
		{
			context.vertexAttrib3fv(index, v);
		}

	public static readonly vertexAttrib3fvWEBGL(index : number, v: Dynamic): void
		{
			context.vertexAttrib3fv(index, v);
		}

	public static readonly vertexAttrib4f(index : number, v0 : number, v1 : number, v2 : number, v3 : number): void
		{
			context.vertexAttrib4f(index, v0, v1, v2, v3);
		}

	public static readonly vertexAttrib4fv(index : number, v: #if(!js || !html5 || doc_gen) DataPointer #else Dynamic #end): void
		{
			context.vertexAttrib4fv(index, v);
		}

	public static readonly vertexAttrib4fvWEBGL(index : number, v: Dynamic): void
		{
			context.vertexAttrib4fv(index, v);
		}

	public static readonly vertexAttribDivisor(index : number, divisor : number): void
		{
			context.vertexAttribDivisor(index, divisor);
		}

	public static readonly vertexAttribI4i(index : number, v0 : number, v1 : number, v2 : number, v3 : number): void
		{
			context.vertexAttribI4i(index, v0, v1, v2, v3);
		}

	public static readonly vertexAttribI4iv(index : number, v: #if(!js || !html5 || doc_gen) DataPointer #else Dynamic #end): void
		{
			context.vertexAttribI4iv(index, v);
		}

	public static readonly vertexAttribI4ivWEBGL(index : number, v: Dynamic): void
		{
			context.vertexAttribI4iv(index, v);
		}

	public static readonly vertexAttribI4ui(index : number, v0 : number, v1 : number, v2 : number, v3 : number): void
		{
			context.vertexAttribI4ui(index, v0, v1, v2, v3);
		}

	public static readonly vertexAttribI4uiv(index : number, v: #if(!js || !html5 || doc_gen) DataPointer #else Dynamic #end): void
		{
			context.vertexAttribI4uiv(index, v);
		}

	public static readonly vertexAttribI4uivWEBGL(index : number, v: Dynamic): void
		{
			context.vertexAttribI4uiv(index, v);
		}

	public static readonly vertexAttribIPointer(index : number, size : number, type : number, stride : number, offset: DataPointer): void
		{
			context.vertexAttribIPointer(index, size, type, stride, offset);
		}

	public static readonly vertexAttribPointer(index : number, size : number, type : number, normalized : boolean, stride : number, offset: DataPointer): void
		{
			context.vertexAttribPointer(index, size, type, normalized, stride, offset);
		}

	public static readonly viewport(x : number, y : number, width : number, height : number): void
		{
			context.viewport(x, y, width, height);
		}

	public static readonly waitSync(sync: GLSync, flags : number, timeout: #if(!js || !html5 || doc_gen) Int64 #else Dynamic #end): void
		{
			context.waitSync(sync, flags, timeout);
		}

	private static readonly __getObjectID(object: #if(!js || !html5 || doc_gen) GLObject #else Dynamic #end) : number
{
				return(object == null) ? 0 : @: privateAccess object.id;
}
}
#end
