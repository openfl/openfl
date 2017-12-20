import Window from "openfl/display/Window";
import * as assert from "assert";


describe ("ES6 | Window", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var window = new Window ();
		var exists = window;
		
		assert.notEqual (exists, null);
		
	});
	
	
});