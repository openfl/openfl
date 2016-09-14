package openfl.display;


import massive.munit.Assert;
import openfl.display.Stage3D;


class Stage3DTest {
	
	
	@Test public function context3D () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.context3D;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function visible () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.visible;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function x () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.x;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function y () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.y;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function requestContext3D () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3D;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function requestContext3DMatchingProfiles  () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3DMatchingProfiles;
		
		Assert.isNotNull (exists);
		
	}
	
	
}