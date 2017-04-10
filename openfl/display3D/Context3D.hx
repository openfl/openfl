package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.math.Vector2;
import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl._internal.stage3D.Context3DStateCache;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.BitmapData;
import openfl.display.Stage3D;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.VideoTexture;
import openfl.display3D.Context3DProgramType;
import openfl.events.EventDispatcher;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix3D;
import openfl.geom.Rectangle;
import openfl.utils.ByteArray;
import openfl.Vector;

#if telemetry
import openfl.profiler.Telemetry;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Stage3D)
@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl._internal.stage3D.Context3DStateCache)
@:access(openfl._internal.stage3D.GLUtils)


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
	public var enableErrorChecking (default, set):Bool = false;
	public var maxBackBufferHeight (default, null):Int;
	public var maxBackBufferWidth (default, null):Int;
	public var profile (default, null):Context3DProfile = BASELINE;
	public var totalGPUMemory (default, null):Int = 0;
	
	private var __backBufferAntiAlias:Int;
	private var __backBufferEnableDepthAndStencil:Bool;
	private var __backBufferWantsBestResolution:Bool;
	private var __depthRenderBuffer:GLRenderbuffer;
	private var __depthStencilRenderBuffer:GLRenderbuffer;
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
		
		__vertexConstants = new Float32Array (4 * MAX_PROGRAM_REGISTERS);
		__fragmentConstants = new Float32Array (4 * MAX_PROGRAM_REGISTERS);
		
		__positionScale = new Float32Array ([ 1.0, 1.0, 1.0, 1.0 ]);
		__samplerDirty = 0;
		__samplerTextures = new Vector<TextureBase> (Context3D.MAX_SAMPLERS);
		__samplerStates = [];
		
		for (i in 0 ... Context3D.MAX_SAMPLERS) {
			
			__samplerStates[i] = new SamplerState (GL.LINEAR, GL.LINEAR, GL.CLAMP_TO_EDGE, GL.CLAMP_TO_EDGE);
			
		}
		
		#if (js && html5)
		maxBackBufferHeight = maxBackBufferWidth = GL.getParameter (GL.MAX_VIEWPORT_DIMS);
		#else
		maxBackBufferHeight = maxBackBufferWidth = 16384;
		#end
		
		__backBufferAntiAlias = 0;
		__backBufferEnableDepthAndStencil = true;
		__backBufferWantsBestResolution = false;
		
		__frameCount = 0;
		__rttDepthAndStencil = false;
		__samplerDirty = 0;
		__stencilCompareMode = Context3DCompareMode.ALWAYS;
		__stencilRef = 0;
		__stencilReadMask = 0xFF;
		
		var anisoExtension:Dynamic = GL.getExtension ("EXT_texture_filter_anisotropic");
		
		#if (js && html5)
		
		if (anisoExtension == null || !Reflect.hasField (anisoExtension, "MAX_TEXTURE_MAX_ANISOTROPY_EXT"))
			anisoExtension = GL.getExtension ("MOZ_EXT_texture_filter_anisotropic");
		if (anisoExtension == null || !Reflect.hasField (anisoExtension, "MAX_TEXTURE_MAX_ANISOTROPY_EXT"))
			anisoExtension = GL.getExtension ("WEBKIT_EXT_texture_filter_anisotropic");
		
		__supportsPackedDepthStencil = true;
		DEPTH_STENCIL = GL.DEPTH_STENCIL;
		
		#else
		
		var stencilExtension = GL.getExtension ("OES_packed_depth_stencil");
		
		if (stencilExtension != null) {
			
			__supportsPackedDepthStencil = true;
			DEPTH_STENCIL = stencilExtension.DEPTH24_STENCIL8_OES;
			
		} else {
			
			stencilExtension = GL.getExtension ("EXT_packed_depth_stencil");
			
			if (stencilExtension != null) {
				
				__supportsPackedDepthStencil = true;
				DEPTH_STENCIL = stencilExtension.DEPTH24_STENCIL8_EXT;
				
			}
			
		}
		
		#end
		
		__supportsAnisotropicFiltering = (anisoExtension != null);
		
		if (__supportsAnisotropicFiltering) {
			
			TEXTURE_MAX_ANISOTROPY_EXT = anisoExtension.TEXTURE_MAX_ANISOTROPY_EXT;
			
			var maxAnisotropy:Int = GL.getParameter (anisoExtension.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
			__maxAnisotropyTexture2D = maxAnisotropy;
			__maxAnisotropyTexture2D = maxAnisotropy;
			
		}
		
		__stats = new Vector<Int> (Context3DTelemetry.length);
		__statsCache = new Vector<Int> (Context3DTelemetry.length);
		
		#if telemetry
		//__spanPresent = new Telemetry.Span (".rend.molehill.present");
		//__valueFrame = new Telemetry.Value (".rend.molehill.frame");
		#end
		
		GLUtils.CheckGLError ();
		
		var vendor = GL.getParameter (GL.VENDOR);
		GLUtils.CheckGLError ();
		
		var version = GL.getParameter (GL.VERSION);
		GLUtils.CheckGLError ();
		
		var renderer = GL.getParameter (GL.RENDERER);
		GLUtils.CheckGLError ();
		
		var glslVersion = #if (js && html5) GL.getParameter (GL.SHADING_LANGUAGE_VERSION); #else "<unknown>"; #end
		GLUtils.CheckGLError ();
		
		driverInfo = "OpenGL" +
					 " Vendor=" + vendor +
					 " Version=" + version +
					 " Renderer=" + renderer +
					 " GLSL=" + glslVersion;
		
		#if telemetry
		//Telemetry.Session.WriteValue (".platform.3d.driverinfo", driverInfo);
		#end
		
		for (i in 0...__stats.length) {
			
			__stats[i] = 0;
			
		}
		
		__stateCache.clearSettings ();
		
	}
	
	
	public function clear (red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = Context3DClearMask.ALL):Void {
		
		var clearMask = 0;
		
		if (mask & Context3DClearMask.COLOR != 0) {
			
			clearMask |= GL.COLOR_BUFFER_BIT;
			
			GL.clearColor (red, green, blue, alpha);
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.DEPTH != 0) {
			
			clearMask |= GL.DEPTH_BUFFER_BIT;
			
			GL.depthMask (true);
			GL.clearDepthf (depth);
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.STENCIL != 0) {
			
			clearMask |= GL.STENCIL_BUFFER_BIT;
			
			GL.clearStencil (stencil);
			GLUtils.CheckGLError ();
			
		}
		
		GL.clear (clearMask);
		GLUtils.CheckGLError ();
		
	}
	
	
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		__updateBackbufferViewport ();
		
		backBufferWidth = width;
		backBufferHeight = height;
		
		__backBufferAntiAlias = antiAlias;
		__backBufferEnableDepthAndStencil = enableDepthAndStencil;
		__backBufferWantsBestResolution = wantsBestResolution;
		
		__stateCache.clearSettings ();
		
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
	
	
	public function dispose ():Void {
		
		// TODO
		
	}
	
	
	public function drawToBitmapData (destination:BitmapData):Void {
		
		if (destination == null) return;
		
		var window = __stage3D.__stage.window;
		
		if (window != null) {
			
			var image = window.renderer.readPixels ();
			destination.image.copyPixels (image, image.rect, new Vector2 ());
			
		}
		
		// TODO
		
	}
	
	
	public function drawTriangles (indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void {
		
		if (__program == null) {
			
			return;
			
		}
		
		__flushSamplerState ();
		__program.__flush ();
		
		var count = (numTriangles == -1) ? indexBuffer.__numIndices : (numTriangles * 3);
		
		GL.bindBuffer (GL.ELEMENT_ARRAY_BUFFER, indexBuffer.__id);
		GLUtils.CheckGLError ();
		
		GL.drawElements (GL.TRIANGLES, count, indexBuffer.__elementType, firstIndex);
		GLUtils.CheckGLError ();
		
		__statsIncrement (Context3DTelemetry.DRAW_CALLS);
		
	}
	
	
	
	public function present ():Void {
		
		__statsSendToTelemetry ();
		
		#if telemetry
		//__spanPresent.End ();
		//__spanPresent.Begin ();
		#end
		
		__statsClear (Context3DTelemetry.DRAW_CALLS);
		
		__frameCount++;
		
	}
	
	
	public function setBlendFactors (sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void {
		
		var updateSrc = __stateCache.updateBlendSrcFactor (sourceFactor);
		var updateDest = __stateCache.updateBlendDestFactor (destinationFactor);
		if (updateSrc || updateDest) {
			
			__updateBlendFactors ();
			
		}
		
	}
	
	
	public function setColorMask (red:Bool, green:Bool, blue:Bool, alpha:Bool):Void {
		
		GL.colorMask (red, green, blue, alpha);
		
	}
	
	
	public function setCulling (triangleFaceToCull:Context3DTriangleFace):Void {
		
		if (__stateCache.updateCullingMode (triangleFaceToCull)) {
			
			switch (triangleFaceToCull) {
				
				case Context3DTriangleFace.NONE:
					
					GL.disable (GL.CULL_FACE);
				
				case Context3DTriangleFace.BACK:
					
					GL.enable (GL.CULL_FACE);
					GL.cullFace (GL.FRONT);
				
				case Context3DTriangleFace.FRONT:
					
					GL.enable (GL.CULL_FACE);
					GL.cullFace (GL.BACK);
				
				case Context3DTriangleFace.FRONT_AND_BACK:
					
					GL.enable (GL.CULL_FACE);
					GL.cullFace (GL.FRONT_AND_BACK);
				
				default:
					
					throw new IllegalOperationError ();
				
			}
			
		}
		
	}
	
	
	public function setDepthTest (depthMask:Bool, passCompareMode:Context3DCompareMode):Void {
		
		var depthTestEnabled = __backBufferEnableDepthAndStencil;
		
		if (__stateCache.updateDepthTestEnabled (depthTestEnabled)) {
			
			if (depthTestEnabled) {
				
				GL.enable (GL.DEPTH_TEST);
				
			} else {
				
				GL.disable (GL.DEPTH_TEST);
				
			}
			
		}
		
		if (__stateCache.updateDepthTestMask (depthMask)) {
			
			GL.depthMask (depthMask);
			
		}
		
		if (__stateCache.updateDepthCompareMode (passCompareMode)) {
			
			switch (passCompareMode) {
				
				case Context3DCompareMode.ALWAYS: GL.depthFunc (GL.ALWAYS);
				case Context3DCompareMode.EQUAL: GL.depthFunc (GL.EQUAL);
				case Context3DCompareMode.GREATER: GL.depthFunc (GL.GREATER);
				case Context3DCompareMode.GREATER_EQUAL: GL.depthFunc (GL.GEQUAL);
				case Context3DCompareMode.LESS: GL.depthFunc (GL.LESS);
				case Context3DCompareMode.LESS_EQUAL: GL.depthFunc (GL.LEQUAL);
				case Context3DCompareMode.NEVER: GL.depthFunc (GL.NEVER);
				case Context3DCompareMode.NOT_EQUAL: GL.depthFunc (GL.NOTEQUAL);
				default:
					
					throw new IllegalOperationError ();
				
			}
			
		}
		
	}
	
	
	public function setProgram (program:Program3D):Void {
		
		if (program == null) {
			
			throw new IllegalOperationError ();
			
		}
		
		if (__stateCache.updateProgram3D (program)) {
			
			program.__use ();
			program.__setPositionScale (__positionScale);
			
			__program = program;
			
			__samplerDirty |= __program.__samplerUsageMask;
			
			for (i in 0...MAX_SAMPLERS) {
				
				__samplerStates[i].copyFrom (__program.__getSamplerState (i));
				
			}
			
		}
		
	}
	
	
	public function setProgramConstantsFromByteArray (programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray, byteArrayOffset:UInt):Void {
		
		if (numRegisters == 0) return;
		
		if (numRegisters == -1) {
			
			numRegisters = ((data.length >> 2) - byteArrayOffset);
			
		}
		
		var isVertex = (programType == Context3DProgramType.VERTEX);
		var dest = isVertex ? __vertexConstants : __fragmentConstants;
		
		var floatData = Float32Array.fromBytes (data, 0, data.length);
		var outOffset = firstRegister * 4;
		var inOffset = Std.int (byteArrayOffset / 4);
		
		for (i in 0...(numRegisters * 4)) {
			
			dest[outOffset + i] = floatData[inOffset + i];
			
		}
		
		if (__program != null) {
			
			__program.__markDirty (isVertex, firstRegister, numRegisters);
			
		}
		
	}
	
	
	public function setProgramConstantsFromMatrix (programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void {
		
		var isVertex = (programType == Context3DProgramType.VERTEX);
		var dest = isVertex ? __vertexConstants : __fragmentConstants;
		var source = matrix.rawData;
		var i = firstRegister * 4;
		
		if (transposedMatrix) {
			
			dest[i++] = source[0];
			dest[i++] = source[4];
			dest[i++] = source[8];
			dest[i++] = source[12];
			
			dest[i++] = source[1];
			dest[i++] = source[5];
			dest[i++] = source[9];
			dest[i++] = source[13];
			
			dest[i++] = source[2];
			dest[i++] = source[6];
			dest[i++] = source[10];
			dest[i++] = source[14];
			
			dest[i++] = source[3];
			dest[i++] = source[7];
			dest[i++] = source[11];
			dest[i++] = source[15];
			
		} else {
			
			dest[i++] = source[0];
			dest[i++] = source[1];
			dest[i++] = source[2];
			dest[i++] = source[3];
			
			dest[i++] = source[4];
			dest[i++] = source[5];
			dest[i++] = source[6];
			dest[i++] = source[7];
			
			dest[i++] = source[8];
			dest[i++] = source[9];
			dest[i++] = source[10];
			dest[i++] = source[11];
			
			dest[i++] = source[12];
			dest[i++] = source[13];
			dest[i++] = source[14];
			dest[i++] = source[15];
			
		}
		
		if (__program != null) {
			
			__program.__markDirty (isVertex, firstRegister, 4);
			
		}
		
	}
	
	
	public function setProgramConstantsFromVector (programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void {
		
		if (numRegisters == 0) return;
		
		if (numRegisters == -1) {
			
			numRegisters = (data.length >> 2);
			
		}
		
		var isVertex = (programType == VERTEX);
		var dest = isVertex ? __vertexConstants : __fragmentConstants;
		var source = data;
		
		var sourceIndex = 0;
		var destIndex = firstRegister * 4;
		
		for (i in 0...numRegisters) {
			
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			dest[destIndex++] = source[sourceIndex++];
			
		}
		
		if (__program != null) {
			
			__program.__markDirty (isVertex, firstRegister, numRegisters);
			
		}
		
	}
	
	
	public function setRenderToBackBuffer ():Void {
		
		GL.bindFramebuffer (GL.FRAMEBUFFER, null);
		GLUtils.CheckGLError ();
		
		GL.frontFace (GL.CCW);
		GLUtils.CheckGLError ();
		
		__renderToTexture = null;
		__scissorRectangle = null;
		__updateBackbufferViewport ();
		__updateScissorRectangle ();
		__updateDepthAndStencilState ();
		
		__positionScale[1] = 1.0;
		
		if (__program != null) {
			
			__program.__setPositionScale (__positionScale);
			
		}
		
	}
	
	
	public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0):Void {
		
		var width = 0;
		var height = 0;
		
		if (__framebuffer == null) {
			
			__framebuffer = GL.createFramebuffer ();
			GLUtils.CheckGLError ();
			
		}
		
		GL.bindFramebuffer (GL.FRAMEBUFFER, __framebuffer);
		GLUtils.CheckGLError ();
		
		if (Std.is (texture, Texture)) {
			
			var texture2D:Texture = cast texture;
			width = texture2D.__width;
			height = texture2D.__height;
			
			GL.framebufferTexture2D (GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.__textureID, 0);
			GLUtils.CheckGLError ();
			
		} else if (Std.is (texture, RectangleTexture)) {
			
			var rectTexture:RectangleTexture = cast texture;
			width = rectTexture.__width;
			height = rectTexture.__height;
			
			GL.framebufferTexture2D (GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.__textureID, 0);
			GLUtils.CheckGLError ();
			
		} else if (Std.is (texture, CubeTexture)) {
			
			var cubeTexture:CubeTexture = cast texture;
			width = cubeTexture.__size;
			height = cubeTexture.__size;
			
			for (i in 0...6) {
				
				GL.framebufferTexture2D (GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_CUBE_MAP_POSITIVE_X + i, texture.__textureID, 0);
				GLUtils.CheckGLError ();
				
			}
			
		} else {
			
			throw new Error ("Invalid texture");
			
		}
		
		if (enableDepthAndStencil) {
			
			if (__supportsPackedDepthStencil) {
				
				if (__depthStencilRenderBuffer == null) {
					
					__depthStencilRenderBuffer = GL.createRenderbuffer ();
					GLUtils.CheckGLError ();
					
				}
				
				GL.bindRenderbuffer (GL.RENDERBUFFER, __depthStencilRenderBuffer);
				GLUtils.CheckGLError ();
				GL.renderbufferStorage (GL.RENDERBUFFER, DEPTH_STENCIL, width, height);
				GLUtils.CheckGLError ();
				
				GL.framebufferRenderbuffer (GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, __depthStencilRenderBuffer);
				GLUtils.CheckGLError ();
				
			} else {
				
				if (__depthRenderBuffer == null) {
					
					__depthRenderBuffer = GL.createRenderbuffer ();
					GLUtils.CheckGLError ();
					
				}
				
				if (__stencilRenderBuffer == null) {
					
					__stencilRenderBuffer = GL.createRenderbuffer ();
					GLUtils.CheckGLError ();
					
				}
				
				GL.bindRenderbuffer (GL.RENDERBUFFER, __depthRenderBuffer);
				GLUtils.CheckGLError ();
				GL.renderbufferStorage (GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, width, height);
				GLUtils.CheckGLError ();
				GL.bindRenderbuffer (GL.RENDERBUFFER, __stencilRenderBuffer);
				GLUtils.CheckGLError ();
				GL.renderbufferStorage (GL.RENDERBUFFER, GL.STENCIL_INDEX8, width, height);
				GLUtils.CheckGLError ();
				
				GL.framebufferRenderbuffer (GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, __depthRenderBuffer);
				GLUtils.CheckGLError ();
				GL.framebufferRenderbuffer (GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.RENDERBUFFER, __stencilRenderBuffer);
				GLUtils.CheckGLError ();
				
			}
			
			GL.bindRenderbuffer (GL.RENDERBUFFER, null);
			GLUtils.CheckGLError ();
			
		}
		
		__setViewport (0, 0, width, height);
		
		if (enableErrorChecking) {
			
			var code = GL.checkFramebufferStatus (GL.FRAMEBUFFER);
			
			if (code != GL.FRAMEBUFFER_COMPLETE) {
				
				trace ("Error: Context3D.setRenderToTexture status:${code} width:${texture2D.__width} height:${texture2D.__height}");
				
			}
			
		}
		
		__positionScale[1] = -1.0;
		
		if (__program != null) {
			
			__program.__setPositionScale (__positionScale);
			
		}
		
		GL.frontFace (GL.CW);
		GLUtils.CheckGLError ();
		
		__renderToTexture = texture;
		__scissorRectangle = null;
		__rttDepthAndStencil = enableDepthAndStencil;
		__updateScissorRectangle ();
		__updateDepthAndStencilState ();
		
	}
	
	
	public function setSamplerStateAt (sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {
			
			throw new Error ("sampler out of range");
			
		}
		
		var state = __samplerStates[sampler];
		
		switch (wrap) {
			
			case Context3DWrapMode.CLAMP:
				
				state.wrapModeS = GL.CLAMP_TO_EDGE;
				state.wrapModeT = GL.CLAMP_TO_EDGE;
			
			case Context3DWrapMode.CLAMP_U_REPEAT_V:
				
				state.wrapModeS = GL.CLAMP_TO_EDGE;
				state.wrapModeT = GL.REPEAT;
			
			case Context3DWrapMode.REPEAT:
				
				state.wrapModeS = GL.REPEAT;
				state.wrapModeT = GL.REPEAT;
			
			case Context3DWrapMode.REPEAT_U_CLAMP_V:
				
				state.wrapModeS = GL.REPEAT;
				state.wrapModeT = GL.CLAMP_TO_EDGE;
			
			default:
				
				throw new Error ("wrap bad enum");
			
		}
		
		switch (filter) {
			
			case Context3DTextureFilter.LINEAR:
				
				state.magFilter = GL.LINEAR;
				
				if (__supportsAnisotropicFiltering) {
					
					state.maxAniso = 1;
					
				}
			
			case Context3DTextureFilter.NEAREST:
				
				state.magFilter = GL.NEAREST;
				
				if (__supportsAnisotropicFiltering) {
					
					state.maxAniso = 1;
					
				}
			
			case Context3DTextureFilter.ANISOTROPIC2X:
				
				if (__supportsAnisotropicFiltering) {
					
					state.maxAniso = (__maxAnisotropyTexture2D < 2 ? __maxAnisotropyTexture2D : 2);
					
				}
			
			case Context3DTextureFilter.ANISOTROPIC4X:
				
				if (__supportsAnisotropicFiltering) {
					
					state.maxAniso = (__maxAnisotropyTexture2D < 4 ? __maxAnisotropyTexture2D : 4);
					
				}
			
			case Context3DTextureFilter.ANISOTROPIC8X:
				
				if (__supportsAnisotropicFiltering) {
					
					state.maxAniso = (__maxAnisotropyTexture2D < 8 ? __maxAnisotropyTexture2D : 8);
					
				}
				
			case Context3DTextureFilter.ANISOTROPIC16X:
				
				if (__supportsAnisotropicFiltering) {
					
					state.maxAniso = (__maxAnisotropyTexture2D < 16 ? __maxAnisotropyTexture2D : 16);
					
				}
			
			default:
				
				throw new Error ("filter bad enum");
			
		}
		
		switch (mipfilter) {
			
			case Context3DMipFilter.MIPLINEAR:
				
				state.minFilter = filter == Context3DTextureFilter.NEAREST ? GL.NEAREST_MIPMAP_LINEAR : GL.LINEAR_MIPMAP_LINEAR;
			
			case Context3DMipFilter.MIPNEAREST:
				
				state.minFilter = filter == Context3DTextureFilter.NEAREST ? GL.NEAREST_MIPMAP_NEAREST : GL.LINEAR_MIPMAP_NEAREST;
			
			case Context3DMipFilter.MIPNONE:
				
				state.minFilter = filter == Context3DTextureFilter.NEAREST ? GL.NEAREST : GL.LINEAR;
			
			default:
				
				throw new Error ("mipfiter bad enum");
			
		}
		
	}
	
	
	public function setScissorRectangle (rectangle:Rectangle):Void {
		
		__scissorRectangle = rectangle != null ? rectangle.clone () : null;
		__updateScissorRectangle ();
		
	}
	
	
	public function setStencilActions (triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS, actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP, actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void {
		
		__stencilCompareMode = compareMode;
		GL.stencilOp (__getGLStencilAction (actionOnDepthFail), __getGLStencilAction (actionOnDepthPassStencilFail), __getGLStencilAction (actionOnBothPass));
		GL.stencilFunc (__getGLCompareMode (__stencilCompareMode), __stencilRef, __stencilReadMask);
		
	}
	
	
	public function setStencilReferenceValue (referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void {
		
		__stencilReadMask = readMask;
		__stencilRef = referenceValue;
		
		GL.stencilFunc (__getGLCompareMode (__stencilCompareMode), __stencilRef, __stencilReadMask);
		GL.stencilMask (writeMask);
		
	}
	
	
	public function setTextureAt(sampler:Int, texture:TextureBase):Void {
		
		if (__samplerTextures[sampler] != texture) {
			
			__samplerTextures[sampler] = texture;
			__samplerDirty |= (1 << sampler);
			
		}
		
	}
	
	
	

	public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void {
		
		if (buffer == null) {
			
			GL.disableVertexAttribArray (index);
			GLUtils.CheckGLError ();
			
			GL.bindBuffer (GL.ARRAY_BUFFER, null);
			GLUtils.CheckGLError ();
			
			return;
			
		}
		
		GL.enableVertexAttribArray (index);
		GLUtils.CheckGLError ();
		
		GL.bindBuffer (GL.ARRAY_BUFFER, buffer.__id);
		GLUtils.CheckGLError ();
		
		var byteOffset = bufferOffset * 4;
		
		switch (format) {
			
			case BYTES_4:
				
				GL.vertexAttribPointer (index, 4, GL.UNSIGNED_BYTE, true, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
				
			case FLOAT_4:
				
				GL.vertexAttribPointer (index, 4, GL.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			case FLOAT_3:
				
				GL.vertexAttribPointer (index, 3, GL.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			case FLOAT_2:
				
				GL.vertexAttribPointer (index, 2, GL.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			case FLOAT_1:
				
				GL.vertexAttribPointer (index, 1, GL.FLOAT, false, buffer.__stride, byteOffset);
				GLUtils.CheckGLError ();
			
			default:
				
				throw new IllegalOperationError ();
			
		}
		
	}
	
	
	private function __flushSamplerState ():Void {
		
		var sampler = 0;
		
		while (__samplerDirty != 0) {
			
			if ((__samplerDirty & (1 << sampler)) != 0) {
				
				if (__stateCache.updateActiveTextureSample (sampler)) {
					
					GL.activeTexture (GL.TEXTURE0 + sampler);
					GLUtils.CheckGLError ();
					
				}
				
				var texture = __samplerTextures[sampler];
				
				if (texture != null) {
					
					var target = texture.__textureTarget;
					
					GL.bindTexture (target, texture.__getTexture ());
					GLUtils.CheckGLError ();
					
					texture.__setSamplerState (__samplerStates[sampler]);
					
				} else {
					
					GL.bindTexture (GL.TEXTURE_2D, null);
					GLUtils.CheckGLError ();
					
				}
				
				__samplerDirty &= ~(1 << sampler);
				
			}
			
			sampler++;
			
		}
		
	}
	
	
	private function __getGLCompareMode (compareMode:Context3DCompareMode):Int {
		
		return switch (compareMode) {
			
			case ALWAYS: GL.ALWAYS;
			case EQUAL: GL.EQUAL;
			case GREATER: GL.GREATER;
			case GREATER_EQUAL: GL.GEQUAL;
			case LESS: GL.LESS;
			case LESS_EQUAL: GL.LEQUAL; // TODO : wrong value
			case NEVER: GL.NEVER;
			case NOT_EQUAL: GL.NOTEQUAL;
			default: GL.EQUAL;
			
		}
		
	}
	
	
	private function __getGLStencilAction (stencilAction:Context3DStencilAction):Int {
		
		return switch (stencilAction) {
			
			case DECREMENT_SATURATE: GL.DECR;
			case DECREMENT_WRAP: GL.DECR_WRAP;
			case INCREMENT_SATURATE: GL.INCR;
			case INCREMENT_WRAP: GL.INCR_WRAP;
			case INVERT: GL.INVERT;
			case KEEP: GL.KEEP;
			case SET: GL.REPLACE;
			case ZERO: GL.ZERO;
			default: GL.KEEP;
			
		}
		
	}
	
	
	private function __hasGLExtension (name:String):Bool {
		
		return (GL.getSupportedExtensions ().indexOf (name) != -1);
		
	}
	
	
	private function __setViewport (originX:Int, originY:Int, width:Int, height:Int):Void {
		
		if (__renderToTexture != null) originY *= -1;
		
		if (__stateCache.updateViewport (originX, originY, width, height)) {
			
			GL.viewport (originX, originY, width, height);
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	public function __statsAdd (stat:Int, value:Int):Int {
		
		__stats[stat] += value;
		return __stats [stat];
		
	}
	
	
	public function __statsClear (stat:Int):Void {
		
		__stats[stat] = 0;
		
	}
	
	
	public function __statsDecrement (stat:Int):Void {
		
		__stats[stat] -= 1;
		
	}
	
	
	public function __statsIncrement (stat:Int):Void {
		
		__stats[stat] += 1;
		
	}
	
	
	private function __statsSendToTelemetry ():Void {
		
		#if telemetry
		/*if (!Telemetry.Session.Connected) {
			
			return;
			
		}
		
		if (__statsValues == null) {
			
			__statsValues = new Array<Telemetry.Value> (Context3DTelemetry.length);
			
			// TODO: Should Context3DTelemetry have a toString()?
			
			var name:String;
			
			for (i in 0...Context3DTelemetry.length) {
				
				switch (i) {
					
					case Context3DTelemetry.DRAW_CALLS: name = ".3d.resource.drawCalls";
					default: name = ".3d.resource." + i.toString ().toLowerCase ().replace ('_', '.');
					
				}
				
				__statsValues[i] = new Telemetry.Value (name);
				
			}
			
		}
		
		for (i in 0...Context3DTelemetry.length) {
			
			if (__stats[i] != __statsCache[i]) {
				
				__statsValues[i].WriteValue (__stats[i]);
				__statsCache[i] = __stats[i];
				
			}
			
		}
		
		__valueFrame.WriteValue (__frameCount);*/
		#end
		
	}
	
	
	public function __statsSubtract (stat:Int, value:Int):Int {
		
		__stats[stat] -= value;
		return __stats [stat];
		
	}
	
	private function __updateDepthAndStencilState ():Void {
		
		var depthAndStencil = __renderToTexture != null ? __rttDepthAndStencil : __backBufferEnableDepthAndStencil;
		
		if (depthAndStencil) {
			
			GL.enable (GL.DEPTH_TEST);
			GLUtils.CheckGLError ();
			GL.enable (GL.STENCIL_TEST);
			GLUtils.CheckGLError ();
			
		} else {
			
			GL.disable (GL.DEPTH_TEST);
			GLUtils.CheckGLError ();
			GL.disable (GL.STENCIL_TEST);
			GLUtils.CheckGLError ();
			
		}
		
	}
	
	
	private function __updateBlendFactors ():Void {
		
		if (__stateCache._srcBlendFactor == null || __stateCache._destBlendFactor == null) {
			
			return;
			
		}
		
		var src = GL.ONE;
		var dest = GL.ZERO;
		switch (__stateCache._srcBlendFactor) {
			
			case Context3DBlendFactor.ONE: src = GL.ONE;
			case Context3DBlendFactor.ZERO: src = GL.ZERO;
			case Context3DBlendFactor.SOURCE_ALPHA: src = GL.SRC_ALPHA;
			case Context3DBlendFactor.DESTINATION_ALPHA: src = GL.DST_ALPHA;
			case Context3DBlendFactor.DESTINATION_COLOR: src = GL.DST_COLOR;
			case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: src = GL.ONE_MINUS_SRC_ALPHA;
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: src = GL.ONE_MINUS_DST_ALPHA;
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR: src = GL.ONE_MINUS_DST_COLOR;
			default:
				throw new IllegalOperationError ();
			
		}
		
		switch (__stateCache._destBlendFactor) {
			
			case Context3DBlendFactor.ONE: dest = GL.ONE;
			case Context3DBlendFactor.ZERO: dest = GL.ZERO;
			case Context3DBlendFactor.SOURCE_ALPHA: dest = GL.SRC_ALPHA;
			case Context3DBlendFactor.SOURCE_COLOR: dest = GL.SRC_COLOR;
			case Context3DBlendFactor.DESTINATION_ALPHA: dest = GL.DST_ALPHA;
			case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA: dest = GL.ONE_MINUS_SRC_ALPHA;
			case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR: dest = GL.ONE_MINUS_SRC_COLOR;
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA: dest = GL.ONE_MINUS_DST_ALPHA;
			default:
				throw new IllegalOperationError ();
			
		}
		
		GL.enable (GL.BLEND);
		GLUtils.CheckGLError ();
		GL.blendFunc (src, dest);
		GLUtils.CheckGLError ();
		
	}
	
	
	private function __updateScissorRectangle ():Void {
		
		if (__scissorRectangle == null) {
			
			GL.disable (GL.SCISSOR_TEST);
			GLUtils.CheckGLError ();
			return;
			
		}
		
		GL.enable (GL.SCISSOR_TEST);
		GLUtils.CheckGLError ();
		
		var height = 0;
		
		if (__renderToTexture != null) {
		
			if (Std.is (__renderToTexture, Texture)) {
			
				var texture2D:Texture = cast __renderToTexture;
				height = texture2D.__height;
			
			} else if (Std.is (__renderToTexture, RectangleTexture)) {
				
				var rectTexture:RectangleTexture = cast __renderToTexture;
				height = rectTexture.__height;
				
			}
			
		} else {
			
			height = backBufferHeight;
			
		}
		
		GL.scissor (Std.int (__scissorRectangle.x),
			Std.int (height - Std.int (__scissorRectangle.y) - Std.int (__scissorRectangle.height)),
			Std.int (__scissorRectangle.width),
			Std.int (__scissorRectangle.height)
		);
		GLUtils.CheckGLError ();
		
	}
	
	
	private function __updateBackbufferViewport ():Void {
		
		if (__renderToTexture == null && backBufferWidth > 0 && backBufferHeight > 0) {
			
			__setViewport (Std.int (__stage3D.x), Std.int (__stage3D.y), backBufferWidth, backBufferHeight);
			
		}
		
	}
	
	
	public function set_enableErrorChecking (value:Bool):Bool {
		
		return enableErrorChecking = GLUtils.debug = value;
		
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