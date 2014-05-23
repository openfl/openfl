package openfl.net;


import massive.munit.Assert;


class URLLoaderTest {
	
	
	@Test public function bytesLoaded () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.bytesLoaded;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function bytesTotal () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.bytesTotal;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function data () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.data;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function dataFormat () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.dataFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		Assert.isNotNull (urlLoader);
		
	}
	
	
	@Test public function close () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.close;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function load () {
		
		// TODO: Confirm functionality
		
		var urlLoader = new URLLoader ();
		var exists = urlLoader.load;
		
		Assert.isNotNull (exists);
		
	}
	
	
}