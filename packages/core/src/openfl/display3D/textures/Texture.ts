import BitmapData from "../../display/BitmapData";
import TextureBase from "../../display3D/textures/TextureBase";
import Context3D from "../../display3D/Context3D";
import Context3DTextureFormat from "../../display3D/Context3DTextureFormat";
import ByteArray from "../../utils/ByteArray";

/**
	The Texture class represents a 2-dimensional texture uploaded to a rendering context.

	Defines a 2D texture for use during rendering.

	Texture cannot be instantiated directly. Create instances by using Context3D
	`createTexture()` method.
**/
export default class Texture extends TextureBase
{
	protected constructor(context: Context3D, width: number, height: number, format: Context3DTextureFormat, optimizeForRenderToTexture: boolean,
		streamingLevels: number)
	{
		super(context, width, height, format, optimizeForRenderToTexture, streamingLevels);
	}

	/**
		Uploads a compressed texture in Adobe Texture Format (ATF) from a ByteArray
		object. ATF file version 2 requires SWF version 21 or newer and ATF file version 3
		requires SWF version 29 or newer. For ATF files created with png image without
		alpha the format string given during Context3DObject `createTexture` should be
		`"COMPRESSED"` and for ATF files created with png image with alpha the format
		string given during Context3DObject `createTexture` should be `"COMPRESSED_ALPHA"`.

		@param	data	a byte array that contains a compressed texture including mipmaps.
		The ByteArray object must use the little endian format.
		@param	byteArrayOffset	the position in the byte array at which to start reading
		the texture data.
		@param	async	If true, this returns immediately. Any draw method which
		attempts to use the texture will fail until the upload completes successfully.
		Upon successful upload, this CubeTexture object dispatches `Event.TEXTURE_READY`.
		Default value: `false`.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	ArgumentError	Texture Decoding Failed: when the compression format of
		this object cannot be derived from the format of the compressed data in data or
		when the SWF version is incompatible with the ATF file version.
		@throws	ArgumentError	Texture Size Does Not Match: when the width and height of
		the decompressed texture do not equal the dimensions of this Texture object.
		@throws	ArgumentError	Miplevel Too Large: if the mip level of the decompressed
		texture is greater than that implied by the size of the texture.
		@throws	ArgumentError	Texture Format Mismatch: if the decoded ATF bytes don't
		contain a texture compatible with this texture's format.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
		@throws	RangeError	Bad Input Size: when there is integer overflow of
		`byteArrayOffset` or if `byteArrayOffset` + 6 is greater than the length of `data`,
		or if the number of bytes available from `byteArrayOffset` to the end of the `data`
		byte array is less than the amount of data required for ATF texture.
	**/
	public uploadCompressedTextureFromByteArray(data: ByteArray, byteArrayOffset: number, async: boolean = false): void
	{
		// __backend.uploadCompressedTextureFromByteArray(data, byteArrayOffset, async);
	}

	/**
		Uploads a texture from a BitmapData object.

		@param	source	a bitmap.
		@param	miplevel	the mip level to be loaded, level zero being the top-level
		full-resolution image.
		@throws	TypeError	Null Pointer Error: when `source` is `null`.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater
		than that implied by the larger of the Texture's dimensions.
		@throws	ArgumentError	Invalid BitmapData Error: if `source` if the BitmapData
		object does not contain a valid cube texture face. The image must have sides equal
		to a power of two, and the correct size for the miplevel specified.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is
		Context3DTextureFormat.COMPRESSED or Context3DTextureFormat.COMPRESSED_ALPHA and
		the code is executing on a mobile platform where runtime texture compression is
		not supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public uploadFromBitmapData(source: BitmapData, miplevel: number = 0, generateMipmap: boolean = false): void
	{
		// __backend.uploadFromBitmapData(source, miplevel, generateMipmap);
	}

	/**
		Uploads a texture from a ByteArray.

		@param	data	a byte array that is contains enough bytes in the textures
		internal format to fill the texture. rgba textures are read as bytes per texel
		component (1 or 4). float textures are read as floats per texel component (1 or 4).
		The ByteArray object must use the little endian format.
		@param	byteArrayOffset	the position in the byte array object at which to start
		reading the texture data.
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater
		than that implied by the larger of the Texture's dimensions.
		@throws	RangeError	Bad Input Size: if the number of bytes available from
		`byteArrayOffset` to the end of the data byte array is less than the amount of data
		required for a texture of this mip level or if `byteArrayOffset` is greater than or
		equal to the length of data.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is
		Context3DTextureFormat.COMPRESSED or Context3DTextureFormat.COMPRESSED_ALPHA and
		the code is executing on a mobile platform where runtime texture compression is not
		supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public uploadFromByteArray(data: ByteArray, byteArrayOffset: number, miplevel: number = 0): void
	{
		// __backend.uploadFromByteArray(data, byteArrayOffset, miplevel);
	}

	/**
		Uploads a texture from an ArrayBufferView.

		@param	data	a typed array that contains enough bytes in the textures
		internal format to fill the texture. rgba textures are read as bytes per texel
		component (1 or 4). float textures are read as floats per texel component (1 or 4).
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
	**/
	public uploadFromTypedArray(data: ArrayBufferView, miplevel: number = 0): void
	{
		// __backend.uploadFromTypedArray(data, miplevel);
	}
}
