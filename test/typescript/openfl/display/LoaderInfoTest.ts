import Loader from "openfl/display/Loader";
import LoaderInfo from "openfl/display/LoaderInfo";
import * as assert from "assert";


describe ("TypeScript | LoaderInfo", function () {
	
	
	it ("applicationDomain", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.applicationDomain;
		
		//assert.equal (exists, null);
		
	});
	
	
	it ("bytes", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytes;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytesLoaded;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytesTotal;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("content", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.content;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("contentType", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.contentType;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("frameRate", function () {
		
		// #if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.frameRate;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("height", function () {
		
		// #if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.height;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("loader", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.loader;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("loaderURL", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.loaderURL;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("parameters", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.parameters;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("parentAllowsChild", function () {
		
		// #if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.parentAllowsChild;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("sameDomain", function () {
		
		// #if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.sameDomain;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
	it ("sharedEvents", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.sharedEvents;
		
		//assert.notEqual (exists, null);
		
	});
	
	
	it ("url", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.url;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("width", function () {
		
		// #if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.width;
		
		//assert.notEqual (exists, null);
		
		// #end
		
	});
	
	
});