package openfl._internal.renderer.context3D;


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GL;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Program3D;
import openfl.geom.Rectangle;


class Context3DState {
	
	
	public var backBufferEnableDepthAndStencil:Bool;
	public var blendDestinationFactor:Context3DBlendFactor;
	public var blendSourceFactor:Context3DBlendFactor;
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
	
	
	public function new () {
		
		backBufferEnableDepthAndStencil = false;
		blendDestinationFactor = ZERO;
		blendSourceFactor = ONE;
		colorMaskRed = true;
		colorMaskGreen = true;
		colorMaskBlue = true;
		colorMaskAlpha = true;
		culling = NONE;
		depthCompareMode = LESS;
		depthMask = true;
		samplerStates = new Array ();
		scissorRectangle = new Rectangle ();
		stencilCompareMode = ALWAYS;
		stencilDepthFail = KEEP;
		stencilFail = KEEP;
		stencilPass = KEEP;
		stencilReadMask = 0xFF;
		stencilReferenceValue = 0;
		stencilTriangleFace = FRONT_AND_BACK;
		stencilWriteMask = 0xFF;
		textures = new Array ();
		__frontFaceGLCCW = true;
		__glBlendEquation = GL.FUNC_ADD;
		
	}
	
	
}