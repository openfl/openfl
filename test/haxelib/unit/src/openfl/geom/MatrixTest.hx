package openfl.geom;

class MatrixTest
{
	@Test public function a()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(25.0, matrix.a);
	}

	@Test public function b()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(28.0, matrix.b);
	}

	@Test public function c()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(57.0, matrix.c);
	}

	@Test public function d()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(64.0, matrix.d);
	}

	@Test public function tx()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(100.0, matrix.tx);
	}

	@Test public function ty()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(112.0, matrix.ty);
	}

	@Test public function new_()
	{
		var matrix_defualt = new Matrix();

		Assert.areEqual(1.0, matrix_defualt.a);
		Assert.areEqual(0.0, matrix_defualt.b);
		Assert.areEqual(0.0, matrix_defualt.c);
		Assert.areEqual(1.0, matrix_defualt.d);

		Assert.areEqual(0.0, matrix_defualt.tx);
		Assert.areEqual(0.0, matrix_defualt.ty);

		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.areEqual(25.0, matrix.a);
		Assert.areEqual(28.0, matrix.b);
		Assert.areEqual(57.0, matrix.c);
		Assert.areEqual(64.0, matrix.d);

		Assert.areEqual(100.0, matrix.tx);
		Assert.areEqual(112.0, matrix.ty);
	}

	@Test public function clone()
	{
		var source = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);
		var source_clone = source.clone();

		Assert.areEqual(25.0, source.a);
		Assert.areEqual(28.0, source.b);
		Assert.areEqual(57.0, source.c);
		Assert.areEqual(64.0, source.d);

		Assert.areEqual(100.0, source.tx);
		Assert.areEqual(112.0, source.ty);

		Assert.areEqual(25.0, source_clone.a);
		Assert.areEqual(28.0, source_clone.b);
		Assert.areEqual(57.0, source_clone.c);
		Assert.areEqual(64.0, source_clone.d);

		Assert.areEqual(100.0, source_clone.tx);
		Assert.areEqual(112.0, source_clone.ty);

		source_clone.identity();

		Assert.areEqual(25.0, source.a);
		Assert.areEqual(28.0, source.b);
		Assert.areEqual(57.0, source.c);
		Assert.areEqual(64.0, source.d);

		Assert.areEqual(100.0, source.tx);
		Assert.areEqual(112.0, source.ty);

		Assert.areEqual(1.0, source_clone.a);
		Assert.areEqual(0.0, source_clone.b);
		Assert.areEqual(0.0, source_clone.c);
		Assert.areEqual(1.0, source_clone.d);

		Assert.areEqual(0.0, source_clone.tx);
		Assert.areEqual(0.0, source_clone.ty);
	}

	@Test public function concat()
	{
		var source = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		var dest = new Matrix(7.0, 8.0, 9.0, 10.0, 11.0, 12.0);

		source.concat(dest);

		Assert.areEqual(25.0, source.a);
		Assert.areEqual(28.0, source.b);
		Assert.areEqual(57.0, source.c);
		Assert.areEqual(64.0, source.d);

		Assert.areEqual(100.0, source.tx);
		Assert.areEqual(112.0, source.ty);

		Assert.areEqual(7.0, dest.a);
		Assert.areEqual(8.0, dest.b);
		Assert.areEqual(9.0, dest.c);
		Assert.areEqual(10.0, dest.d);

		Assert.areEqual(11.0, dest.tx);
		Assert.areEqual(12.0, dest.ty);
	}

	@Test public function copyColumnFrom()
	{
		#if !flash // Flash is behaving the same as copyRowFrom?
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyColumnFrom(0, vector3D);
		Assert.areEqual(x, matrix.a);
		Assert.areEqual(y, matrix.b);

		Assert.areEqual(c, matrix.c);
		Assert.areEqual(d, matrix.d);
		Assert.areEqual(tx, matrix.tx);
		Assert.areEqual(ty, matrix.ty);
		Assert.areEqual(x, vector3D.x);
		Assert.areEqual(y, vector3D.y);
		Assert.areEqual(z, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyColumnFrom(1, vector3D);
		Assert.areEqual(x, matrix.c);
		Assert.areEqual(y, matrix.d);

		Assert.areEqual(a, matrix.a);
		Assert.areEqual(b, matrix.b);
		Assert.areEqual(tx, matrix.tx);
		Assert.areEqual(ty, matrix.ty);
		Assert.areEqual(x, vector3D.x);
		Assert.areEqual(y, vector3D.y);
		Assert.areEqual(z, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyColumnFrom(2, vector3D);
		Assert.areEqual(x, matrix.tx);
		Assert.areEqual(y, matrix.ty);

		Assert.areEqual(a, matrix.a);
		Assert.areEqual(b, matrix.b);
		Assert.areEqual(c, matrix.c);
		Assert.areEqual(d, matrix.d);
		Assert.areEqual(x, vector3D.x);
		Assert.areEqual(y, vector3D.y);
		Assert.areEqual(z, vector3D.z);
		Assert.areEqual(w, vector3D.w);
		#end
	}

	@Test public function copyColumnTo()
	{
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyColumnTo(0, vector3D);
		Assert.areEqual(a, vector3D.x);
		Assert.areEqual(b, vector3D.y);
		Assert.areEqual(0, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyColumnTo(1, vector3D);
		Assert.areEqual(c, vector3D.x);
		Assert.areEqual(d, vector3D.y);
		Assert.areEqual(0, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyColumnTo(2, vector3D);
		Assert.areEqual(tx, vector3D.x);
		Assert.areEqual(ty, vector3D.y);
		Assert.areEqual(1, vector3D.z);
		Assert.areEqual(w, vector3D.w);
	}

	@Test public function copyFrom()
	{
		var source = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		var dest = new Matrix(7.0, 8.0, 9.0, 10.0, 11.0, 12.0);

		source.copyFrom(dest);

		Assert.areEqual(7.0, source.a);
		Assert.areEqual(8.0, source.b);
		Assert.areEqual(9.0, source.c);
		Assert.areEqual(10.0, source.d);

		Assert.areEqual(11.0, source.tx);
		Assert.areEqual(12.0, source.ty);

		Assert.areEqual(7.0, dest.a);
		Assert.areEqual(8.0, dest.b);
		Assert.areEqual(9.0, dest.c);
		Assert.areEqual(10.0, dest.d);

		Assert.areEqual(11.0, dest.tx);
		Assert.areEqual(12.0, dest.ty);
	}

	@Test public function copyRowFrom()
	{
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyRowFrom(0, vector3D);
		Assert.areEqual(x, matrix.a);
		Assert.areEqual(y, matrix.c);
		Assert.areEqual(z, matrix.tx);

		Assert.areEqual(b, matrix.b);
		Assert.areEqual(d, matrix.d);
		Assert.areEqual(ty, matrix.ty);
		Assert.areEqual(x, vector3D.x);
		Assert.areEqual(y, vector3D.y);
		Assert.areEqual(z, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyRowFrom(1, vector3D);
		Assert.areEqual(x, matrix.b);
		Assert.areEqual(y, matrix.d);
		Assert.areEqual(z, matrix.ty);

		Assert.areEqual(a, matrix.a);
		Assert.areEqual(c, matrix.c);
		Assert.areEqual(tx, matrix.tx);
		Assert.areEqual(x, vector3D.x);
		Assert.areEqual(y, vector3D.y);
		Assert.areEqual(z, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyRowFrom(2, vector3D);

		Assert.areEqual(a, matrix.a);
		Assert.areEqual(b, matrix.b);
		Assert.areEqual(c, matrix.c);
		Assert.areEqual(d, matrix.d);
		Assert.areEqual(tx, matrix.tx);
		Assert.areEqual(ty, matrix.ty);
		Assert.areEqual(x, vector3D.x);
		Assert.areEqual(y, vector3D.y);
		Assert.areEqual(z, vector3D.z);
		Assert.areEqual(w, vector3D.w);
	}

	@Test public function copyRowTo()
	{
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyRowTo(0, vector3D);
		Assert.areEqual(a, vector3D.x);
		Assert.areEqual(c, vector3D.y);
		Assert.areEqual(tx, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyRowTo(1, vector3D);
		Assert.areEqual(b, vector3D.x);
		Assert.areEqual(d, vector3D.y);
		Assert.areEqual(ty, vector3D.z);
		Assert.areEqual(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyRowTo(2, vector3D);
		Assert.areEqual(0, vector3D.x);
		Assert.areEqual(0, vector3D.y);
		Assert.areEqual(1, vector3D.z);
		Assert.areEqual(w, vector3D.w);
	}

	@Test public function createBox()
	{
		var scaleX = 0.4, scaleY = 1.0, rotation = 30.0, tx = 11.1, ty = 11.12;

		var matrix = new Matrix();
		matrix.rotate(rotation);
		matrix.scale(scaleX, scaleY);
		matrix.translate(tx, ty);

		var matrix2 = new Matrix();
		matrix2.createBox(scaleX, scaleY, rotation, tx, ty);

		Assert.areEqual(matrix.a, matrix2.a);
		Assert.areEqual(matrix.b, matrix2.b);
		Assert.areEqual(matrix.c, matrix2.c);
		Assert.areEqual(matrix.d, matrix2.d);
		Assert.areEqual(matrix.tx, matrix2.tx);
		Assert.areEqual(matrix.ty, matrix2.ty);

		scaleX = 0;
		scaleY = 11;
		rotation = 0;
		tx = 0;
		ty = 11;

		matrix.identity();
		matrix.rotate(rotation);
		matrix.scale(scaleX, scaleY);
		matrix.translate(tx, ty);

		matrix2 = new Matrix();
		matrix2.createBox(scaleX, scaleY, rotation, tx, ty);

		Assert.areEqual(matrix.a, matrix2.a);
		Assert.areEqual(matrix.b, matrix2.b);
		Assert.areEqual(matrix.c, matrix2.c);
		Assert.areEqual(matrix.d, matrix2.d);
		Assert.areEqual(matrix.tx, matrix2.tx);
		Assert.areEqual(matrix.ty, matrix2.ty);
	}

	@Test public function createGradientBox()
	{
		// TODO: Confirm functionality

		var matrix = new Matrix();
		var exists = matrix.createGradientBox;

		Assert.isNotNull(exists);
	}

	@Test public function deltaTransformPoint()
	{
		var matrix = new Matrix();
		matrix.a = 1.0;
		matrix.b = 2.0;
		matrix.c = 3.0;
		matrix.d = 4.0;

		var point = new Point(5.0, 6.0);

		var result = matrix.deltaTransformPoint(point);

		Assert.areEqual(23.0, result.x);
		Assert.areEqual(34.0, result.y);
	}

	@Test public function identity()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.identity();

		Assert.areEqual(1.0, matrix.a);
		Assert.areEqual(0.0, matrix.b);
		Assert.areEqual(0.0, matrix.c);
		Assert.areEqual(1.0, matrix.d);

		Assert.areEqual(0.0, matrix.tx);
		Assert.areEqual(0.0, matrix.ty);
	}

	@Test public function invert()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.invert();

		Assert.areEqual(-2, Math.round(matrix.a * 10000.0) / 10000.0);
		Assert.areEqual(1, Math.round(matrix.b * 10000.0) / 10000.0);
		Assert.areEqual(1.5, Math.round(matrix.c * 10000.0) / 10000.0);
		Assert.areEqual(-0.5, Math.round(matrix.d * 10000.0) / 10000.0);

		Assert.areEqual(1, Math.round(matrix.tx));
		Assert.areEqual(-2, Math.round(matrix.ty));
	}

	@Test public function rotate()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.rotate(0.5 * Math.PI);

		Assert.areEqual(-2.0, Math.round(matrix.a));
		Assert.areEqual(1.0, Math.round(matrix.b));
		Assert.areEqual(-4.0, Math.round(matrix.c));
		Assert.areEqual(3.0, Math.round(matrix.d));

		Assert.areEqual(-6.0, Math.round(matrix.tx));
		Assert.areEqual(5.0, Math.round(matrix.ty));
	}

	@Test public function scale()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.scale(2.5, 3.0);

		Assert.areEqual(2.5, matrix.a);
		Assert.areEqual(6.0, matrix.b);
		Assert.areEqual(7.5, matrix.c);
		Assert.areEqual(12.0, matrix.d);

		Assert.areEqual(12.5, matrix.tx);
		Assert.areEqual(18.0, matrix.ty);
	}

	@Test public function setTo()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.setTo(7.0, 8.0, 9.0, 10.0, 11.0, 12.0);

		Assert.areEqual(7.0, matrix.a);
		Assert.areEqual(8.0, matrix.b);
		Assert.areEqual(9.0, matrix.c);
		Assert.areEqual(10.0, matrix.d);

		Assert.areEqual(11.0, matrix.tx);
		Assert.areEqual(12.0, matrix.ty);
	}

	@Test public function transformPoint()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);

		var result = matrix.transformPoint(new Point(10.0, 50.0));

		Assert.areEqual(165.0, result.x);
		Assert.areEqual(226.0, result.y);
	}

	@Test public function translate()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.translate(10.0, 50.0);

		Assert.areEqual(1.0, matrix.a);
		Assert.areEqual(2.0, matrix.b);
		Assert.areEqual(3.0, matrix.c);
		Assert.areEqual(4.0, matrix.d);

		Assert.areEqual(15.0, matrix.tx);
		Assert.areEqual(56.0, matrix.ty);
	}
}
