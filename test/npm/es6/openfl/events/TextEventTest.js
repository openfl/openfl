import TextEvent from "openfl/events/TextEvent";
import * as assert from "assert";


describe ("ES6 | TextEvent", function () {
	
	
	it ("text", function () {
		
		// TODO: Confirm functionality
		
		var textEvent = new TextEvent (TextEvent.LINK);
		var exists = textEvent.text;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var textEvent = new TextEvent (TextEvent.LINK);
		assert.notEqual (textEvent, null);
		
	});
	
	
});