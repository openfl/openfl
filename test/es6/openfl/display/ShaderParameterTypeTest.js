import ShaderParameterType from "openfl/display/ShaderParameterType";
import * as assert from "assert";


describe ("ES6 | ShaderParameterType", function () {
	
	
	it ("test", function () {
		
		switch (+ShaderParameterType.BOOL) {
			
			case ShaderParameterType.BOOL:
			case ShaderParameterType.BOOL2:
			case ShaderParameterType.BOOL3:
			case ShaderParameterType.BOOL4:
			case ShaderParameterType.FLOAT:
			case ShaderParameterType.FLOAT2:
			case ShaderParameterType.FLOAT3:
			case ShaderParameterType.FLOAT4:
			case ShaderParameterType.INT:
			case ShaderParameterType.INT2:
			case ShaderParameterType.INT3:
			case ShaderParameterType.INT4:
			case ShaderParameterType.MATRIX2X2:
			case ShaderParameterType.MATRIX2X3:
			case ShaderParameterType.MATRIX2X4:
			case ShaderParameterType.MATRIX3X2:
			case ShaderParameterType.MATRIX3X3:
			case ShaderParameterType.MATRIX3X4:
			case ShaderParameterType.MATRIX4X2:
			case ShaderParameterType.MATRIX4X3:
			case ShaderParameterType.MATRIX4X4:
				break;
			
		}
		
	});
	
	
});