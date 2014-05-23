package openfl.errors;


import massive.munit.Assert;


class ErrorTest {
	
	
	@Test public function errorID () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.errorID;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function message () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.message;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function name () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.name;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		
		Assert.isNotNull (error);
		
	}
	
	
	@Test public function getStackTrace () {
		
		// TODO: Confirm functionality
		
		var error = new Error ();
		var exists = error.getStackTrace;
		
		Assert.isNotNull (exists);
		
	}
	
	
}