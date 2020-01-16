package openfl._internal.backend.opengl;

#if openfl_gl
import haxe.Timer;
import openfl._internal.bindings.gl.GLFramebuffer;
import openfl._internal.bindings.gl.GL;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl._internal.formats.atf.ATFReader;
import openfl._internal.renderer.SamplerState;
import openfl._internal.utils.Log;
import openfl.display3D.textures.CubeTexture;
import openfl.display3D.Context3DTextureFormat;
import openfl.display.BitmapData;
import openfl.errors.IllegalOperationError;
import openfl.events.Event;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.backend.opengl)
@:access(openfl.display3D.textures.CubeTexture)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:access(openfl.events.Event)
class OpenGLCubeTextureBackend extends OpenGLTextureBaseBackend
{
	private var framebufferSurface:Int;
	private var parent:CubeTexture;
	private var uploadedSides:Int;

	public function new(parent:CubeTexture)
	{
		super(parent);

		this.parent = parent;

		glTextureTarget = GL.TEXTURE_CUBE_MAP;
		uploadedSides = 0;

		// if (optimizeForRenderToTexture) getFramebuffer (true, 0, 0);
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

				parent.dispatchEvent(event);

				#if openfl_pool_events
				Event.pool.release(event);
				#end
			}, 1);
		}
	}

	public function uploadFromBitmapData(source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void
	{
		#if (lime || openfl_html5)
		if (source == null) return;
		var size = parent.__size >> miplevel;
		if (size == 0) return;

		var image = getImage(source);
		if (image == null) return;

		// TODO: Improve handling of miplevels with canvas src

		#if openfl_html5
		if (miplevel == 0 && image.buffer != null && image.buffer.data == null && image.buffer.src != null)
		{
			var size = parent.__size >> miplevel;
			if (size == 0) return;

			var target = sideToTarget(side);
			contextBackend.bindGLTextureCubeMap(glTextureID);
			gl.texImage2D(target, miplevel, glInternalFormat, glFormat, GL.UNSIGNED_BYTE, image.buffer.src);
			contextBackend.bindGLTextureCubeMap(null);

			uploadedSides |= 1 << side;
			return;
		}

		uploadFromTypedArray(image.data, side, miplevel);
		#end
		#end
	}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void
	{
		#if (js && !display)
		if (byteArrayOffset == 0)
		{
			uploadFromTypedArray(@:privateAccess (data : ByteArrayData).b, side, miplevel);
			return;
		}
		#end

		uploadFromTypedArray(new UInt8Array(data.toArrayBuffer(), byteArrayOffset), side, miplevel);
	}

	public function uploadFromTypedArray(data:ArrayBufferView, side:UInt, miplevel:UInt = 0):Void
	{
		if (data == null) return;

		var size = parent.__size >> miplevel;
		if (size == 0) return;

		var target = sideToTarget(side);

		contextBackend.bindGLTextureCubeMap(glTextureID);
		gl.texImage2D(target, miplevel, glInternalFormat, size, size, 0, glFormat, GL.UNSIGNED_BYTE, data);
		contextBackend.bindGLTextureCubeMap(null);

		uploadedSides |= 1 << side;
	}

	private override function getGLFramebuffer(enableDepthAndStencil:Bool, antiAlias:Int, surfaceSelector:Int):GLFramebuffer
	{
		if (glFramebuffer == null)
		{
			glFramebuffer = gl.createFramebuffer();
			framebufferSurface = -1;
		}

		if (framebufferSurface != surfaceSelector)
		{
			framebufferSurface = surfaceSelector;

			contextBackend.bindGLFramebuffer(glFramebuffer);
			gl.framebufferTexture2D(GL.FRAMEBUFFER, GL.COLOR_ATTACHMENT0, GL.TEXTURE_CUBE_MAP_POSITIVE_X + surfaceSelector, glTextureID, 0);

			if (parent.__context.enableErrorChecking)
			{
				var code = gl.checkFramebufferStatus(GL.FRAMEBUFFER);

				if (code != GL.FRAMEBUFFER_COMPLETE)
				{
					Log.error('Error: Context3D.setRenderToTexture status:${code} size:${parent.__size}');
				}
			}
		}

		return super.getGLFramebuffer(enableDepthAndStencil, antiAlias, surfaceSelector);
	}

	private override function setSamplerState(state:SamplerState):Bool
	{
		if (super.setSamplerState(state))
		{
			if (state.mipfilter != MIPNONE && !samplerState.mipmapGenerated)
			{
				gl.generateMipmap(GL.TEXTURE_CUBE_MAP);
				samplerState.mipmapGenerated = true;
			}

			if (OpenGLContext3DBackend.glMaxTextureMaxAnisotropy != 0)
			{
				var aniso = switch (state.filter)
				{
					case ANISOTROPIC2X: 2;
					case ANISOTROPIC4X: 4;
					case ANISOTROPIC8X: 8;
					case ANISOTROPIC16X: 16;
					default: 1;
				}

				if (aniso > OpenGLContext3DBackend.glMaxTextureMaxAnisotropy)
				{
					aniso = OpenGLContext3DBackend.glMaxTextureMaxAnisotropy;
				}

				gl.texParameterf(GL.TEXTURE_CUBE_MAP, OpenGLContext3DBackend.glTextureMaxAnisotropy, aniso);
			}

			return true;
		}

		return false;
	}

	private function sideToTarget(side:UInt):Int
	{
		return switch (side)
		{
			case 0: GL.TEXTURE_CUBE_MAP_POSITIVE_X;
			case 1: GL.TEXTURE_CUBE_MAP_NEGATIVE_X;
			case 2: GL.TEXTURE_CUBE_MAP_POSITIVE_Y;
			case 3: GL.TEXTURE_CUBE_MAP_NEGATIVE_Y;
			case 4: GL.TEXTURE_CUBE_MAP_POSITIVE_Z;
			case 5: GL.TEXTURE_CUBE_MAP_NEGATIVE_Z;
			default: throw new IllegalOperationError();
		}
	}

	private function _uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		var reader = new ATFReader(data, byteArrayOffset);
		var alpha = reader.readHeader(parent.__size, parent.__size, true);

		contextBackend.bindGLTextureCubeMap(glTextureID);

		var hasTexture = false;

		reader.readTextures(function(side, level, gpuFormat, width, height, blockLength, bytes)
		{
			var format = alpha ? OpenGLTextureBaseBackend.glCompressedFormatsAlpha[gpuFormat] : OpenGLTextureBaseBackend.glCompressedFormats[gpuFormat];
			if (format == 0) return;

			hasTexture = true;
			var target = sideToTarget(side);

			this.glFormat = format;
			this.glInternalFormat = format;

			if (alpha && gpuFormat == 2)
			{
				var size = Std.int(blockLength / 2);

				gl.compressedTexImage2D(target, level, glInternalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, size));

				var alphaTexture = new CubeTexture(parent.__context, parent.__size, Context3DTextureFormat.COMPRESSED, parent.__optimizeForRenderToTexture,
					parent.__streamingLevels);
				alphaTexture.__backend.glFormat = format;
				alphaTexture.__backend.glInternalFormat = format;

				contextBackend.bindGLTextureCubeMap(alphaTexture.__backend.glTextureID);
				gl.compressedTexImage2D(target, level, alphaTexture.__backend.glInternalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, size, size));

				this.alphaTexture = alphaTexture;
			}
			else
			{
				gl.compressedTexImage2D(target, level, glInternalFormat, width, height, 0,
					new UInt8Array(#if js @:privateAccess bytes.b.buffer #else bytes #end, 0, blockLength));
			}
		});

		if (!hasTexture)
		{
			for (side in 0...6)
			{
				var data = new UInt8Array(parent.__size * parent.__size * 4);
				gl.texImage2D(sideToTarget(side), 0, glInternalFormat, parent.__size, parent.__size, 0, glFormat, GL.UNSIGNED_BYTE, data);
			}
		}

		contextBackend.bindGLTextureCubeMap(null);
	}
}
#end
