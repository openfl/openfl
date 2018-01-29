import DOMSprite from "openfl/display/DOMSprite";
import * as assert from "assert";


describe ("ES6 | DOMSprite", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var domSprite = new DOMSprite (null);
		var exists = domSprite;
		
		assert.notEqual (exists, null);
		
	});
	
	
});