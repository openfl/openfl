import StageDisplayState from "openfl/display/StageDisplayState";
import * as assert from "assert";


describe ("ES6 | StageDisplayState", function () {
	
	
	it ("test", function () {
		
		switch (""+StageDisplayState.NORMAL) {
			
			case StageDisplayState.FULL_SCREEN:
			case StageDisplayState.FULL_SCREEN_INTERACTIVE:
			case StageDisplayState.NORMAL:
				break;
			
		}
		
	});
	
	
});