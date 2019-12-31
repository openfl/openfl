package openfl.display3D.textures;

#if !flash
import openfl._internal.backend.gl.GL;
import openfl._internal.renderer.SamplerState;
import openfl._internal.backend.utils.ArrayBufferView;
import openfl._internal.backend.utils.UInt8Array;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

/**
	The Rectangle Texture class represents a 2-dimensional texture uploaded to a rendering
	context.

	Defines a 2D texture for use during rendering.

	Texture cannot be instantiated directly. Create instances by using Context3D
	`createRectangleTexture()` method.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:access(openfl.display3D.Context3D)
@:access(openfl.display.Stage)
@:final class RectangleTexture extends TextureBase
{
	@:noCompletion private function new(context:Context3D, width:Int, height:Int, format:String, optimizeForRenderToTexture:Bool)
	{
		super(context);

		__width = width;
		__height = height;
		// __format = format;
		__optimizeForRenderToTexture = optimizeForRenderToTexture;

		#if openfl_gl
		__textureTarget = GL.TEXTURE_2D;
		uploadFromTypedArray(null);

		if (optimizeForRenderToTexture) __getGLFramebuffer(true, 0, 0);
		#end
	}

	/**
		Uploads a texture from a BitmapData object.

		@param	source	a bitmap.
		@throws	TypeError	Null Pointer Error: when `source` is `null`.
		@throws	ArgumentError	Invalid BitmapData Error: when `source` does not contain a
		valid texture. The maximum allowed size in any dimension is 4096 or the size of the
		backbuffer, whichever is greater.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromBitmapData(source:BitmapData):Void
	{
		#if (lime || openfl_html5)
		if (source == null) return;

		var image = __getImage(source);
		if (image == null) return;

		#if (openfl_gl && openfl_html5)
		if (image.buffer != null && image.buffer.data == null && image.buffer.src != null)
		{
			var gl = __context.gl;

			__context.__bindGLTexture2D(__textureID);
			gl.texImage2D(__textureTarget, 0, __internalFormat, __format, GL.UNSIGNED_BYTE, image.buffer.src);
			__context.__bindGLTexture2D(null);
			return;
		}
		#end

		uploadFromTypedArray(image.data);
		#end
	}

	/**
		Uploads a texture from a ByteArray.

		@param	data	a byte array that is contains enough bytes in the textures internal
		format to fill the texture. rgba textures are read as bytes per texel component (1
		or 4). float textures are read as floats per texel component (1 or 4). The
		ByteArray object must use the little endian format.
		@param	byteArrayOffset	the position in the byte array object at which to start
		reading the texture data.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	RangeError	Bad Input Size: if the number of bytes available from
		`byteArrayOffset` to the end of data byte array is less than the amount of data
		required for a texture, or if `byteArrayOffset` is greater than or equal to the
		length of data.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt):Void
	{
		#if openfl_gl
		#if (js && !display)
		if (byteArrayOffset == 0)
		{
			uploadFromTypedArray(@:privateAccess (data : ByteArrayData).b);
			return;
		}
		#end

		uploadFromTypedArray(new UInt8Array(data.toArrayBuffer(), byteArrayOffset));
		#end
	}

	/**
		Uploads a texture from an ArrayBufferView.

		@param	data	a typed array that contains enough bytes in the textures internal
		format to fill the texture. rgba textures are read as bytes per texel component (1
		or 4). float textures are read as floats per texel component (1 or 4).
	**/
	public function uploadFromTypedArray(data:ArrayBufferView):Void
	{
		#if openfl_gl
		var gl = __context.gl;

		__context.__bindGLTexture2D(__textureID);
		gl.texImage2D(__textureTarget, 0, __internalFormat, __width, __height, 0, __format, GL.UNSIGNED_BYTE, data);
		__context.__bindGLTexture2D(null);
		#end
	}

	@:noCompletion private override function __setSamplerState(state:SamplerState):Bool
	{
		#if openfl_gl
		if (super.__setSamplerState(state))
		{
			var gl = __context.gl;

			if (Context3D.__glMaxTextureMaxAnisotropy != 0)
			{
				var aniso = switch (state.filter)
				{
					case ANISOTROPIC2X: 2;
					case ANISOTROPIC4X: 4;
					case ANISOTROPIC8X: 8;
					case ANISOTROPIC16X: 16;
					default: 1;
				}

				if (aniso > Context3D.__glMaxTextureMaxAnisotropy)
				{
					aniso = Context3D.__glMaxTextureMaxAnisotropy;
				}

				gl.texParameterf(GL.TEXTURE_2D, Context3D.__glTextureMaxAnisotropy, aniso);
			}

			return true;
		}
		#end

		return false;
	}
}
#else
typedef RectangleTexture = flash.display3D.textures.RectangleTexture;
#end
