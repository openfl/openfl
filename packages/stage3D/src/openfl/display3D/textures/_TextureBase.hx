package openfl.display3D.textures;

#if openfl_gl
import lime.graphics.opengl.GLFramebuffer;
import lime.graphics.opengl.GLRenderbuffer;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GL;
import lime.graphics.WebGLRenderContext;
import openfl.display3D._internal.atf.ATFGPUFormat;
import openfl._internal.renderer.SamplerState;
import openfl.display3D.textures.TextureBase;
import openfl.display3D.Context3D;
import openfl.display3D.Context3DMipFilter;
import openfl.display.BitmapData;
import openfl.errors.Error;
import openfl._internal.utils.Log;
#if lime
import lime._internal.graphics.ImageCanvasUtil;
import lime.graphics.Image;
#elseif openfl_html5
import openfl._internal.backend.lime_standalone.ImageCanvasUtil;
import openfl._internal.backend.lime_standalone.Image;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.renderer.SamplerState)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display.BitmapData)
@:access(openfl.display.Stage)
@:noCompletion
class _TextureBase
{
	private static var glCompressedFormats:Map<Int, Int>;
	private static var glCompressedFormatsAlpha:Map<Int, Int>;
	private static var glTextureFormat:Int;
	private static var glTextureInternalFormat:Int;

	private var alphaTexture:TextureBase;
	private var baseParent:TextureBase;
	// private var compressedMemoryUsage:Int;
	// private var context:Context3D;
	private var contextBackend:_Context3D;
	private var gl:WebGLRenderContext;
	private var glDepthRenderbuffer:GLRenderbuffer;
	private var glFormat:Int;
	private var glFramebuffer:GLFramebuffer;
	private var glStencilRenderbuffer:GLRenderbuffer;
	private var glInternalFormat:Int;
	private var glTextureID:GLTexture;
	private var glTextureTarget:Int;
	// private var memoryUsage:Int;
	// private var outputTextureMemoryUsage:Bool = false;
	private var samplerState:SamplerState;

	public function new(parent:TextureBase)
	{
		baseParent = parent;
		contextBackend = parent.__context._;
		gl = contextBackend.gl;
		// textureTarget = target;

		glTextureID = gl.createTexture();

		if (Context3D.__supportsBGRA == null)
		{
			glTextureInternalFormat = GL.RGBA;

			var bgraExtension = null;
			#if (!js || !html5)
			bgraExtension = gl.getExtension("EXT_bgra");
			if (bgraExtension == null) bgraExtension = gl.getExtension("EXT_texture_format_BGRA8888");
			if (bgraExtension == null) bgraExtension = gl.getExtension("APPLE_texture_format_BGRA8888");
			#end

			if (bgraExtension != null)
			{
				Context3D.__supportsBGRA = true;
				glTextureFormat = bgraExtension.BGRA_EXT;

				#if (lime && !ios && !tvos)
				if (contextBackend.limeContext.type == OPENGLES)
				{
					glTextureInternalFormat = bgraExtension.BGRA_EXT;
				}
				#end
			}
			else
			{
				Context3D.__supportsBGRA = false;
				glTextureFormat = GL.RGBA;
			}

			glCompressedFormats = new Map();
			glCompressedFormatsAlpha = new Map();

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
				glCompressedFormats[ATFGPUFormat.DXT] = dxtExtension.COMPRESSED_RGBA_S3TC_DXT1_EXT;
				glCompressedFormatsAlpha[ATFGPUFormat.DXT] = dxtExtension.COMPRESSED_RGBA_S3TC_DXT5_EXT;
			}

			if (etc1Extension != null)
			{
				#if openfl_html5
				glCompressedFormats[ATFGPUFormat.ETC1] = etc1Extension.COMPRESSED_RGB_ETC1_WEBGL;
				glCompressedFormatsAlpha[ATFGPUFormat.ETC1] = etc1Extension.COMPRESSED_RGB_ETC1_WEBGL;
				#else
				glCompressedFormats[ATFGPUFormat.ETC1] = etc1Extension.ETC1_RGB8_OES;
				glCompressedFormatsAlpha[ATFGPUFormat.ETC1] = etc1Extension.ETC1_RGB8_OES;
				#end
			}

			if (pvrtcExtension != null)
			{
				glCompressedFormats[ATFGPUFormat.PVRTC] = pvrtcExtension.COMPRESSED_RGB_PVRTC_4BPPV1_IMG;
				glCompressedFormatsAlpha[ATFGPUFormat.PVRTC] = pvrtcExtension.COMPRESSED_RGBA_PVRTC_4BPPV1_IMG;
			}
		}

		glInternalFormat = glTextureInternalFormat;
		glFormat = glTextureFormat;

