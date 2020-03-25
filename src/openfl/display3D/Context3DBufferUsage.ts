namespace openfl.display3D
{
	/**
		Defines the values to use for specifying the buffer usage type.
	**/
	export enum Context3DBufferUsage
	{
		/**
			Indicates the buffer will be used for drawing and be updated frequently
		**/
		DYNAMIC_DRAW = "dynamicDraw",

		/**
			Indicates the buffer will be used for drawing and be updated once

			This type is the default value for buffers in `Stage3D`.
		**/
		STATIC_DRAW = "staticDraw"
	}
}

export default openfl.display3D.Context3DBufferUsage;
