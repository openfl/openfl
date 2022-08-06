package;

import openfl.geom.Matrix;
import openfl.geom.Point;
import openfl.geom.Vector3D;
import utest.Assert;
import utest.Test;

class MatrixTest extends Test
{
	public function test_a()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(25.0, matrix.a);
	}

	public function test_b()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(28.0, matrix.b);
	}

	public function test_c()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(57.0, matrix.c);
	}

	public function test_d()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(64.0, matrix.d);
	}

	public function test_tx()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(100.0, matrix.tx);
	}

	public function test_ty()
	{
		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(112.0, matrix.ty);
	}

	public function test_new_()
	{
		var matrix_defualt = new Matrix();

		Assert.equals(1.0, matrix_defualt.a);
		Assert.equals(0.0, matrix_defualt.b);
		Assert.equals(0.0, matrix_defualt.c);
		Assert.equals(1.0, matrix_defualt.d);

		Assert.equals(0.0, matrix_defualt.tx);
		Assert.equals(0.0, matrix_defualt.ty);

		var matrix = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);

		Assert.equals(25.0, matrix.a);
		Assert.equals(28.0, matrix.b);
		Assert.equals(57.0, matrix.c);
		Assert.equals(64.0, matrix.d);

		Assert.equals(100.0, matrix.tx);
		Assert.equals(112.0, matrix.ty);
	}

	public function test_clone()
	{
		var source = new Matrix(25.0, 28.0, 57.0, 64.0, 100.0, 112.0);
		var source_clone = source.clone();

		Assert.equals(25.0, source.a);
		Assert.equals(28.0, source.b);
		Assert.equals(57.0, source.c);
		Assert.equals(64.0, source.d);

		Assert.equals(100.0, source.tx);
		Assert.equals(112.0, source.ty);

		Assert.equals(25.0, source_clone.a);
		Assert.equals(28.0, source_clone.b);
		Assert.equals(57.0, source_clone.c);
		Assert.equals(64.0, source_clone.d);

		Assert.equals(100.0, source_clone.tx);
		Assert.equals(112.0, source_clone.ty);

		source_clone.identity();

		Assert.equals(25.0, source.a);
		Assert.equals(28.0, source.b);
		Assert.equals(57.0, source.c);
		Assert.equals(64.0, source.d);

		Assert.equals(100.0, source.tx);
		Assert.equals(112.0, source.ty);

		Assert.equals(1.0, source_clone.a);
		Assert.equals(0.0, source_clone.b);
		Assert.equals(0.0, source_clone.c);
		Assert.equals(1.0, source_clone.d);

		Assert.equals(0.0, source_clone.tx);
		Assert.equals(0.0, source_clone.ty);
	}

	public function test_concat()
	{
		var source = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		var dest = new Matrix(7.0, 8.0, 9.0, 10.0, 11.0, 12.0);

		source.concat(dest);

		Assert.equals(25.0, source.a);
		Assert.equals(28.0, source.b);
		Assert.equals(57.0, source.c);
		Assert.equals(64.0, source.d);

		Assert.equals(100.0, source.tx);
		Assert.equals(112.0, source.ty);

		Assert.equals(7.0, dest.a);
		Assert.equals(8.0, dest.b);
		Assert.equals(9.0, dest.c);
		Assert.equals(10.0, dest.d);

		Assert.equals(11.0, dest.tx);
		Assert.equals(12.0, dest.ty);
	}

	#if flash
	@Ignored
	#end
	public function test_copyColumnFrom()
	{
		#if !flash // Flash is behaving the same as copyRowFrom?
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyColumnFrom(0, vector3D);
		Assert.equals(x, matrix.a);
		Assert.equals(y, matrix.b);

		Assert.equals(c, matrix.c);
		Assert.equals(d, matrix.d);
		Assert.equals(tx, matrix.tx);
		Assert.equals(ty, matrix.ty);
		Assert.equals(x, vector3D.x);
		Assert.equals(y, vector3D.y);
		Assert.equals(z, vector3D.z);
		Assert.equals(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyColumnFrom(1, vector3D);
		Assert.equals(x, matrix.c);
		Assert.equals(y, matrix.d);

		Assert.equals(a, matrix.a);
		Assert.equals(b, matrix.b);
		Assert.equals(tx, matrix.tx);
		Assert.equals(ty, matrix.ty);
		Assert.equals(x, vector3D.x);
		Assert.equals(y, vector3D.y);
		Assert.equals(z, vector3D.z);
		Assert.equals(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyColumnFrom(2, vector3D);
		Assert.equals(x, matrix.tx);
		Assert.equals(y, matrix.ty);

		Assert.equals(a, matrix.a);
		Assert.equals(b, matrix.b);
		Assert.equals(c, matrix.c);
		Assert.equals(d, matrix.d);
		Assert.equals(x, vector3D.x);
		Assert.equals(y, vector3D.y);
		Assert.equals(z, vector3D.z);
		Assert.equals(w, vector3D.w);
		#end
	}

	public function test_copyColumnTo()
	{
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyColumnTo(0, vector3D);
		Assert.equals(a, vector3D.x);
		Assert.equals(b, vector3D.y);
		Assert.equals(0, vector3D.z);
		Assert.equals(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyColumnTo(1, vector3D);
		Assert.equals(c, vector3D.x);
		Assert.equals(d, vector3D.y);
		Assert.equals(0, vector3D.z);
		Assert.equals(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyColumnTo(2, vector3D);
		Assert.equals(tx, vector3D.x);
		Assert.equals(ty, vector3D.y);
		Assert.equals(1, vector3D.z);
		Assert.equals(w, vector3D.w);
	}

	public function test_copyFrom()
	{
		var source = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		var dest = new Matrix(7.0, 8.0, 9.0, 10.0, 11.0, 12.0);

		source.copyFrom(dest);

		Assert.equals(7.0, source.a);
		Assert.equals(8.0, source.b);
		Assert.equals(9.0, source.c);
		Assert.equals(10.0, source.d);

		Assert.equals(11.0, source.tx);
		Assert.equals(12.0, source.ty);

		Assert.equals(7.0, dest.a);
		Assert.equals(8.0, dest.b);
		Assert.equals(9.0, dest.c);
		Assert.equals(10.0, dest.d);

		Assert.equals(11.0, dest.tx);
		Assert.equals(12.0, dest.ty);
	}

	public function test_copyRowFrom()
	{
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyRowFrom(0, vector3D);
		Assert.equals(x, matrix.a);
		Assert.equals(y, matrix.c);
		Assert.equals(z, matrix.tx);

		Assert.equals(b, matrix.b);
		Assert.equals(d, matrix.d);
		Assert.equals(ty, matrix.ty);
		Assert.equals(x, vector3D.x);
		Assert.equals(y, vector3D.y);
		Assert.equals(z, vector3D.z);
		Assert.equals(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyRowFrom(1, vector3D);
		Assert.equals(x, matrix.b);
		Assert.equals(y, matrix.d);
		Assert.equals(z, matrix.ty);

		Assert.equals(a, matrix.a);
		Assert.equals(c, matrix.c);
		Assert.equals(tx, matrix.tx);
		Assert.equals(x, vector3D.x);
		Assert.equals(y, vector3D.y);
		Assert.equals(z, vector3D.z);
		Assert.equals(w, vector3D.w);

		matrix.setTo(a, b, c, d, tx, ty);

		matrix.copyRowFrom(2, vector3D);

		Assert.equals(a, matrix.a);
		Assert.equals(b, matrix.b);
		Assert.equals(c, matrix.c);
		Assert.equals(d, matrix.d);
		Assert.equals(tx, matrix.tx);
		Assert.equals(ty, matrix.ty);
		Assert.equals(x, vector3D.x);
		Assert.equals(y, vector3D.y);
		Assert.equals(z, vector3D.z);
		Assert.equals(w, vector3D.w);
	}

	public function test_copyRowTo()
	{
		var a = 1, b = 2, c = 3, d = 4, tx = 5, ty = 6;
		var x = 10, y = 11, z = 12, w = 13;

		var matrix = new Matrix(a, b, c, d, tx, ty);
		var vector3D = new Vector3D(x, y, z, w);

		matrix.copyRowTo(0, vector3D);
		Assert.equals(a, vector3D.x);
		Assert.equals(c, vector3D.y);
		Assert.equals(tx, vector3D.z);
		Assert.equals(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyRowTo(1, vector3D);
		Assert.equals(b, vector3D.x);
		Assert.equals(d, vector3D.y);
		Assert.equals(ty, vector3D.z);
		Assert.equals(w, vector3D.w);

		vector3D.setTo(x, y, z);
		vector3D.w = w;

		matrix.copyRowTo(2, vector3D);
		Assert.equals(0, vector3D.x);
		Assert.equals(0, vector3D.y);
		Assert.equals(1, vector3D.z);
		Assert.equals(w, vector3D.w);
	}

	public function test_createBox()
	{
		var scaleX = 0.4, scaleY = 1.0, rotation = 30.0, tx = 11.1, ty = 11.12;

		var matrix = new Matrix();
		matrix.rotate(rotation);
		matrix.scale(scaleX, scaleY);
		matrix.translate(tx, ty);

		var matrix2 = new Matrix();
		matrix2.createBox(scaleX, scaleY, rotation, tx, ty);

		Assert.equals(matrix.a, matrix2.a);
		Assert.equals(matrix.b, matrix2.b);
		Assert.equals(matrix.c, matrix2.c);
		Assert.equals(matrix.d, matrix2.d);
		Assert.equals(matrix.tx, matrix2.tx);
		Assert.equals(matrix.ty, matrix2.ty);

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

		Assert.equals(matrix.a, matrix2.a);
		Assert.equals(matrix.b, matrix2.b);
		Assert.equals(matrix.c, matrix2.c);
		Assert.equals(matrix.d, matrix2.d);
		Assert.equals(matrix.tx, matrix2.tx);
		Assert.equals(matrix.ty, matrix2.ty);
	}

	public function test_createGradientBox()
	{
		// TODO: Confirm functionality

		var matrix = new Matrix();
		var exists = matrix.createGradientBox;

		Assert.notNull(exists);
	}

	public function test_deltaTransformPoint()
	{
		var matrix = new Matrix();
		matrix.a = 1.0;
		matrix.b = 2.0;
		matrix.c = 3.0;
		matrix.d = 4.0;

		var point = new Point(5.0, 6.0);

		var result = matrix.deltaTransformPoint(point);

		Assert.equals(23.0, result.x);
		Assert.equals(34.0, result.y);
	}

	public function test_identity()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.identity();

		Assert.equals(1.0, matrix.a);
		Assert.equals(0.0, matrix.b);
		Assert.equals(0.0, matrix.c);
		Assert.equals(1.0, matrix.d);

		Assert.equals(0.0, matrix.tx);
		Assert.equals(0.0, matrix.ty);
	}

	public function test_invert()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.invert();

		Assert.equals(-2, Math.round(matrix.a * 10000.0) / 10000.0);
		Assert.equals(1, Math.round(matrix.b * 10000.0) / 10000.0);
		Assert.equals(1.5, Math.round(matrix.c * 10000.0) / 10000.0);
		Assert.equals(-0.5, Math.round(matrix.d * 10000.0) / 10000.0);

		Assert.equals(1, Math.round(matrix.tx));
		Assert.equals(-2, Math.round(matrix.ty));
	}

	public function test_rotate()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.rotate(0.5 * Math.PI);

		Assert.equals(-2.0, Math.round(matrix.a));
		Assert.equals(1.0, Math.round(matrix.b));
		Assert.equals(-4.0, Math.round(matrix.c));
		Assert.equals(3.0, Math.round(matrix.d));

		Assert.equals(-6.0, Math.round(matrix.tx));
		Assert.equals(5.0, Math.round(matrix.ty));
	}

	public function test_scale()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.scale(2.5, 3.0);

		Assert.equals(2.5, matrix.a);
		Assert.equals(6.0, matrix.b);
		Assert.equals(7.5, matrix.c);
		Assert.equals(12.0, matrix.d);

		Assert.equals(12.5, matrix.tx);
		Assert.equals(18.0, matrix.ty);
	}

	public function test_setTo()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.setTo(7.0, 8.0, 9.0, 10.0, 11.0, 12.0);

		Assert.equals(7.0, matrix.a);
		Assert.equals(8.0, matrix.b);
		Assert.equals(9.0, matrix.c);
		Assert.equals(10.0, matrix.d);

		Assert.equals(11.0, matrix.tx);
		Assert.equals(12.0, matrix.ty);
	}

	public function test_transformPoint()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);

		var result = matrix.transformPoint(new Point(10.0, 50.0));

		Assert.equals(165.0, result.x);
		Assert.equals(226.0, result.y);
	}

	public function test_translate()
	{
		var matrix = new Matrix(1.0, 2.0, 3.0, 4.0, 5.0, 6.0);
		matrix.translate(10.0, 50.0);

		Assert.equals(1.0, matrix.a);
		Assert.equals(2.0, matrix.b);
		Assert.equals(3.0, matrix.c);
		Assert.equals(4.0, matrix.d);

		Assert.equals(15.0, matrix.tx);
		Assert.equals(56.0, matrix.ty);
	}
}
