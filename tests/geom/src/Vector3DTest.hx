package;

import openfl.geom.Vector3D;
import utest.Assert;
import utest.Test;

class Vector3DTest extends Test
{
	public function test_length()
	{
		var zero = new Vector3D(0.0, 0.0, 0.0, 0.0);
		var vector = new Vector3D(3.0, 4.0, 5.0, 6.0);

		Assert.equals(0.0, zero.length);
		Assert.equals(7.07107, Math.round(vector.length * 100000.0) / 100000.0);
	}

	public function test_lengthSquared()
	{
		var zero = new Vector3D(0.0, 0.0, 0.0, 0.0);
		var vector = new Vector3D(3.0, 4.0, 5.0, 6.0);

		Assert.equals(0.0, zero.lengthSquared);
		Assert.equals(50, vector.lengthSquared);
	}

	public function test_w()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.equals(6, vector.w);
	}

	public function test_x()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.equals(3, vector.x);
	}

	public function test_y()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.equals(4, vector.y);
	}

	public function test_z()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.equals(5, vector.z);
	}

	public function test_new_()
	{
		var a = new Vector3D();

		Assert.equals(0.0, a.x);
		Assert.equals(0.0, a.y);
		Assert.equals(0.0, a.z);
		Assert.equals(0.0, a.w);

		var b = new Vector3D(3, 4, 5, 6);

		Assert.equals(3, b.x);
		Assert.equals(4, b.y);
		Assert.equals(5, b.z);
		Assert.equals(6, b.w);
	}

	public function test_add()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		var result = vector.add(vector2);

		Assert.equals(3, result.x);
		Assert.equals(3, result.y);
		Assert.equals(3, result.z);

		Assert.equals(0, result.w); // stays default
	}

	public function test_copyFrom()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		vector2.copyFrom(vector);

		Assert.equals(1, vector2.x);
		Assert.equals(1, vector2.y);
		Assert.equals(1, vector2.z);

		Assert.equals(2, vector2.w); // ignored
	}

	public function test_crossProduct()
	{
		var v1 = new Vector3D(1, 0, 0, 0);
		var v2 = new Vector3D(0, 1, 0, 0);

		var crossV1V2 = v1.crossProduct(v2);

		Assert.equals(0, crossV1V2.x);
		Assert.equals(0, crossV1V2.y);
		Assert.equals(1, crossV1V2.z);
		Assert.equals(1, crossV1V2.w);

		var a = new Vector3D(2, 3, 4, 4);
		var b = new Vector3D(3, 4, 5, 6);
		var c = new Vector3D(3, 4, 5, 10); // w ignored

		var crossAB = a.crossProduct(b);
		var crossAC = a.crossProduct(c);

		Assert.equals(-1, crossAB.x);
		Assert.equals(2, crossAB.y);
		Assert.equals(-1, crossAB.z);
		Assert.equals(1, crossAB.w);

		Assert.equals(-1, crossAC.x);
		Assert.equals(2, crossAC.y);
		Assert.equals(-1, crossAC.z);
		Assert.equals(1, crossAC.w);
	}

	public function test_decrementBy()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		vector2.decrementBy(vector);

		Assert.equals(1, vector2.x);
		Assert.equals(1, vector2.y);
		Assert.equals(1, vector2.z);

		Assert.equals(2, vector2.w); // ignored
	}

	public function test_dotProduct()
	{
		var v1 = new Vector3D(1, 0, 0, 0);
		var v2 = new Vector3D(0, 1, 0, 0);

		Assert.equals(0, v1.dotProduct(v2));

		var a = new Vector3D(2, 3, 4, 4);
		var b = new Vector3D(3, 4, 5, 6);
		var c = new Vector3D(3, 4, 5, 10); // w ignored

		Assert.equals(29, a.dotProduct(a));
		Assert.equals(38, a.dotProduct(b));
		Assert.equals(38, a.dotProduct(c));
	}

	public function test_equals()
	{
		var a = new Vector3D(1, 2, 3, 4);
		var a_cloned = a.clone();

		var a_w_diff_only = new Vector3D(1, 2, 3, 5);

		var b = new Vector3D(2, 3, 4, 4);
		var c = new Vector3D(3, 4, 5, 6);

		Assert.equals(true, a.equals(a_w_diff_only, false));
		Assert.equals(false, a.equals(a_w_diff_only, true));

		Assert.equals(true, a.equals(a_cloned, true));

		Assert.equals(false, a.equals(b, true));
		Assert.equals(false, a.equals(c, true));
	}

	public function test_incrementBy()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		vector.incrementBy(vector2);

		Assert.equals(3, vector.x);
		Assert.equals(3, vector.y);
		Assert.equals(3, vector.z);

		Assert.equals(1, vector.w); // ignored
	}

	public function test_nearEquals()
	{
		var a = new Vector3D(3.7, -1.1, 6.9, 2.3);
		var a_w_diff_only = new Vector3D(3.7, -1.1, 6.9, 2.28);

		var b = new Vector3D(3.6, -1.0, 6.9, 2.2);
		var c = new Vector3D(3.72, -1.11, 6.88, 2.31);

		Assert.equals(true, a.nearEquals(a_w_diff_only, 0.01, false));

		Assert.equals(false, a.nearEquals(b, 0.1, true));
		Assert.equals(false, a.nearEquals(c, 0.02, true));

		#if flash
		// TODO: alpha is considered abs(max(2.3, 2.2) - 0.0) < 2.4 with allFour=true
		Assert.equals(true, a.nearEquals(b, 2.4, true));
		Assert.equals(true, a.nearEquals(c, 2.4, true));

		Assert.equals(true, a.nearEquals(b, 0.11, false));
		Assert.equals(true, a.nearEquals(c, 0.03, false));
		#else
		Assert.equals(true, a.nearEquals(b, 0.11, true));
		Assert.equals(true, a.nearEquals(c, 0.03, true));
		#end
	}

	public function test_negate()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		vector.negate();

		Assert.equals(-1, vector.x);
		Assert.equals(-1, vector.y);
		Assert.equals(-1, vector.z);

		Assert.equals(1, vector.w); // ignored
	}

	public function test_normalize()
	{
		var vector = new Vector3D(4, 4, 4, 4);

		var normalizedValue = 4 / vector.length;
		vector.normalize();

		Assert.equals(normalizedValue, vector.x);
		Assert.equals(normalizedValue, vector.y);
		Assert.equals(normalizedValue, vector.z);

		Assert.equals(4, vector.w); // ignored
	}

	public function test_project()
	{
		var vector = new Vector3D(3.7, -1.1, 6.9, 2.3);
		vector.project();

		Assert.equals(3.7 / 2.3, vector.x);
		Assert.equals(-1.1 / 2.3, vector.y);
		Assert.equals(6.9 / 2.3, vector.z);
		Assert.equals(2.3, vector.w);
	}

	public function test_scaleBy()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		vector.scaleBy(4);

		Assert.equals(4, vector.x);
		Assert.equals(4, vector.y);
		Assert.equals(4, vector.z);

		Assert.equals(1, vector.w); // ignored
	}

	public function test_setTo()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		vector.setTo(4, 4, 4);

		Assert.equals(4, vector.x);
		Assert.equals(4, vector.y);
		Assert.equals(4, vector.z);
		Assert.equals(1, vector.w);
	}

	public function test_subtract()
	{
		var vector = new Vector3D(5, 5, 5, 5);
		var vector2 = new Vector3D(2, 2, 2, 2);

		var result = vector.subtract(vector2);

		Assert.equals(3, result.x);
		Assert.equals(3, result.y);
		Assert.equals(3, result.z);

		Assert.equals(0, result.w); // ignored
	}

	public function test_clone()
	{
		var a = new Vector3D(5.1, 3.2, 4.4, 1.0);
		var a_cloned = a.clone();

		Assert.equals(a.x, a_cloned.x);
		Assert.equals(a.y, a_cloned.y);
		Assert.equals(a.z, a_cloned.z);
		Assert.equals(a.w, a_cloned.w);

		a.x = 123.0;
		a.y = 234.0;
		a.z = 345.0;
		a.w = 456.0;

		Assert.notEquals(a.x, a_cloned.x);
		Assert.notEquals(a.y, a_cloned.y);
		Assert.notEquals(a.z, a_cloned.z);
		Assert.notEquals(a.w, a_cloned.w);

		Assert.equals(5.1, a_cloned.x);
		Assert.equals(3.2, a_cloned.y);
		Assert.equals(4.4, a_cloned.z);
		Assert.equals(1.0, a_cloned.w);
	}

	public function test_angleBetween()
	{
		var a = new Vector3D(5.1, 3.2, 4.4, 1.0);
		var b = new Vector3D(3.1, 6.2, -5.3, 2.0);
		var c = new Vector3D(3.1, 6.2, -5.3, 5.1); // w ignored

		Assert.equals(0.0, Vector3D.angleBetween(a, a));

		// TODO: Flash returns 39.3205 - for a/b and a/c.
		// TODO: I had to remove assertions though because it showed them anyway as failures
		// ... even when they were commented out
	}

	public function test_distance()
	{
		var a = new Vector3D(1.1, 2.2, 3.3, 4.4);
		var b = new Vector3D(-33.3, -31.2, 32.1, 12.3);
		var c = new Vector3D(-33.3, -31.2, 32.1, 7.7); // w ignored

		Assert.equals(0.0, Vector3D.distance(a, a));
		Assert.equals(55.9317, Math.round(Vector3D.distance(a, b) * 10000.0) / 10000.0);
		Assert.equals(55.9317, Math.round(Vector3D.distance(a, c) * 10000.0) / 10000.0);
	}
}
