package openfl.display; #if (display || !flash)


@:enum abstract ShaderParameterType(Null<Int>) {
	
	public var BOOL = 0;
	public var BOOL2 = 1;
	public var BOOL3 = 2;
	public var BOOL4 = 3;
	public var FLOAT = 4;
	public var FLOAT2 = 5;
	public var FLOAT3 = 6;
	public var FLOAT4 = 7;
	public var INT = 8;
	public var INT2 = 9;
	public var INT3 = 10;
	public var INT4 = 11;
	public var MATRIX2X2 = 12;
	public var MATRIX2X3 = 13;
	public var MATRIX2X4 = 14;
	public var MATRIX3X2 = 15;
	public var MATRIX3X3 = 16;
	public var MATRIX3X4 = 17;
	public var MATRIX4X2 = 18;
	public var MATRIX4X3 = 19;
	public var MATRIX4X4 = 20;
	
	@:from private static function fromString (value:String):ShaderParameterType {
		
		return switch (value) {
			
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
	
	@:to private static function toString (value:Int):String {
		
		return switch (value) {
			
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
typedef ShaderParameterType = flash.display.ShaderParameterType;
#end