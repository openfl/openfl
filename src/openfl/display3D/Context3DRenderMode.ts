namespace openfl.display3D
{
	/**
		Defines the values to use for specifying the Context3D render mode.
	**/
	export enum Context3DRenderMode
	{
		/**
			Automatically choose rendering engine.

			A hardware-accelerated rendering engine is used if available on the current
			device. Availability of hardware acceleration is influenced by the device
			capabilites, the wmode when running under Flash Player, and the render mode when
			running under AIR.
		**/
		AUTO = "auto",

		/**
			Use software 3D rendering.

			Software rendering is not available on mobile devices.
		**/
		SOFTWARE = "software"
	}
}

export default openfl.display3D.Context3DRenderMode;
