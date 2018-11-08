package openfl.geom;


import massive.munit.Assert;


class MatrixTest {
	
	
	@Test public function a () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.a;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function b () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.b;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function c () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.c;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function d () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.d;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function tx () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.tx;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function ty () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.ty;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		Assert.isNotNull (matrix);
		
	}
	
	
	@Test public function clone () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.clone;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function concat () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.concat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function copyColumnFrom () {
		
		#if !flash // Flash is behaving the same as copyRowFrom?
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;
		
		var matrix = new Matrix (a, b, c, d, tx, ty);
		var vector3D = new Vector3D (x, y, z, w);
		
		matrix.copyColumnFrom (0, vector3D);
		Assert.areEqual (x, matrix.a);
		Assert.areEqual (y, matrix.b);
		
		Assert.areEqual (c, matrix.c);
		Assert.areEqual (d, matrix.d);
		Assert.areEqual (tx, matrix.tx);
		Assert.areEqual (ty, matrix.ty);
		Assert.areEqual (x, vector3D.x);
		Assert.areEqual (y, vector3D.y);
		Assert.areEqual (z, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		matrix.setTo (a, b, c, d, tx, ty);
		
		matrix.copyColumnFrom (1, vector3D);
		Assert.areEqual (x, matrix.c);
		Assert.areEqual (y, matrix.d);
		
		Assert.areEqual (a, matrix.a);
		Assert.areEqual (b, matrix.b);
		Assert.areEqual (tx, matrix.tx);
		Assert.areEqual (ty, matrix.ty);
		Assert.areEqual (x, vector3D.x);
		Assert.areEqual (y, vector3D.y);
		Assert.areEqual (z, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		matrix.setTo (a, b, c, d, tx, ty);
		
		matrix.copyColumnFrom (2, vector3D);
		Assert.areEqual (x, matrix.tx);
		Assert.areEqual (y, matrix.ty);
		
		Assert.areEqual (a, matrix.a);
		Assert.areEqual (b, matrix.b);
		Assert.areEqual (c, matrix.c);
		Assert.areEqual (d, matrix.d);
		Assert.areEqual (x, vector3D.x);
		Assert.areEqual (y, vector3D.y);
		Assert.areEqual (z, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		#end
		
	}
	
	
	@Test public function copyColumnTo () {
		
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;
		
		var matrix = new Matrix (a, b, c, d, tx, ty);
		var vector3D = new Vector3D (x, y, z, w);
		
		matrix.copyColumnTo (0, vector3D);
		Assert.areEqual (a, vector3D.x);
		Assert.areEqual (b, vector3D.y);
		Assert.areEqual (0, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		vector3D.setTo (x, y, z);
		vector3D.w = w;
		
		matrix.copyColumnTo (1, vector3D);
		Assert.areEqual (c, vector3D.x);
		Assert.areEqual (d, vector3D.y);
		Assert.areEqual (0, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		vector3D.setTo (x, y, z);
		vector3D.w = w;
		
		matrix.copyColumnTo (2, vector3D);
		Assert.areEqual (tx, vector3D.x);
		Assert.areEqual (ty, vector3D.y);
		Assert.areEqual (1, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
	}
	
	
	@Test public function copyFrom () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.copyFrom;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function copyRowFrom () {
		
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;
		
		var matrix = new Matrix (a, b, c, d, tx, ty);
		var vector3D = new Vector3D (x, y, z, w);
		
		matrix.copyRowFrom (0, vector3D);
		Assert.areEqual (x, matrix.a);
		Assert.areEqual (y, matrix.c);
		Assert.areEqual (z, matrix.tx);
		
		Assert.areEqual (b, matrix.b);
		Assert.areEqual (d, matrix.d);
		Assert.areEqual (ty, matrix.ty);
		Assert.areEqual (x, vector3D.x);
		Assert.areEqual (y, vector3D.y);
		Assert.areEqual (z, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		matrix.setTo (a, b, c, d, tx, ty);
		
		matrix.copyRowFrom (1, vector3D);
		Assert.areEqual (x, matrix.b);
		Assert.areEqual (y, matrix.d);
		Assert.areEqual (z, matrix.ty);
		
		Assert.areEqual (a, matrix.a);
		Assert.areEqual (c, matrix.c);
		Assert.areEqual (tx, matrix.tx);
		Assert.areEqual (x, vector3D.x);
		Assert.areEqual (y, vector3D.y);
		Assert.areEqual (z, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		matrix.setTo (a, b, c, d, tx, ty);
		
		matrix.copyRowFrom (2, vector3D);
		
		Assert.areEqual (a, matrix.a);
		Assert.areEqual (b, matrix.b);
		Assert.areEqual (c, matrix.c);
		Assert.areEqual (d, matrix.d);
		Assert.areEqual (tx, matrix.tx);
		Assert.areEqual (ty, matrix.ty);
		Assert.areEqual (x, vector3D.x);
		Assert.areEqual (y, vector3D.y);
		Assert.areEqual (z, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
	}
	
	
	@Test public function copyRowTo () {
		
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;
		
		var matrix = new Matrix (a, b, c, d, tx, ty);
		var vector3D = new Vector3D (x, y, z, w);
		
		matrix.copyRowTo (0, vector3D);
		Assert.areEqual (a, vector3D.x);
		Assert.areEqual (c, vector3D.y);
		Assert.areEqual (tx, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		vector3D.setTo (x, y, z);
		vector3D.w = w;
		
		matrix.copyRowTo (1, vector3D);
		Assert.areEqual (b, vector3D.x);
		Assert.areEqual (d, vector3D.y);
		Assert.areEqual (ty, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
		vector3D.setTo (x, y, z);
		vector3D.w = w;
		
		matrix.copyRowTo (2, vector3D);
		Assert.areEqual (0, vector3D.x);
		Assert.areEqual (0, vector3D.y);
		Assert.areEqual (1, vector3D.z);
		Assert.areEqual (w, vector3D.w);
		
	}
	
	
	@Test public function createBox () {
		
		var scaleX = 0.4, scaleY = 1.0, rotation = 30.0, tx = 11.1, ty = 11.12;
		
		var matrix = new Matrix ();
		matrix.rotate (rotation);
		matrix.scale (scaleX, scaleY);
		matrix.translate (tx, ty);
		
		var matrix2 = new Matrix ();
		matrix2.createBox (scaleX, scaleY, rotation, tx, ty);
		
		Assert.areEqual (matrix.a, matrix2.a);
		Assert.areEqual (matrix.b, matrix2.b);
		Assert.areEqual (matrix.c, matrix2.c);
		Assert.areEqual (matrix.d, matrix2.d);
		Assert.areEqual (matrix.tx, matrix2.tx);
		Assert.areEqual (matrix.ty, matrix2.ty);
		
		scaleX = 0; scaleY = 11; rotation = 0; tx = 0; ty = 11;
		
		matrix.identity ();
		matrix.rotate (rotation);
		matrix.scale (scaleX, scaleY);
		matrix.translate (tx, ty);
		
		matrix2 = new Matrix ();
		matrix2.createBox (scaleX, scaleY, rotation, tx, ty);
		
		Assert.areEqual (matrix.a, matrix2.a);
		Assert.areEqual (matrix.b, matrix2.b);
		Assert.areEqual (matrix.c, matrix2.c);
		Assert.areEqual (matrix.d, matrix2.d);
		Assert.areEqual (matrix.tx, matrix2.tx);
		Assert.areEqual (matrix.ty, matrix2.ty);
		
	}
	
	
	@Test public function createGradientBox () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.createGradientBox;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function deltaTransformPoint () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.deltaTransformPoint;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function identity () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.identity;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function invert () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.invert;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function rotate () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.rotate;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scale () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.scale;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setTo () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		#if !neko
		var exists = matrix.setTo;
		
		Assert.isNotNull (exists);
		#end
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
	@Test public function transformPoint () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.transformPoint;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function translate () {
		
		// TODO: Confirm functionality
		
		var matrix = new Matrix ();
		var exists = matrix.translate;
		
		Assert.isNotNull (exists);
		
	}
	
	
}