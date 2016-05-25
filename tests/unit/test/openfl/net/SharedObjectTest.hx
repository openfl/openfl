package openfl.net;


import massive.munit.Assert;


class SharedObjectTest {
	
	
	@Test public function data () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.data;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function size () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.size;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		Assert.isNotNull (sharedObject);
		
	}
	
	
	@Test public function clear () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.clear;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function flush () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.flush;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setProperty () {
		
		// TODO: Confirm functionality
		
		var sharedObject = SharedObject.getLocal ("test");
		var exists = sharedObject.setProperty;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getLocal () {
		
		// TODO: Confirm functionality
		
		var exists = SharedObject.getLocal;
		
		Assert.isNotNull (exists);
		
	}
	
	
}