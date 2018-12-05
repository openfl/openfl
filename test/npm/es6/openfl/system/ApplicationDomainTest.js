import ApplicationDomain from "openfl/system/ApplicationDomain";
import * as assert from "assert";


describe ("ES6 | ApplicationDomain", function () {
	
	
	it ("parentDomain", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.parentDomain;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		assert.notEqual (applicationDomain, null);
		
	});
	
	
	it ("getDefinition", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.getDefinition;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("hasDefinition", function () {
		
		// TODO: Confirm functionality
		
		var applicationDomain = ApplicationDomain.currentDomain;
		var exists = applicationDomain.hasDefinition;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("currentDomain", function () {
		
		// TODO: Confirm functionality
		
		var exists = ApplicationDomain.currentDomain;
		
		assert.notEqual (exists, null);
		
	});
	
	
});