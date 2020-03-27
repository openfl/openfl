// import openfl._internal.bindings.typedarray.ArrayBufferView;
import BitmapData from "../display/BitmapData";
import ByteArray from "../utils/ByteArray";

namespace openfl.display3D.textures
{
	/**
		The Rectangle Texture class represents a 2-dimensional texture uploaded to a rendering
		context.

		Defines a 2D texture for use during rendering.

		Texture cannot be instantiated directly. Create instances by using Context3D
		`createRectangleTexture()` method.
	**/
	export class RectangleTexture extends TextureBase
	{
		protected __backend: RectangleTextureBackend;

		protected constructor(context: Context3D, width: number, height: number, format: string, optimizeForRenderToTexture: boolean)
		{
			super(context, width, height, format, optimizeForRenderToTexture, 0);

			__backend = new RectangleTextureBackend(this);
			__baseBackend = __backend;
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
		public uploadFromBitmapData(source: BitmapData): void
		{
			__backend.uploadFromBitmapData(source);
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
		public uploadFromByteArray(data: ByteArray, byteArrayOffset: number): void
		{
			__backend.uploadFromByteArray(data, byteArrayOffset);
		}

		/**
			Uploads a texture from an ArrayBufferView.

			@param	data	a typed array that contains enough bytes in the textures internal
			format to fill the texture. rgba textures are read as bytes per texel component (1
			or 4). float textures are read as floats per texel component (1 or 4).
		**/
		public uploadFromTypedArray(data: ArrayBufferView): void
		{
			__backend.uploadFromTypedArray(data);
		}
	}
}

export default openfl.display3D.textures.RectangleTexture;
