package openfl.display3D;


import lime.graphics.opengl.GL;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.utils.Float32Array;
import openfl._internal.renderer.RenderSession;
import openfl._internal.stage3D.Context3DStateCache;
import openfl._internal.stage3D.GLUtils;
import openfl._internal.stage3D.SamplerState;
import openfl.display.Stage3D;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.Context3DProgramType;
import openfl.display.BitmapData;
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

@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.textures.RectangleTexture)
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl._internal.stage3D.GLUtils)


@:final class Context3D extends EventDispatcher {
	
	
	public static var supportsVideoTexture (default, null):Bool = false;
	
	private static inline var MAX_SAMPLERS = 8;
	private static inline var MAX_ATTRIBUTES = 16;
	private static inline var MAX_PROGRAM_REGISTERS = 128;
	
	private static var __stateCache:Context3DStateCache = new Context3DStateCache ();
	
	public var backBufferHeight (default, null):Int;
	public var backBufferWidth (default, null):Int;
	public var driverInfo (default, null):String = "OpenGL (Direct blitting)";
	public var enableErrorChecking(default, set):Bool;
	public var maxBackBufferHeight:Int;
	public var maxBackBufferWidth:Int;
	public var profile (default, null):Context3DProfile = BASELINE;
	public var totalGPUMemory (default, null):Int = 0;
	
	private var __backBufferAntiAlias:Int;
	private var __backBufferEnableDepthAndStencil:Bool;
	private var __backBufferWantsBestResolution:Bool;
	private var __depthRenderBufferID:GLRenderbuffer;
	private var __fragmentConstants:Float32Array;
	private var __frameCount:Int;
	private var __positionScale:Float32Array;
	private var __program:Program3D;
	private var __renderSession:RenderSession;
	private var __renderToTexture:TextureBase;
	private var __samplerDirty:Int;
	private var __samplerTextures:Vector<TextureBase>;
	private var __samplerStates:Array<SamplerState>;
	private var __stage3D:Dynamic;
	private var __stats:Vector<Int>;
	private var __statsCache:Vector<Int>;
	private var __textureDepthBufferID:GLRenderbuffer;
	private var __textureFrameBufferID:GLFramebuffer;
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
			
			__samplerStates[i] = new SamplerState (GL.LINEAR, GL.LINEAR, GL.CLAMP_TO_EDGE, GL.CLAMP_TO_EDGE).intern ();
			
		}
		
		__backBufferAntiAlias = 0;
		__backBufferEnableDepthAndStencil = true;
		__backBufferWantsBestResolution = false;
		
		__frameCount = 0;
		
		__stats = new Vector<Int> (Context3DTelemetry.length);
		__statsCache = new Vector<Int> (Context3DTelemetry.length);
		
		#if telemetry
		//__spanPresent = new Telemetry.Span (".rend.molehill.present");
		//__valueFrame = new Telemetry.Value (".rend.molehill.frame");
		#end
		
		enableErrorChecking = false;
		
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
		
		__depthRenderBufferID = GL.createRenderbuffer ();
		GLUtils.CheckGLError ();
		
		__textureFrameBufferID = GL.createFramebuffer ();
		GLUtils.CheckGLError ();
		
		__textureDepthBufferID = GL.createRenderbuffer ();
		GLUtils.CheckGLError ();
		
		for (i in 0...__stats.length) {
			
			__stats[i] = 0;
			
		}
		
		__stateCache.clearSettings ();
		
	}
	
	
	public function clear (red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0, mask:UInt = Context3DClearMask.ALL):Void {
		
		var clearMask = 0;
		
		if (mask & Context3DClearMask.DEPTH > 0) {
			
			clearMask |= GL.DEPTH_BUFFER_BIT;
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.COLOR > 0) {
			
			clearMask |= GL.COLOR_BUFFER_BIT;
			
			GL.clearColor (red, green, blue, alpha);
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.DEPTH > 0) {
			
			GL.clearDepth (depth);
			GLUtils.CheckGLError ();
			
		}
		
		if (mask & Context3DClearMask.STENCIL > 0) {
			
			clearMask |= GL.STENCIL_BUFFER_BIT;
			
			GL.clearStencil (stencil);
			GLUtils.CheckGLError ();
			
		}
		
		GL.clear (clearMask);
		GLUtils.CheckGLError ();
		
	}
	
	
	public function configureBackBuffer (width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false, wantsBestResolutionOnBrowserZoom:Bool = false):Void {
		
		__setViewport (0, 0, width, height);
		
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
	
	
	public function dispose ():Void {
		
		// TODO
		
	}
	
	
	public function drawToBitmapData (destination:BitmapData):Void {
		
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
		
		var src = GL.ONE;
		var dest = GL.ONE_MINUS_SRC_ALPHA;
		var updateBlendFunction = false;
		
		if (__stateCache.updateBlendSrcFactor (sourceFactor) || __stateCache.updateBlendDestFactor (destinationFactor)) {
			
			updateBlendFunction = true;
			
		}
		
		if (updateBlendFunction) {
			
			switch (sourceFactor) {
				
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
			
			switch (destinationFactor) {
				
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
			GL.blendFunc (src, dest);
			
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
				
				GL.enable(GL.DEPTH_TEST);
				
			} else {
				
				GL.disable(GL.DEPTH_TEST);
				
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
		
		__setViewport (0, 0, backBufferWidth, backBufferHeight);
		
		__positionScale[1] = 1.0;
		
		if (__program != null) {
			
			__program.__setPositionScale (__positionScale);
			
		}
		
		__renderToTexture = null;
		
	}
	
	
	public function setRenderToTexture (texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0):Void {
		
		var texture2D:Texture = cast texture;
		
		if (texture2D == null) {
			
			throw new Error ("Invalid texture");
			
		}
		
		if (!texture.__allocated) {
			
			GL.bindTexture (GL.TEXTURE_2D, texture.__textureID);
			texture.__allocated = true;
			
		}
		
		GL.bindFramebuffer (GL.FRAMEBUFFER, __textureFrameBufferID);
		GL.framebufferTexture2D (GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, texture.__textureID, 0);
		GLUtils.CheckGLError ();
		
		__setViewport (0, 0, texture2D.__width, texture2D.__height);
		
		var code = GL.checkFramebufferStatus (GL.FRAMEBUFFER);
		if (code != GL.FRAMEBUFFER_COMPLETE) {
			
			trace("Error: Context3D.setRenderToTexture status:${code} width:${texture2D.__width} height:${texture2D.__height}");
			
		}
		
		__positionScale[1] = -1.0;
		
		if (__program != null) {
			
			__program.__setPositionScale (__positionScale);
			
		}
		
		__renderToTexture = texture;
		
	}
	
	
	public function setSamplerStateAt (sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void {
		
		if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {
			
			throw new Error ("sampler out of range");
			
		}
		
		var glWrapModeS;
		var glWrapModeT;
		var glMagFilter;
		var glMinFilter;
		
		switch (wrap) {
			
			case Context3DWrapMode.CLAMP:
				
				glWrapModeS = GL.CLAMP_TO_EDGE;
				glWrapModeT = GL.CLAMP_TO_EDGE;
				
			case Context3DWrapMode.CLAMP_U_REPEAT_V:
				
				glWrapModeS = GL.CLAMP_TO_EDGE;
				glWrapModeT = GL.REPEAT;
				
			case Context3DWrapMode.REPEAT:
				
				glWrapModeS = GL.REPEAT;
				glWrapModeT = GL.REPEAT;
				
			case Context3DWrapMode.REPEAT_U_CLAMP_V:
				
				glWrapModeS = GL.REPEAT;
				glWrapModeT = GL.CLAMP_TO_EDGE;
				
			default:
				
				throw new Error ("wrap bad enum");
				
		}
		
		switch (filter) {
			
			case Context3DTextureFilter.LINEAR:
				
				glMagFilter = GL.LINEAR;
				
			case Context3DTextureFilter.NEAREST:
				
				glMagFilter = GL.NEAREST;
				
			case Context3DTextureFilter.ANISOTROPIC2X:
					
				// TODO
				glMagFilter = GL.LINEAR;
				 
			case Context3DTextureFilter.ANISOTROPIC4X:
					
				// TODO
				glMagFilter = GL.LINEAR;
				
			case Context3DTextureFilter.ANISOTROPIC8X:
				
				// TODO
				glMagFilter = GL.LINEAR;
				
			case Context3DTextureFilter.ANISOTROPIC16X:
				
				// TODO
				glMagFilter = GL.LINEAR;
				
			default:
				
				throw new Error ("filter bad enum");
				
		}
		
		switch (mipfilter) {
						
			case Context3DMipFilter.MIPLINEAR:
				
				glMinFilter = GL.LINEAR_MIPMAP_LINEAR;
			
			case Context3DMipFilter.MIPNEAREST:
				
				glMinFilter = GL.NEAREST_MIPMAP_NEAREST;
			
			case Context3DMipFilter.MIPNONE:
				
				glMinFilter = filter == Context3DTextureFilter.NEAREST ? GL.NEAREST : GL.LINEAR;
				
			default:
				
				throw new Error ("mipfiter bad enum");
				
		}
		
		__samplerStates[sampler] = new SamplerState (glMinFilter, glMagFilter, glWrapModeS, glWrapModeT);
		
	}
	
	
	public function setScissorRectangle (rectangle:Rectangle):Void {
		
		if (rectangle != null) {
			
			GL.scissor (Std.int (rectangle.x), Std.int (rectangle.y), Std.int (rectangle.width), Std.int (rectangle.height));
			
		} else {
			
			GL.scissor (0, 0, backBufferWidth, backBufferHeight);
			
		}
		
	}
	
	
	public function setStencilActions (triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS, actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP, actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void {
		
		// TODO
		
	}
	
	
	public function setStencilReferenceValue (referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void {
		
		// TODO
		
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
					
					GL.bindTexture (target, texture.__textureID);
					GLUtils.CheckGLError ();
					
					var state = __program.__getSamplerState(sampler);
					
					if (state != null) {
						
						texture.__setSamplerState (state);
						
					} else {
						
						texture.__setSamplerState (__samplerStates[sampler]);
						
					}
					
				} else {
					
					GL.bindTexture (GL.TEXTURE_2D, null);
					GLUtils.CheckGLError ();
					
				}
				
				__samplerDirty &= ~(1 << sampler);
				
			}
			
			sampler++;
			
		}
		
	}
	
	
	private function __setViewport (originX:Int, originY:Int, width:Int, height:Int):Void {
		
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