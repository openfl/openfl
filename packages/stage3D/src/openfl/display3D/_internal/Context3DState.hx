package openfl.display3D._internal;

import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import openfl._internal.renderer.SamplerState;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Program3D;
import openfl.display.Shader;
import openfl.geom.Rectangle;

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

	#if openfl_gl
	public var __currentGLArrayBuffer:GLBuffer;
	public var __currentGLElementArrayBuffer:GLBuffer;
	public var __currentGLFramebuffer:GLFramebuffer;
	public var __currentGLTexture2D:GLTexture;
	public var __currentGLTextureCubeMap:GLTexture;
	public var __enableGLBlend:Bool;
	public var __enableGLCullFace:Bool;
	public var __enableGLDepthTest:Bool;
	public var __enableGLScissorTest:Bool;
	public var __enableGLStencilTest:Bool;
	public var __frontFaceGLCCW:Bool;
	public var __glBlendEquation:Int;
	public var __primaryGLFramebuffer:GLFramebuffer;
	public var __rttDepthGLRenderbuffer:GLRenderbuffer;
	public var __rttGLFramebuffer:GLFramebuffer;
	public var __rttGLRenderbuffer:GLRenderbuffer;
	public var __rttStencilGLRenderbuffer:GLRenderbuffer;
	#end

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

		#if openfl_gl
		__frontFaceGLCCW = true;
		__glBlendEquation = 0x8006; // GL.FUNC_ADD
		#end
	}
}
