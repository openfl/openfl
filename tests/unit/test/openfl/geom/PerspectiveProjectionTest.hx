package openfl.geom;


import massive.munit.Assert;


class PerspectiveProjectionTest {
	
	
	@Test public function fieldOfView () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.fieldOfView;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function focalLength () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.focalLength;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function projectionCenter () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.projectionCenter;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function toMatrix3D () {
		
		// TODO: Confirm functionality
		
		var perspectiveProjection = new PerspectiveProjection ();
		var exists = perspectiveProjection.toMatrix3D;
		
		Assert.isNotNull (exists);
		
	}
	
	
}