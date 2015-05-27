package openfl.display; #if !flash #if !openfl_legacy


@:enum abstract ShaderParameterType(String) from String {
	var BOOL = "bool";
	var BOOL2 = "bool2";
	var BOOL3 = "bool3";
	var BOOL4 = "bool4";
	var FLOAT = "float";
	var FLOAT2 = "float2";
	var FLOAT3 = "float3";
	var FLOAT4 = "float4";
	var INT = "int";
	var INT2 = "int2";
	var INT3 = "int3";
	var INT4 = "int4";
	var MATRIX2X2 = "matrix2x2";
	var MATRIX3X3 = "matrix3x3";
	var MATRIX4X4 = "matrix4x4";
}

#else
typedef ShaderParameterType = openfl._legacy.display.ShaderParameterType;
#end
#else
typedef ShaderParameterType = flash.display.ShaderParameterType;
#end