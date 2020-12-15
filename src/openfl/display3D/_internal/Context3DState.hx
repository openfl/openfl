package openfl.display3D._internal;

import openfl.display3D._internal.GLBuffer;
import openfl.display3D._internal.GLFramebuffer;
import openfl.display3D._internal.GLRenderbuffer;
import openfl.display3D._internal.GLTexture;
import openfl.display._internal.SamplerState;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Program3D;
import openfl.display.Shader;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.opengl.GL;
#end

@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DState
{
	public var backBufferEnableDepthAndStencil:Bool;
	public var blendDestinationAlphaFactor:Context3DBlendFactor;
	public var blendSourceAlphaFactor:Context3DBlendFactor;
	public var blendDestinationRGBFactor:Context3DBlendFactor;
	public var blendSourceRGBFactor:Context3DBlendFactor;
	public var colorMaskRed:Bool;
	public var colorMaskGreen:Bool;
	public var colorMaskBlue:Bool;
	public var colorMaskAlpha:Bool;
	public var culling:Context3DTriangleFace;
	public var depthCompareMode:Context3DCompareMode;
	public var depthMask:Bool;
	// public var fillMode:Context3DFillMode;
	public var program:Program3D;
	// program constants?
	public var renderToTexture:TextureBase;
	public var renderToTextureAntiAlias:Int;
	public var renderToTextureDepthStencil:Bool;
	public var renderToTextureSurfaceSelector:Int;
	public var samplerStates:Array<SamplerState>;
	public var scissorEnabled:Bool;
	public var scissorRectangle:Rectangle;
	public var stencilCompareMode:Context3DCompareMode;
	public var stencilDepthFail:Context3DStencilAction;
	public var stencilFail:Context3DStencilAction;
	public var stencilPass:Context3DStencilAction;
	public var stencilReadMask:UInt;
	public var stencilReferenceValue:UInt;
	public var stencilTriangleFace:Context3DTriangleFace;
	public var stencilWriteMask:UInt;
	public var textures:Array<TextureBase>;
	// vertex buffer at?
	public var shader:Shader; // TODO: Merge shader/program3d

	private var __currentGLArrayBuffer:GLBuffer;
	private var __currentGLElementArrayBuffer:GLBuffer;
	private var __currentGLFramebuffer:GLFramebuffer;
	private var __currentGLTexture2D:GLTexture;
	private var __currentGLTextureCubeMap:GLTexture;
	private var __enableGLBlend:Bool;
	private var __enableGLCullFace:Bool;
	private var __enableGLDepthTest:Bool;
	private var __enableGLScissorTest:Bool;
	private var __enableGLStencilTest:Bool;
	private var __frontFaceGLCCW:Bool;
	private var __glBlendEquation:Int;
	private var __primaryGLFramebuffer:GLFramebuffer;
	private var __rttDepthGLRenderbuffer:GLRenderbuffer;
	private var __rttGLFramebuffer:GLFramebuffer;
	private var __rttGLRenderbuffer:GLRenderbuffer;
	private var __rttStencilGLRenderbuffer:GLRenderbuffer;

	public function new()
	{
		backBufferEnableDepthAndStencil = false;
		blendDestinationAlphaFactor = ZERO;
		blendSourceAlphaFactor = ONE;
		blendDestinationRGBFactor = ZERO;
		blendSourceRGBFactor = ONE;
		colorMaskRed = true;
		colorMaskGreen = true;
		colorMaskBlue = true;
		colorMaskAlpha = true;
		culling = NONE;
		depthCompareMode = LESS;
		depthMask = true;
		samplerStates = new Array();
		scissorRectangle = new Rectangle();
		stencilCompareMode = ALWAYS;
		stencilDepthFail = KEEP;
		stencilFail = KEEP;
		stencilPass = KEEP;
		stencilReadMask = 0xFF;
		stencilReferenceValue = 0;
		stencilTriangleFace = FRONT_AND_BACK;
		stencilWriteMask = 0xFF;
		textures = new Array();
		__frontFaceGLCCW = true;

		#if lime
		__glBlendEquation = GL.FUNC_ADD;
		#end
	}
}
