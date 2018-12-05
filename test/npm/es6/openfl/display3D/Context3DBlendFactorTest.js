import Context3DBlendFactor from "openfl/display3D/Context3DBlendFactor";
import * as assert from "assert";


describe ("ES6 | Context3DBlendFactor", function () {
	
	
	it ("test", function () {
		
		switch (""+Context3DBlendFactor.DESTINATION_ALPHA) {
			
			case Context3DBlendFactor.DESTINATION_ALPHA:
			case Context3DBlendFactor.DESTINATION_COLOR:
			case Context3DBlendFactor.ONE:
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA:
			case Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR:
			case Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA:
			case Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR:
			case Context3DBlendFactor.SOURCE_ALPHA:
			case Context3DBlendFactor.SOURCE_COLOR:
			case Context3DBlendFactor.ZERO:
				break;
			
		}
		
	});
	
	
});