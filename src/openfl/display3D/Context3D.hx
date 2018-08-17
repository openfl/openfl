package openfl.display3D; #if !flash


import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLProgram;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import lime.utils.Float32Array;
import openfl._internal.renderer.opengl.GLContext3D;
import openfl._internal.renderer.opengl.Context3DStateCache;
import openfl._internal.formats.agal.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.VideoTexture;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.display.Stage3D;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

#if (lime >= "7.0.0")
import lime.graphics.RenderContext;
import lime.graphics.WebGLRenderContext;
#else
import lime.graphics.GLRenderContext;
#end

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
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.Stage)


@:final class Context3D extends EventDispatcher {
	
	
	public static var supportsVideoTexture (default, null):Bool = #if (js && html5) true #else false #end;
	
	@:noCompletion private static inline var MAX_SAMPLERS = 8;
	@:noCompletion private static inline var MAX_ATTRIBUTES = 16;
	@:noCompletion private static inline var MAX_PROGRAM_REGISTERS = 128;
	
	@:noCompletion private static var TEXTURE_MAX_ANISOTROPY_EXT:Int = 0;
	@:noCompletion private static var DEPTH_STENCIL:Int = 0;
	
	@:noCompletion private static var __stateCache:Context3DStateCache = new Context3DStateCache ();
	
	public var backBufferHeight (default, null):Int = 0;
	public var backBufferWidth (default, null):Int = 0;
	public var driverInfo (default, null):String = "OpenGL (Direct blitting)";
	public var enableErrorChecking (get, set):Bool;
	public var maxBackBufferHeight (default, null):Int;
	public var maxBackBufferWidth (default, null):Int;
	public var profile (default, null):Context3DProfile = BASELINE;
	public var totalGPUMemory (default, null):Int = 0;
	
	
	@:noCompletion private var __backBufferAntiAlias:Int;
	@:noCompletion private var __backBufferEnableDepthAndStencil:Bool;
	@:noCompletion private var __backBufferWantsBestResolution:Bool;
	@:noCompletion private var __depthRenderBuffer:GLRenderbuffer;
	@:noCompletion private var __depthStencilRenderBuffer:GLRenderbuffer;
	@:noCompletion private var __enableErrorChecking:Bool;
	@:noCompletion private var __context:#if (lime >= "7.0.0") RenderContext #else Dynamic #end;
	@:noCompletion private var __culling:Context3DTriangleFace = NONE;
	@:noCompletion private var __fragmentConstants:Float32Array;
	@:noCompletion private var __framebuffer:GLFramebuffer;
	@:noCompletion private var __frameCount:Int;
	@:noCompletion private var __gl:#if (lime >= "7.0.0") WebGLRenderContext #else GLRenderContext #end;
	@:noCompletion private var __glActiveTexture:Int;
	@:noCompletion private var __glBlendColor:Array<Float>;
	@:noCompletion private var __glBlendEquation:Int;
	@:noCompletion private var __glBlendEquationSeparate:Array<Int>;
	@:noCompletion private var __glBlendFunc:Array<Int>;
	@:noCompletion private var __glBlendFuncSeparate:Array<Int>;
	@:noCompletion private var __glBuffers:Map<Int, GLBuffer>;
	@:noCompletion private var __glClearColor:Array<Float>;
	@:noCompletion private var __glClearDepth:Float;
	@:noCompletion private var __glColorMask:Array<Bool>;
	@:noCompletion private var __glCullFace:Int;
	@:noCompletion private var __glDepthFunc:Int;
	@:noCompletion private var __glDepthMask:Bool;
	@:noCompletion private var __glEnabled:Map<Int, Bool>;
	@:noCompletion private var __glFramebuffers:Map<Int, GLFramebuffer>;
	@:noCompletion private var __glFrontFace:Int;
	@:noCompletion private var __glProgram:GLProgram;
	@:noCompletion private var __glRenderbuffers:Map<Int, GLRenderbuffer>;
	@:noCompletion private var __glScissorHeight:Int;
	@:noCompletion private var __glScissorWidth:Int;
	@:noCompletion private var __glScissorX:Int;
	@:noCompletion private var __glScissorY:Int;
	@:noCompletion private var __glStencilFunc:Array<Int>;
	@:noCompletion private var __glStencilMask:Int;
	@:noCompletion private var __glStencilOp:Array<Int>;
	@:noCompletion private var __glStencilOpSeparate:Array<Int>;
	@:noCompletion private var __glTextures:Map<Int, GLTexture>;
	@:noCompletion private var __glViewportHeight:Int;
	@:noCompletion private var __glViewportWidth:Int;
	@:noCompletion private var __glViewportX:Int;
	@:noCompletion private var __glViewportY:Int;
	@:noCompletion private var __maxAnisotropyCubeTexture:Int;
	@:noCompletion private var __maxAnisotropyTexture2D:Int;
	@:noCompletion private var __positionScale:Float32Array;
	@:noCompletion private var __program:Program3D;
	@:noCompletion private var __renderToTexture:TextureBase;
	@:noCompletion private var __rttDepthAndStencil:Bool;
	@:noCompletion private var __samplerDirty:Int;
	@:noCompletion private var __samplerTextures:Vector<TextureBase>;
	@:noCompletion private var __samplerStates:Array<SamplerState>;
	@:noCompletion private var __scissorRectangle:Rectangle;
	@:noCompletion private var __stage:Stage;
	// @:noCompletion private var __stage3D:Stage3D;
	@:noCompletion private var __stats:Vector<Int>;
	@:noCompletion private var __statsCache:Vector<Int>;
	@:noCompletion private var __stencilCompareMode:Context3DCompareMode;
	@:noCompletion private var __stencilRef:Int;
	@:noCompletion private var __stencilReadMask:Int;
	@:noCompletion private var __stencilRenderBuffer:GLRenderbuffer;
	@:noCompletion private var __supportsAnisotropicFiltering:Bool;
	@:noCompletion private var __supportsPackedDepthStencil:Bool;
	@:noCompletion private var __vertexConstants:Float32Array;
	@:noCompletion private var __x:Float;
	@:noCompletion private var __y:Float;
	
	#if telemetry
	//private var __spanPresent:Telemetry.Span;
	//private var __statsValues:Array<Telemetry.Value>;
	//private var __valueFrame:Telemetry.Value;
	#end
	
	
	@:noCompletion private function new (stage:Stage) {
		
		super ();
		
		__stage = stage;
		__x = 0;
		__y = 0;
		
		__context = stage.window.context;
		
		#if (lime >= "7.0.0")
		__gl = stage.window.context.webgl;
		#else
		__gl = stage.window.context;
		#end
		
		__glActiveTexture = -1;
		__glBlendColor = [ 0, 0, 0, 0 ];
		__glBlendEquation = -1;
		__glBlendEquationSeparate = [ -1, -1 ];
		__glBlendFunc = [ -1, -1 ];
		__glBlendFuncSeparate = [ -1, -1, -1, -1 ];
		__glBuffers = new Map ();
		__glClearColor = [ 0, 0, 0, 0 ];
		__glClearDepth = -1;
		__glColorMask = [ true, true, true, true ];
		__glCullFace = -1;
		__glDepthFunc = -1;
		__glEnabled = new Map ();
		__glFramebuffers = new Map ();
		__glFrontFace = -1;
		__glRenderbuffers = new Map ();
		__glStencilFunc = [ -1, -1, -1 ];
		__glStencilMask = -1;
		__glStencilOp = [ -1, -1, -1 ];
		__glStencilOpSeparate = [ -1, -1, -1, -1 ];
		__glTextures = new Map ();
		
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
	
	
	@:noCompletion private function __activeTexture (texture:Int):Void {
		
		if (__glActiveTexture != texture) {
			
			__glActiveTexture = texture;
			__gl.activeTexture (texture);
			
		}
		
	}
	
	
	@:noCompletion private function __bindBuffer (target:Int, buffer:GLBuffer):Void {
		
		if (__glBuffers[target] != buffer) {
			
			__glBuffers[target] = buffer;
			__gl.bindBuffer (target, buffer);
			
		}
		
	}
	
	
	@:noCompletion private function __bindFramebuffer (target:Int, framebuffer:GLFramebuffer):Void {
		
		if (__glFramebuffers[target] != framebuffer) {
			
			__glFramebuffers[target] = framebuffer;
			__gl.bindFramebuffer (target, framebuffer);
			
		}
		
	}
	
	
	@:noCompletion private function __bindRenderbuffer (target:Int, renderbuffer:GLRenderbuffer):Void {
		
		if (__glRenderbuffers[target] != renderbuffer) {
			
			__glRenderbuffers[target] = renderbuffer;
			__gl.bindRenderbuffer (target, renderbuffer);
			
		}
		
	}
	
	
	@:noCompletion private function __bindTexture (target:Int, texture:GLTexture):Void {
		
		if (__glTextures[target] != texture) {
			
			__glTextures[target] = texture;
			__gl.bindTexture (target, texture);
			
		}
		
	}
	
	
	@:noCompletion private function __blendColor (red:Float, green:Float, blue:Float, alpha:Float):Void {
		
		if (__glBlendColor[0] != red || __glBlendColor[1] != green || __glBlendColor[2] != blue || __glBlendColor[3] != alpha) {
			
			__glBlendColor[0] = red;
			__glBlendColor[1] = green;
			__glBlendColor[2] = blue;
			__glBlendColor[3] = alpha;
			__gl.blendColor (red, green, blue, alpha);
			
		}
		
	}
	
	
	@:noCompletion private function __blendEquation (mode:Int):Void {
		
		if (__glBlendEquation != mode) {
			
			__glBlendEquation = mode;
			__glBlendEquationSeparate[0] = -1;
			__glBlendEquationSeparate[1] = -1;
			__gl.blendEquation (mode);
			
		}
		
	}
	
	
	@:noCompletion private function __blendEquationSeparate (modeRGB:Int, modeAlpha:Int):Void {
		
		if (__glBlendEquationSeparate[0] != modeRGB || __glBlendEquationSeparate[1] != modeAlpha) {
			
			__glBlendEquationSeparate[0] = modeRGB;
			__glBlendEquationSeparate[1] = modeAlpha;
			__glBlendEquation = -1;
			__gl.blendEquationSeparate (modeRGB, modeAlpha);
			
		}
		
	}
	
	
	@:noCompletion private function __blendFunc (sfactor:Int, dfactor:Int):Void {
		
		if (__glBlendFunc[0] != sfactor || __glBlendFunc[1] != dfactor) {
			
			__glBlendFunc[0] = sfactor;
			__glBlendFunc[1] = dfactor;
			__glBlendFuncSeparate[0] = -1;
			__glBlendFuncSeparate[1] = -1;
			__glBlendFuncSeparate[2] = -1;
			__glBlendFuncSeparate[3] = -1;
			__gl.blendFunc (sfactor, dfactor);
			
		}
		
	}
	
	
	@:noCompletion private function __blendFuncSeparate (srcRGB:Int, dstRGB:Int, srcAlpha:Int, dstAlpha:Int):Void {
		
		if (__glBlendFuncSeparate[0] != srcRGB || __glBlendFuncSeparate[1] != dstRGB || __glBlendFuncSeparate[2] != srcAlpha || __glBlendFuncSeparate[3] != dstAlpha) {
			
			__glBlendFuncSeparate[0] = srcRGB;
			__glBlendFuncSeparate[1] = dstRGB;
			__glBlendFuncSeparate[2] = srcAlpha;
			__glBlendFuncSeparate[3] = dstAlpha;
			__glBlendFunc[0] = -1;
			__glBlendFunc[1] = -1;
			__gl.blendFuncSeparate (srcRGB, dstRGB, srcAlpha, dstAlpha);
			
		}
		
	}
	
	
	@:noCompletion private function __clearColor (red:Float, green:Float, blue:Float, alpha:Float):Void {
		
		if (__glClearColor[0] != red || __glClearColor[1] != green || __glClearColor[2] != blue || __glClearColor[3] != alpha) {
			
			__glClearColor[0] = red;
			__glClearColor[1] = green;
			__glClearColor[2] = blue;
			__glClearColor[3] = alpha;
			__gl.clearColor (red, green, blue, alpha);
			
		}
		
	}
	
	
	@:noCompletion private function __clearDepth (depth:Float):Void {
		
		if (__glClearDepth != depth) {
			
			__glClearDepth = depth;
			__gl.clearDepth (depth);
			
		}
		
	}
	
	
	@:noCompletion private function __colorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		if (__glColorMask[0] != red || __glColorMask[1] != green || __glColorMask[2] != blue || __glColorMask[3] != alpha) {
			
			__glColorMask[0] = red;
			__glColorMask[1] = green;
			__glColorMask[2] = blue;
			__glColorMask[3] = alpha;
			__gl.colorMask (red, green, blue, alpha);
			
		}
		
	}
	
	
	@:noCompletion private function __copyState (other:Context3D):Void {
		
		__glActiveTexture = other.__glActiveTexture;
		__glBlendEquation = other.__glBlendEquation;
		__glClearDepth = other.__glClearDepth;
		__glCullFace = other.__glCullFace;
		__glDepthFunc = other.__glDepthFunc;
		__glDepthMask = other.__glDepthMask;
		__glFrontFace = other.__glFrontFace;
		__glProgram = other.__glProgram;
		__glScissorHeight = other.__glScissorHeight;
		__glScissorWidth = other.__glScissorWidth;
		__glScissorX = other.__glScissorX;
		__glScissorY = other.__glScissorY;
		__glStencilMask = other.__glStencilMask;
		__glViewportHeight = other.__glViewportHeight;
		__glViewportWidth = other.__glViewportWidth;
		__glViewportX = other.__glViewportX;
		__glViewportY = other.__glViewportY;
		
		for (i in 0...4) {
			
			__glBlendColor[i] = other.__glBlendColor[i];
			if (i < 3) __glBlendEquationSeparate[i] = other.__glBlendEquationSeparate[i];
			if (i < 3) __glBlendFunc[i] = other.__glBlendFunc[i];
			__glBlendFuncSeparate[i] = other.__glBlendFuncSeparate[i];
			__glClearColor[i] = other.__glClearColor[i];
			__glColorMask[i] = other.__glColorMask[i];
			if (i < 4) __glStencilFunc[i] = other.__glStencilFunc[i];
			if (i < 4) __glStencilOp[i] = other.__glStencilOp[i];
			__glStencilOpSeparate[i] = other.__glStencilOpSeparate[i];
			
		}
		
		// TODO: Better way to handle this?
		
		__glBuffers = new Map ();
		__glEnabled = new Map ();
		__glFramebuffers = new Map ();
		__glRenderbuffers = new Map ();
		__glTextures = new Map ();
		
		for (key in other.__glBuffers.keys ()) {
			
			__glBuffers[key] = other.__glBuffers[key];
			
		}
		
		for (key in other.__glEnabled.keys ()) {
			
			__glEnabled[key] = other.__glEnabled[key];
			
		}
		
		for (key in other.__glFramebuffers.keys ()) {
			
			__glFramebuffers[key] = other.__glFramebuffers[key];
			
		}
		
		for (key in other.__glRenderbuffers.keys ()) {
			
			__glRenderbuffers[key] = other.__glRenderbuffers[key];
			
		}
		
		for (key in other.__glTextures.keys ()) {
			
			__glTextures[key] = other.__glTextures[key];
			
		}
		
	}
	
	
	@:noCompletion private function __cullFace (face:Int):Void {
		
		if (__glCullFace != face) {
			
			__glCullFace = face;
			__gl.cullFace (face);
			
		}
		
	}
	
	
	@:noCompletion private function __depthFunc (func:Int):Void {
		
		if (__glDepthFunc != func) {
			
			__glDepthFunc = func;
			__gl.depthFunc (func);
			
		}
		
	}
	
	
	@:noCompletion private function __depthMask (flag:Bool):Void {
		
		if (__glDepthMask != flag) {
			
			__glDepthMask = flag;
			__gl.depthMask (flag);
			
		}
		
	}
	
	
	@:noCompletion private function __disable (cap:Int):Void {
		
		if (__glEnabled[cap] == true) {
			
			__glEnabled[cap] = false;
			__gl.disable (cap);
			
		}
		
	}
	
	
	@:noCompletion private function __enable (cap:Int):Void {
		
		if (__glEnabled[cap] != true) {
			
			__glEnabled[cap] = true;
			__gl.enable (cap);
			
		}
		
	}
	
	
	@:noCompletion private function __frontFace (mode:Int):Void {
		
		if (__glFrontFace != mode) {
			
			__glFrontFace = mode;
			__gl.frontFace (mode);
			
		}
		
	}
	
	
	@:noCompletion private function __restoreState (other:Context3D):Void {
		
		if (other.__glActiveTexture != __glActiveTexture) {
			if (__glActiveTexture != -1) {
				__gl.activeTexture (__glActiveTexture);
			} else {
				__glActiveTexture = other.__glActiveTexture;
			}
		}
		
		if (other.__glBlendEquation != __glBlendEquation) {
			if (__glBlendEquation != -1) {
				__gl.blendEquation (__glBlendEquation);
			} else {
				__glBlendEquation = other.__glBlendEquation;
			}
		}
		
		if (other.__glClearDepth != __glClearDepth) {
			if (__glClearDepth != -1) {
				__gl.clearDepth (__glClearDepth);
			} else {
				__glClearDepth = other.__glClearDepth;
			}
		}
		
		if (other.__glCullFace != __glCullFace) {
			if (__glCullFace != -1) {
				__gl.cullFace (__glCullFace);
			} else {
				__glCullFace = other.__glCullFace;
			}
		}
		
		if (other.__glDepthFunc != __glDepthFunc) {
			if (__glDepthFunc != -1) {
				__gl.depthFunc (__glDepthFunc);
			} else {
				__glDepthFunc = other.__glDepthFunc;
			}
		}
		
		if (other.__glDepthMask != __glDepthMask) {
			__gl.depthMask (__glDepthMask);
		}
		
		if (other.__glFrontFace != __glFrontFace) {
			if (__glFrontFace != -1) {
				__gl.frontFace (__glFrontFace);
			} else {
				__glFrontFace = other.__glFrontFace;
			}
		}
		
		if (other.__glProgram != __glProgram) {
			__gl.useProgram (__glProgram);
		}
		
		if (other.__glScissorX != __glScissorX || other.__glScissorY != __glScissorY || other.__glScissorWidth != __glScissorWidth || other.__glScissorHeight != __glScissorHeight) {
			if (__glScissorWidth != 0 || __glScissorHeight != 0) {
				__gl.scissor (__glScissorX, __glScissorY, __glScissorWidth, __glScissorHeight);
			} else {
				__glScissorX = other.__glScissorX;
				__glScissorY = other.__glScissorY;
				__glScissorWidth = other.__glScissorWidth;
				__glScissorHeight = other.__glScissorHeight;
			}
		}
		
		if (other.__glStencilMask != __glStencilMask) {
			if (__glStencilMask != -1) {
				__gl.stencilMask (__glStencilMask);
			} else {
				__glStencilMask = other.__glStencilMask;
			}
		}
		
		if (other.__glViewportX != __glViewportX || other.__glViewportY != __glViewportY || other.__glViewportWidth != __glViewportWidth || other.__glViewportHeight != __glViewportHeight) {
			if (__glViewportWidth != 0 || __glViewportHeight != 0) {
				__gl.viewport (__glViewportX, __glViewportY, __glViewportWidth, __glViewportHeight);
			} else {
				__glViewportX = other.__glViewportX;
				__glViewportY = other.__glViewportY;
				__glViewportWidth = other.__glViewportWidth;
				__glViewportHeight = other.__glViewportHeight;
			}
		}
		
		if (other.__glBlendColor[0] != __glBlendColor[0] || other.__glBlendColor[1] != __glBlendColor[1] || other.__glBlendColor[2] != __glBlendColor[2] || other.__glBlendColor[3] != __glBlendColor[3]) {
			if (__glBlendColor[0] != -1) {
				__gl.blendColor (__glBlendColor[0], __glBlendColor[1], __glBlendColor[2], __glBlendColor[3]);
			} else {
				__glBlendColor[0] = other.__glBlendColor[0];
				__glBlendColor[1] = other.__glBlendColor[1];
				__glBlendColor[2] = other.__glBlendColor[2];
				__glBlendColor[3] = other.__glBlendColor[3];
			}
		}
		
		if (other.__glBlendEquationSeparate[0] != __glBlendEquationSeparate[0] || other.__glBlendEquationSeparate[1] != __glBlendEquationSeparate[1]) {
			if (__glBlendEquationSeparate[0] != -1) {
				__gl.blendEquationSeparate (__glBlendEquationSeparate[0], __glBlendEquationSeparate[1]);
			} else {
				__glBlendEquationSeparate[0] = other.__glBlendEquationSeparate[0];
				__glBlendEquationSeparate[1] = other.__glBlendEquationSeparate[1];
			}
		}
		
		if (other.__glBlendFunc[0] != __glBlendFunc[0] || other.__glBlendFunc[1] != __glBlendFunc[1]) {
			if (__glBlendFunc[0] != -1) {
				__gl.blendFunc (__glBlendFunc[0], __glBlendFunc[1]);
			} else {
				__glBlendFunc[0] = other.__glBlendFunc[0];
				__glBlendFunc[1] = other.__glBlendFunc[1];
			}
		}
		
		if (other.__glBlendFuncSeparate[0] != __glBlendFuncSeparate[0] || other.__glBlendFuncSeparate[1] != __glBlendFuncSeparate[1] || other.__glBlendFuncSeparate[2] != __glBlendFuncSeparate[2] || other.__glBlendFuncSeparate[3] != __glBlendFuncSeparate[3]) {
			if (__glBlendFuncSeparate[0] != -1) {
				__gl.blendFuncSeparate (__glBlendFuncSeparate[0], __glBlendFuncSeparate[1], __glBlendFuncSeparate[2], __glBlendFuncSeparate[3]);
			} else {
				__glBlendFuncSeparate[0] = other.__glBlendFuncSeparate[0];
				__glBlendFuncSeparate[1] = other.__glBlendFuncSeparate[1];
				__glBlendFuncSeparate[2] = other.__glBlendFuncSeparate[2];
				__glBlendFuncSeparate[3] = other.__glBlendFuncSeparate[3];
			}
		}
		
		if (other.__glClearColor[0] != __glClearColor[0] || other.__glClearColor[1] != __glClearColor[1] || other.__glClearColor[2] != __glClearColor[2] || other.__glClearColor[3] != __glClearColor[3]) {
			if (__glClearColor[0] != -1) {
				__gl.clearColor (__glClearColor[0], __glClearColor[1], __glClearColor[2], __glClearColor[3]);
			} else {
				__glClearColor[0] = other.__glClearColor[0];
				__glClearColor[1] = other.__glClearColor[1];
				__glClearColor[2] = other.__glClearColor[2];
				__glClearColor[3] = other.__glClearColor[3];
			}
		}
		
		if (other.__glColorMask[0] != __glColorMask[0] || other.__glColorMask[1] != __glColorMask[1] || other.__glColorMask[2] != __glColorMask[2] || other.__glColorMask[3] != __glColorMask[3]) {
			__gl.colorMask (__glColorMask[0], __glColorMask[1], __glColorMask[2], __glColorMask[3]);
		}
		
		if (other.__glStencilFunc[0] != __glStencilFunc[0] || other.__glStencilFunc[1] != __glStencilFunc[1] || other.__glStencilFunc[2] != __glStencilFunc[2]) {
			if (__glStencilFunc[0] != -1) {
				__gl.stencilFunc (__glStencilFunc[0], __glStencilFunc[1], __glStencilFunc[2]);
			} else {
				__glStencilFunc[0] = other.__glStencilFunc[0];
				__glStencilFunc[1] = other.__glStencilFunc[1];
				__glStencilFunc[2] = other.__glStencilFunc[2];
			}
		}
		
		if (other.__glStencilOp[0] != __glStencilOp[0] || other.__glStencilOp[1] != __glStencilOp[1] || other.__glStencilOp[2] != __glStencilOp[2]) {
			if (__glStencilOp[0] != -1) {
				__gl.stencilOp (__glStencilOp[0], __glStencilOp[1], __glStencilOp[2]);
			} else {
				__glStencilOp[0] = other.__glStencilOp[0];
				__glStencilOp[1] = other.__glStencilOp[1];
				__glStencilOp[2] = other.__glStencilOp[2];
			}
		}
		
		if (other.__glStencilOpSeparate[0] != __glStencilOpSeparate[0] || other.__glStencilOpSeparate[1] != __glStencilOpSeparate[1] || other.__glStencilOpSeparate[2] != __glStencilOpSeparate[2] || other.__glStencilOpSeparate[3] != __glStencilOpSeparate[3]) {
			if (__glStencilOpSeparate[0] != -1) {
				__gl.stencilOpSeparate (__glStencilOpSeparate[0], __glStencilOpSeparate[1], __glStencilOpSeparate[2], __glStencilOpSeparate[3]);
			} else {
				__glStencilOpSeparate[0] = other.__glStencilOpSeparate[0];
				__glStencilOpSeparate[1] = other.__glStencilOpSeparate[1];
				__glStencilOpSeparate[2] = other.__glStencilOpSeparate[2];
				__glStencilOpSeparate[3] = other.__glStencilOpSeparate[3];
			}
		}
		
		for (key in __glBuffers.keys ()) {
			if (other.__glBuffers.exists (key) && other.__glBuffers[key] != __glBuffers[key]) {
				if (__glBuffers[key] != null) {
					__gl.bindBuffer (key, __glBuffers[key]);
				} else {
					__glBuffers[key] = other.__glBuffers[key];
				}
			}
		}
		for (key in other.__glBuffers.keys ()) {
			if (!__glBuffers.exists (key)) __glBuffers[key] = other.__glBuffers[key];
		}
		
		for (key in __glEnabled.keys ()) {
			if (other.__glEnabled.exists (key) && other.__glEnabled[key] != __glEnabled[key]) {
				if (__glEnabled[key] == true) {
					__gl.enable (key);
				} else {
					__gl.disable (key);
				}
			}
		}
		for (key in other.__glEnabled.keys ()) {
			if (!__glEnabled.exists (key)) __glEnabled[key] = other.__glEnabled[key];
		}
		
		for (key in __glFramebuffers.keys ()) {
			if (other.__glFramebuffers.exists (key) && other.__glFramebuffers[key] != __glFramebuffers[key]) {
				if (__glFramebuffers[key] != null) {
					__gl.bindFramebuffer (key, __glFramebuffers[key]);
				} else {
					__glFramebuffers[key] = other.__glFramebuffers[key];
				}
			}
		}
		for (key in other.__glFramebuffers.keys ()) {
			if (!__glFramebuffers.exists (key)) __glFramebuffers[key] = other.__glFramebuffers[key];
		}
		
		for (key in __glRenderbuffers.keys ()) {
			if (other.__glRenderbuffers.exists (key) && other.__glRenderbuffers[key] != __glRenderbuffers[key]) {
				if (__glRenderbuffers[key] != null) {
					__gl.bindRenderbuffer (key, __glRenderbuffers[key]);
				} else {
					__glRenderbuffers[key] = other.__glRenderbuffers[key];
				}
			}
		}
		for (key in other.__glRenderbuffers.keys ()) {
			if (!__glRenderbuffers.exists (key)) __glRenderbuffers[key] = other.__glRenderbuffers[key];
		}
		
		// TODO: Do we need to rebind textures here?
		
		for (key in __glTextures.keys ()) {
			if (other.__glTextures.exists (key) && other.__glTextures[key] != __glTextures[key]) {
				if (__glTextures[key] != null) {
					__gl.bindTexture (key, __glTextures[key]);
				} else {
					__glTextures[key] = other.__glTextures[key];
				}
			}
		}
		for (key in other.__glTextures.keys ()) {
			if (!__glTextures.exists (key)) __glTextures[key] = other.__glTextures[key];
		}
		
	}
	
	
	@:noCompletion private function __scissor (x:Int, y:Int, width:Int, height:Int):Void {
		
		if (x != __glScissorX || y != __glScissorY || width != __glScissorWidth || height != __glScissorHeight) {
			
			__glScissorX = x;
			__glScissorY = y;
			__glScissorWidth = width;
			__glScissorHeight = height;
			__gl.scissor (x, y, width, height);
			
		}
		
	}
	
	
	@:noCompletion private function __stencilFunc (func:Int, ref:Int, mask:Int):Void {
		
		if (__glStencilFunc[0] != func || __glStencilFunc[1] != ref || __glStencilFunc[2] != mask) {
			
			__glStencilFunc[0] = func;
			__glStencilFunc[1] = ref;
			__glStencilFunc[2] = mask;
			__gl.stencilFunc (func, ref, mask);
			
		}
		
	}
	
	
	@:noCompletion private function __stencilMask (mask:Int):Void {
		
		if (__glStencilMask != mask) {
			
			__glStencilMask = mask;
			__gl.stencilMask (mask);
			
		}
		
	}
	
	
	@:noCompletion private function __stencilOp (sfail:Int, dpfail:Int, dppass:Int):Void {
		
		if (__glStencilOp[0] != sfail || __glStencilOp[1] != dpfail || __glStencilOp[2] != dppass) {
			
			__glStencilOp[0] = sfail;
			__glStencilOp[1] = dpfail;
			__glStencilOp[2] = dppass;
			__glStencilOpSeparate[0] = -1;
			__glStencilOpSeparate[1] = -1;
			__glStencilOpSeparate[2] = -1;
			__glStencilOpSeparate[3] = -1;
			__gl.stencilOp (sfail, dpfail, dppass);
			
		}
		
	}
	
	
	@:noCompletion private function __stencilOpSeparate (face:Int, sfail:Int, dpfail:Int, dppass:Int):Void {
		
		if (__glStencilOpSeparate[0] != face || __glStencilOpSeparate[1] != sfail || __glStencilOpSeparate[2] != dpfail || __glStencilOpSeparate[3] != dppass) {
			
			__glStencilOpSeparate[0] = face;
			__glStencilOpSeparate[1] = sfail;
			__glStencilOpSeparate[2] = dpfail;
			__glStencilOpSeparate[3] = dppass;
			__glStencilOp[0] = -1;
			__glStencilOp[1] = -1;
			__glStencilOp[2] = -1;
			__gl.stencilOpSeparate (face, sfail, dpfail, dppass);
			
		}
		
	}
	
	
	@:noCompletion private function __updateBackbufferViewport ():Void {
		
		GLContext3D.__updateBackbufferViewportTEMP (this);
		
	}
	
	
	@:noCompletion private function __updateBlendFactors ():Void {
		
		GLContext3D.__updateBlendFactorsTEMP (this);
		
	}
	
	
	@:noCompletion private function __updateCulling ():Void {
		
		setCulling (__culling);
		
	}
	
	
	@:noCompletion private function __updateDepthAndStencilState ():Void {
		
		GLContext3D.__updateDepthAndStencilStateTEMP (this);
		
	}
	
	
	@:noCompletion private function __updateScissorRectangle ():Void {
		
		GLContext3D.__updateScissorRectangleTEMP (this);
		
	}
	
	
	@:noCompletion private function __useProgram (program:GLProgram):Void {
		
		if (__glProgram != program) {
			
			__glProgram = program;
			__gl.useProgram (program);
			
		}
		
	}
	
	
	@:noCompletion private function __viewport (x:Int, y:Int, width:Int, height:Int):Void {
		
		// if (width == 0 || height == 0) {
			
		// 	x = __offsetX;
		// 	y = __offsetY;
		// 	width = __displayWidth;
		// 	height = __displayHeight;
			
		// }
		
		if (x != __glViewportX || y != __glViewportY || width != __glViewportWidth || height != __glViewportHeight) {
			
			__glViewportX = x;
			__glViewportY = y;
			__glViewportWidth = width;
			__glViewportHeight = height;
			__gl.viewport (x, y, width, height);
			
		}
		
	}
	
	
	
	
	// Get & Set Methods
	
	
	
	
	@:noCompletion private function get_enableErrorChecking ():Bool {
		
		return __enableErrorChecking;
		
	}
	
	
	@:noCompletion private function set_enableErrorChecking (value:Bool):Bool {
		
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


#else
typedef Context3D = flash.display3D.Context3D;
#end