package openfl._internal.backend.opengl;

#if openfl_gl
import openfl._internal.bindings.gl.GL;
import openfl._internal.renderer.SamplerState;
import openfl._internal.bindings.typedarray.ArrayBufferView;
import openfl._internal.bindings.typedarray.UInt8Array;
import openfl.display3D.textures.RectangleTexture;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl._internal.backend.opengl)
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
class OpenGLRectangleTextureBackend extends OpenGLTextureBaseBackend
{
	private var parent:RectangleTexture;

	public function new(parent:RectangleTexture)
	{
		super(parent);

		this.parent = parent;
		gl = parent.__context.__backend.gl;

		glTextureTarget = GL.TEXTURE_2D;
		uploadFromTypedArray(null);

		if (parent.__optimizeForRenderToTexture) getGLFramebuffer(true, 0, 0);
	}

	public function uploadFromBitmapData(source:BitmapData):Void
	{
		#if (lime || openfl_html5)
		if (source == null) return;

		var image = getImage(source);
		if (image == null) return;

		#if openfl_html5
		if (image.buffer != null && image.buffer.data == null && image.buffer.src != null)
		{
			contextBackend.bindGLTexture2D(glTextureID);
			gl.texImage2D(glTextureTarget, 0, glInternalFormat, glFormat, GL.UNSIGNED_BYTE, image.buffer.src);
			contextBackend.bindGLTexture2D(null);
			return;
		}
		#end

		uploadFromTypedArray(image.data);
		#end
	}

	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		#if (js && !display)
		if (byteArrayOffset == 0)
		{
			uploadFromTypedArray(@:privateAccess (data : ByteArrayData).b);
			return;
		}
		#end

		uploadFromTypedArray(new UInt8Array(data.toArrayBuffer(), byteArrayOffset));
	}

	public function uploadFromTypedArray(data:ArrayBufferView):Void
	{
		contextBackend.bindGLTexture2D(glTextureID);
		gl.texImage2D(glTextureTarget, 0, glInternalFormat, parent.__width, parent.__height, 0, glFormat, GL.UNSIGNED_BYTE, data);
		contextBackend.bindGLTexture2D(null);
	}

	private override function setSamplerState(state:SamplerState):Bool
	{
		if (super.setSamplerState(state))
		{
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

				gl.texParameterf(GL.TEXTURE_2D, OpenGLContext3DBackend.glTextureMaxAnisotropy, aniso);
			}

			return true;
		}

		return false;
	}
}
#end
