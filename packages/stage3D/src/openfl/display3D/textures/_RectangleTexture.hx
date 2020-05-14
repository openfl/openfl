package openfl.display3D.textures;

#if openfl_gl
import lime.graphics.opengl.GL;
import openfl._internal.renderer.SamplerState;
import lime.utils.ArrayBufferView;
import lime.utils.UInt8Array;
import openfl.display3D.textures.RectangleTexture;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.textures.TextureBase)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D._Context3D)
@:access(openfl.display.Stage)
@:noCompletion
class _RectangleTexture extends _TextureBase
{
	private var rectangleTexture:RectangleTexture;

	public function new(rectangleTexture:RectangleTexture, context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool)
	{
		super(rectangleTexture, context, width, height, format, optimizeForRenderToTexture, 0);

		this.rectangleTexture = rectangleTexture;
		gl = (__context._ : _Context3D).gl;

		glTextureTarget = GL.TEXTURE_2D;
		uploadFromTypedArray(null);

		if (__optimizeForRenderToTexture) getGLFramebuffer(true, 0, 0);
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
		gl.texImage2D(glTextureTarget, 0, glInternalFormat, __width, __height, 0, glFormat, GL.UNSIGNED_BYTE, data);
		contextBackend.bindGLTexture2D(null);
	}

	public override function setSamplerState(state:SamplerState):Bool
	{
		if (super.setSamplerState(state))
		{
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
}
#end
