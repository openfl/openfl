package openfl._internal.backend.opengl;

#if openfl_gl
import openfl._internal.bindings.gl.GLBuffer;
import openfl._internal.bindings.gl.GLFramebuffer;
import openfl._internal.bindings.gl.GLTexture;
import openfl._internal.bindings.gl.GL;
import openfl._internal.bindings.gl.WebGLRenderingContext;
import openfl._internal.renderer.SamplerState;
import openfl._internal.bindings.typedarray.Float32Array;
import openfl._internal.bindings.typedarray.UInt8Array;
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
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.backend.opengl)
@:access(openfl._internal.renderer.context3D.Context3DState)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.IndexBuffer3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display3D.VertexBuffer3D)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.Shader)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.geom.Point)
@:access(openfl.geom.Rectangle)
class OpenGLContext3DBackend
{
	public static var glDepthStencil:Int = -1;
	public static var glMaxTextureMaxAnisotropy:Int = -1;
	public static var glMaxViewportDims:Int = -1;
	public static var glMemoryCurrentAvailable:Int = -1;
	public static var glMemoryTotalAvailable:Int = -1;
	public static var glTextureMaxAnisotropy:Int = -1;

	private static var driverInfo:String;

	#if lime
	public var limeContext:RenderContext;
	#end
	public var gl:WebGLRenderingContext;

	private var parent:Context3D;
	private var positionScale:Float32Array; // TODO: Better approach?

	public function new(parent:Context3D)
	{
		this.parent = parent;

		positionScale = new Float32Array([1.0, 1.0, 1.0, 1.0]);

		#if lime
		limeContext = parent.__stage.limeWindow.context;
		gl = limeContext.webgl;

		if (glMaxViewportDims == -1)
		{
			#if openfl_html5
			glMaxViewportDims = gl.getParameter(GL.MAX_VIEWPORT_DIMS);
			#else
			glMaxViewportDims = 16384;
			#end
		}

		parent.maxBackBufferWidth = glMaxViewportDims;
		parent.maxBackBufferHeight = glMaxViewportDims;

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

		if (driverInfo == null)
		{
			var vendor = gl.getParameter(GL.VENDOR);
			var version = gl.getParameter(GL.VERSION);
			var renderer = gl.getParameter(GL.RENDERER);
			var glslVersion = gl.getParameter(GL.SHADING_LANGUAGE_VERSION);

			driverInfo = "OpenGL Vendor=" + vendor + " Version=" + version + " Renderer=" + renderer + " GLSL=" + glslVersion;
		}

		parent.driverInfo = driverInfo;
		#end
	}

