namespace openfl.display3D
{
	/**
		Defines the values to use for sampler filter mode.
	**/
	export enum Context3DTextureFilter
	{
		/**
			Use anisotropic filter with radio 16 when upsampling textures
		**/
		ANISOTROPIC16X = "anisotropic16x",

		/**
			Use anisotropic filter with radio 2 when upsampling textures
		**/
		ANISOTROPIC2X = "anisotropic2x",

		/**
			Use anisotropic filter with radio 4 when upsampling textures
		**/
		ANISOTROPIC4X = "anisotropic4x",

		/**
			Use anisotropic filter with radio 8 when upsampling textures
		**/
		ANISOTROPIC8X = "anisotropic8x",

		/**
			Use linear interpolation when upsampling textures (gives a smooth, blurry look).
		**/
		LINEAR = "linear",

		/**
			Use nearest neighbor sampling when upsampling textures (gives a pixelated,
			sharp mosaic look).
		**/
		NEAREST = "nearest"
	}
}

export default openfl.display3D.Context3DTextureFilter;
