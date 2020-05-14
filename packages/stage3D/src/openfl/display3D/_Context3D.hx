package openfl.display3D;

import openfl.events._EventDispatcher;
import openfl.display3D._internal.Context3DState;
import openfl._internal.renderer.BitmapDataPool;
import openfl._internal.renderer.SamplerState;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.textures.RectangleTexture;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.textures._TextureBase;
import openfl.display3D.textures.Texture;
import openfl.display3D.textures.VideoTexture;
import openfl.display._DisplayObjectRenderer;
import openfl.display.BitmapData;
import openfl.display.Stage;
import openfl.display._Stage;
import openfl.display.Stage3D;
import openfl.display._Stage3D;
import openfl.errors.Error;
import openfl.events.EventDispatcher;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.utils.AGALMiniAssembler;
import openfl.utils.ByteArray;
import lime.graphics.opengl.GLBuffer;
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import openfl._internal.renderer.SamplerState;
import lime.utils.Float32Array;
import lime.utils.UInt8Array;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DBlendFactor;
import openfl.display3D.Context3DClearMask;
import openfl.display3D.Context3DCompareMode;
import openfl.display3D.Context3DProgramType;
import openfl.display3D.Context3DStencilAction;
import openfl.display3D.Context3DTriangleFace;
import openfl.display3D.Context3DVertexBufferFormat;
import openfl.display3D.IndexBuffer3D;
import openfl.display3D.VertexBuffer3D;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl.errors.IllegalOperationError;
import openfl.geom.Matrix3D;
import openfl.geom.Point;
import openfl.geom.Rectangle;
#if lime
import lime.graphics.Image;
import lime.graphics.ImageBuffer;
import lime.graphics.RenderContext;
import lime.math.Rectangle as LimeRectangle;
import lime.math.Vector2;
import lime.utils.Float32Array;
import lime.utils.UInt16Array;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:noCompletion
class _Context3D extends _EventDispatcher
{
	public static var glDepthStencil:Int = -1;
	public static var glMaxTextureMaxAnisotropy:Int = -1;
	public static var glMaxViewportDims:Int = -1;
	public static var glMemoryCurrentAvailable:Int = -1;
	public static var glMemoryTotalAvailable:Int = -1;
	public static var glTextureMaxAnisotropy:Int = -1;
	public static var supportsVideoTexture(default, null):Bool = #if openfl_html5 true #else false #end;

	private static var _driverInfo:String;

	public var backBufferHeight(default, null):Int = 0;
	public var backBufferWidth(default, null):Int = 0;
	public var driverInfo(default, null):String = "OpenGL (Direct blitting)";
	public var enableErrorChecking(get, set):Bool;
	public var maxBackBufferHeight(default, null):Int;
	public var maxBackBufferWidth(default, null):Int;
	public var profile(default, null):Context3DProfile = STANDARD;
	public var totalGPUMemory(get, never):Int;

	#if lime
	public var limeContext:RenderContext;
	#end
	public var gl:WebGLRenderContext;

	public var positionScale:Float32Array; // TODO: Better approach?

	public static var __supportsBGRA:Null<Bool> = null;

	public var __backBufferAntiAlias:Int;
	public var __backBufferTexture:RectangleTexture;
	public var __backBufferWantsBestResolution:Bool;
	public var __backBufferWantsBestResolutionOnBrowserZoom:Bool;
	public var __bitmapDataPool:BitmapDataPool;
	public var __cleared:Bool;
	public var __contextState:Context3DState;
	public var __enableErrorChecking:Bool;
	public var __fragmentConstants:Float32Array;
	public var __frontBufferTexture:RectangleTexture;
	public var __present:Bool;
	public var __programs:Map<String, Program3D>;
	public var __quadIndexBuffer:IndexBuffer3D;
	public var __quadIndexBufferCount:Int;
	public var __quadIndexBufferElements:Int;
	public var __renderStage3DProgram:Program3D;
	public var __stage:Stage;
	public var __stage3D:Stage3D;
	public var __state:Context3DState;
	public var __vertexConstants:Float32Array;

	private var context3D:Context3D;

