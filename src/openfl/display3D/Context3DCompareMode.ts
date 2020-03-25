namespace openfl.display3D
{
	/**
		Defines the values to use for specifying 3D buffer comparisons in the
		`setDepthTest()` and `setStencilAction()` methods of a Context3D instance.
	**/
	export enum Context3DCompareMode
	{
		/**
			The comparison always evaluates as true.
		**/
		ALWAYS = "always",

		/**
			Equal (==).
		**/
		EQUAL = "equal",

		/**
			Greater than (>).
		**/
		GREATER = "greater",

		/**
			Greater than or equal (>=).
		**/
		GREATER_EQUAL = "greaterEqual",

		/**
			Less than (<).
		**/
		LESS = "less",

		/**
			Less than or equal (<=).
		**/
		LESS_EQUAL = "lessEqual",

		/**
			The comparison never evaluates as true.
		**/
		NEVER = "never",

		/**
			Not equal (!=).
		**/
		NOT_EQUAL = "notEqual"
	}
}

export default openfl.display3D.Context3DCompareMode;
