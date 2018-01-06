import StageQuality from "openfl/display/StageQuality";
import * as assert from "assert";


describe ("TypeScript | StageQuality", function () {
	
	
	it ("test", function () {
		
		switch (+StageQuality.MEDIUM) {
			
			case StageQuality.BEST:
			case StageQuality.HIGH:
			case StageQuality.LOW:
			case StageQuality.MEDIUM:
				break;
			
		}
		
	});
	
	
});