	public function clear(red:Float = 0, green:Float = 0, blue:Float = 0, alpha:Float = 1, depth:Float = 1, stencil:UInt = 0,
			mask:UInt = Context3DClearMask.ALL):Void
	{
		flushGLFramebuffer();
		flushGLViewport();

		var clearMask = 0;

		if (mask & Context3DClearMask.COLOR != 0)
		{
			if (parent.__state.renderToTexture == null)
			{
				if (parent.__stage.context3D == parent && !parent.__stage.__renderer.__cleared) parent.__stage.__renderer.__cleared = true;
				parent.__cleared = true;
			}

			clearMask |= GL.COLOR_BUFFER_BIT;

			if (#if openfl_disable_context_cache true #else parent.__contextState.colorMaskRed != true
				|| parent.__contextState.colorMaskGreen != true
				|| parent.__contextState.colorMaskBlue != true
				|| parent.__contextState.colorMaskAlpha != true #end)
			{
				gl.colorMask(true, true, true, true);
				parent.__contextState.colorMaskRed = true;
				parent.__contextState.colorMaskGreen = true;
				parent.__contextState.colorMaskBlue = true;
				parent.__contextState.colorMaskAlpha = true;
			}

			gl.clearColor(red, green, blue, alpha);
		}

		if (mask & Context3DClearMask.DEPTH != 0)
		{
			clearMask |= GL.DEPTH_BUFFER_BIT;

			if (#if openfl_disable_context_cache true #else parent.__contextState.depthMask != true #end)
			{
				gl.depthMask(true);
				parent.__contextState.depthMask = true;
			}

			gl.clearDepth(depth);
		}

		if (mask & Context3DClearMask.STENCIL != 0)
		{
			clearMask |= GL.STENCIL_BUFFER_BIT;

			if (#if openfl_disable_context_cache true #else parent.__contextState.stencilWriteMask != 0xFF #end)
			{
				gl.stencilMask(0xFF);
				parent.__contextState.stencilWriteMask = 0xFF;
			}

			gl.clearStencil(stencil);
			parent.__contextState.stencilWriteMask = 0xFF;
		}

		if (clearMask == 0) return;

		setGLScissorTest(false);
		gl.clear(clearMask);
	}

	public function configureBackBuffer(width:Int, height:Int, antiAlias:Int, enableDepthAndStencil:Bool = true, wantsBestResolution:Bool = false,
			wantsBestResolutionOnBrowserZoom:Bool = false):Void
	{
		if (parent.__stage3D == null)
		{
			parent.backBufferWidth = width;
			parent.backBufferHeight = height;

			parent.__backBufferAntiAlias = antiAlias;
			parent.__state.backBufferEnableDepthAndStencil = enableDepthAndStencil;
			parent.__backBufferWantsBestResolution = wantsBestResolution;
			parent.__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;
		}
		else
		{
			if (parent.__backBufferTexture == null || parent.backBufferWidth != width || parent.backBufferHeight != height)
			{
				if (parent.__backBufferTexture != null) parent.__backBufferTexture.dispose();
				if (parent.__frontBufferTexture != null) parent.__frontBufferTexture.dispose();

				parent.__backBufferTexture = parent.createRectangleTexture(width, height, BGRA, true);
				parent.__frontBufferTexture = parent.createRectangleTexture(width, height, BGRA, true);

				if (parent.__stage3D.__renderData.vertexBuffer == null)
				{
					parent.__stage3D.__renderData.vertexBuffer = parent.createVertexBuffer(4, 5);
				}

				var vertexData = new Vector<Float>([width, height, 0, 1, 1, 0, height, 0, 0, 1, width, 0, 0, 1, 0, 0, 0, 0, 0, 0.0]);

				parent.__stage3D.__renderData.vertexBuffer.uploadFromVector(vertexData, 0, 20);

				if (parent.__stage3D.__renderData.indexBuffer == null)
				{
					parent.__stage3D.__renderData.indexBuffer = parent.createIndexBuffer(6);

					var indexData = new Vector<UInt>([0, 1, 2, 2, 1, 3]);

					parent.__stage3D.__renderData.indexBuffer.uploadFromVector(indexData, 0, 6);
				}
			}

			parent.backBufferWidth = width;
			parent.backBufferHeight = height;

			parent.__backBufferAntiAlias = antiAlias;
			parent.__state.backBufferEnableDepthAndStencil = enableDepthAndStencil;
			parent.__backBufferWantsBestResolution = wantsBestResolution;
			parent.__backBufferWantsBestResolutionOnBrowserZoom = wantsBestResolutionOnBrowserZoom;

			parent.__state.__primaryGLFramebuffer = parent.__backBufferTexture.__baseBackend.getGLFramebuffer(enableDepthAndStencil, antiAlias, 0);
			parent.__frontBufferTexture.__baseBackend.getGLFramebuffer(enableDepthAndStencil, antiAlias, 0);
		}
	}

	public function dispose(recreate:Bool = true):Void
	{
		// TODO: Dispose all related buffers

		gl = null;
		driverInfo += " (Disposed)";

		if (parent.__stage3D != null)
		{
			parent.__stage3D.__renderData.indexBuffer = null;
			parent.__stage3D.__renderData.vertexBuffer = null;
			parent.__stage3D.context3D = null;
			parent.__stage3D = null;
		}

		#if lime
		limeContext = null;
		#end
		positionScale = null;
	}

	public function drawToBitmapData(destination:BitmapData, srcRect:Rectangle = null, destPoint:Point = null):Void
	{
		#if lime
		if (destination == null) return;

		var sourceRect = srcRect != null ? srcRect.__toLimeRectangle() : new LimeRectangle(0, 0, parent.backBufferWidth, parent.backBufferHeight);
		var destVector = destPoint != null ? destPoint.__toLimeVector2() : new Vector2();

		if (parent.__stage.context3D == parent)
		{
			if (parent.__stage.limeWindow != null)
			{
				if (parent.__stage3D != null)
				{
					destVector.setTo(Std.int(-parent.__stage3D.x), Std.int(-parent.__stage3D.y));
				}

				var image = parent.__stage.limeWindow.readPixels();
				destination.limeImage.copyPixels(image, sourceRect, destVector);
			}
		}
		else if (parent.__backBufferTexture != null)
		{
			var cacheRenderToTexture = parent.__state.renderToTexture;
			parent.setRenderToBackBuffer();

			flushGLFramebuffer();
			flushGLViewport();

			// TODO: Read less pixels if srcRect is smaller

			var data = new UInt8Array(parent.backBufferWidth * parent.backBufferHeight * 4);
			gl.readPixels(0, 0, parent.backBufferWidth, parent.backBufferHeight, parent.__backBufferTexture.__backend.glFormat, GL.UNSIGNED_BYTE, data);

			var image = new Image(new ImageBuffer(data, parent.backBufferWidth, parent.backBufferHeight, 32, BGRA32));
			destination.limeImage.copyPixels(image, sourceRect, destVector);

			if (cacheRenderToTexture != null)
			{
				parent.setRenderToTexture(cacheRenderToTexture, parent.__state.renderToTextureDepthStencil, parent.__state.renderToTextureAntiAlias,
					parent.__state.renderToTextureSurfaceSelector);
			}
		}
		#end
	}

	public function drawTriangles(indexBuffer:IndexBuffer3D, firstIndex:Int = 0, numTriangles:Int = -1):Void
	{
		#if !openfl_disable_display_render
		if (parent.__state.renderToTexture == null)
		{
			// TODO: Make sure state is correct for this?
			if (parent.__stage.context3D == parent && !parent.__stage.__renderer.__cleared)
			{
				parent.__stage.__renderer.__clear();
			}
			else if (!parent.__cleared)
			{
				// TODO: Throw error if error reporting is enabled?
				clear(0, 0, 0, 0, 1, 0, Context3DClearMask.COLOR);
			}
		}

		flushGL();
		#end

		if (parent.__state.program != null)
		{
			parent.__state.program.__backend.flush();
		}

		var count = (numTriangles == -1) ? indexBuffer.__numIndices : (numTriangles * 3);

		bindGLElementArrayBuffer(indexBuffer.__backend.glBufferID);
		gl.drawElements(GL.TRIANGLES, count, GL.UNSIGNED_SHORT, firstIndex * 2);
	}

	public function present():Void
	{
		parent.setRenderToBackBuffer();

		if (parent.__stage3D != null && parent.__backBufferTexture != null)
		{
			if (!parent.__cleared)
			{
				// Make sure texture is initialized
				// TODO: Throw error if error reporting is enabled?
				clear(0, 0, 0, 0, 1, 0, Context3DClearMask.COLOR);
			}

			var cacheBuffer = parent.__backBufferTexture;
			parent.__backBufferTexture = parent.__frontBufferTexture;
			parent.__frontBufferTexture = cacheBuffer;

			parent.__state.__primaryGLFramebuffer = parent.__backBufferTexture.__backend.getGLFramebuffer(parent.__state.backBufferEnableDepthAndStencil,
				parent.__backBufferAntiAlias, 0);
			parent.__cleared = false;
		}

		parent.__present = true;
	}

	public function setGLSLProgramConstantsFromMatrix(programType:Context3DProgramType, firstRegister:Int, matrix:Matrix3D, transposedMatrix:Bool = false):Void
	{
		flushGLProgram();

		// TODO: Cache value, prevent need to copy
		var data = new Float32Array(16);
		for (i in 0...16)
		{
			data[i] = matrix.rawData[i];
		}

		gl.uniformMatrix4fv(cast firstRegister, transposedMatrix, data);
	}

	public function setVertexBufferAt(index:Int, buffer:VertexBuffer3D, bufferOffset:Int = 0, format:Context3DVertexBufferFormat = FLOAT_4):Void
	{
		if (buffer == null)
		{
			gl.disableVertexAttribArray(index);
			bindGLArrayBuffer(null);
			return;
		}

		bindGLArrayBuffer(buffer.__backend.glBufferID);
		gl.enableVertexAttribArray(index);

		var byteOffset = bufferOffset * 4;
		var stride = buffer.__backend.stride;

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
	}

	private function bindGLArrayBuffer(buffer:GLBuffer):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__currentGLArrayBuffer != buffer #end)
		{
			gl.bindBuffer(GL.ARRAY_BUFFER, buffer);
			parent.__contextState.__currentGLArrayBuffer = buffer;
		}
	}

	private function bindGLElementArrayBuffer(buffer:GLBuffer):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__currentGLElementArrayBuffer != buffer #end)
		{
			gl.bindBuffer(GL.ELEMENT_ARRAY_BUFFER, buffer);
			parent.__contextState.__currentGLElementArrayBuffer = buffer;
		}
	}

	private function bindGLFramebuffer(framebuffer:GLFramebuffer):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__currentGLFramebuffer != framebuffer #end)
		{
			gl.bindFramebuffer(GL.FRAMEBUFFER, framebuffer);
			parent.__contextState.__currentGLFramebuffer = framebuffer;
		}
	}

