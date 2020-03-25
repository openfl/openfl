namespace openfl.display3D
{
	/**
		Defines the values to use for specifying Context3D clear masks.
	**/
	export enum Context3DClearMask
	{
		/**
			Clear all buffers.
		**/
		ALL = 0x07,

		/**
			Clear only the color buffer.
		**/
		COLOR = 0x01,

		/**
			Clear only the depth buffer.
		**/
		DEPTH = 0x02,

		/**
			Clear only the stencil buffer.
		**/
		STENCIL = 0x04
	}
}

export default openfl.display3D.Context3DClearMask;
