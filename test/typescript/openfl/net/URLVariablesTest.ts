import URLVariables from "openfl/net/URLVariables";
import * as assert from "assert";


describe ("TypeScript | URLVariables", function () {
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var urlVariables = new URLVariables ();
		assert.notEqual (urlVariables, null);
		
	});
	
	
	it ("decode", function () {
		
		var urlVariables = new URLVariables ("firstName=Tom&lastName=Jones");
		assert.equal ("Tom", urlVariables.firstName);
		assert.equal ("Jones", urlVariables.lastName);
		
		var urlVariables = new URLVariables ();
		urlVariables.decode ("firstName=Tom&lastName=Jones");
		assert.equal ("Tom", urlVariables.firstName);
		assert.equal ("Jones", urlVariables.lastName);
		
	});
	
	
	it ("toString", function () {
		
		var urlVariables = new URLVariables ("firstName=Tom&lastName=Jones");
		assert.equal ("firstName=Tom&lastName=Jones", urlVariables.toString ());
		
	});
	
	
});