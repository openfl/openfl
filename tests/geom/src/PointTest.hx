package;

import openfl.geom.Point;
import utest.Assert;
import utest.Test;

class PointTest extends Test
{
	public function test_length()
	{
		Assert.equals(10, new Point(0, 10).length);
		Assert.equals(10, new Point(10, 0).length);
		Assert.equals(20, new Point(-20, 0).length);
		Assert.equals(0, new Point().length);

		Assert.equals(Math.sqrt(40 * 40 + 40 * 40), new Point(40, 40).length);
	}

	public function test_x()
	{
		var point = new Point();

		Assert.equals(0, point.x);

		point.x = 100;

		Assert.equals(100, point.x);
	}

	public function test_y()
	{
		var point = new Point();

		Assert.equals(0, point.x);

		point.x = 100;

		Assert.equals(100, point.x);
	}

	/*public function test_new_ () {



	}*/
	public function test_add()
	{
		var point = new Point();

		Assert.isTrue(point.add(new Point(20, 20)).equals(new Point(20, 20)));

		point = new Point(-20, 0);

		Assert.isTrue(point.add(new Point(20, 20)).equals(new Point(0, 20)));

		point = new Point();
		point.add(new Point(20, 100));

		Assert.isTrue(point.equals(new Point()));
	}

	public function test_clone()
	{
		var point = new Point();

		Assert.notEquals(point, point.clone());
		Assert.isTrue(point.equals(point.clone()));

		point = new Point(-20, 100);

		Assert.notEquals(point, point.clone());
		Assert.isTrue(point.equals(point.clone()));
	}

	// public function test_copyFrom() {}

	public function test_equals()
	{
		var point = new Point();

		Assert.isTrue(point.equals(new Point()));

		var point = new Point(-40, 100);

		Assert.isTrue(point.equals(new Point(-40, 100)));
	}

	public function test_normalize()
	{
		var point = new Point();
		point.normalize(0);

		Assert.isTrue(point.equals(new Point()));

		point = new Point();
		point.normalize(1);

		Assert.isTrue(point.equals(new Point()));

		point = new Point(100, 100);
		point.normalize(point.length / 2);

		Assert.isTrue(point.equals(new Point(50, 50)));

		point = new Point(0, 100);
		point.normalize(1);

		Assert.isTrue(point.equals(new Point(0, 1)));
	}

	public function test_offset()
	{
		var point = new Point();
		point.offset(10, 100);

		Assert.isTrue(point.equals(new Point(10, 100)));

		point.offset(-10, 0);

		Assert.isTrue(point.equals(new Point(0, 100)));
	}

	public function test_setTo()
	{
		var point = new Point(1.0, 2.0);
		point.setTo(5.0, 6.0);

		Assert.equals(5.0, point.x);
		Assert.equals(6.0, point.y);
	}

	public function test_subtract()
	{
		var point = new Point();

		Assert.isTrue(point.subtract(new Point(20, 20)).equals(new Point(-20, -20)));

		point = new Point(-20, 0);

		Assert.isTrue(point.subtract(new Point(20, 20)).equals(new Point(-40, -20)));

		point = new Point();
		point.subtract(new Point(20, 100));

		Assert.isTrue(point.equals(new Point()));
	}

	public function test_distance()
	{
		Assert.equals(100, Point.distance(new Point(), new Point(100, 0)));
		Assert.equals(120, Point.distance(new Point(0, -20), new Point(0, 100)));

		var differenceX = 100 - 20;
		var differenceY = 20 - 10;

		var distance = Math.sqrt((differenceX * differenceX) + (differenceY * differenceY));

		Assert.equals(distance, Point.distance(new Point(100, 20), new Point(20, 10)));
	}

	public function test_interpolate()
	{
		Assert.isTrue(Point.interpolate(new Point(), new Point(100, 100), 0.5).equals(new Point(50, 50)));
		Assert.isTrue(Point.interpolate(new Point(), new Point(100, 100), 0.2).equals(new Point(80, 80)));

		var point = new Point(-200, 100);

		Assert.equals(point.length * 0.1, Point.interpolate(point, new Point(), 0.1).length);
	}

	public function test_polar()
	{
		Assert.isTrue(Point.polar(1, 0).equals(new Point(1, 0)));
		Assert.equals(-10, Point.polar(10, -Math.PI).x);
	}
}
