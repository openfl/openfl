package openfl.display3D.textures;

#if !flash
import lime.utils.ArrayBufferView;
import openfl.display.BitmapData;
import openfl.utils.ByteArray;

/**
	The CubeTexture class represents a cube texture uploaded to a rendering context.

	Defines a cube map texture for use during rendering. Cube mapping is used for many
	rendering techniques, such as environment maps, skyboxes, and skylight illumination.

	You cannot create a CubeTexture object directly; use the Context3D
	`createCubeTexture()` instead.
**/
#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end
@:final class CubeTexture extends TextureBase
{
	@:noCompletion private var _:_CubeTexture;
	@:noCompletion private var __size:Int;

	@:noCompletion private function new(context:Context3D, size:Int, format:Context3DTextureFormat, optimizeForRenderToTexture:Bool, streamingLevels:Int)
	{
		super(context, size, size, format, optimizeForRenderToTexture, streamingLevels);
		__size = size;

		_ = new _CubeTexture(this);
		__base = _;
	}

	/**
		Uploads a cube texture in Adobe Texture Format (ATF) from a byte array.

		The byte array must contain all faces and mipmaps for the texture.

		@param	data	a byte array that containing a compressed cube texture including
		mipmaps. The ByteArray object must use the little endian format.
		@param	byteArrayOffset	an optional offset at which to start reading the texture
		data.
		@param	async	If `true`, this function returns immediately. Any draw method which
		attempts to use the texture will fail until the upload completes successfully. Upon
		successful upload, this Texture object dispatches `Event.TEXTURE_READY`. Default
		value: `false`.
		@throws	TypeError	Null Pointer Error: when `data` is `null`.
		@throws	ArgumentError	Texture Decoding Failed: when the compression format of
		this object cannot be derived from the format of the compressed data in data.
		@throws	ArgumentError	Texture Needs To Be Square: when the decompressed texture
		does not have equal `width` and `height`.
		@throws	ArgumentError	Texture Size Does Not Match: when the width and height of
		the decompressed texture do not equal the length of the texture's edge.
		@throws	ArgumentError	Miplevel Too Large: if the mip level of the decompressed
		texture is greater than that implied by the length of the texture's edge.
		@throws	ArgumentError	Texture Format Mismatch: if the decoded ATF bytes don't
		contain a texture compatible with this texture's format or is not a cube texture.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
		@throws	RangeError	Bad Input Size: when there is integer overflow of
		`byteArrayOffset` or if `byteArrayOffset` + 6 is greater than the length of `data`,
		or if the number of bytes available from `byteArrayOffset` to the end of the data
		byte array is less than the amount of data required for ATF texture.
	**/
	public function uploadCompressedTextureFromByteArray(data:ByteArray, byteArrayOffset:UInt, async:Bool = false):Void
	{
		_.uploadCompressedTextureFromByteArray(data, byteArrayOffset, async);
	}

	/**
		Uploads a component of a cube map texture from a BitmapData object.

		This function uploads one mip level of one side of the cube map. Call
		`uploadFromBitmapData()` as necessary to upload each mip level and face of the
		cube map.

		@param	source	a bitmap.
		@param	side	A code indicating which side of the cube to upload:
		positive X : 0
		negative X : 1
		positive Y : 2
		negative Y : 3
		positive Z : 4
		negative Z : 5
		@param	miplevel	the mip level to be loaded, level zero being the top-level
		full-resolution image. The default value is zero.
		@throws	TypeError	Null Pointer Error: if source is `null`.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater
		than that implied by the the texture's dimensions.
		@throws	ArgumentError	Invalid Cube Side: if side is greater than 5.
		@throws	ArgumentError	Invalid BitmapData Error: if source if the BitmapData
		object does not contain a valid cube texture face. The image must be square, with
		sides equal to a power of two, and the correct size for the miplevel specified.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is
		`Context3DTextureFormat.COMPRESSED` or `Context3DTextureFormat.COMPRESSED_ALPHA`
		and the code is executing on a mobile platform where runtime texture compression
		is not supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromBitmapData(source:BitmapData, side:UInt, miplevel:UInt = 0, generateMipmap:Bool = false):Void
	{
		_.uploadFromBitmapData(source, side, miplevel, generateMipmap);
	}

	/**
		Uploads a component of a cube map texture from a ByteArray object.

		This function uploads one mip level of one side of the cube map. Call
		`uploadFromByteArray()` as neccessary to upload each mip level and face of the
		cube map.

		@param	data	a byte array containing the image in the format specified when
		this CubeTexture object was created. The ByteArray object must use the little
		endian format.
		@param	byteArrayOffset	reading of the byte array starts there.
		@param	side	A code indicating which side of the cube to upload:
		positive X : 0
		negative X : 1
		positive Y : 2
		negative Y : 3
		positive Z : 4
		negative Z : 5
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
		@throws	TypeError	Null Pointer Error: when data is null.
		@throws	ArgumentError	Miplevel Too Large: if the specified mip level is greater than that implied by the Texture's dimensions.
		@throws	RangeError	Bad Input Size: if the number of bytes available from byteArrayOffset to the end of the data byte array is less than the amount of data required for a texture of this mip level or if byteArrayOffset is greater than or equal to the length of data.
		@throws	ArgumentError	Texture Format Mismatch: if the texture format is Context3DTextureFormat.COMPRESSED or Context3DTextureFormat.COMPRESSED_ALPHA and the code is executing on a mobile platform where runtime texture compression is not supported.
		@throws	Error	3768: The Stage3D API may not be used during background execution.
	**/
	public function uploadFromByteArray(data:ByteArray, byteArrayOffset:UInt, side:UInt, miplevel:UInt = 0):Void
	{
		_.uploadFromByteArray(data, byteArrayOffset, side, miplevel);
	}

	/**
		Uploads a component of a cube map texture from an ArrayBufferView object.

		This function uploads one mip level of one side of the cube map. Call
		`uploadFromTypedArray()` as necessary to upload each mip level and face of the
		cube map.

		@param	data	a typed array containing the image in the format specified when
		this CubeTexture object was created.
		@param	side	A code indicating which side of the cube to upload:
		positive X : 0
		negative X : 1
		positive Y : 2
		negative Y : 3
		positive Z : 4
		negative Z : 5
		@param	miplevel	the mip level to be loaded, level zero is the top-level,
		full-resolution image.
	**/
	public function uploadFromTypedArray(data:ArrayBufferView, side:UInt, miplevel:UInt = 0):Void
	{
		_.uploadFromTypedArray(data, side, miplevel);
	}
}
#else
typedef CubeTexture = flash.display3D.textures.CubeTexture;
#end
