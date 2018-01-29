import BitmapFilterType from "openfl/filters/BitmapFilterType";
import * as assert from "assert";


describe ("ES6 | BitmapFilterType", function () {
	
	
	it ("test", function () {
		
		switch (+BitmapFilterType.FULL) {
			
			case BitmapFilterType.FULL:
			case BitmapFilterType.INNER:
			case BitmapFilterType.OUTER:
				break;
			
		}
		
	});
	
	
});