	public function new(context3D:Context3D, stage:Stage, contextState:Context3DState = null, stage3D:Stage3D = null)
	{
		this.context3D = context3D;

		super(context3D);

		__stage = stage;
		__contextState = contextState;
		__stage3D = stage3D;

		if (__contextState == null) __contextState = new Context3DState();
		__state = new Context3DState();

		#if (lime || js)
		// TODO: Dummy impl?
		__vertexConstants = new Float32Array(4 * 128);
		__fragmentConstants = new Float32Array(4 * 128);
		#end

		__programs = new Map<String, Program3D>();

		positionScale = new Float32Array([1.0, 1.0, 1.0, 1.0]);

		#if lime
		limeContext = __stage.limeWindow.context;
		gl = limeContext.webgl;

		if (glMaxViewportDims == -1)
		{
			#if openfl_html5
			glMaxViewportDims = gl.getParameter(GL.MAX_VIEWPORT_DIMS);
			#else
			glMaxViewportDims = 16384;
			#end
		}

		maxBackBufferWidth = glMaxViewportDims;
		maxBackBufferHeight = glMaxViewportDims;

		if (glMaxTextureMaxAnisotropy == -1)
		{
			var extension:Dynamic = gl.getExtension("EXT_texture_filter_anisotropic");

			#if openfl_html5
			if (extension == null
				|| extension.MAX_TEXTURE_MAX_ANISOTROPY_EXT == null) extension = gl.getExtension("MOZ_EXT_texture_filter_anisotropic");
			if (extension == null
				|| extension.MAX_TEXTURE_MAX_ANISOTROPY_EXT == null) extension = gl.getExtension("WEBKIT_EXT_texture_filter_anisotropic");
			#end

			if (extension != null)
			{
				glTextureMaxAnisotropy = extension.TEXTURE_MAX_ANISOTROPY_EXT;
				glMaxTextureMaxAnisotropy = gl.getParameter(extension.MAX_TEXTURE_MAX_ANISOTROPY_EXT);
			}
			else
			{
				glTextureMaxAnisotropy = 0;
				glMaxTextureMaxAnisotropy = 0;
			}
		}

		if (glDepthStencil == -1)
		{
			#if openfl_html5
			glDepthStencil = GL.DEPTH_STENCIL;
			#elseif lime
			if (limeContext.type == OPENGLES && Std.parseFloat(limeContext.version) >= 3)
			{
				glDepthStencil = limeContext.gles3.DEPTH24_STENCIL8;
			}
			else
			{
				var extension = gl.getExtension("OES_packed_depth_stencil");
				if (extension != null)
				{
					glDepthStencil = extension.DEPTH24_STENCIL8_OES;
				}
				else
				{
					extension = gl.getExtension("EXT_packed_depth_stencil");
					if (extension != null)
					{
						glDepthStencil = extension.DEPTH24_STENCIL8_EXT;
					}
					else
					{
						glDepthStencil = 0;
					}
				}
			}
			#end
		}

		if (glMemoryTotalAvailable == -1)
		{
			var extension = gl.getExtension("NVX_gpu_memory_info");
			if (extension != null)
			{
				glMemoryTotalAvailable = extension.GPU_MEMORY_INFO_DEDICATED_VIDMEM_NVX;
				glMemoryCurrentAvailable = extension.GPU_MEMORY_INFO_CURRENT_AVAILABLE_VIDMEM_NVX;
			}
		}

		if (_driverInfo == null)
		{
			var vendor = gl.getParameter(GL.VENDOR);
			var version = gl.getParameter(GL.VERSION);
			var renderer = gl.getParameter(GL.RENDERER);
			var glslVersion = gl.getParameter(GL.SHADING_LANGUAGE_VERSION);

			_driverInfo = "OpenGL Vendor=" + vendor + " Version=" + version + " Renderer=" + renderer + " GLSL=" + glslVersion;
		}

		driverInfo = _driverInfo;
		#end

		__bitmapDataPool = new BitmapDataPool(30, context3D);

		__quadIndexBufferElements = Math.floor(0xFFFF / 4);
		__quadIndexBufferCount = __quadIndexBufferElements * 6;

		#if (lime || js)
		// TODO: Dummy impl?
		var data = new UInt16Array(__quadIndexBufferCount);
		#else
		var data = null;
		#end

		var index:UInt = 0;
		var vertex:UInt = 0;

		for (i in 0...__quadIndexBufferElements)
		{
			data[index] = vertex;
			data[index + 1] = vertex + 1;
			data[index + 2] = vertex + 2;
			data[index + 3] = vertex + 2;
			data[index + 4] = vertex + 1;
			data[index + 5] = vertex + 3;

			index += 6;
			vertex += 4;
		}

		__quadIndexBuffer = createIndexBuffer(__quadIndexBufferCount);
		__quadIndexBuffer.uploadFromTypedArray(data);
	}

