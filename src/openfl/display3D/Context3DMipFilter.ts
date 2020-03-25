namespace openfl.display3D
{
	/**
		Defines the values to use for sampler mipmap filter mode
	**/
	export enum Context3DMipFilter
	{
		/**
			Select the two closest MIP levels and linearly blend between them (the highest
			quality mode, but has some performance cost).
		**/
		MIPLINEAR = "miplinear",

		/**
			Use the nearest neighbor metric to select MIP levels (the fastest rendering method).
		**/
		MIPNEAREST = "mipnearest",

		/**
			Always use the top level texture (has a performance penalty when downscaling).
		**/
		MIPNONE = "mipnone"
	}
}

export default openfl.display3D.Context3DMipFilter;
