import Context3DWrapMode from "openfl/display3D/Context3DWrapMode";
import * as assert from "assert";


describe ("ES6 | Context3DWrapMode", function () {
	
	
	it ("test", function () {
		
		switch (+Context3DWrapMode.CLAMP) {
			
			case Context3DWrapMode.CLAMP:
			case Context3DWrapMode.CLAMP_U_REPEAT_V:
			case Context3DWrapMode.REPEAT:
			case Context3DWrapMode.REPEAT_U_CLAMP_V:
				break;
			
		}
		
	});
	
	
});