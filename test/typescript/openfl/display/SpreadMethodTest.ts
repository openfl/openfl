import SpreadMethod from "openfl/display/SpreadMethod";
import * as assert from "assert";


describe ("TypeScript | SpreadMethod", function () {
	
	
	it ("test", function () {
		
		switch (+SpreadMethod.REPEAT) {
			
			case SpreadMethod.PAD:
			case SpreadMethod.REFLECT:
			case SpreadMethod.REPEAT:
				break;
			
		}
		
	});
	
	
});