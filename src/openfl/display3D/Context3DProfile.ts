namespace openfl.display3D
{
	/**
		Defines the values to use for specifying the Context3D profile.
	**/
	export enum Context3DProfile
	{
		/**
			Use the default feature support profile.

			This profile most closely resembles Stage3D support used in previous releases.
		**/
		BASELINE = "baseline",

		/**
			Use a constrained feature support profile to target older GPUs

			This profile is primarily targeted at devices that only support PS_2.0 level
			shaders like the Intel GMA 9xx series. In addition, this mode tries to improve
			memory bandwidth usage by rendering directly into the back buffer. There are
			several side effects:

			* You are limited to 64 ALU and 32 texture instructions per shader.
			* Only four texture read instructions per shader.
			* No support for predicate register. This affects sln/sge/seq/sne, which you
			replace with compound mov/cmp instructions, available with ps_2_0.
			* The Context3D back buffer must always be within the bounds of the stage.
			* Only one instance of a Context3D running in Constrained profile is allowed
			within a Flash Player instance.
			* Standard display list list rendering is driven by `Context3D.present()` instead of
			being based on the SWF frame rate. That is, if a Context3D object is active and
			visible you must call `Context3D.present()` to render the standard display list.
			* Reading back from the back buffer through `Context3D.drawToBitmapData()` might
			include parts of the display list content. Alpha information will be lost.
		**/
		BASELINE_CONSTRAINED = "baselineConstrained",

		/**
			Use an extended feature support profile to target newer GPUs which support larger
			textures

			This profile increases the maximum 2D Texture and RectangleTexture size to 4096x4096
		**/
		BASELINE_EXTENDED = "baselineExtended",

		/**
			Use an standard profile to target GPUs which support MRT, AGAL2 and float textures.

			This profile supports 4 render targets. Increase AGAL commands and register count.
			Add float textures.
		**/
		STANDARD = "standard",

		/**
			Use an standard profile to target GPUs which support AGAL2 and float textures.

			This profile is an alternative to standard profile, which removes MRT and a few
			features in AGAL2 but can reach more GPUs.
		**/
		STANDARD_CONSTRAINED = "standardConstrained",

		/**
			Use standard extended profile to target GPUs which support AGAL3 and instanced
			drawing feature.

			This profile extends the standard profile.

			This profile is enabled on mobile platforms from AIR 17.0 and on Windows and Mac
			from AIR 18.0.
		**/
		STANDARD_EXTENDED = "standardExtended"
	}
}

export default openfl.display3D.Context3DProfile;
