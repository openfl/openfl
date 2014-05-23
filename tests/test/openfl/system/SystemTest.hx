package openfl.system;


import massive.munit.Assert;


class SystemTest {
	
	
	@Test public function totalMemory () {
		
		// TODO: Confirm functionality
		
		var exists = System.totalMemory;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function exit () {
		
		// TODO: Confirm functionality
		
		var exists = System.exit;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function gc () {
		
		// TODO: Confirm functionality
		
		var exists = System.gc;
		
		Assert.isNotNull (exists);
		
	}
	
	
}