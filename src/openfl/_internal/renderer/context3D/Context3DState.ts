namespace openfl._internal.renderer.context3D;

import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GLFramebuffer;
import openfl._internal.bindings.gl.GLRenderbuffer;
import openfl._internal.bindings.gl.GLTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Program3D;
import openfl.display.Shader;
import Rectangle from "openfl/geom/Rectangle";

@SuppressWarnings("checkstyle:FieldDocComment")
class Context3DState
{
	public backBufferEnableDepthAndStencil: boolean;
	public blendDestinationAlphaFactor: Context3DBlendFactor;
	public blendSourceAlphaFactor: Context3DBlendFactor;
	public blendDestinationRGBFactor: Context3DBlendFactor;
	public blendSourceRGBFactor: Context3DBlendFactor;
	public colorMaskRed: boolean;
	public colorMaskGreen: boolean;
	public colorMaskBlue: boolean;
	public colorMaskAlpha: boolean;
	public culling: Context3DTriangleFace;
	public depthCompareMode: Context3DCompareMode;
	public depthMask: boolean;
	// public fillMode:Context3DFillMode;
	public program: Program3D;
	// program constants?
	public renderToTexture: TextureBase;
	public renderToTextureAntiAlias: number;
	public renderToTextureDepthStencil: boolean;
	public renderToTextureSurfaceSelector: number;
	public samplerStates: Array<SamplerState>;
	public scissorEnabled: boolean;
	public scissorRectangle: Rectangle;
	public stencilCompareMode: Context3DCompareMode;
	public stencilDepthFail: Context3DStencilAction;
	public stencilFail: Context3DStencilAction;
	public stencilPass: Context3DStencilAction;
	public stencilReadMask: UInt;
	public stencilReferenceValue: UInt;
	public stencilTriangleFace: Context3DTriangleFace;
	public stencilWriteMask: UInt;
	public textures: Array<TextureBase>;
	// vertex buffer at?
	public shader: Shader; // TODO: Merge shader/program3d

	#if openfl_gl
	private __currentGLArrayBuffer: GLBuffer;
	private __currentGLElementArrayBuffer: GLBuffer;
	private __currentGLFramebuffer: GLFramebuffer;
	private __currentGLTexture2D: GLTexture;
	private __currentGLTextureCubeMap: GLTexture;
	private __enableGLBlend: boolean;
	private __enableGLCullFace: boolean;
	private __enableGLDepthTest: boolean;
	private __enableGLScissorTest: boolean;
	private __enableGLStencilTest: boolean;
	private __frontFaceGLCCW: boolean;
	private __glBlendEquation: number;
	private __primaryGLFramebuffer: GLFramebuffer;
	private __rttDepthGLRenderbuffer: GLRenderbuffer;
	private __rttGLFramebuffer: GLFramebuffer;
	private __rttGLRenderbuffer: GLRenderbuffer;
	private __rttStencilGLRenderbuffer: GLRenderbuffer;
	#end

	public new()
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
