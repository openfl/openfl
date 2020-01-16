package openfl.display;

#if !flash

#if !openfljs
/**
	This class defines the constants that represent the possible values for
	the ShaderParameter class's `type` property. Each constant represents one
	of the data types available in Flash Player for parameters in the Pixel
	Bender shader language.
**/
@:enum abstract ShaderParameterType(Null<Int>)
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
	public var BOOL = 0;

	/**
		Indicates that the shader parameter is defined as a `bool2` value,
		equivalent to an Array of two Boolean instances in ActionScript.
	**/
	public var BOOL2 = 1;

	/**
		Indicates that the shader parameter is defined as a `bool3` value,
		equivalent to an Array of three Boolean instances in ActionScript.
	**/
	public var BOOL3 = 2;

	/**
		Indicates that the shader parameter is defined as a `bool4` value,
		equivalent to an Array of four Boolean instances in ActionScript.
	**/
	public var BOOL4 = 3;

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
	public var FLOAT = 4;

	/**
		Indicates that the shader parameter is defined as a `float2` value,
		equivalent to an Array of two Number instances in ActionScript.
	**/
	public var FLOAT2 = 5;

	/**
		Indicates that the shader parameter is defined as a `float3` value,
		equivalent to an Array of three Number instances in ActionScript.
	**/
	public var FLOAT3 = 6;

	/**
		Indicates that the shader parameter is defined as a `float4` value,
		equivalent to an Array of four Number instances in ActionScript.
	**/
	public var FLOAT4 = 7;

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
	public var INT = 8;

	/**
		Indicates that the shader parameter is defined as an `int2` value,
		equivalent to an Array of two int or uint instances in ActionScript.
	**/
	public var INT2 = 9;

	/**
		Indicates that the shader parameter is defined as an `int3` value,
		equivalent to an Array of three int or uint instances in ActionScript.
	**/
	public var INT3 = 10;

	/**
		Indicates that the shader parameter is defined as an `int4` value,
		equivalent to an Array of four int or uint instances in ActionScript.
	**/
	public var INT4 = 11;

	/**
		Indicates that the shader parameter is defined as a `float2x2` value,
		equivalent to a 2-by-2 matrix. This matrix is represented as an Array
		of four Number instances in ActionScript.
	**/
	public var MATRIX2X2 = 12;

	/**
		Indicates that the shader parameter is defined as a `float2x3` value,
		equivalent to a 2-by-3 matrix. This matrix is represented as an Array
		of six Float instances in Haxe.
	**/
	public var MATRIX2X3 = 13;

	/**
		Indicates that the shader parameter is defined as a `float2x4` value,
		equivalent to a 2-by-4 matrix. This matrix is represented as an Array
		of eight Float instances in Haxe.
	**/
	public var MATRIX2X4 = 14;

	/**
		Indicates that the shader parameter is defined as a `float3x2` value,
		equivalent to a 3-by-2 matrix. This matrix is represented as an Array
		of six Float instances in Haxe.
	**/
	public var MATRIX3X2 = 15;

	/**
		Indicates that the shader parameter is defined as a `float3x3` value,
		equivalent to a 3-by-3 matrix. This matrix is represented as an Array
		of nine Number instances in ActionScript.
	**/
	public var MATRIX3X3 = 16;

	/**
		Indicates that the shader parameter is defined as a `float3x4` value,
		equivalent to a 3-by-4 matrix. This matrix is represented as an Array
		of twelve Float instances in Haxe.
	**/
	public var MATRIX3X4 = 17;

	/**
		Indicates that the shader parameter is defined as a `float4x2` value,
		equivalent to a 4-by-2 matrix. This matrix is represented as an Array
		of eight Float instances in Haxe.
	**/
	public var MATRIX4X2 = 18;

	/**
		Indicates that the shader parameter is defined as a `float4x3` value,
		equivalent to a 4-by-3 matrix. This matrix is represented as an Array
		of twelve Float instances in Haxe.
	**/
	public var MATRIX4X3 = 19;

	/**
		Indicates that the shader parameter is defined as a `float4x4` value,
		equivalent to a 4-by-4 matrix. This matrix is represented as an Array
		of 16 Number instances in ActionScript.
	**/
	public var MATRIX4X4 = 20;

	@:from private static function fromString(value:String):ShaderParameterType
	{
		return switch (value)
		{
			case "bool": BOOL;
			case "bool2": BOOL2;
			case "bool3": BOOL2;
			case "bool4": BOOL2;
			case "float": FLOAT;
			case "float2": FLOAT2;
			case "float3": FLOAT3;
			case "float4": FLOAT4;
			case "int": INT;
			case "int2": INT2;
			case "int3": INT3;
			case "int4": INT4;
			case "matrix2x2": MATRIX2X2;
			case "matrix2x3": MATRIX2X3;
			case "matrix2x4": MATRIX2X4;
			case "matrix3x2": MATRIX3X2;
			case "matrix3x3": MATRIX3X3;
			case "matrix3x4": MATRIX3X4;
			case "matrix4x2": MATRIX4X2;
			case "matrix4x3": MATRIX4X3;
			case "matrix4x4": MATRIX4X4;
			default: null;
		}
	}

	@:to private function toString():String
	{
		return switch (cast this : ShaderParameterType)
		{
			case ShaderParameterType.BOOL: "bool";
			case ShaderParameterType.BOOL2: "bool2";
			case ShaderParameterType.BOOL3: "bool3";
			case ShaderParameterType.BOOL4: "bool4";
			case ShaderParameterType.FLOAT: "float";
			case ShaderParameterType.FLOAT2: "float2";
			case ShaderParameterType.FLOAT3: "float3";
			case ShaderParameterType.FLOAT4: "float4";
			case ShaderParameterType.INT: "int";
			case ShaderParameterType.INT2: "int2";
			case ShaderParameterType.INT3: "int3";
			case ShaderParameterType.INT4: "int4";
			case ShaderParameterType.MATRIX2X2: "matrix2x2";
			case ShaderParameterType.MATRIX2X3: "matrix2x3";
			case ShaderParameterType.MATRIX2X4: "matrix2x4";
			case ShaderParameterType.MATRIX3X2: "matrix3x2";
			case ShaderParameterType.MATRIX3X3: "matrix3x3";
			case ShaderParameterType.MATRIX3X4: "matrix3x4";
			case ShaderParameterType.MATRIX4X2: "matrix4x2";
			case ShaderParameterType.MATRIX4X3: "matrix4x3";
			case ShaderParameterType.MATRIX4X4: "matrix4x4";
			default: null;
		}
	}
}
#else
@SuppressWarnings("checkstyle:FieldDocComment")
@:enum abstract ShaderParameterType(String) from String to String
{
	public var BOOL = "bool";
	public var BOOL2 = "bool2";
	public var BOOL3 = "bool3";
	public var BOOL4 = "bool4";
	public var FLOAT = "float";
	public var FLOAT2 = "float2";
	public var FLOAT3 = "float3";
	public var FLOAT4 = "float4";
	public var INT = "int";
	public var INT2 = "int2";
	public var INT3 = "int3";
	public var INT4 = "int4";
	public var MATRIX2X2 = "matrix2x2";
	public var MATRIX2X3 = "matrix2x3";
	public var MATRIX2X4 = "matrix2x4";
	public var MATRIX3X2 = "matrix3x2";
	public var MATRIX3X3 = "matrix3x3";
	public var MATRIX3X4 = "matrix3x4";
	public var MATRIX4X2 = "matrix4x2";
	public var MATRIX4X3 = "matrix4x3";
	public var MATRIX4X4 = "matrix4x4";
}
#end
#else
typedef ShaderParameterType = flash.display.ShaderParameterType;
#end
