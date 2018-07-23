package openfl.geom;


import massive.munit.Assert;


class Vector3DTest {
	
	
	@Test public function length () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.length;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function lengthSquared () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.lengthSquared;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function w () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.w;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function x () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.x;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function y () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.y;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function z () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.z;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		Assert.isNotNull (vector3D);
		
	}
	
	
	@Test public function add () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		var vector2 = new Vector3D (2, 2, 2, 2);
		
		var result = vector.add (vector2);
		
		Assert.areEqual (3, result.x);
		Assert.areEqual (3, result.y);
		Assert.areEqual (3, result.z);
		
		Assert.areEqual (0, result.w); // stays default
		
	}
	
	
	@Test public function clone () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.clone;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function copyFrom () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		var vector2 = new Vector3D (2, 2, 2, 2);
		
		vector2.copyFrom (vector);
		
		Assert.areEqual (1, vector2.x);
		Assert.areEqual (1, vector2.y);
		Assert.areEqual (1, vector2.z);
		
		Assert.areEqual (2, vector2.w); // ignored
		
	}
	
	
	@Test public function crossProduct () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.crossProduct;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function decrementBy () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		var vector2 = new Vector3D (2, 2, 2, 2);
		
		vector2.decrementBy (vector);
		
		Assert.areEqual (1, vector2.x);
		Assert.areEqual (1, vector2.y);
		Assert.areEqual (1, vector2.z);
		
		Assert.areEqual (2, vector2.w); // ignored
		
	}
	
	
	@Test public function dotProduct () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.dotProduct;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function equals () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.equals;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function incrementBy () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		var vector2 = new Vector3D (2, 2, 2, 2);
		
		vector.incrementBy (vector2);
		
		Assert.areEqual (3, vector.x);
		Assert.areEqual (3, vector.y);
		Assert.areEqual (3, vector.z);
		
		Assert.areEqual (1, vector.w); // ignored
		
	}
	
	
	@Test public function nearEquals () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.nearEquals;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function negate () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		vector.negate ();
		
		Assert.areEqual (-1, vector.x);
		Assert.areEqual (-1, vector.y);
		Assert.areEqual (-1, vector.z);
		
		Assert.areEqual (1, vector.w); // ignored
		
	}
	
	
	@Test public function normalize () {
		
		var vector = new Vector3D (4, 4, 4, 4);
		
		var normalizedValue = 4 / vector.length;
		vector.normalize ();
		
		Assert.areEqual (normalizedValue, vector.x);
		Assert.areEqual (normalizedValue, vector.y);
		Assert.areEqual (normalizedValue, vector.z);
		
		Assert.areEqual (4, vector.w); // ignored
		
	}
	
	
	@Test public function project () {
		
		// TODO: Confirm functionality
		
		var vector3D = new Vector3D ();
		var exists = vector3D.project;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scaleBy () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		vector.scaleBy (4);
		
		Assert.areEqual (4, vector.x);
		Assert.areEqual (4, vector.y);
		Assert.areEqual (4, vector.z);
		
		Assert.areEqual (1, vector.w); // ignored
		
	}
	
	
	@Test public function setTo () {
		
		var vector = new Vector3D (1, 1, 1, 1);
		vector.setTo (4, 4, 4);
		
		Assert.areEqual (4, vector.x);
		Assert.areEqual (4, vector.y);
		Assert.areEqual (4, vector.z);
		Assert.areEqual (1, vector.w);
		
	}
	
	
	@Test public function subtract () {
		
		var vector = new Vector3D (5, 5, 5, 5);
		var vector2 = new Vector3D (2, 2, 2, 2);
		
		var result = vector.subtract (vector2);
		
		Assert.areEqual (3, result.x);
		Assert.areEqual (3, result.y);
		Assert.areEqual (3, result.z);
		
		Assert.areEqual (0, result.w); // ignored
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
	@Test public function angleBetween () {
		
		// TODO: Confirm functionality
		
		var exists = Vector3D.angleBetween;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function distance () {
		
		// TODO: Confirm functionality
		
		var exists = Vector3D.distance;
		
		Assert.isNotNull (exists);
		
	}
	
	
}