	public function clear(red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0,
			mask:UInt = Context3DClearMask.ALL):Void
	{
		flushGLFramebuffer();
		flushGLViewport();

		var clearMask = 0;

		if (mask & Context3DClearMask.COLOR != 0)
		{
			if (__state.renderToTexture == null)
			{
				if (__stage.context3D == this.context3D && !((__stage._ : _Stage).__renderer._ : _DisplayObjectRenderer).__cleared)
				{
					((__stage._ : _Stage).__renderer._ : _DisplayObjectRenderer).__cleared = true;
				}
				__cleared = true;
			}

			clearMask |= GL.COLOR_BUFFER_BIT;

			if (#if openfl_disable_context_cache true #else __contextState.colorMaskRed != true
				|| __contextState.colorMaskGreen != true
				|| __contextState.colorMaskBlue != true
				|| __contextState.colorMaskAlpha != true #end)
			{
				gl.colorMask(true, true, true, true);
				__contextState.colorMaskRed = true;
				__contextState.colorMaskGreen = true;
				__contextState.colorMaskBlue = true;
				__contextState.colorMaskAlpha = true;
			}

			gl.clearColor(red, green, blue, alpha);
		}

		if (mask & Context3DClearMask.DEPTH != 0)
		{
			clearMask |= GL.DEPTH_BUFFER_BIT;

			if (#if openfl_disable_context_cache true #else __contextState.depthMask != true #end)
			{
				gl.depthMask(true);
				__contextState.depthMask = true;
			}

			gl.clearDepth(depth);
		}

		if (mask & Context3DClearMask.STENCIL != 0)
		{
			clearMask |= GL.STENCIL_BUFFER_BIT;

			if (#if openfl_disable_context_cache true #else __contextState.stencilWriteMask != 0xFF #end)
			{
				gl.stencilMask(0xFF);
				__contextState.stencilWriteMask = 0xFF;
			}

			gl.clearStencil(stencil);
			__contextState.stencilWriteMask = 0xFF;
		}

		if (clearMask == 0) return;

		setGLScissorTest(false);
		gl.clear(clearMask);
	}

	public function configureBackBuffer(width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false,
			wantsBestResolutionOnBrowserZoom:Bool = false):Void
	{
		if (__stage3D == null)
		{
			backBufferWidth = width;
			backBufferHeight = height;

			__backBufferAntiAlias = antiAlias;
			__state.backBufferEnableDepthAndStencil = enableDepthAndStencil;
			__backBufferWantsBestResolution = wantsBestResolution;
			__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;
		}
		else
		{
			if (__backBufferTexture == null || backBufferWidth != width || backBufferHeight != height)
			{
				if (__backBufferTexture != null) __backBufferTexture.dispose();
				if (__frontBufferTexture != null) __frontBufferTexture.dispose();

				__backBufferTexture = createRectangleTexture(width, height, BGRA, true);
				__frontBufferTexture = createRectangleTexture(width, height, BGRA, true);

				if ((__stage3D._ : _Stage3D).__renderData.vertexBuffer == null)
				{
					(__stage3D._ : _Stage3D).__renderData.vertexBuffer = createVertexBuffer(4, 5);
				}

				var vertexData = new Vector<Float>([width, height, 0, 1, 1, 0, height, 0, 0, 1, width, 0, 0, 1, 0, 0, 0, 0, 0, 0.0]);

				(__stage3D._ : _Stage3D).__renderData.vertexBuffer.uploadFromVector(vertexData, 0, 20);

				if ((__stage3D._ : _Stage3D).__renderData.indexBuffer == null)
				{
					(__stage3D._ : _Stage3D).__renderData.indexBuffer = createIndexBuffer(6);

					var indexData = new Vector<UInt>([0, 1, 2, 2, 1, 3]);

					(__stage3D._ : _Stage3D).__renderData.indexBuffer.uploadFromVector(indexData, 0, 6);
				}
			}

			backBufferWidth = width;
			backBufferHeight = height;

			__backBufferAntiAlias = antiAlias;
			__state.backBufferEnableDepthAndStencil = enableDepthAndStencil;
			__backBufferWantsBestResolution = wantsBestResolution;
			__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;

			__state.__primaryGLFramebuffer = (__backBufferTexture._ : _TextureBase).getGLFramebuffer(enableDepthAndStencil, antiAlias, 0);
			(__frontBufferTexture._ : _TextureBase).getGLFramebuffer(enableDepthAndStencil, antiAlias, 0);
		}
	}

	public function createCubeTexture(size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):CubeTexture
	{
		return new CubeTexture(this.context3D, size, format, optimizeForRenderToTexture, streamingLevels);
	}

	public function createIndexBuffer(numIndices:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):IndexBuffer3D
	{
		return new IndexBuffer3D(this.context3D, numIndices, bufferUsage);
	}

	public function createProgram(format:Context3DProgramFormat = AGAL):Program3D
	{
		return new Program3D(this.context3D, format);
	}

	public function createRectangleTexture(width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool):RectangleTexture
	{
		return new RectangleTexture(this.context3D, width, height, format, optimizeForRenderToTexture);
	}

	public function createTexture(width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int = 0):Texture
	{
		return new Texture(this.context3D, width, height, format, optimizeForRenderToTexture, streamingLevels);
	}

	public function createVertexBuffer(numVertices:Int, data32PerVertex:Int, bufferUsage:Context3DBufferUsage = STATIC_DRAW):VertexBuffer3D
	{
		return new VertexBuffer3D(this.context3D, numVertices, data32PerVertex, bufferUsage);
	}

	public function createVideoTexture():VideoTexture
	{
		if (supportsVideoTexture)
		{
			return new VideoTexture(this.context3D);
		}
		else
		{
			throw new Error("Video textures are not currently supported");
			return null;
		}
	}

	public function dispose(recreate:Bool = true):Void
	{
		// TODO: Dispose all related buffers

		gl = null;
		driverInfo += " (Disposed)";

		if (__stage3D != null)
		{
			(__stage3D._ : _Stage3D).__renderData.indexBuffer = null;
			(__stage3D._ : _Stage3D).__renderData.vertexBuffer = null;
			(__stage3D._ : _Stage3D).context3D = null;
			__stage3D = null;
		}

		#if lime
		limeContext = null;
		#end
		positionScale = null;

		__renderStage3DProgram = null;
		__frontBufferTexture = null;
		__present = false;
		__backBufferTexture = null;
		__fragmentConstants = null;
		__quadIndexBuffer = null;
		__stage = null;
		__vertexConstants = null;
	}

	public function drawToBitmapData(destination:BitmapData, srcRect:Rectangle = null, destPoint:Point = null):Void
	{
		#if lime
		if (destination == null) return;

		var sourceRect = srcRect != null ? srcRect._.__toLimeRectangle() : new LimeRectangle(0, 0, backBufferWidth, backBufferHeight);
		var destVector = destPoint != null ? destPoint._.__toLimeVector2() : new Vector2();

		if (__stage.context3D == this.context3D)
		{
			if (__stage.limeWindow != null)
			{
				if (__stage3D != null)
				{
					destVector.setTo(Std.int(-__stage3D.x), Std.int(-__stage3D.y));
				}

				var image = __stage.limeWindow.readPixels();
				destination.limeImage.copyPixels(image, sourceRect, destVector);
			}
		}
		else if (__backBufferTexture != null)
		{
			var cacheRenderToTexture = __state.renderToTexture;
			setRenderToBackBuffer();

			flushGLFramebuffer();
			flushGLViewport();

			// TODO: Read less pixels if srcRect is smaller

			var data = new UInt8Array(backBufferWidth * backBufferHeight * 4);
			gl.readPixels(0, 0, backBufferWidth, backBufferHeight, (__backBufferTexture._ : _TextureBase).glFormat, GL.UNSIGNED_BYTE, data);

			var image = new Image(new ImageBuffer(data, backBufferWidth, backBufferHeight, 32, BGRA32));
			destination.limeImage.copyPixels(image, sourceRect, destVector);

			if (cacheRenderToTexture != null)
			{
				setRenderToTexture(cacheRenderToTexture, __state.renderToTextureDepthStencil, __state.renderToTextureAntiAlias,
					__state.renderToTextureSurfaceSelector);
			}
		}
		#end
	}

	public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void
	{
		#if !openfl_disable_display_render
		if (__state.renderToTexture == null)
		{
			// TODO: Make sure state is correct for this?
			if (__stage.context3D == this.context3D && !((__stage._ : _Stage).__renderer._ : _DisplayObjectRenderer).__cleared)
			{
				((__stage._ : _Stage).__renderer._ : _DisplayObjectRenderer).__clear();
			}
			else if (!__cleared)
			{
				// TODO: Throw error if error reporting is enabled?
				clear(0, 0, 0, 0, 1, 0, Context3DClearMask.COLOR);
			}
		}

		flushGL();
		#end

		if (__state.program != null)
		{
			__state.program._.flush();
		}

		var count = (numTriangles == -1) ? indexBuffer._.__numIndices : (numTriangles * 3);

		bindGLElementArrayBuffer(indexBuffer._.glBufferID);
		gl.drawElements(GL.TRIANGLES, count, GL.UNSIGNED_SHORT, firstIndex * 2);
	}

	public function present():Void
	{
		setRenderToBackBuffer();

		if (__stage3D != null && __backBufferTexture != null)
		{
			if (!__cleared)
			{
				// Make sure texture is initialized
				// TODO: Throw error if error reporting is enabled?
				clear(0, 0, 0, 0, 1, 0, Context3DClearMask.COLOR);
			}

			var cacheBuffer = __backBufferTexture;
			__backBufferTexture = __frontBufferTexture;
			__frontBufferTexture = cacheBuffer;

			__state.__primaryGLFramebuffer = (__backBufferTexture._ : _TextureBase).getGLFramebuffer(__state.backBufferEnableDepthAndStencil,
				__backBufferAntiAlias, 0);
			__cleared = false;
		}

		__present = true;
	}

	public function setBlendFactors(sourceFactor:Context3DBlendFactor, destinationFactor:Context3DBlendFactor):Void
	{
		setBlendFactorsSeparate(sourceFactor, destinationFactor, sourceFactor, destinationFactor);
	}

	@:dox(hide) public function setBlendFactorsSeparate(sourceRGBFactor:Context3DBlendFactor, destinationRGBFactor:Context3DBlendFactor,
			sourceAlphaFactor:Context3DBlendFactor, destinationAlphaFactor:Context3DBlendFactor):Void
	{
		__state.blendSourceRGBFactor = sourceRGBFactor;
		__state.blendDestinationRGBFactor = destinationRGBFactor;
		__state.blendSourceAlphaFactor = sourceAlphaFactor;
		__state.blendDestinationAlphaFactor = destinationAlphaFactor;

		#if openfl_gl
		// TODO: Better way to handle this?
		resetGLBlendEquation();
		#end
	}

	public function setColorMask(red:Bool, green:Bool, blue:Bool, alpha:Bool):Void
	{
		__state.colorMaskRed = red;
		__state.colorMaskGreen = green;
		__state.colorMaskBlue = blue;
		__state.colorMaskAlpha = alpha;
	}

	public function setCulling(triangleFaceToCull:Context3DTriangleFace):Void
	{
		__state.culling = triangleFaceToCull;
	}

	public function setDepthTest(depthMask:Bool, passCompareMode:Context3DCompareMode):Void
	{
		__state.depthMask = depthMask;
		__state.depthCompareMode = passCompareMode;
	}

	public function setProgram(program:Program3D):Void
	{
		__state.program = program;
		__state.shader = null; // TODO: Merge this logic

		if (program != null)
		{
			for (i in 0...program._.__samplerStates.length)
			{
				if (__state.samplerStates[i] == null)
				{
					__state.samplerStates[i] = program._.__samplerStates[i].clone();
				}
				else
				{
					__state.samplerStates[i].copyFrom(program._.__samplerStates[i]);
				}
			}
		}
	}

	public function setProgramConstantsFromByteArray(programType:Context3DProgramType, firstRegister:Int, numRegisters:Int, data:ByteArray,
			byteArrayOffset:UInt):Void
	{
		if (numRegisters == 0 || __state.program == null) return;

		if (__state.program != null && __state.program._.__format == GLSL)
		{
			// TODO
		}
		else
		{
			// TODO: Cleanup?

			if (numRegisters == -1)
			{
				numRegisters = ((data.length >> 2) - byteArrayOffset);
			}

			var isVertex = (programType == VERTEX);
			var dest = isVertex ? __vertexConstants : __fragmentConstants;

			#if lime
			var floatData = Float32Array.fromBytes(data, 0, data.length);
			#elseif openfl_html5
			var bytes:haxe.io.Bytes = cast data;
			var floatData = new Float32Array(bytes.getData(), 0, data.length);
			#else
			// TODO: Dummy impl?
			var floatData = null;
			#end
			var outOffset = firstRegister * 4;
			var inOffset = Std.int(byteArrayOffset / 4);

			for (i in 0...(numRegisters * 4))
			{
				dest[outOffset + i] = floatData[inOffset + i];
			}

			if (__state.program != null)
			{
				__state.program._.markDirty(isVertex, firstRegister, numRegisters);
			}
		}
	}

	public function setProgramConstantsFromMatrix(programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void
	{
		if (__state.program != null && __state.program._.__format == GLSL)
		{
			#if openfl_gl
			flushGLProgram();

			// TODO: Cache value, prevent need to copy
			var data = new Float32Array(16);
			for (i in 0...16)
			{
				data[i] = matrix.rawData[i];
			}

			gl.uniformMatrix4fv(cast firstRegister, transposedMatrix, data);
			#end
		}
		else
		{
			var isVertex = (programType == VERTEX);
			var dest = isVertex ? __vertexConstants : __fragmentConstants;
			var source = matrix.rawData;
			var i = firstRegister * 4;

			if (transposedMatrix)
			{
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
			}
			else
			{
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

			if (__state.program != null)
			{
				__state.program._.markDirty(isVertex, firstRegister, 4);
			}
		}
	}

	public function setProgramConstantsFromVector(programType:Context3DProgramType, firstRegister:Int, data:Vector<Float>, numRegisters:Int = -1):Void
	{
		if (numRegisters == 0) return;

		if (__state.program != null && __state.program._.__format == GLSL) {}
		else
		{
			if (numRegisters == -1)
			{
				numRegisters = (data.length >> 2);
			}

			var isVertex = (programType == VERTEX);
			var dest = isVertex ? __vertexConstants : __fragmentConstants;
			var source = data;

			var sourceIndex = 0;
			var destIndex = firstRegister * 4;

			for (i in 0...numRegisters)
			{
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
				dest[destIndex++] = source[sourceIndex++];
			}

			if (__state.program != null)
			{
				__state.program._.markDirty(isVertex, firstRegister, numRegisters);
			}
		}
	}

	public function setRenderToBackBuffer():Void
	{
		__state.renderToTexture = null;
	}

	public function setRenderToTexture(texture:TextureBase, enableDepthAndStencil:Bool = false, antiAlias:Int = 0, surfaceSelector:Int = 0):Void
	{
		__state.renderToTexture = texture;
		__state.renderToTextureDepthStencil = enableDepthAndStencil;
		__state.renderToTextureAntiAlias = antiAlias;
		__state.renderToTextureSurfaceSelector = surfaceSelector;
	}

	public function setSamplerStateAt(sampler:Int, wrap:Context3DWrapMode, filter:Context3DTextureFilter, mipfilter:Context3DMipFilter):Void
	{
		// if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {

		// 	throw new Error ("sampler out of range");

		// }

		if (__state.samplerStates[sampler] == null)
		{
			__state.samplerStates[sampler] = new SamplerState();
		}

		var state = __state.samplerStates[sampler];
		state.wrap = wrap;
		state.filter = filter;
		state.mipfilter = mipfilter;
	}

	public function setScissorRectangle(rectangle:Rectangle):Void
	{
		if (rectangle != null)
		{
			__state.scissorEnabled = true;
			__state.scissorRectangle.copyFrom(rectangle);
		}
		else
		{
			__state.scissorEnabled = false;
		}
	}

	public function setStencilActions(triangleFace:Context3DTriangleFace = FRONT_AND_BACK, compareMode:Context3DCompareMode = ALWAYS,
			actionOnBothPass:Context3DStencilAction = KEEP, actionOnDepthFail:Context3DStencilAction = KEEP,
			actionOnDepthPassStencilFail:Context3DStencilAction = KEEP):Void
	{
		__state.stencilTriangleFace = triangleFace;
		__state.stencilCompareMode = compareMode;
		__state.stencilPass = actionOnBothPass;
		__state.stencilDepthFail = actionOnDepthFail;
		__state.stencilFail = actionOnDepthPassStencilFail;
	}

	public function setStencilReferenceValue(referenceValue:UInt, readMask:UInt = 0xFF, writeMask:UInt = 0xFF):Void
	{
		__state.stencilReferenceValue = referenceValue;
		__state.stencilReadMask = readMask;
		__state.stencilWriteMask = writeMask;
	}

	public function setTextureAt(sampler:Int, texture:TextureBase):Void
	{
		// if (sampler < 0 || sampler > Context3D.MAX_SAMPLERS) {

		// 	throw new Error ("sampler out of range");

		// }

		__state.textures[sampler] = texture;
	}

	public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void
	{
		// TODO: Don't flush immediately?
		#if openfl_gl
		if (buffer == null)
		{
			gl.disableVertexAttribArray(index);
			bindGLArrayBuffer(null);
			return;
		}

		bindGLArrayBuffer(buffer._.glBufferID);
		gl.enableVertexAttribArray(index);

		var byteOffset = bufferOffset * 4;
		var stride = buffer._.stride;

		switch (format)
		{
			case BYTES_4:
				gl.vertexAttribPointer(index, 4, GL.UNSIGNED_BYTE, true, stride, byteOffset);

			case FLOAT_4:
				gl.vertexAttribPointer(index, 4, GL.FLOAT, false, stride, byteOffset);

			case FLOAT_3:
				gl.vertexAttribPointer(index, 3, GL.FLOAT, false, stride, byteOffset);

			case FLOAT_2:
				gl.vertexAttribPointer(index, 2, GL.FLOAT, false, stride, byteOffset);

			case FLOAT_1:
				gl.vertexAttribPointer(index, 1, GL.FLOAT, false, stride, byteOffset);

			default:
				throw new IllegalOperationError();
		}
		#end
	}

	public function __renderStage3D(stage3D:Stage3D):Void
	{
		// Assume this is the primary Context3D

		var context = stage3D.context3D;

		if (context != null
			&& context != this.context3D
			&& (context._ : _Context3D).__frontBufferTexture != null && stage3D.visible && backBufferHeight > 0 && backBufferWidth > 0)
		{
			// if (!stage.renderer.cleared) stage.renderer.clear ();

			if (__renderStage3DProgram == null)
			{
				var vertexAssembler = new AGALMiniAssembler();
				vertexAssembler.assemble(Context3DProgramType.VERTEX, "m44 op, va0, vc0\n" + "mov v0, va1");

				var fragmentAssembler = new AGALMiniAssembler();
				fragmentAssembler.assemble(Context3DProgramType.FRAGMENT, "tex ft1, v0, fs0 <2d,nearest,nomip>\n" + "mov oc, ft1");

				__renderStage3DProgram = createProgram();
				__renderStage3DProgram.upload(vertexAssembler.agalcode, fragmentAssembler.agalcode);
			}

			setProgram(__renderStage3DProgram);

			setBlendFactors(ONE, ZERO);
			setColorMask(true, true, true, true);
			setCulling(NONE);
			setDepthTest(false, ALWAYS);
			setStencilActions();
			setStencilReferenceValue(0, 0, 0);
			setScissorRectangle(null);

			setTextureAt(0, (context._ : _Context3D).__frontBufferTexture);
			setVertexBufferAt(0, (stage3D._ : _Stage3D).__renderData.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			setVertexBufferAt(1, (stage3D._ : _Stage3D).__renderData.vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, (stage3D._ : _Stage3D).__renderTransform, true);
			drawTriangles((stage3D._ : _Stage3D).__renderData.indexBuffer);

			__present = true;
		}
	}

	public function bindGLArrayBuffer(buffer:GLBuffer):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__currentGLArrayBuffer != buffer #end)
		{
			gl.bindBuffer(GL.ARRAY_BUFFER, buffer);
			__contextState.__currentGLArrayBuffer = buffer;
		}
	}

	public function bindGLElementArrayBuffer(buffer:GLBuffer):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__currentGLElementArrayBuffer != buffer #end)
		{
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, buffer);
			__contextState.__currentGLElementArrayBuffer = buffer;
		}
	}

	public function bindGLFramebuffer(framebuffer:GLFramebuffer):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__currentGLFramebuffer != framebuffer #end)
		{
			gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
			__contextState.__currentGLFramebuffer = framebuffer;
		}
	}

	public function bindGLTexture2D(texture:GLTexture):Void
	{
		// TODO: Need to consider activeTexture ID

		// if (#if openfl_disable_context_cache true #else __contextState.__currentGLTexture2D != texture #end) {

		gl.bindTexture(GL.TEXTURE_2D, texture);
		__contextState.__currentGLTexture2D = texture;

		// }
	}

	public function bindGLTextureCubeMap(texture:GLTexture):Void
	{
		// TODO: Need to consider activeTexture ID

		// if (#if openfl_disable_context_cache true #else __contextState.__currentGLTextureCubeMap != texture #end) {

		gl.bindTexture(GL.TEXTURE_CUBE_MAP, texture);
		__contextState.__currentGLTextureCubeMap = texture;

		// }
	}

	public function _drawTriangles(firstIndex:Int = 0, count:Int):Void
	{
		#if !openfl_disable_display_render
		if (__state.renderToTexture == null)
		{
			// TODO: Make sure state is correct for this?
			if (__stage.context3D == this.context3D && !((__stage._ : _Stage).__renderer._ : _DisplayObjectRenderer).__cleared)
			{
				((__stage._ : _Stage).__renderer._ : _DisplayObjectRenderer).__clear();
			}
			else if (!__cleared)
			{
				// TODO: Throw error if error reporting is enabled?
				clear(0, 0, 0, 0, 1, 0, Context3DClearMask.COLOR);
			}
		}

		flushGL();
		#end

		if (__state.program != null)
		{
			__state.program._.flush();
		}

		gl.drawArrays(GL.TRIANGLES, firstIndex, count);
	}

	public function flushGL():Void
	{
		flushGLProgram();
		flushGLFramebuffer();
		flushGLViewport();

		flushGLBlend();
		flushGLColor();
		flushGLCulling();
		flushGLDepth();
		flushGLScissor();
		flushGLStencil();
		flushGLTextures();
	}

	public function flushGLBlend():Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.blendDestinationRGBFactor != __state.blendDestinationRGBFactor
			|| __contextState.blendSourceRGBFactor != __state.blendSourceRGBFactor
			|| __contextState.blendDestinationAlphaFactor != __state.blendDestinationAlphaFactor
			|| __contextState.blendSourceAlphaFactor != __state.blendSourceAlphaFactor #end)
		{
			setGLBlend(true);

			if (__state.blendDestinationRGBFactor == __state.blendDestinationAlphaFactor
				&& __state.blendSourceRGBFactor == __state.blendSourceAlphaFactor)
			{
				gl.blendFunc(getGLBlend(__state.blendSourceRGBFactor), getGLBlend(__state.blendDestinationRGBFactor));
			}
			else
			{
				gl.blendFuncSeparate(getGLBlend(__state.blendSourceRGBFactor), getGLBlend(__state.blendDestinationRGBFactor),
					getGLBlend(__state.blendSourceAlphaFactor), getGLBlend(__state.blendDestinationAlphaFactor));
			}

			__contextState.blendDestinationRGBFactor = __state.blendDestinationRGBFactor;
			__contextState.blendSourceRGBFactor = __state.blendSourceRGBFactor;
			__contextState.blendDestinationAlphaFactor = __state.blendDestinationAlphaFactor;
			__contextState.blendSourceAlphaFactor = __state.blendSourceAlphaFactor;
		}
	}

	public inline function flushGLColor():Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.colorMaskRed != __state.colorMaskRed
			|| __contextState.colorMaskGreen != __state.colorMaskGreen
			|| __contextState.colorMaskBlue != __state.colorMaskBlue
			|| __contextState.colorMaskAlpha != __state.colorMaskAlpha #end)
		{
			gl.colorMask(__state.colorMaskRed, __state.colorMaskGreen, __state.colorMaskBlue, __state.colorMaskAlpha);
			__contextState.colorMaskRed = __state.colorMaskRed;
			__contextState.colorMaskGreen = __state.colorMaskGreen;
			__contextState.colorMaskBlue = __state.colorMaskBlue;
			__contextState.colorMaskAlpha = __state.colorMaskAlpha;
		}
	}

