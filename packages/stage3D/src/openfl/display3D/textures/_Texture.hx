package openfl.display3D.textures;

#if openfl_gl
import haxe.io.Bytes;
import haxe.Timer;
import lime.graphics.opengl.GL;
import openfl.display3D._internal.atf.ATFReader;
import openfl._internal.renderer.SamplerState;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl.display3D.textures.Texture;
import openfl.display3D.Context3DTextureFormat;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.textures.Texture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display.Stage)
@:access(openfl.events.Event)
@:noCompletion
class _Texture extends _TextureBase
{
	public static var lowMemoryMode:Bool = false;

	private var texture:Texture;

	public function new(texture:Texture, context:Context3D, width:Int, height:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool,
			streamingLevels:Int)
	{
		this.texture = texture;

		super(texture, context, width, height, format, optimizeForRenderToTexture, streamingLevels);

		gl = contextBackend.gl;
		glTextureTarget = GL.TEXTURE_2D;

		contextBackend.bindGLTexture2D(glTextureID);
		gl.texImage2D(glTextureTarget, 0, glInternalFormat, __width, __height, 0, glFormat, GL.UNSIGNED_BYTE, null);
		contextBackend.bindGLTexture2D(null);

		if (__optimizeForRenderToTexture) getGLFramebuffer(true, 0, 0);
	}

	public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void
	{
		if (!async)
		{
			_uploadCompressedTextureFromByteArray(data, byteArrayOffset);
		}
		else
		{
			Timer.delay(function()
			{
				_uploadCompressedTextureFromByteArray(data, byteArrayOffset);

				var event:Event = null;

				#if openfl_pool_events
				event = Event.pool.get(Event.TEXTURE_READY);
				#else
				event = new Event(Event.TEXTURE_READY);
				#end

				texture.dispatchEvent(event);

				#if openfl_pool_events
				Event.pool.release(event);
				#end
			}, 1);
		}
	}

	public function uploadFromBitmapData(source:BitmapData, miplevel:UInt = 0, generateMipmap:Bool = false):Void
	{
		#if (lime || openfl_html5)
		/* TODO
			if (LowMemoryMode) {
				// shrink bitmap data
				source = source.shrinkToHalfResolution();
				// shrink our dimensions for upload
				width = source.width;
				height = source.height;
			}
		**/

		if (source == null) return;

		var width = __width >> miplevel;
		var height = __height >> miplevel;

		if (width == 0 && height == 0) return;

		if (width == 0) width = 1;
		if (height == 0) height = 1;

		if (source.width != width || source.height != height)
		{
			var copy = new BitmapData(width, height, true, 0);
			copy.draw(source);
			source = copy;
		}

		var image = getImage(source);
		if (image == null) return;

		// TODO: Improve handling of miplevels with canvas src

		#if openfl_html5
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null)
		{
			var width = __width >> miplevel;
			var height = __height >> miplevel;

			if (width == 0 && height == 0) return;

			if (width == 0) width = 1;
			if (height == 0) height = 1;

			contextBackend.bindGLTexture2D(glTextureID);
			gl.texImage2D(glTextureTarget, miplevel, glInternalFormat, glFormat, GL.UNSIGNED_BYTE, image.buffer.src);
			contextBackend.bindGLTexture2D(null);

			return;
		}
		#end

		uploadFromTypedArray(image.data, miplevel);
		#end
	}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, miplevel:UInt = 0):Void
	{
		#if (js && !display)
		if (byteArrayOffset == 0)
		{
			uploadFromTypedArray(@:privateAccess (data : ByteArrayData).b, miplevel);
			return;
		}
		#end

		uploadFromTypedArray(new UInt8Array(data.toArrayBuffer(), byteArrayOffset), miplevel);
	}

	public function uploadFromTypedArray(data:ArrayBufferView, miplevel:UInt = 0):Void
	{
		if (data == null) return;

		var width = __width >> miplevel;
		var height = __height >> miplevel;

		if (width == 0 && height == 0) return;

		if (width == 0) width = 1;
		if (height == 0) height = 1;

		contextBackend.bindGLTexture2D(glTextureID);
		gl.texImage2D(glTextureTarget, miplevel, glInternalFormat, width, height, 0, glFormat, GL.UNSIGNED_BYTE, data);
		contextBackend.bindGLTexture2D(null);
	}

	public override function setSamplerState(state:SamplerState):Bool
	{
		if (super.setSamplerState(state))
		{
			if (state.mipfilter != MIPNONE && !samplerState.mipmapGenerated)
			{
				gl.generateMipmap(GL.TEXTURE_2D);
				samplerState.mipmapGenerated = true;
			}

			if (_Context3D.glMaxTextureMaxAnisotropy != 0)
			{
				var aniso = switch (state.filter)
				{
					case ANISOTROPIC2X: 2;
					case ANISOTROPIC4X: 4;
					case ANISOTROPIC8X: 8;
					case ANISOTROPIC16X: 16;
					default: 1;
				}

				if (aniso > _Context3D.glMaxTextureMaxAnisotropy)
				{
					aniso = _Context3D.glMaxTextureMaxAnisotropy;
				}

				gl.texParameterf(GL.TEXTURE_2D, _Context3D.glTextureMaxAnisotropy, aniso);
			}

			return true;
		}

		return false;
	}

	public function _uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		var reader = new ATFReader(data, byteArrayOffset);
		var alpha = reader.readHeader(__width, __height, false);

		contextBackend.bindGLTexture2D(glTextureID);

		var hasTexture = false;

		reader.readTextures(function(target, level, gpuFormat, width, height, blockLength, bytes:Bytes)
		{
			var format = alpha ? _TextureBase.glCompressedFormatsAlpha[gpuFormat] : _TextureBase.glCompressedFormats[gpuFormat];
			if (format == 0) return;

			hasTexture = true;
			glFormat = format;
			glInternalFormat = format;

			if (alpha && gpuFormat == 2)
			{
				var size = Std.int(blockLength / 2);

				gl.compressedTexImage2D(glTextureTarget, level, glInternalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));

				var alphaTexture = new Texture(__context, __width, __height, Context3DTextureFormat.COMPRESSED, __optimizeForRenderToTexture,
					__streamingLevels);
				(alphaTexture._ : _TextureBase).glFormat = format;
				(alphaTexture._ : _TextureBase).glInternalFormat = format;

				contextBackend.bindGLTexture2D((alphaTexture._ : _TextureBase).glTextureID);
				gl.compressedTexImage2D((alphaTexture._ : _TextureBase).glTextureTarget, level, (alphaTexture._ : _TextureBase).glInternalFormat, width,
					height, 0, new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, size, size));

				this.alphaTexture = alphaTexture;
			}
			else
			{
				gl.compressedTexImage2D(glTextureTarget, level, glInternalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, blockLength));
			}
		});

		if (!hasTexture)
		{
			var data = new UInt8Array(__width * __height * 4);
			gl.texImage2D(glTextureTarget, 0, glInternalFormat, __width, __height, 0, glFormat, GL.UNSIGNED_BYTE, data);
		}

		contextBackend.bindGLTexture2D(null);
	}
}
#end
