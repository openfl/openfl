package openfl.display;


import massive.munit.Assert;
import openfl.display.LoaderInfo;


class LoaderInfoTest {
	
	
	@Test public function applicationDomain () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.applicationDomain;
		
		//Assert.isNull (exists);
		
	}
	
	
	@Test public function bytes () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytes;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function bytesLoaded () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytesLoaded;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function bytesTotal () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.bytesTotal;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function content () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.content;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function contentType () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.contentType;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function frameRate () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.frameRate;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function height () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.height;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function loader () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.loader;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function loaderURL () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.loaderURL;
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function parameters () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.parameters;
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function parentAllowsChild () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.parentAllowsChild;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function sameDomain () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.sameDomain;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
	@Test public function sharedEvents () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.sharedEvents;
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function url () {
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.url;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function width () {
		
		#if !flash // throws error until certain types of content are loaded
		
		// TODO: Confirm functionality
		
		var loader = new Loader ();
		var exists = loader.contentLoaderInfo.width;
		
		//Assert.isNotNull (exists);
		
		#end
		
	}
	
	
}