	private function bindGLTexture2D(texture:GLTexture):Void
	{
		// TODO: Need to consider activeTexture ID

		// if (#if openfl_disable_context_cache true #else parent.__contextState.__currentGLTexture2D != texture #end) {

		gl.bindTexture(GL.TEXTURE_2D, texture);
		parent.__contextState.__currentGLTexture2D = texture;

		// }
	}

	private function bindGLTextureCubeMap(texture:GLTexture):Void
	{
		// TODO: Need to consider activeTexture ID

		// if (#if openfl_disable_context_cache true #else parent.__contextState.__currentGLTextureCubeMap != texture #end) {

		gl.bindTexture(GL.TEXTURE_CUBE_MAP, texture);
		parent.__contextState.__currentGLTextureCubeMap = texture;

		// }
	}

	private function _drawTriangles(firstIndex:Int = 0, count:Int):Void
	{
		#if !openfl_disable_display_render
		if (parent.__state.renderToTexture == null)
		{
			// TODO: Make sure state is correct for this?
			if (parent.__stage.context3D == parent && !parent.__stage.__renderer.__cleared)
			{
				parent.__stage.__renderer.__clear();
			}
			else if (!parent.__cleared)
			{
				// TODO: Throw error if error reporting is enabled?
				clear(0, 0, 0, 0, 1, 0, Context3DClearMask.COLOR);
			}
		}

		flushGL();
		#end

		if (parent.__state.program != null)
		{
			parent.__state.program.__backend.flush();
		}

		gl.drawArrays(GL.TRIANGLES, firstIndex, count);
	}

