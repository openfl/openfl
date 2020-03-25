namespace openfl.display
{
	/**
		This class defines the constants that represent the possible values for
		the ShaderParameter class's `type` property. Each constant represents one
		of the data types available in Flash Player for parameters in the Pixel
		Bender shader language.
	**/
	export enum ShaderParameterType
	{
		/**
			Indicates that the shader parameter is defined as a `bool` value,
			equivalent to a single Boolean instance in ActionScript.
			Note that even though the parameter only expects a single value, the
			`ShaderParameter.value` property is an Array, so the single value must
			be the only element of an Array assigned to the `value` property, like
			this:

			```haxe
			// assumes the shader has a parameter named "param"
			// whose data type is bool
			myShader.data.param.value = [true];
			```
		**/
		BOOL = "bool",

		/**
			Indicates that the shader parameter is defined as a `bool2` value,
			equivalent to an Array of two Boolean instances in ActionScript.
		**/
		BOOL2 = "bool2",

		/**
			Indicates that the shader parameter is defined as a `bool3` value,
			equivalent to an Array of three Boolean instances in ActionScript.
		**/
		BOOL3 = "bool3",

		/**
			Indicates that the shader parameter is defined as a `bool4` value,
			equivalent to an Array of four Boolean instances in ActionScript.
		**/
		BOOL4 = "bool4",

		/**
			Indicates that the shader parameter is defined as a `float` value,
			equivalent to a single Number instance in ActionScript.
			Note that even though the parameter only expects a single value, the
			`ShaderParameter.value` property is an Array, so the single value must
			be the only element of an Array assigned to the `value` property, like
			this:

			```haxe
			// assumes the shader has a parameter named "param"
			// whose data type is float
			myShader.data.param.value = [22.5];
			```
		**/
		FLOAT = "float",

		/**
			Indicates that the shader parameter is defined as a `float2` value,
			equivalent to an Array of two Number instances in ActionScript.
		**/
		FLOAT2 = "float2",

		/**
			Indicates that the shader parameter is defined as a `float3` value,
			equivalent to an Array of three Number instances in ActionScript.
		**/
		FLOAT3 = "float3",

		/**
			Indicates that the shader parameter is defined as a `float4` value,
			equivalent to an Array of four Number instances in ActionScript.
		**/
		FLOAT4 = "float4",

		/**
			Indicates that the shader parameter is defined as an `int` value,
			equivalent to a single int or uint instance in ActionScript.
			Note that even though the parameter only expects a single value, the
			`ShaderParameter.value` property is an Array, so the single value must
			be the only element of an Array assigned to the `value` property, like
			this:

			```haxe
			// assumes the shader has a parameter named "param"
			// whose data type is int
			myShader.data.param.value = [275];
			```
		**/
		INT = "int",

		/**
			Indicates that the shader parameter is defined as an `int2` value,
			equivalent to an Array of two int or uint instances in ActionScript.
		**/
		INT2 = "int2",

		/**
			Indicates that the shader parameter is defined as an `int3` value,
			equivalent to an Array of three int or uint instances in ActionScript.
		**/
		INT3 = "int3",

		/**
			Indicates that the shader parameter is defined as an `int4` value,
			equivalent to an Array of four int or uint instances in ActionScript.
		**/
		INT4 = "int4",

		/**
			Indicates that the shader parameter is defined as a `float2x2` value,
			equivalent to a 2-by-2 matrix. This matrix is represented as an Array
			of four Number instances in ActionScript.
		**/
		MATRIX2X2 = "matrix2x2",

		/**
			Indicates that the shader parameter is defined as a `float2x3` value,
			equivalent to a 2-by-3 matrix. This matrix is represented as an Array
			of six Float instances in Haxe.
		**/
		MATRIX2X3 = "matrix2x3",

		/**
			Indicates that the shader parameter is defined as a `float2x4` value,
			equivalent to a 2-by-4 matrix. This matrix is represented as an Array
			of eight Float instances in Haxe.
		**/
		MATRIX2X4 = "matrix2x4",

		/**
			Indicates that the shader parameter is defined as a `float3x2` value,
			equivalent to a 3-by-2 matrix. This matrix is represented as an Array
			of six Float instances in Haxe.
		**/
		MATRIX3X2 = "matrix3x2",

		/**
			Indicates that the shader parameter is defined as a `float3x3` value,
			equivalent to a 3-by-3 matrix. This matrix is represented as an Array
			of nine Number instances in ActionScript.
		**/
		MATRIX3X3 = "matrix3x3",

		/**
			Indicates that the shader parameter is defined as a `float3x4` value,
			equivalent to a 3-by-4 matrix. This matrix is represented as an Array
			of twelve Float instances in Haxe.
		**/
		MATRIX3X4 = "matrix3x4",

		/**
			Indicates that the shader parameter is defined as a `float4x2` value,
			equivalent to a 4-by-2 matrix. This matrix is represented as an Array
			of eight Float instances in Haxe.
		**/
		MATRIX4X2 = "matrix4x2",

		/**
			Indicates that the shader parameter is defined as a `float4x3` value,
			equivalent to a 4-by-3 matrix. This matrix is represented as an Array
			of twelve Float instances in Haxe.
		**/
		MATRIX4X3 = "matrix4x3",

		/**
			Indicates that the shader parameter is defined as a `float4x4` value,
			equivalent to a 4-by-4 matrix. This matrix is represented as an Array
			of 16 Number instances in ActionScript.
		**/
		MATRIX4X4 = "matrix4x4"
	}
}

export default openfl.display.ShaderParameterType;