		// memoryUsage = 0;
		// compressedMemoryUsage = 0;
	}

	public function dispose():Void
	{
		if (alphaTexture != null)
		{
			alphaTexture.dispose();
			alphaTexture = null;
		}

		if (glTextureID != null)
		{
			gl.deleteTexture(glTextureID);
			glTextureID = null;
		}

		if (glFramebuffer != null)
		{
			gl.deleteFramebuffer(glFramebuffer);
			glFramebuffer = null;
		}

		if (glDepthRenderbuffer != null)
		{
			gl.deleteRenderbuffer(glDepthRenderbuffer);
			glDepthRenderbuffer = null;
		}

		if (glStencilRenderbuffer != null)
		{
			gl.deleteRenderbuffer(glStencilRenderbuffer);
			glStencilRenderbuffer = null;
		}
	}

	@SuppressWarnings("checkstyle:Dynamic")
	private function getGLFramebuffer(enableDepthAndStencil:Bool, antiAlias:Int, surfaceSelector:Int):GLFramebuffer
	{
		if (glFramebuffer == null)
		{
			glFramebuffer = gl.createFramebuffer();
			contextBackend.bindGLFramebuffer(glFramebuffer);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_2D, glTextureID, 0);

			if (baseParent.__context.enableErrorChecking)
			{
				var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);

				if (code != GL.FRAMEBUFFER_COMPLETE)
				{
					Log.warn('Error: Context3D.setRenderToTexture status:${code} width:${baseParent.__width} height:${baseParent.__height}');
				}
			}
		}

		if (enableDepthAndStencil && glDepthRenderbuffer == null)
		{
			contextBackend.bindGLFramebuffer(glFramebuffer);

			if (_Context3D.glDepthStencil != 0)
			{
				glDepthRenderbuffer = gl.createRenderbuffer();
				glStencilRenderbuffer = glDepthRenderbuffer;

				gl.bindRenderbuffer(GL.RENDERBUFFER, glDepthRenderbuffer);
				gl.renderbufferStorage(GL.RENDERBUFFER, _Context3D.glDepthStencil, baseParent.__width, baseParent.__height);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_STENCIL_ATTACHMENT, GL.RENDERBUFFER, glDepthRenderbuffer);
			}
			else
			{
				glDepthRenderbuffer = gl.createRenderbuffer();
				glStencilRenderbuffer = gl.createRenderbuffer();

				gl.bindRenderbuffer(GL.RENDERBUFFER, glDepthRenderbuffer);
				gl.renderbufferStorage(GL.RENDERBUFFER, GL.DEPTH_COMPONENT16, baseParent.__width, baseParent.__height);
				gl.bindRenderbuffer(GL.RENDERBUFFER, glStencilRenderbuffer);
				gl.renderbufferStorage(GL.RENDERBUFFER, GL.STENCIL_INDEX8, baseParent.__width, baseParent.__height);

				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.DEPTH_ATTACHMENT, GL.RENDERBUFFER, glDepthRenderbuffer);
				gl.framebufferRenderbuffer(GL.FRAMEBUFFER, GL.STENCIL_ATTACHMENT, GL.RENDERBUFFER, glStencilRenderbuffer);
			}

			if (baseParent.__context.enableErrorChecking)
			{
				var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);

				if (code != GL.FRAMEBUFFER_COMPLETE)
				{
					Log.warn('Error: Context3D.setRenderToTexture status:${code} width:${baseParent.__width} height:${baseParent.__height}');
				}
			}

			gl.bindRenderbuffer(GL.RENDERBUFFER, null);
		}

		return glFramebuffer;
	}

	#if (lime || openfl_html5)
	private function getImage(bitmapData:BitmapData):Image
	{
		#if lime
		var image = bitmapData.limeImage;
		#elseif openfl_html5
		var image = @:privateAccess bitmapData._.image;
		#end

		if (!bitmapData.__isValid || image == null)
		{
			return null;
		}

		#if openfl_html5
		ImageCanvasUtil.sync(image, false);
		#end

		#if openfl_html5
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

	private function getTexture():GLTexture
	{
		return glTextureID;
	}

	private function setSamplerState(state:SamplerState):Bool
	{
		if (!state.equals(samplerState))
		{
			if (glTextureTarget == GL.TEXTURE_CUBE_MAP) contextBackend.bindGLTextureCubeMap(glTextureID);
			else
				contextBackend.bindGLTexture2D(glTextureID);

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

			gl.texParameteri(glTextureTarget, GL.TEXTURE_MIN_FILTER, minFilter);
			gl.texParameteri(glTextureTarget, GL.TEXTURE_MAG_FILTER, magFilter);
			gl.texParameteri(glTextureTarget, GL.TEXTURE_WRAP_S, wrapModeS);
			gl.texParameteri(glTextureTarget, GL.TEXTURE_WRAP_T, wrapModeT);

			if (state.lodBias != 0.0)
			{
				// TODO
				// throw new IllegalOperationError("Lod bias setting not supported yet");
			}

			if (samplerState == null) samplerState = state.clone();
			samplerState.copyFrom(state);

			return true;
		}

		return false;
	}

	#if (lime || openfl_html5)
	private function uploadFromImage(image:Image):Void
	{
		var internalFormat, format;

		if (glTextureTarget != GL.TEXTURE_2D) return;

		if (image.buffer.bitsPerPixel == 1)
		{
			internalFormat = GL.ALPHA;
			format = GL.ALPHA;
		}
		else
		{
			internalFormat = glTextureInternalFormat;
			format = glTextureFormat;
		}

		contextBackend.bindGLTexture2D(glTextureID);

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

		contextBackend.bindGLTexture2D(null);
	}
	#end
}
#end