	private function flushGL():Void
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

	private function flushGLBlend():Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.blendDestinationRGBFactor != parent.__state.blendDestinationRGBFactor
			|| parent.__contextState.blendSourceRGBFactor != parent.__state.blendSourceRGBFactor
			|| parent.__contextState.blendDestinationAlphaFactor != parent.__state.blendDestinationAlphaFactor
			|| parent.__contextState.blendSourceAlphaFactor != parent.__state.blendSourceAlphaFactor #end)
		{
			setGLBlend(true);

			if (parent.__state.blendDestinationRGBFactor == parent.__state.blendDestinationAlphaFactor
				&& parent.__state.blendSourceRGBFactor == parent.__state.blendSourceAlphaFactor)
			{
				gl.blendFunc(getGLBlend(parent.__state.blendSourceRGBFactor), getGLBlend(parent.__state.blendDestinationRGBFactor));
			}
			else
			{
				gl.blendFuncSeparate(getGLBlend(parent.__state.blendSourceRGBFactor), getGLBlend(parent.__state.blendDestinationRGBFactor),
					getGLBlend(parent.__state.blendSourceAlphaFactor), getGLBlend(parent.__state.blendDestinationAlphaFactor));
			}

			parent.__contextState.blendDestinationRGBFactor = parent.__state.blendDestinationRGBFactor;
			parent.__contextState.blendSourceRGBFactor = parent.__state.blendSourceRGBFactor;
			parent.__contextState.blendDestinationAlphaFactor = parent.__state.blendDestinationAlphaFactor;
			parent.__contextState.blendSourceAlphaFactor = parent.__state.blendSourceAlphaFactor;
		}
	}

	private inline function flushGLColor():Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.colorMaskRed != parent.__state.colorMaskRed
			|| parent.__contextState.colorMaskGreen != parent.__state.colorMaskGreen
			|| parent.__contextState.colorMaskBlue != parent.__state.colorMaskBlue
			|| parent.__contextState.colorMaskAlpha != parent.__state.colorMaskAlpha #end)
		{
			gl.colorMask(parent.__state.colorMaskRed, parent.__state.colorMaskGreen, parent.__state.colorMaskBlue, parent.__state.colorMaskAlpha);
			parent.__contextState.colorMaskRed = parent.__state.colorMaskRed;
			parent.__contextState.colorMaskGreen = parent.__state.colorMaskGreen;
			parent.__contextState.colorMaskBlue = parent.__state.colorMaskBlue;
			parent.__contextState.colorMaskAlpha = parent.__state.colorMaskAlpha;
		}
	}

	private function flushGLCulling():Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.culling != parent.__state.culling #end)
		{
			if (parent.__state.culling == NONE)
			{
				setGLCullFace(false);
			}
			else
			{
				setGLCullFace(true);

				switch (parent.__state.culling)
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

			parent.__contextState.culling = parent.__state.culling;
		}
	}

	private function flushGLDepth():Void
	{
		var depthMask = (parent.__state.depthMask
			&& (parent.__state.renderToTexture != null ? parent.__state.renderToTextureDepthStencil : parent.__state.backBufferEnableDepthAndStencil));

		if (#if openfl_disable_context_cache true #else parent.__contextState.depthMask != depthMask #end)
		{
			gl.depthMask(depthMask);
			parent.__contextState.depthMask = depthMask;
		}

		if (#if openfl_disable_context_cache true #else parent.__contextState.depthCompareMode != parent.__state.depthCompareMode #end)
		{
			switch (parent.__state.depthCompareMode)
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

			parent.__contextState.depthCompareMode = parent.__state.depthCompareMode;
		}
	}

	private function flushGLFramebuffer():Void
	{
		if (parent.__state.renderToTexture != null)
		{
			if (#if openfl_disable_context_cache true #else parent.__contextState.renderToTexture != parent.__state.renderToTexture
				|| parent.__contextState.renderToTextureSurfaceSelector != parent.__state.renderToTextureSurfaceSelector #end)
			{
				var framebuffer = parent.__state.renderToTexture.__baseBackend.getGLFramebuffer(parent.__state.renderToTextureDepthStencil,
					parent.__state.renderToTextureAntiAlias, parent.__state.renderToTextureSurfaceSelector);
				bindGLFramebuffer(framebuffer);

				parent.__contextState.renderToTexture = parent.__state.renderToTexture;
				parent.__contextState.renderToTextureAntiAlias = parent.__state.renderToTextureAntiAlias;
				parent.__contextState.renderToTextureDepthStencil = parent.__state.renderToTextureDepthStencil;
				parent.__contextState.renderToTextureSurfaceSelector = parent.__state.renderToTextureSurfaceSelector;
			}

			setGLDepthTest(parent.__state.renderToTextureDepthStencil);
			setGLStencilTest(parent.__state.renderToTextureDepthStencil);

			setGLFrontFace(true);
		}
		else
		{
			if (parent.__stage == null && parent.backBufferWidth == 0 && parent.backBufferHeight == 0)
			{
				throw new Error("Context3D backbuffer has not been configured");
			}

			if (#if openfl_disable_context_cache true #else parent.__contextState.renderToTexture != null
				|| parent.__contextState.__currentGLFramebuffer != parent.__state.__primaryGLFramebuffer
				|| parent.__contextState.backBufferEnableDepthAndStencil != parent.__state.backBufferEnableDepthAndStencil #end
			)
			{
				bindGLFramebuffer(parent.__state.__primaryGLFramebuffer);

				parent.__contextState.renderToTexture = null;
				parent.__contextState.backBufferEnableDepthAndStencil = parent.__state.backBufferEnableDepthAndStencil;
			}

			setGLDepthTest(parent.__state.backBufferEnableDepthAndStencil);
			setGLStencilTest(parent.__state.backBufferEnableDepthAndStencil);

			setGLFrontFace(parent.__stage.context3D != parent);
		}
	}

	private function flushGLProgram():Void
	{
		var shader = parent.__state.shader;
		var program = parent.__state.program;

		if (#if openfl_disable_context_cache true #else parent.__contextState.shader != shader #end)
		{
			// TODO: Merge this logic

			if (parent.__contextState.shader != null)
			{
				parent.__contextState.shader.__backend.disable();
			}

			if (shader != null)
			{
				shader.__backend.enable();
			}

			parent.__contextState.shader = shader;
		}

		if (#if openfl_disable_context_cache true #else parent.__contextState.program != program #end)
		{
			if (parent.__contextState.program != null)
			{
				parent.__contextState.program.__backend.disable();
			}

			if (program != null)
			{
				program.__backend.enable();
			}

			parent.__contextState.program = program;
		}

		if (program != null && program.__format == AGAL)
		{
			positionScale[1] = (parent.__stage.context3D == parent && parent.__state.renderToTexture == null) ? 1.0 : -1.0;
			program.__backend.setPositionScale(positionScale);
		}
	}

	private function flushGLScissor():Void
	{
		#if lime
		if (!parent.__state.scissorEnabled)
		{
			if (#if openfl_disable_context_cache true #else parent.__contextState.scissorEnabled != parent.__state.scissorEnabled #end)
			{
				setGLScissorTest(false);
				parent.__contextState.scissorEnabled = false;
			}
		}
		else
		{
			setGLScissorTest(true);
			parent.__contextState.scissorEnabled = true;

			var scissorX = Std.int(parent.__state.scissorRectangle.x);
			var scissorY = Std.int(parent.__state.scissorRectangle.y);
			var scissorWidth = Std.int(parent.__state.scissorRectangle.width);
			var scissorHeight = Std.int(parent.__state.scissorRectangle.height);

			if (parent.__state.renderToTexture == null && parent.__stage3D == null)
			{
				var contextHeight = Std.int(parent.__stage.limeWindow.height * parent.__stage.limeWindow.scale);
				scissorY = contextHeight - Std.int(parent.__state.scissorRectangle.height) - scissorY;
			}

			if (#if openfl_disable_context_cache true #else parent.__contextState.scissorRectangle.x != scissorX
				|| parent.__contextState.scissorRectangle.y != scissorY
				|| parent.__contextState.scissorRectangle.width != scissorWidth
				|| parent.__contextState.scissorRectangle.height != scissorHeight #end)
			{
				gl.scissor(scissorX, scissorY, scissorWidth, scissorHeight);
				parent.__contextState.scissorRectangle.setTo(scissorX, scissorY, scissorWidth, scissorHeight);
			}
		}
		#end
	}

	private function flushGLStencil():Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.stencilTriangleFace != parent.__state.stencilTriangleFace
			|| parent.__contextState.stencilPass != parent.__state.stencilPass
			|| parent.__contextState.stencilDepthFail != parent.__state.stencilDepthFail
			|| parent.__contextState.stencilFail != parent.__state.stencilFail #end)
		{
			gl.stencilOpSeparate(getGLTriangleFace(parent.__state.stencilTriangleFace), getGLStencilAction(parent.__state.stencilFail),
				getGLStencilAction(parent.__state.stencilDepthFail), getGLStencilAction(parent.__state.stencilPass));
			parent.__contextState.stencilTriangleFace = parent.__state.stencilTriangleFace;
			parent.__contextState.stencilPass = parent.__state.stencilPass;
			parent.__contextState.stencilDepthFail = parent.__state.stencilDepthFail;
			parent.__contextState.stencilFail = parent.__state.stencilFail;
		}

		if (#if openfl_disable_context_cache true #else parent.__contextState.stencilWriteMask != parent.__state.stencilWriteMask #end)
		{
			gl.stencilMask(parent.__state.stencilWriteMask);
			parent.__contextState.stencilWriteMask = parent.__state.stencilWriteMask;
		}

		if (#if openfl_disable_context_cache true #else parent.__contextState.stencilCompareMode != parent.__state.stencilCompareMode
			|| parent.__contextState.stencilReferenceValue != parent.__state.stencilReferenceValue
			|| parent.__contextState.stencilReadMask != parent.__state.stencilReadMask #end
		)
		{
			gl.stencilFunc(getGLCompareMode(parent.__state.stencilCompareMode), parent.__state.stencilReferenceValue, parent.__state.stencilReadMask);
			parent.__contextState.stencilCompareMode = parent.__state.stencilCompareMode;
			parent.__contextState.stencilReferenceValue = parent.__state.stencilReferenceValue;
			parent.__contextState.stencilReadMask = parent.__state.stencilReadMask;
		}
	}

	private function flushGLTextures():Void
	{
		var sampler = 0;
		var texture, samplerState;

		for (i in 0...parent.__state.textures.length)
		{
			texture = parent.__state.textures[i];
			samplerState = parent.__state.samplerStates[i];
			if (samplerState == null)
			{
				parent.__state.samplerStates[i] = new SamplerState();
				samplerState = parent.__state.samplerStates[i];
			}

			gl.activeTexture(GL.TEXTURE0 + sampler);

			if (texture != null)
			{
				// if (#if openfl_disable_context_cache true #else texture != parent.__contextState.textures[i] #end) {

				// TODO: Cleaner approach?
				if (texture.__baseBackend.glTextureTarget == GL.TEXTURE_2D)
				{
					bindGLTexture2D(texture.__baseBackend.getTexture());
				}
				else
				{
					bindGLTextureCubeMap(texture.__baseBackend.getTexture());
				}

				#if (desktop && !html5)
				// TODO: Cache?
				gl.enable(GL.TEXTURE_2D);
				#end

				parent.__contextState.textures[i] = texture;

				// }

				texture.__baseBackend.setSamplerState(samplerState);
			}
			else
			{
				bindGLTexture2D(null);
			}

			if (parent.__state.program != null && parent.__state.program.__format == AGAL && samplerState.textureAlpha)
			{
				gl.activeTexture(GL.TEXTURE0 + sampler + 4);

				if (texture != null && texture.__baseBackend.alphaTexture != null)
				{
					if (texture.__baseBackend.alphaTexture.__baseBackend.glTextureTarget == GL.TEXTURE_2D)
					{
						bindGLTexture2D(texture.__baseBackend.alphaTexture.__baseBackend.getTexture());
					}
					else
					{
						bindGLTextureCubeMap(texture.__baseBackend.alphaTexture.__baseBackend.getTexture());
					}

					texture.__baseBackend.alphaTexture.__baseBackend.setSamplerState(samplerState);
					gl.uniform1i(parent.__state.program.__backend.agalAlphaSamplerEnabled[sampler].location, 1);

					#if (desktop && !html5)
					// TODO: Cache?
					gl.enable(GL.TEXTURE_2D);
					#end
				}
				else
				{
					bindGLTexture2D(null);
					if (parent.__state.program.__backend.agalAlphaSamplerEnabled[sampler] != null)
					{
						gl.uniform1i(parent.__state.program.__backend.agalAlphaSamplerEnabled[sampler].location, 0);
					}
				}
			}

			sampler++;
		}
	}

	private function flushGLViewport():Void
	{
		#if lime
		// TODO: Cache

		if (parent.__state.renderToTexture == null)
		{
			if (parent.__stage.context3D == parent)
			{
				var x = parent.__stage3D == null ? 0 : Std.int(parent.__stage3D.x);
				var y = Std.int((parent.__stage.limeWindow.height * parent.__stage.limeWindow.scale)
					- parent.backBufferHeight
					- (parent.__stage3D == null ? 0 : parent.__stage3D.y));
				gl.viewport(x, y, parent.backBufferWidth, parent.backBufferHeight);
			}
			else
			{
				gl.viewport(0, 0, parent.backBufferWidth, parent.backBufferHeight);
			}
		}
		else
		{
			gl.viewport(0, 0, parent.__state.renderToTexture.__width, parent.__state.renderToTexture.__height);
		}
		#end
	}

	private function getGLBlend(blendFactor:Context3DBlendFactor):Int
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

	private function getGLCompareMode(mode:Context3DCompareMode):Int
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

	private function getGLStencilAction(action:Context3DStencilAction):Int
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

	private function getGLTriangleFace(face:Context3DTriangleFace):Int
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

	private function setGLBlend(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__enableGLBlend != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.BLEND);
			}
			else
			{
				gl.disable(GL.BLEND);
			}
			parent.__contextState.__enableGLBlend = enable;
		}
	}

	private function setGLBlendEquation(value:Int):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__glBlendEquation != value #end)
		{
			gl.blendEquation(value);
			parent.__contextState.__glBlendEquation = value;
		}
	}

	private function setGLCullFace(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__enableGLCullFace != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.CULL_FACE);
			}
			else
			{
				gl.disable(GL.CULL_FACE);
			}
			parent.__contextState.__enableGLCullFace = enable;
		}
	}

	private function setGLDepthTest(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__enableGLDepthTest != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.DEPTH_TEST);
			}
			else
			{
				gl.disable(GL.DEPTH_TEST);
			}
			parent.__contextState.__enableGLDepthTest = enable;
		}
	}

	private function setGLFrontFace(counterClockWise:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__frontFaceGLCCW != counterClockWise #end)
		{
			gl.frontFace(counterClockWise ? GL.CCW : GL.CW);
			parent.__contextState.__frontFaceGLCCW = counterClockWise;
		}
	}

	private function setGLScissorTest(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__enableGLScissorTest != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.SCISSOR_TEST);
			}
			else
			{
				gl.disable(GL.SCISSOR_TEST);
			}
			parent.__contextState.__enableGLScissorTest = enable;
		}
	}

	private function setGLStencilTest(enable:Bool):Void
	{
		if (#if openfl_disable_context_cache true #else parent.__contextState.__enableGLStencilTest != enable #end)
		{
			if (enable)
			{
				gl.enable(GL.STENCIL_TEST);
			}
			else
			{
				gl.disable(GL.STENCIL_TEST);
			}
			parent.__contextState.__enableGLStencilTest = enable;
		}
	}

	public function getTotalGPUMemory():Int
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
#end
