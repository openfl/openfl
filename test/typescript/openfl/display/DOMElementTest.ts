import DOMElement from "openfl/display/DOMElement";
import * as assert from "assert";


describe ("TypeScript | DOMElement", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var domElement = new DOMElement (null);
		var exists = domElement;
		
		assert.notEqual (exists, null);
		
	});
	
	
});