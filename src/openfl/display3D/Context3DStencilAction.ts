namespace openfl.display3D
{
	/**
		Defines the values to use for specifying stencil actions.
	
		A stencil action specifies how the values in the stencil buffer should be changed.
	**/
	export enum Context3DStencilAction
	{
		/**
			Decrement the stencil buffer value, clamping at 0, the minimum value.
		**/
		DECREMENT_SATURATE = "decrementSaturate",

		/**
			Decrement the stencil buffer value. If the result is less than 0, the minimum
			value, then the buffer value is "wrapped around" to 255.
		**/
		DECREMENT_WRAP = "decrementWrap",

		/**
			Increment the stencil buffer value, clamping at 255, the maximum value.
		**/
		INCREMENT_SATURATE = "incrementSaturate",

		/**
			Increment the stencil buffer value. If the result exceeds 255, the maximum
			value, then the buffer value is "wrapped around" to 0.
		**/
		INCREMENT_WRAP = "incrementWrap",

		/**
			Invert the stencil buffer value, bitwise.

			For example, if the 8-bit binary number in the stencil buffer is: 11110000, then
			the value is changed to: 00001111.
		**/
		INVERT = "invert",

		/**
			Keep the current stencil buffer value.
		**/
		KEEP = "keep",

		/**
			Replace the stencil buffer value with the reference value.
		**/
		SET = "set",

		/**
			Set the stencil buffer value to 0.
		**/
		ZERO = "zero"
	}
}

export default openfl.display3D.Context3DStencilAction;
