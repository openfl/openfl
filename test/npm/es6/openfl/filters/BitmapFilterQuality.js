import BitmapFilterQuality from "openfl/filters/BitmapFilterQuality";
import * as assert from "assert";


describe ("ES6 | BitmapFilterQuality", function () {
	
	
	it ("test", function () {
		
		switch (+BitmapFilterQuality.HIGH) {
			
			case BitmapFilterQuality.HIGH:
			case BitmapFilterQuality.MEDIUM:
			case BitmapFilterQuality.LOW:
				break;
			
		}
		
	});
	
	
});