namespace openfl.display
{
	/**
		This class defines the constants that represent the possible values for
		the Shader class's `precisionHint` property. Each constant represents one
		of the precision modes for executing shader operations.
		The precision mode selection affects the following shader operations.
		These operations are faster on an Intel processor with the SSE instruction
		set:

		* `sin(x)`
		* `cos(x)`
		* `tan(x)`
		* `asin(x)`
		* `acos(x)`
		* `atan(x)`
		* `atan(x, y)`
		* `exp(x)`
		* `exp2(x)`
		* `log(x)`
		* `log2(x)`
		* `pow(x, y)`
		* `reciprocal(x)`
		* `sqrt(x)`
	**/
	export enum ShaderPrecision
	{
		/**
			Represents fast precision mode.
			Fast precision mode is designed for maximum performance but does not
			work consistently on different platforms and individual CPU
			configurations. In many cases, this level of precision is sufficient
			to create graphic effects without visible artifacts.

			It is usually faster to use fast precision mode than to use lookup
			tables.
		**/
		FAST = "fast",

		/**
			Represents full precision mode.
			In full precision mode, the shader computes all math operations to the
			full width of the IEEE 32-bit floating standard. This mode provides
			consistent behavior on all platforms. In this mode, some math
			operations such as trigonometric and exponential functions can be
			slow.
		**/
		FULL = "full"
	}
}

export default openfl.display.ShaderPrecision;
