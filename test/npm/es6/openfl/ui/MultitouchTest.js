import Multitouch from "openfl/ui/Multitouch";
import * as assert from "assert";


describe ("ES6 | Multitouch", function () {
	
	
	it ("inputMode", function () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.inputMode;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("maxTouchPoints", function () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.inputMode;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("supportedGestures", function () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.supportedGestures;
		
		// Is null if not supported
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("supportsGestureEvents", function () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.supportsGestureEvents;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("supportsTouchEvents", function () {
		
		// TODO: Confirm functionality
		
		var exists = Multitouch.supportsTouchEvents;
		
		assert.notEqual (exists, null);
		
	});
	
	
});