package openfl.display3D;


import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl._internal.stage3D.opengl.GLContext3D;
import openfl._internal.stage3D.Context3DStateCache;
import openfl._internal.stage3D.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.VideoTexture;
import openfl.display.BitmapData;
import openfl.display.Stage3D;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.textures.VideoTexture)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)


@:final class Context3D extends EventDispatcher {
	
	
	public static var supportsVideoTexture (default, null):Bool = #if (js && html5) true #else false #end;
	
	private static inline var MAX_SAMPLERS = 8;
	private static inline var MAX_ATTRIBUTES = 16;
	private static inline var MAX_PROGRAM_REGISTERS = 128;
	
	private static var TEXTURE_MAX_ANISOTROPY_EXT:Int = 0;
	private static var DEPTH_STENCIL:Int = 0;
	
	private static var __stateCache:Context3DStateCache = new Context3DStateCache ();
	
	public var backBufferHeight (default, null):Int = 0;
	public var backBufferWidth (default, null):Int = 0;
	public var driverInfo (default, null):String = "OpenGL (Direct blitting)";
	public var enableErrorChecking (get, set):Bool;
	public var maxBackBufferHeight (default, null):Int;
	public var maxBackBufferWidth (default, null):Int;
	public var profile (default, null):Context3DProfile = BASELINE;
	public var totalGPUMemory (default, null):Int = 0;
	
	private var __backBufferAntiAlias:Int;
	private var __backBufferEnableDepthAndStencil:Bool;
	private var __backBufferWantsBestResolution:Bool;
	private var __depthRenderBuffer:GLRenderbuffer;
	private var __depthStencilRenderBuffer:GLRenderbuffer;
	private var __enableErrorChecking:Bool;
	private var __fragmentConstants:Float32Array;
	private var __framebuffer:GLFramebuffer;
	private var __frameCount:Int;
	private var __maxAnisotropyCubeTexture:Int;
	private var __maxAnisotropyTexture2D:Int;
	private var __positionScale:Float32Array;
	private var __program:Program3D;
	private var __renderSession:RenderSession;
	private var __renderToTexture:TextureBase;
	private var __rttDepthAndStencil:Bool;
	private var __samplerDirty:Int;
	private var __samplerTextures:Vector<TextureBase>;
	private var __samplerStates:Array<SamplerState>;
	private var __scissorRectangle:Rectangle;
	private var __stage3D:Stage3D;
	private var __stats:Vector<Int>;
	private var __statsCache:Vector<Int>;
	private var __stencilCompareMode:Context3DCompareMode;
	private var __stencilRef:Int;
	private var __stencilReadMask:Int;
	private var __stencilRenderBuffer:GLRenderbuffer;
	private var __supportsAnisotropicFiltering:Bool;
	private var __supportsPackedDepthStencil:Bool;
	private var __vertexConstants:Float32Array;
	
	#if telemetry
	//private var __spanPresent:Telemetry.Span;
	//private var __statsValues:Array<Telemetry.Value>;
	//private var __valueFrame:Telemetry.Value;
	#end
	
	
	private function new (stage3D:Stage3D, renderSession:RenderSession) {
		
		super ();
		
		__stage3D = stage3D;
		__renderSession = renderSession;
		
		GLContext3D.create (this);
		
	}
	
	
	public function clear (red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = Context3DClearMask.ALL):Void {
		
		GLContext3D.clear (this, red, green, blue, alpha, depth, stencil, mask);
		
	}
	
	
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		GLContext3D.configureBackBuffer (this, width, height, antiAlias, enableDepthAndStencil, wantsBestResolution, wantsBestResolutionOnBrowserZoom);
		
	}
	
	
	public function createCubeTexture (size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture {
		
		return new CubeTexture (this, size, format, optimizeForRenderToTexture, streamingLevels);
		
	}
	
	
	public function createIndexBuffer (numIndices:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):IndexBuffer3D {
		
		return new IndexBuffer3D (this, numIndices, bufferUsage);
		
	}
	
	
	public function createProgram ():Program3D {
		
		return new Program3D (this);
		
	}
	
	
	public function createRectangleTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool):RectangleTexture {
		
		return new RectangleTexture (this, width, height, format, optimizeForRenderToTexture);
		
	}
	
	
	public function createTexture (width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture {
		
		return new Texture (this, width, height, format, optimizeForRenderToTexture, streamingLevels);
		
	}
	
	
	public function createVertexBuffer (numVertices:Int, data32PerVertex:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):VertexBuffer3D {
		
		return new VertexBuffer3D (this, numVertices, data32PerVertex, bufferUsage);
		
	}
	
	
	public function createVideoTexture ():VideoTexture {
		
		#if (js && html5)
		return new VideoTexture (this);
		#else
		throw new Error ("Video textures are not supported on this platform");
		#end
		
	}
	
	
	public function dispose (recreate:Bool = true):Void {
		
		GLContext3D.dispose (this, recreate);
		
	}
	
	
	public function drawToBitmapData (destination:BitmapData):Void {
		
		if (destination == null) return;
		
		GLContext3D.drawToBitmapData (this, destination);
		
	}
	
	
	public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {
		
		if (__program == null) {
			
			return;
			
		}
		
		GLContext3D.drawTriangles (this, indexBuffer, firstIndex, numTriangles);
		
	}
	
	
	
	public function present ():Void {
		
		GLContext3D.present (this);
		
	}
	
	
	public function setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void {
		
		GLContext3D.setBlendFactors (this, sourceFactor, destinationFactor);
		
	}
	
	
	public function setColorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		GLContext3D.setColorMask (this, red, green, blue, alpha);
		
	}
	
	
	public function setCulling (triangleFaceToCull:Context3DTriangleFace):Void {
		
		GLContext3D.setCulling (this, triangleFaceToCull);
		
	}
	
	
	public function setDepthTest (depthMask:Bool, passCompareMode:Context3DCompareMode):Void {
		
		GLContext3D.setDepthTest (this, depthMask, passCompareMode);
		
	}
	
	
	public function setProgram (program:Program3D):Void {
		
		if (program == null) {
			
			throw new IllegalOperationError ();
			
		}
		
		GLContext3D.setProgram (this, program);
		
	}
	
	
	public function setProgramConstantsFromByteArray (programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void {
		
		if (numRegisters == 0) return;
		
		GLContext3D.setProgramConstantsFromByteArray (this, programType, firstRegister, numRegisters, data, byteArrayOffset);
		
	}
	
	
	public function setProgramConstantsFromMatrix (programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void {
		
		GLContext3D.setProgramConstantsFromMatrix (this, programType, firstRegister, matrix, transposedMatrix);
		
	}
	
	
	public function setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void {
		
		if (numRegisters == 0) return;
		
		GLContext3D.setProgramConstantsFromVector (this, programType, firstRegister, data, numRegisters);
		
	}
	
	
	public function setRenderToBackBuffer ():Void {
		
		GLContext3D.setRenderToBackBuffer (this);
		
	}
	
	
	public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0):Void {
		
		GLContext3D.setRenderToTexture (this, texture, enableDepthAndStencil, antiAlias, surfaceSelector);
		
	}
	
	
	public function setSamplerStateAt (sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		GLContext3D.setSamplerStateAt (this, sampler, wrap, filter, mipfilter);
		
	}
	
	
	public function setScissorRectangle (rectangle:Rectangle):Void {
		
		GLContext3D.setScissorRectangle (this, rectangle);
		
	}
	
	
	public function setStencilActions (triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS, actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP, actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void {
		
		GLContext3D.setStencilActions (this, triangleFace, compareMode, actionOnBothPass, actionOnDepthFail, actionOnDepthPassStencilFail);
		
	}
	
	
	public function setStencilReferenceValue (referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void {
		
		GLContext3D.setStencilReferenceValue (this, referenceValue, readMask, writeMask);
		
	}
	
	
	public function setTextureAt (sampler:Int, texture:TextureBase):Void {
		
		GLContext3D.setTextureAt (this, sampler, texture);
		
	}
	
	
	public function setVertexBufferAt (index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void {
		
		GLContext3D.setVertexBufferAt (this, index, buffer, bufferOffset, format);
		
	}
	
	
	private function __updateBackbufferViewport ():Void {
		
		GLContext3D.__updateBackbufferViewportTEMP (this);
		
	}
	
	
	private function __updateBlendFactors ():Void {
		
		GLContext3D.__updateBlendFactorsTEMP (this);
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	private function get_enableErrorChecking ():Bool {
		
		return __enableErrorChecking;
		
	}
	
	
	private function set_enableErrorChecking (value:Bool):Bool {
		
		GLContext3D.setEnableErrorChecking (value);
		return __enableErrorChecking = value;
		
	}
	
	
}


@:enum abstract Context3DTelemetry(Int) to Int {
	
	public var DRAW_CALLS = 0;
	public var COUNT_INDEX_BUFFER = 1;
	public var COUNT_VERTEX_BUFFER = 2;
	public var COUNT_TEXTURE = 3;
	public var COUNT_TEXTURE_COMPRESSED = 4;
	public var COUNT_PROGRAM = 5;
	public var MEM_INDEX_BUFFER = 6;
	public var MEM_VERTEX_BUFFER = 7;
	public var MEM_TEXTURE = 8;
	public var MEM_TEXTURE_COMPRESSED = 9;
	public var MEM_PROGRAM = 10;
	
	public static inline var length = 11;
	
}