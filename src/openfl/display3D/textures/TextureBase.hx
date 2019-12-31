package openfl.display3D.textures;

#if !flash
import openfl._internal.backend.gl.GLFramebuffer;
import openfl._internal.backend.gl.GLRenderbuffer;
import openfl._internal.backend.gl.GLTexture;
import openfl._internal.backend.gl.GL;
import openfl._internal.formats.atf.ATFGPUFormat;
import openfl._internal.renderer.SamplerState;
import openfl.display.BitmapData;
import openfl.events.EventDispatcher;
import openfl.errors.Error;
import openfl._internal.utils.Log;
#if (!lime && openfl_html5)
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
import openfl._internal.backend.lime_standalone.Image;
import openfl._internal.backend.lime_standalone.RenderContext;
#else
import openfl._internal.backend.lime.ImageCanvasUtil;
import openfl._internal.backend.lime.Image;
import openfl._internal.backend.lime.RenderContext;
#end

/**
	The TextureBase class is the base class for Context3D texture objects.

	**Note:** You cannot create your own texture classes using TextureBase. To add
	functionality to a texture class, extend either Texture or CubeTexture instead.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.renderer.SamplerState)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)
class TextureBase extends EventDispatcher
{
	@:noCompletion private static var __compressedFormats:Map<Int, Int>;
	@:noCompletion private static var __compressedFormatsAlpha:Map<Int, Int>;
	@:noCompletion private static var __supportsBGRA:Null<Bool> = null;
	@:noCompletion private static var __textureFormat:Int;
	@:noCompletion private static var __textureInternalFormat:Int;

	@:noCompletion private var __alphaTexture:TextureBase;
	// private var __compressedMemoryUsage:Int;
	@:noCompletion private var __context:Context3D;
	@:noCompletion private var __format:Int;
	#if openfl_gl
	@:noCompletion private var __glDepthRenderbuffer:GLRenderbuffer;
	@:noCompletion private var __glFramebuffer:GLFramebuffer;
	@:noCompletion private var __glStencilRenderbuffer:GLRenderbuffer;
	#end
	@:noCompletion private var __height:Int;
	@:noCompletion private var __internalFormat:Int;
	// private var __memoryUsage:Int;
	@:noCompletion private var __optimizeForRenderToTexture:Bool;
	// private var __outputTextureMemoryUsage:Bool = false;
	@:noCompletion private var __samplerState:SamplerState;
	@:noCompletion private var __streamingLevels:Int;
	@SuppressWarnings("checkstyle:Dynamic") @:noCompletion private var __textureContext:#if (lime || openfl_html5) RenderContext #else Dynamic #end;
	#if openfl_gl
	@:noCompletion private var __textureID:GLTexture;
	#end
	@:noCompletion private var __textureTarget:Int;
	@:noCompletion private var __width:Int;

	@:noCompletion private function new(context:Context3D)
	{
		super();

		__context = context;

		#if openfl_gl
		var gl = __context.gl;
		// __textureTarget = target;

		__textureID = gl.createTexture();
		__textureContext = __context.__context;

		if (__supportsBGRA == null)
		{
			__textureInternalFormat = GL.RGBA;

			var bgraExtension = null;
			#if (!js || !html5)
			bgraExtension = gl.getExtension("EXT_bgra");
			if (bgraExtension == null) bgraExtension = gl.getExtension("EXT_texture_format_BGRA8888");
			if (bgraExtension == null) bgraExtension = gl.getExtension("APPLE_texture_format_BGRA8888");
			#end

			if (bgraExtension != null)
			{
				__supportsBGRA = true;
				__textureFormat = bgraExtension.BGRA_EXT;

				#if (lime && !ios && !tvos)
				if (context.__context.type == OPENGLES)
				{
					__textureInternalFormat = bgraExtension.BGRA_EXT;
				}
				#end
			}
			else
			{
				__supportsBGRA = false;
				__textureFormat = GL.RGBA;
			}

			__compressedFormats = new Map();
			__compressedFormatsAlpha = new Map();

			#if openfl_html5
			var dxtExtension = gl.getExtension("WEBGL_compressed_texture_s3tc");
			var etc1Extension = gl.getExtension("WEBGL_compressed_texture_etc1");
			// WEBGL_compressed_texture_pvrtc is not available on iOS Safari
			var pvrtcExtension = gl.getExtension("WEBKIT_WEBGL_compressed_texture_pvrtc");
			#else
			var dxtExtension = gl.getExtension("EXT_texture_compression_s3tc");
			var etc1Extension = gl.getExtension("OES_compressed_ETC1_RGB8_texture");
			var pvrtcExtension = gl.getExtension("IMG_texture_compression_pvrtc");
			#end

			if (dxtExtension != null)
			{
				__compressedFormats[ATFGPUFormat.DXT] = dxtExtension.COMPRESSED_RGBA_S3TC_DXT1_EXT;
				__compressedFormatsAlpha[ATFGPUFormat.DXT] = dxtExtension.COMPRESSED_RGBA_S3TC_DXT5_EXT;
			}

			if (etc1Extension != null)
			{
				#if openfl_html5
				__compressedFormats[ATFGPUFormat.ETC1] = etc1Extension.COMPRESSED_RGB_ETC1_WEBGL;
				__compressedFormatsAlpha[ATFGPUFormat.ETC1] = etc1Extension.COMPRESSED_RGB_ETC1_WEBGL;
				#else
				__compressedFormats[ATFGPUFormat.ETC1] = etc1Extension.ETC1_RGB8_OES;
				__compressedFormatsAlpha[ATFGPUFormat.ETC1] = etc1Extension.ETC1_RGB8_OES;
				#end
			}

			if (pvrtcExtension != null)
			{
				__compressedFormats[ATFGPUFormat.PVRTC] = pvrtcExtension.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;
				__compressedFormatsAlpha[ATFGPUFormat.PVRTC] = pvrtcExtension.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
			}
		}

		__internalFormat = __textureInternalFormat;
		__format = __textureFormat;
		#end

		// __memoryUsage = 0;
		// __compressedMemoryUsage = 0;
	}

	/**
		Frees all GPU resources associated with this texture. After disposal, calling
		`upload()` or rendering with this object fails.
	**/
	public function dispose():Void
	{
		#if openfl_gl
		var gl = __context.gl;

		if (__alphaTexture != null)
		{
			__alphaTexture.dispose();
		}

		gl.deleteTexture(__textureID);

		if (__glFramebuffer != null)
		{
			gl.deleteFramebuffer(__glFramebuffer);
		}

		if (__glDepthRenderbuffer != null)
		{
			gl.deleteRenderbuffer(__glDepthRenderbuffer);
		}

		if (__glStencilRenderbuffer != null)
		{
			gl.deleteRenderbuffer(__glStencilRenderbuffer);
		}
		#end
	}

	#if openfl_gl
	@SuppressWarnings("checkstyle:Dynamic")
	@:noCompletion private function __getGLFramebuffer(enableDepthAndStencil:Bool, antiAlias:Int, surfaceSelector:Int):GLFramebuffer
	{
		var gl = __context.gl;

		if (__glFramebuffer == null)
		{
			__glFramebuffer = gl.createFramebuffer();
			__context.__bindGLFramebuffer(__glFramebuffer);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, __textureID, 0);

			if (__context.__enableErrorChecking)
			{
				var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);

				if (code != GL.FRAMEBUFFER_COMPLETE)
				{
					Log.warn('Error: Context3D.setRenderToTexture status:${code} width:${__width} height:${__height}');
				}
			}
		}

		if (enableDepthAndStencil && __glDepthRenderbuffer == null)
		{
			__context.__bindGLFramebuffer(__glFramebuffer);

			if (Context3D.__glDepthStencil != 0)
			{
				__glDepthRenderbuffer = gl.createRenderbuffer();
				__glStencilRenderbuffer = __glDepthRenderbuffer;

				gl.bindRenderbuffer(GL.RENDERBUFFER, __glDepthRenderbuffer);
				gl.renderbufferStorage(GL.RENDERBUFFER, Context3D.__glDepthStencil, __width, __height);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, __glDepthRenderbuffer);
			}
			else
			{
				__glDepthRenderbuffer = gl.createRenderbuffer();
				__glStencilRenderbuffer = gl.createRenderbuffer();

				gl.bindRenderbuffer(GL.RENDERBUFFER, __glDepthRenderbuffer);
				gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, __width, __height);
				gl.bindRenderbuffer(GL.RENDERBUFFER, __glStencilRenderbuffer);
				gl.renderbufferStorage(GL.RENDERBUFFER, GL.STENCIL_INDEX8, __width, __height);

				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, __glDepthRenderbuffer);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.RENDERBUFFER, __glStencilRenderbuffer);
			}

			if (__context.__enableErrorChecking)
			{
				var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);

				if (code != GL.FRAMEBUFFER_COMPLETE)
				{
					Log.warn('Error: Context3D.setRenderToTexture status:${code} width:${__width} height:${__height}');
				}
			}

			gl.bindRenderbuffer(GL.RENDERBUFFER, null);
		}

		return __glFramebuffer;
	}
	#end

	#if (lime || openfl_html5)
	@:noCompletion private function __getImage(bitmapData:BitmapData):Image
	{
		var image = bitmapData.image;

		if (!bitmapData.__isValid || image == null)
		{
			return null;
		}

		#if openfl_html5
		ImageCanvasUtil.sync(image, false);
		#end

		#if (openfl_gl && openfl_html5)
		var gl = __context.gl;

		if (image.type != DATA && !image.premultiplied)
		{
			gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
		}
		else if (!image.premultiplied && image.transparent)
		{
			gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);
			image = image.clone();
			image.premultiplied = true;
		}

		// TODO: Some way to support BGRA on WebGL?

		if (image.format != RGBA32)
		{
			image = image.clone();
			image.format = RGBA32;
			image.buffer.premultiplied = true;
			#if openfl_power_of_two
			image.powerOfTwo = true;
			#end
		}
		#else
		if (#if openfl_power_of_two !image.powerOfTwo || #end (!image.premultiplied && image.transparent))
		{
			image = image.clone();
			image.premultiplied = true;
			#if openfl_power_of_two
			image.powerOfTwo = true;
			#end
		}
		#end

		return image;
	}
	#end

	#if openfl_gl
	@:noCompletion private function __getTexture():GLTexture
	{
		return __textureID;
	}
	#end

	@:noCompletion private function __setSamplerState(state:SamplerState):Bool
	{
		#if openfl_gl
		if (!state.equals(__samplerState))
		{
			var gl = __context.gl;

			if (__textureTarget == GL.TEXTURE_CUBE_MAP) __context.__bindGLTextureCubeMap(__textureID);
			else
				__context.__bindGLTexture2D(__textureID);

			var wrapModeS = 0, wrapModeT = 0;

			switch (state.wrap)
			{
				case CLAMP:
					wrapModeS = GL.CLAMP_TO_EDGE;
					wrapModeT = GL.CLAMP_TO_EDGE;
				case CLAMP_U_REPEAT_V:
					wrapModeS = GL.CLAMP_TO_EDGE;
					wrapModeT = GL.REPEAT;
				case REPEAT:
					wrapModeS = GL.REPEAT;
					wrapModeT = GL.REPEAT;
				case REPEAT_U_CLAMP_V:
					wrapModeS = GL.REPEAT;
					wrapModeT = GL.CLAMP_TO_EDGE;
				default:
					throw new Error("wrap bad enum");
			}

			var magFilter = 0, minFilter = 0;

			switch (state.filter)
			{
				case NEAREST:
					magFilter = GL.NEAREST;
				default:
					magFilter = GL.LINEAR;
			}

			switch (state.mipfilter)
			{
				case MIPLINEAR:
					minFilter = state.filter == NEAREST ? GL.NEAREST_MIPMAP_LINEAR : GL.LINEAR_MIPMAP_LINEAR;
				case MIPNEAREST:
					minFilter = state.filter == NEAREST ? GL.NEAREST_MIPMAP_NEAREST : GL.LINEAR_MIPMAP_NEAREST;
				case Context3DMipFilter.MIPNONE:
					minFilter = state.filter == NEAREST ? GL.NEAREST : GL.LINEAR;
				default:
					throw new Error("mipfiter bad enum");
			}

			gl.texParameteri(__textureTarget, GL.TEXTURE_MIN_FILTER, minFilter);
			gl.texParameteri(__textureTarget, GL.TEXTURE_MAG_FILTER, magFilter);
			gl.texParameteri(__textureTarget, GL.TEXTURE_WRAP_S, wrapModeS);
			gl.texParameteri(__textureTarget, GL.TEXTURE_WRAP_T, wrapModeT);

			if (state.lodBias != 0.0)
			{
				// TODO
				// throw new IllegalOperationError("Lod bias setting not supported yet");
			}

			if (__samplerState == null) __samplerState = state.clone();
			__samplerState.copyFrom(state);

			return true;
		}
		#end

		return false;
	}

	#if (lime || openfl_html5)
	@:noCompletion private function __uploadFromImage(image:Image):Void
	{
		#if openfl_gl
		var gl = __context.gl;
		var internalFormat, format;

		if (__textureTarget != GL.TEXTURE_2D) return;

		if (image.buffer.bitsPerPixel == 1)
		{
			internalFormat = GL.ALPHA;
			format = GL.ALPHA;
		}
		else
		{
			internalFormat = TextureBase.__textureInternalFormat;
			format = TextureBase.__textureFormat;
		}

		__context.__bindGLTexture2D(__textureID);

		#if openfl_html5
		if (image.type != DATA && !image.premultiplied)
		{
			gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
		}
		else if (!image.premultiplied && image.transparent)
		{
			gl.pixelStorei(GL.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 1);
			// gl.pixelStorei (gl.UNPACK_PREMULTIPLY_ALPHA_WEBGL, 0);
			// textureImage = textureImage.clone ();
			// textureImage.premultiplied = true;
		}

		if (image.type == DATA)
		{
			gl.texImage2D(GL.TEXTURE_2D, 0, internalFormat, image.buffer.width, image.buffer.height, 0, format, GL.UNSIGNED_BYTE, image.data);
		}
		else
		{
			gl.texImage2D(GL.TEXTURE_2D, 0, internalFormat, format, GL.UNSIGNED_BYTE, image.src);
		}
		#else
		gl.texImage2D(GL.TEXTURE_2D, 0, internalFormat, image.buffer.width, image.buffer.height, 0, format, GL.UNSIGNED_BYTE, image.data);
		#end

		__context.__bindGLTexture2D(null);
		#end
	}
	#end
}
#else
typedef TextureBase = flash.display3D.textures.TextureBase;
#end
