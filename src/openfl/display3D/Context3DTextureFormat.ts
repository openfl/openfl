namespace openfl.display3D
{
	/**
		Defines the values to use for specifying a texture format.
	**/
	export enum Context3DTextureFormat
	{
		/**
			16 bit, bgr packed as 5:6:5
		**/
		BGR_PACKED = "bgrPacked565",

		/**
			32 bit
		**/
		BGRA = "bgra",

		/**
			16 bit, bgra packed as 4:4:4:4
		**/
		BGRA_PACKED = "bgraPacked4444",

		/**
			ATF (Adobe Texture Format)
		**/
		COMPRESSED = "compressed",

		/**
			ATF (Adobe Texture Format), with alpha
		**/
		COMPRESSED_ALPHA = "compressedAlpha",

		/**
			64 bit, rgba as 16:16:16:16
		**/
		RGBA_HALF_FLOAT = "rgbaHalfFloat"
	}
}

export default openfl.display3D.Context3DTextureFormat;
