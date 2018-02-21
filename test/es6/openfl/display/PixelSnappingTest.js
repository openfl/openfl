import PixelSnapping from "openfl/display/PixelSnapping";
import * as assert from "assert";


describe ("ES6 | PixelSnapping", function () {
	
	
	it ("test", function () {
		
		switch (+PixelSnapping.NEVER) {
			
			case PixelSnapping.ALWAYS:
			case PixelSnapping.AUTO:
			case PixelSnapping.NEVER:
				break;
			
		}
		
	});
	
	
});