import LineScaleMode from "openfl/display/LineScaleMode";
import * as assert from "assert";


describe ("ES6 | LineScaleMode", function () {
	
	
	it ("test", function () {
		
		switch (+LineScaleMode.VERTICAL) {
			
			case LineScaleMode.HORIZONTAL:
			case LineScaleMode.NONE:
			case LineScaleMode.NORMAL:
			case LineScaleMode.VERTICAL:
				break;
			
		}
		
	});
	
	
});