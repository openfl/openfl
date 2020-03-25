namespace openfl.display3D
{
	/**
		Defines the values to use for sampler wrap mode
	**/
	export enum Context3DWrapMode
	{
		/**
			Clamp texture coordinates outside the 0..1 range.

			The is x = max(min(x,0),1)
		**/
		CLAMP = "clamp",

		/**
			Clamp in U axis but Repeat in V axis.
		**/
		CLAMP_U_REPEAT_V = "clamp_u_repeat_v",

		/**
			Repeat (tile) texture coordinates outside the 0..1 range.

			The is x = x<0?1.0-frac(abs(x)):frac(x)
		**/
		REPEAT = "repeat",

		/**
			Repeat in U axis but Clamp in V axis.
		**/
		REPEAT_U_CLAMP_V = "repeat_u_clamp_v"
	}
}

export default openfl.display3D.Context3DWrapMode;
