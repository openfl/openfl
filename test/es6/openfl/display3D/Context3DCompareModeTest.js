import Context3DCompareMode from "openfl/display3D/Context3DCompareMode";
import * as assert from "assert";


describe ("ES6 | Context3DCompareMode", function () {
	
	
	it ("test", function () {
		
		switch (+Context3DCompareMode.ALWAYS) {
			
			case Context3DCompareMode.ALWAYS:
			case Context3DCompareMode.EQUAL:
			case Context3DCompareMode.GREATER:
			case Context3DCompareMode.GREATER_EQUAL:
			case Context3DCompareMode.LESS:
			case Context3DCompareMode.LESS_EQUAL:
			case Context3DCompareMode.NEVER:
			case Context3DCompareMode.NOT_EQUAL:
				break;
			
		}
		
	});
	
	
});