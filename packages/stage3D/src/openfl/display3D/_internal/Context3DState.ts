import SamplerState from "../../../_internal/renderer/SamplerState";
import TextureBase from "../../../display3D/textures/TextureBase";
import Context3DBlendFactor from "../../../display3D/Context3DBlendFactor";
import Context3DCompareMode from "../../../display3D/Context3DCompareMode";
import Context3DStencilAction from "../../../display3D/Context3DStencilAction";
import Context3DTriangleFace from "../../../display3D/Context3DTriangleFace";
import Program3D from "../../../display3D/Program3D";
import Shader from "../../../display/Shader";
import Rectangle from "../../../geom/Rectangle";

export default class Context3DState
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
	public stencilReadMask: number;
	public stencilReferenceValue: number;
	public stencilTriangleFace: Context3DTriangleFace;
	public stencilWriteMask: number;
	public textures: Array<TextureBase>;
	// vertex buffer at?
	public shader: Shader; // TODO: Merge shader/program3d

	private __currentGLArrayBuffer: WebGLBuffer;
	private __currentGLElementArrayBuffer: WebGLBuffer;
	private __currentGLFramebuffer: WebGLFramebuffer;
	private __currentGLTexture2D: WebGLTexture;
	private __currentGLTextureCubeMap: WebGLTexture;
	private __enableGLBlend: boolean;
	private __enableGLCullFace: boolean;
	private __enableGLDepthTest: boolean;
	private __enableGLScissorTest: boolean;
	private __enableGLStencilTest: boolean;
	private __frontFaceGLCCW: boolean;
	private __glBlendEquation: number;
	private __primaryGLFramebuffer: WebGLFramebuffer;
	private __rttDepthGLRenderbuffer: WebGLRenderbuffer;
	private __rttGLFramebuffer: WebGLFramebuffer;
	private __rttGLRenderbuffer: WebGLRenderbuffer;
	private __rttStencilGLRenderbuffer: WebGLRenderbuffer;

	public constructor()
	{
		this.backBufferEnableDepthAndStencil = false;
		this.blendDestinationAlphaFactor = Context3DBlendFactor.ZERO;
		this.blendSourceAlphaFactor = Context3DBlendFactor.ONE;
		this.blendDestinationRGBFactor = Context3DBlendFactor.ZERO;
		this.blendSourceRGBFactor = Context3DBlendFactor.ONE;
		this.colorMaskRed = true;
		this.colorMaskGreen = true;
		this.colorMaskBlue = true;
		this.colorMaskAlpha = true;
		this.culling = Context3DTriangleFace.NONE;
		this.depthCompareMode = Context3DCompareMode.LESS;
		this.depthMask = true;
		this.samplerStates = new Array();
		this.scissorRectangle = new Rectangle();
		this.stencilCompareMode = Context3DCompareMode.ALWAYS;
		this.stencilDepthFail = Context3DStencilAction.KEEP;
		this.stencilFail = Context3DStencilAction.KEEP;
		this.stencilPass = Context3DStencilAction.KEEP;
		this.stencilReadMask = 0xFF;
		this.stencilReferenceValue = 0;
		this.stencilTriangleFace = Context3DTriangleFace.FRONT_AND_BACK;
		this.stencilWriteMask = 0xFF;
		this.textures = new Array();

		this.__frontFaceGLCCW = true;
		this.__glBlendEquation = 0x8006; // GL.FUNC_ADD
	}
}
