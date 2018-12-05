package openfl.display;


import openfl.display.LoaderInfo;


class LoaderInfoTest { public static function __init__ () { Mocha.describe ("Haxe | LoaderInfo", function () {
	
	
	Mocha.it ("applicationDomain", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.applicationDomain;
		
		//Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("bytes", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytes;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytesLoaded;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytesTotal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("content", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.content;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("contentType", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.contentType;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("frameRate", function () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.frameRate;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("height", function () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.height;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("loader", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.loader;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("loaderURL", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.loaderURL;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("parameters", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.parameters;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("parentAllowsChild", function () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.parentAllowsChild;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("sameDomain", function () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.sameDomain;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
	Mocha.it ("sharedEvents", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.sharedEvents;
		
		//Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("url", function () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.url;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("width", function () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.width;
		
		//Assert.notEqual (exists, null);
		
		#end
		
	});
	
	
}); }}