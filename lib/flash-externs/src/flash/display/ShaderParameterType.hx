package flash.display;

#if flash
#if (haxe_ver >= 4.0) enum #else @:enum #end abstract ShaderParameterType(String) from String to String

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
#else
typedef ShaderParameterType = openfl.display.ShaderParameterType;
#end
