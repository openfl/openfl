import StageAlign from "openfl/display/StageAlign";
import * as assert from "assert";


describe ("TypeScript | StageAlign", function () {
	
	
	it ("test", function () {
		
		switch (""+StageAlign.TOP_RIGHT) {
				
			case StageAlign.BOTTOM:
			case StageAlign.BOTTOM_LEFT:
			case StageAlign.BOTTOM_RIGHT:
			case StageAlign.LEFT:
			case StageAlign.RIGHT:
			case StageAlign.TOP:
			case StageAlign.TOP_LEFT:
			case StageAlign.TOP_RIGHT:
				break;
			
		}
		
	});
	
	
});