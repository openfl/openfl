import StageScaleMode from "openfl/display/StageScaleMode";
import * as assert from "assert";


describe ("ES6 | StageScaleMode", function () {
	
	
	it ("test", function () {
		
		switch (+StageScaleMode.SHOW_ALL) {
			
			case StageScaleMode.EXACT_FIT:
			case StageScaleMode.NO_BORDER:
			case StageScaleMode.NO_SCALE:
			case StageScaleMode.SHOW_ALL:
				break;
			
		}
		
	});
	
	
});