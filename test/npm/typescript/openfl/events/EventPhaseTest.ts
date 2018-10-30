import EventPhase from "openfl/events/EventPhase";
import * as assert from "assert";


describe ("TypeScript | EventPhase", function () {
	
	
	it ("test", function () {
		
		switch (+EventPhase.CAPTURING_PHASE) {
			
			case EventPhase.CAPTURING_PHASE:
			case EventPhase.AT_TARGET:
			case EventPhase.BUBBLING_PHASE:
				break;
			
		}
		
	});
	
	
});