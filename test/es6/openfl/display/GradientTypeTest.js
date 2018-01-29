import GradientType from "openfl/display/GradientType";
import * as assert from "assert";


describe ("ES6 | GradientType", function () {
	
	
	it ("test", function () {
		
		//assert.equal (0, Type.enumIndex (GradientType.LINEAR));
		//assert.equal (1, Type.enumIndex (GradientType.RADIAL));
		
		switch (+GradientType.RADIAL) {
			
			case GradientType.LINEAR:
			case GradientType.RADIAL:
				break;
			
			default:
				assert.ok (false);
			
		}
		
	});
	
	
});