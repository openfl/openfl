package openfl.geom;


import massive.munit.Assert;
import openfl.display.Sprite;


class TransformTest {
	
	
	@Test public function colorTransform () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.colorTransform;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function concatenatedColorTransform () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.concatenatedColorTransform;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function concatenatedMatrix () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.concatenatedMatrix;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function matrix () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.matrix;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function pixelBounds () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		var exists = transform.pixelBounds;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var transform = new Sprite ().transform;
		Assert.isNotNull (transform);
		
	}
	
	
}