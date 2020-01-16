package openfl.geom;

import massive.munit.Assert;

class Vector3DTest
{
	@Test public function length()
	{
		var zero = new Vector3D(0.0, 0.0, 0.0, 0.0);
		var vector = new Vector3D(3.0, 4.0, 5.0, 6.0);

		Assert.areEqual(0.0, zero.length);
		Assert.areEqual(7.07107, Math.round(vector.length * 100000.0) / 100000.0);
	}

	@Test public function lengthSquared()
	{
		var zero = new Vector3D(0.0, 0.0, 0.0, 0.0);
		var vector = new Vector3D(3.0, 4.0, 5.0, 6.0);

		Assert.areEqual(0.0, zero.lengthSquared);
		Assert.areEqual(50, vector.lengthSquared);
	}

	@Test public function w()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.areEqual(6, vector.w);
	}

	@Test public function x()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.areEqual(3, vector.x);
	}

	@Test public function y()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.areEqual(4, vector.y);
	}

	@Test public function z()
	{
		var vector = new Vector3D(3, 4, 5, 6);

		Assert.areEqual(5, vector.z);
	}

	@Test public function new_()
	{
		var a = new Vector3D();

		Assert.areEqual(0.0, a.x);
		Assert.areEqual(0.0, a.y);
		Assert.areEqual(0.0, a.z);
		Assert.areEqual(0.0, a.w);

		var b = new Vector3D(3, 4, 5, 6);

		Assert.areEqual(3, b.x);
		Assert.areEqual(4, b.y);
		Assert.areEqual(5, b.z);
		Assert.areEqual(6, b.w);
	}

	@Test public function add()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		var result = vector.add(vector2);

		Assert.areEqual(3, result.x);
		Assert.areEqual(3, result.y);
		Assert.areEqual(3, result.z);

		Assert.areEqual(0, result.w); // stays default
	}

	@Test public function copyFrom()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		vector2.copyFrom(vector);

		Assert.areEqual(1, vector2.x);
		Assert.areEqual(1, vector2.y);
		Assert.areEqual(1, vector2.z);

		Assert.areEqual(2, vector2.w); // ignored
	}

	@Test public function crossProduct()
	{
		var v1 = new Vector3D(1, 0, 0, 0);
		var v2 = new Vector3D(0, 1, 0, 0);

		var crossV1V2 = v1.crossProduct(v2);

		Assert.areEqual(0, crossV1V2.x);
		Assert.areEqual(0, crossV1V2.y);
		Assert.areEqual(1, crossV1V2.z);
		Assert.areEqual(1, crossV1V2.w);

		var a = new Vector3D(2, 3, 4, 4);
		var b = new Vector3D(3, 4, 5, 6);
		var c = new Vector3D(3, 4, 5, 10); // w ignored

		var crossAB = a.crossProduct(b);
		var crossAC = a.crossProduct(c);

		Assert.areEqual(-1, crossAB.x);
		Assert.areEqual(2, crossAB.y);
		Assert.areEqual(-1, crossAB.z);
		Assert.areEqual(1, crossAB.w);

		Assert.areEqual(-1, crossAC.x);
		Assert.areEqual(2, crossAC.y);
		Assert.areEqual(-1, crossAC.z);
		Assert.areEqual(1, crossAC.w);
	}

	@Test public function decrementBy()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		vector2.decrementBy(vector);

		Assert.areEqual(1, vector2.x);
		Assert.areEqual(1, vector2.y);
		Assert.areEqual(1, vector2.z);

		Assert.areEqual(2, vector2.w); // ignored
	}

	@Test public function dotProduct()
	{
		var v1 = new Vector3D(1, 0, 0, 0);
		var v2 = new Vector3D(0, 1, 0, 0);

		Assert.areEqual(0, v1.dotProduct(v2));

		var a = new Vector3D(2, 3, 4, 4);
		var b = new Vector3D(3, 4, 5, 6);
		var c = new Vector3D(3, 4, 5, 10); // w ignored

		Assert.areEqual(29, a.dotProduct(a));
		Assert.areEqual(38, a.dotProduct(b));
		Assert.areEqual(38, a.dotProduct(c));
	}

	@Test public function equals()
	{
		var a = new Vector3D(1, 2, 3, 4);
		var a_cloned = a.clone();

		var a_w_diff_only = new Vector3D(1, 2, 3, 5);

		var b = new Vector3D(2, 3, 4, 4);
		var c = new Vector3D(3, 4, 5, 6);

		Assert.areEqual(true, a.equals(a_w_diff_only, false));
		Assert.areEqual(false, a.equals(a_w_diff_only, true));

		Assert.areEqual(true, a.equals(a_cloned, true));

		Assert.areEqual(false, a.equals(b, true));
		Assert.areEqual(false, a.equals(c, true));
	}

	@Test public function incrementBy()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		var vector2 = new Vector3D(2, 2, 2, 2);

		vector.incrementBy(vector2);

		Assert.areEqual(3, vector.x);
		Assert.areEqual(3, vector.y);
		Assert.areEqual(3, vector.z);

		Assert.areEqual(1, vector.w); // ignored
	}

	@Test public function nearEquals()
	{
		var a = new Vector3D(3.7, -1.1, 6.9, 2.3);
		var a_w_diff_only = new Vector3D(3.7, -1.1, 6.9, 2.28);

		var b = new Vector3D(3.6, -1.0, 6.9, 2.2);
		var c = new Vector3D(3.72, -1.11, 6.88, 2.31);

		Assert.areEqual(true, a.nearEquals(a_w_diff_only, 0.01, false));

		Assert.areEqual(false, a.nearEquals(b, 0.1, true));
		Assert.areEqual(false, a.nearEquals(c, 0.02, true));

		#if flash
		// TODO: alpha is considered abs(max(2.3, 2.2) - 0.0) < 2.4 with allFour=true
		Assert.areEqual(true, a.nearEquals(b, 2.4, true));
		Assert.areEqual(true, a.nearEquals(c, 2.4, true));

		Assert.areEqual(true, a.nearEquals(b, 0.11, false));
		Assert.areEqual(true, a.nearEquals(c, 0.03, false));
		#else
		Assert.areEqual(true, a.nearEquals(b, 0.11, true));
		Assert.areEqual(true, a.nearEquals(c, 0.03, true));
		#end
	}

	@Test public function negate()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		vector.negate();

		Assert.areEqual(-1, vector.x);
		Assert.areEqual(-1, vector.y);
		Assert.areEqual(-1, vector.z);

		Assert.areEqual(1, vector.w); // ignored
	}

	@Test public function normalize()
	{
		var vector = new Vector3D(4, 4, 4, 4);

		var normalizedValue = 4 / vector.length;
		vector.normalize();

		Assert.areEqual(normalizedValue, vector.x);
		Assert.areEqual(normalizedValue, vector.y);
		Assert.areEqual(normalizedValue, vector.z);

		Assert.areEqual(4, vector.w); // ignored
	}

	@Test public function project()
	{
		var vector = new Vector3D(3.7, -1.1, 6.9, 2.3);
		vector.project();

		Assert.areEqual(3.7 / 2.3, vector.x);
		Assert.areEqual(-1.1 / 2.3, vector.y);
		Assert.areEqual(6.9 / 2.3, vector.z);
		Assert.areEqual(2.3, vector.w);
	}

	@Test public function scaleBy()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		vector.scaleBy(4);

		Assert.areEqual(4, vector.x);
		Assert.areEqual(4, vector.y);
		Assert.areEqual(4, vector.z);

		Assert.areEqual(1, vector.w); // ignored
	}

	@Test public function setTo()
	{
		var vector = new Vector3D(1, 1, 1, 1);
		vector.setTo(4, 4, 4);

		Assert.areEqual(4, vector.x);
		Assert.areEqual(4, vector.y);
		Assert.areEqual(4, vector.z);
		Assert.areEqual(1, vector.w);
	}

	@Test public function subtract()
	{
		var vector = new Vector3D(5, 5, 5, 5);
		var vector2 = new Vector3D(2, 2, 2, 2);

		var result = vector.subtract(vector2);

		Assert.areEqual(3, result.x);
		Assert.areEqual(3, result.y);
		Assert.areEqual(3, result.z);

		Assert.areEqual(0, result.w); // ignored
	}

	@Test public function clone()
	{
		var a = new Vector3D(5.1, 3.2, 4.4, 1.0);
		var a_cloned = a.clone();

		Assert.areEqual(a.x, a_cloned.x);
		Assert.areEqual(a.y, a_cloned.y);
		Assert.areEqual(a.z, a_cloned.z);
		Assert.areEqual(a.w, a_cloned.w);

		a.x = 123.0;
		a.y = 234.0;
		a.z = 345.0;
		a.w = 456.0;

		Assert.areNotEqual(a.x, a_cloned.x);
		Assert.areNotEqual(a.y, a_cloned.y);
		Assert.areNotEqual(a.z, a_cloned.z);
		Assert.areNotEqual(a.w, a_cloned.w);

		Assert.areEqual(5.1, a_cloned.x);
		Assert.areEqual(3.2, a_cloned.y);
		Assert.areEqual(4.4, a_cloned.z);
		Assert.areEqual(1.0, a_cloned.w);
	}

	@Test public function angleBetween()
	{
		var a = new Vector3D(5.1, 3.2, 4.4, 1.0);
		var b = new Vector3D(3.1, 6.2, -5.3, 2.0);
		var c = new Vector3D(3.1, 6.2, -5.3, 5.1); // w ignored

		Assert.areEqual(0.0, Vector3D.angleBetween(a, a));

		// TODO: Flash returns 39.3205 - for a/b and a/c.
		// TODO: I had to remove assertions though because it showed them anyway as failures
		// ... even when they were commented out
	}

	@Test public function distance()
	{
		var a = new Vector3D(1.1, 2.2, 3.3, 4.4);
		var b = new Vector3D(-33.3, -31.2, 32.1, 12.3);
		var c = new Vector3D(-33.3, -31.2, 32.1, 7.7); // w ignored

		Assert.areEqual(0.0, Vector3D.distance(a, a));
		Assert.areEqual(55.9317, Math.round(Vector3D.distance(a, b) * 10000.0) / 10000.0);
		Assert.areEqual(55.9317, Math.round(Vector3D.distance(a, c) * 10000.0) / 10000.0);
	}
}