	public function flushGLCulling():Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.culling != __state.culling #end)
		{
			if (__state.culling == NONE)
			{
				setGLCullFace(false);
			}
			else
			{
				setGLCullFace(true);

				switch (__state.culling)
				{
					case NONE: // skip
					case BACK:
						gl.cullFace(GL.BACK);
					case FRONT:
						gl.cullFace(GL.FRONT);
					case FRONT_AND_BACK:
						gl.cullFace(GL.FRONT_AND_BACK);
					default:
						throw new IllegalOperationError();
				}
			}

			__contextState.culling = __state.culling;
		}
	}

	public function flushGLDepth():Void
	{
		var depthMask = (__state.depthMask
			&& (__state.renderToTexture != null ? __state.renderToTextureDepthStencil : __state.backBufferEnableDepthAndStencil));

		if (#if openfl_disable_context_cache true #else __contextState.depthMask != depthMask #end)
		{
			gl.depthMask(depthMask);
			__contextState.depthMask = depthMask;
		}

		if (#if openfl_disable_context_cache true #else __contextState.depthCompareMode != __state.depthCompareMode #end)
		{
			switch (__state.depthCompareMode)
			{
				case ALWAYS:
					gl.depthFunc(GL.ALWAYS);
				case EQUAL:
					gl.depthFunc(GL.EQUAL);
				case GREATER:
					gl.depthFunc(GL.GREATER);
				case GREATER_EQUAL:
					gl.depthFunc(GL.GEQUAL);
				case LESS:
					gl.depthFunc(GL.LESS);
				case LESS_EQUAL:
					gl.depthFunc(GL.LEQUAL);
				case NEVER:
					gl.depthFunc(GL.NEVER);
				case NOT_EQUAL:
					gl.depthFunc(GL.NOTEQUAL);
				default:
					throw new IllegalOperationError();
			}

			__contextState.depthCompareMode = __state.depthCompareMode;
		}
	}

	public function flushGLFramebuffer():Void
	{
		if (__state.renderToTexture != null)
		{
			if (#if openfl_disable_context_cache true #else __contextState.renderToTexture != __state.renderToTexture
				|| __contextState.renderToTextureSurfaceSelector != __state.renderToTextureSurfaceSelector #end)
			{
				var framebuffer = (__state.renderToTexture._ : _TextureBase).getGLFramebuffer(__state.renderToTextureDepthStencil,
					__state.renderToTextureAntiAlias, __state.renderToTextureSurfaceSelector);
				bindGLFramebuffer(framebuffer);

				__contextState.renderToTexture = __state.renderToTexture;
				__contextState.renderToTextureAntiAlias = __state.renderToTextureAntiAlias;
				__contextState.renderToTextureDepthStencil = __state.renderToTextureDepthStencil;
				__contextState.renderToTextureSurfaceSelector = __state.renderToTextureSurfaceSelector;
			}

			setGLDepthTest(__state.renderToTextureDepthStencil);
			setGLStencilTest(__state.renderToTextureDepthStencil);

			setGLFrontFace(true);
		}
		else
		{
			if (__stage == null && backBufferWidth == 0 && backBufferHeight == 0)
			{
				throw new Error("Context3D backbuffer has not been configured");
			}

			if (#if openfl_disable_context_cache true #else __contextState.renderToTexture != null
				|| __contextState.__currentGLFramebuffer != __state.__primaryGLFramebuffer
				|| __contextState.backBufferEnableDepthAndStencil != __state.backBufferEnableDepthAndStencil #end
			)
			{
				bindGLFramebuffer(__state.__primaryGLFramebuffer);

				__contextState.renderToTexture = null;
				__contextState.backBufferEnableDepthAndStencil = __state.backBufferEnableDepthAndStencil;
			}

			setGLDepthTest(__state.backBufferEnableDepthAndStencil);
			setGLStencilTest(__state.backBufferEnableDepthAndStencil);

			setGLFrontFace(__stage.context3D != this.context3D);
		}
	}

	public function flushGLProgram():Void
	{
		var shader = __state.shader;
		var program = __state.program;

		if (#if openfl_disable_context_cache true #else __contextState.shader != shader #end)
		{
			// TODO: Merge this logic

			if (__contextState.shader != null)
			{
				__contextState.shader._.disable();
			}

			if (shader != null)
			{
				shader._.enable();
			}

			__contextState.shader = shader;
		}

		if (#if openfl_disable_context_cache true #else __contextState.program != program #end)
		{
			if (__contextState.program != null)
			{
				__contextState.program._.disable();
			}

			if (program != null)
			{
				program._.enable();
			}

			__contextState.program = program;
		}

		if (program != null && program._.__format == AGAL)
		{
			positionScale[1] = (__stage.context3D == this.context3D && __state.renderToTexture == null) ? 1.0 : -1.0;
			program._.setPositionScale(positionScale);
		}
	}

	public function flushGLScissor():Void
	{
		#if lime
		if (!__state.scissorEnabled)
		{
			if (#if openfl_disable_context_cache true #else __contextState.scissorEnabled != __state.scissorEnabled #end)
			{
				setGLScissorTest(false);
				__contextState.scissorEnabled = false;
			}
		}
		else
		{
			setGLScissorTest(true);
			__contextState.scissorEnabled = true;

			var scissorX = Std.int(__state.scissorRectangle.x);
			var scissorY = Std.int(__state.scissorRectangle.y);
			var scissorWidth = Std.int(__state.scissorRectangle.width);
			var scissorHeight = Std.int(__state.scissorRectangle.height);

			if (__state.renderToTexture == null && __stage3D == null)
			{
				var contextHeight = Std.int(__stage.limeWindow.height * __stage.limeWindow.scale);
				scissorY = contextHeight - Std.int(__state.scissorRectangle.height) - scissorY;
			}

			if (#if openfl_disable_context_cache true #else __contextState.scissorRectangle.x != scissorX
				|| __contextState.scissorRectangle.y != scissorY
				|| __contextState.scissorRectangle.width != scissorWidth
				|| __contextState.scissorRectangle.height != scissorHeight #end)
			{
				gl.scissor(scissorX, scissorY, scissorWidth, scissorHeight);
				__contextState.scissorRectangle.setTo(scissorX, scissorY, scissorWidth, scissorHeight);
			}
		}
		#end
	}

	public function flushGLStencil():Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.stencilTriangleFace != __state.stencilTriangleFace
			|| __contextState.stencilPass != __state.stencilPass
			|| __contextState.stencilDepthFail != __state.stencilDepthFail
			|| __contextState.stencilFail != __state.stencilFail #end)
		{
			gl.stencilOpSeparate(getGLTriangleFace(__state.stencilTriangleFace), getGLStencilAction(__state.stencilFail),
				getGLStencilAction(__state.stencilDepthFail), getGLStencilAction(__state.stencilPass));
			__contextState.stencilTriangleFace = __state.stencilTriangleFace;
			__contextState.stencilPass = __state.stencilPass;
			__contextState.stencilDepthFail = __state.stencilDepthFail;
			__contextState.stencilFail = __state.stencilFail;
		}

		if (#if openfl_disable_context_cache true #else __contextState.stencilWriteMask != __state.stencilWriteMask #end)
		{
			gl.stencilMask(__state.stencilWriteMask);
			__contextState.stencilWriteMask = __state.stencilWriteMask;
		}

		if (#if openfl_disable_context_cache true #else __contextState.stencilCompareMode != __state.stencilCompareMode
			|| __contextState.stencilReferenceValue != __state.stencilReferenceValue
			|| __contextState.stencilReadMask != __state.stencilReadMask #end
		)
		{
			gl.stencilFunc(getGLCompareMode(__state.stencilCompareMode), __state.stencilReferenceValue, __state.stencilReadMask);
			__contextState.stencilCompareMode = __state.stencilCompareMode;
			__contextState.stencilReferenceValue = __state.stencilReferenceValue;
			__contextState.stencilReadMask = __state.stencilReadMask;
		}
	}

	public function flushGLTextures():Void
	{
		var sampler = 0;
		var texture, samplerState;

		for (i in 0...__state.textures.length)
		{
			texture = __state.textures[i];
			samplerState = __state.samplerStates[i];
			if (samplerState == null)
			{
				__state.samplerStates[i] = new SamplerState();
				samplerState = __state.samplerStates[i];
			}

			gl.activeTexture(GL.TEXTURE0 + sampler);

			if (texture != null)
			{
				// if (#if openfl_disable_context_cache true #else texture != __contextState.textures[i] #end) {

				// TODO: Cleaner approach?
				if ((texture._ : _TextureBase).glTextureTarget == GL.TEXTURE_2D)
				{
					bindGLTexture2D((texture._ : _TextureBase).getTexture());
				}
				else
				{
					bindGLTextureCubeMap((texture._ : _TextureBase).getTexture());
				}

				#if (desktop && !html5)
				// TODO: Cache?
				gl.enable(GL.TEXTURE_2D);
				#end

				__contextState.textures[i] = texture;

				// }

				(texture._ : _TextureBase).setSamplerState(samplerState);
			}
			else
			{
				bindGLTexture2D(null);
			}

			if (__state.program != null && __state.program._.__format == AGAL && samplerState.textureAlpha)
			{
				gl.activeTexture(GL.TEXTURE0 + sampler + 4);

				if (texture != null && (texture._ : _TextureBase).alphaTexture != null)
				{
					if (((texture._ : _TextureBase).alphaTexture._ : _TextureBase).glTextureTarget == GL.TEXTURE_2D)
					{
						bindGLTexture2D(((texture._ : _TextureBase).alphaTexture._ : _TextureBase).getTexture());
					}
					else
					{
						bindGLTextureCubeMap(((texture._ : _TextureBase).alphaTexture._ : _TextureBase).getTexture());
					}

						((texture._ : _TextureBase).alphaTexture._ : _TextureBase).setSamplerState(samplerState);
					gl.uniform1i((__state.program._ : _Program3D).agalAlphaSamplerEnabled[sampler].location, 1);

					#if (desktop && !html5)
					// TODO: Cache?
					gl.enable(GL.TEXTURE_2D);
					#end
				}
				else
				{
					bindGLTexture2D(null);
					if ((__state.program._ : _Program3D).agalAlphaSamplerEnabled[sampler] != null)
					{
						gl.uniform1i((__state.program._ : _Program3D).agalAlphaSamplerEnabled[sampler].location, 0);
					}
				}
			}

			sampler++;
		}
	}

	public function flushGLViewport():Void
	{
		#if lime
		// TODO: Cache

		if (__state.renderToTexture == null)
		{
			if (__stage.context3D == this.context3D)
			{
				var x = __stage3D == null ? 0 : Std.int(__stage3D.x);
				var y = Std.int((__stage.limeWindow.height * __stage.limeWindow.scale) - backBufferHeight - (__stage3D == null ? 0 : __stage3D.y));
				gl.viewport(x, y, backBufferWidth, backBufferHeight);
			}
			else
			{
				gl.viewport(0, 0, backBufferWidth, backBufferHeight);
			}
		}
		else
		{
			gl.viewport(0, 0, (__state.renderToTexture._ : _TextureBase).__width, (__state.renderToTexture._ : _TextureBase).__height);
		}
		#end
	}

	public function getGLBlend(blendFactor:Context3DBlendFactor):Int
	{
		switch (blendFactor)
		{
			case DESTINATION_ALPHA:
				return GL.DST_ALPHA;
			case DESTINATION_COLOR:
				return GL.DST_COLOR;
			case ONE:
				return GL.ONE;
			case ONE_MINUS_DESTINATION_ALPHA:
				return GL.ONE_MINUS_DST_ALPHA;
			case ONE_MINUS_DESTINATION_COLOR:
				return GL.ONE_MINUS_DST_COLOR;
			case ONE_MINUS_SOURCE_ALPHA:
				return GL.ONE_MINUS_SRC_ALPHA;
			case ONE_MINUS_SOURCE_COLOR:
				return GL.ONE_MINUS_SRC_COLOR;
			case SOURCE_ALPHA:
				return GL.SRC_ALPHA;
			case SOURCE_COLOR:
				return GL.SRC_COLOR;
			case ZERO:
				return GL.ZERO;
			default:
				throw new IllegalOperationError();
		}

		return 0;
	}

	public function getGLCompareMode(mode:Context3DCompareMode):Int
	{
		return switch (mode)
		{
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

	public function getGLStencilAction(action:Context3DStencilAction):Int
	{
		return switch (action)
		{
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

	public function getGLTriangleFace(face:Context3DTriangleFace):Int
	{
		return switch (face)
		{
			case FRONT: GL.FRONT;
			case BACK: GL.BACK;
			case FRONT_AND_BACK: GL.FRONT_AND_BACK;
			case NONE: GL.NONE;
			default: GL.FRONT_AND_BACK;
		}
	}

	public function resetGLBlendEquation():Void
	{
		setGLBlendEquation(GL.FUNC_ADD);
	}

	public function setGLBlend(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLBlend != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.BLEND);
			}
			else
			{
				gl.disable(GL.BLEND);
			}
			__contextState.__enableGLBlend = enable;
		}
	}

	public function setGLBlendEquation(value:Int):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__glBlendEquation != value #end)
		{
			gl.blendEquation(value);
			__contextState.__glBlendEquation = value;
		}
	}

	public function setGLCullFace(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLCullFace != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.CULL_FACE);
			}
			else
			{
				gl.disable(GL.CULL_FACE);
			}
			__contextState.__enableGLCullFace = enable;
		}
	}

	public function setGLDepthTest(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLDepthTest != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.DEPTH_TEST);
			}
			else
			{
				gl.disable(GL.DEPTH_TEST);
			}
			__contextState.__enableGLDepthTest = enable;
		}
	}

	public function setGLFrontFace(counterClockWise:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__frontFaceGLCCW != counterClockWise #end)
		{
			gl.frontFace(counterClockWise ? GL.CCW : GL.CW);
			__contextState.__frontFaceGLCCW = counterClockWise;
		}
	}

	public function setGLScissorTest(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLScissorTest != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.SCISSOR_TEST);
			}
			else
			{
				gl.disable(GL.SCISSOR_TEST);
			}
			__contextState.__enableGLScissorTest = enable;
		}
	}

	public function setGLStencilTest(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else __contextState.__enableGLStencilTest != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.STENCIL_TEST);
			}
			else
			{
				gl.disable(GL.STENCIL_TEST);
			}
			__contextState.__enableGLStencilTest = enable;
		}
	}

	// Get & Set Methods

	private function get_enableErrorChecking():Bool
	{
		return __enableErrorChecking;
	}

	private function set_enableErrorChecking(value:Bool):Bool
	{
		return __enableErrorChecking = value;
	}

	private function get_totalGPUMemory():Int
	{
		if (glMemoryCurrentAvailable != -1)
		{
			// TODO: Return amount used by this application only
			var current = gl.getParameter(glMemoryCurrentAvailable);
			var total = gl.getParameter(glMemoryTotalAvailable);

			if (total > 0)
			{
				return (total - current) * 1024;
			}
		}
		return 0;
	}
}
