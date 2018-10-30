import LoaderContext from "openfl/system/LoaderContext";
import * as assert from "assert";


describe ("TypeScript | LoaderContext", function () {
	
	
	it ("allowCodeImport", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.allowCodeImport;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("allowLoadBytesCodeExecution", function () {
		
		// #if !flash // not available in Linux Flash Player
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.allowLoadBytesCodeExecution;
		
		assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("applicationDomain", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.applicationDomain;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("checkPolicyFile", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.checkPolicyFile;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("securityDomain", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		var exists = loaderContext.securityDomain;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var loaderContext = new LoaderContext ();
		assert.notEqual (loaderContext, null);
		
	});
	
	
});