package;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import utest.Assert;
import utest.Test;

class RectangleTest extends Test
{
	public function test_bottom()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(100, rect.bottom);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(0, rect.bottom);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.bottom);
	}

	public function test_bottomRight()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.notNull(rect.bottomRight);
		Assert.isOfType(rect.bottomRight, openfl.geom.Point);

		Assert.equals(100, rect.bottomRight.x);
		Assert.equals(100, rect.bottomRight.y);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(0, rect.bottomRight.x);
		Assert.equals(0, rect.bottomRight.y);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.bottomRight.x);
		Assert.equals(0, rect.bottomRight.y);
	}

	public function test_height()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(100, rect.height);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(100, rect.height);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.height);
	}

	public function test_left()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(0, rect.left);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(-100, rect.left);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.left);
	}

	public function test_right()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(100, rect.right);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(0, rect.right);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.right);
	}

	public function test_size()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.notNull(rect.size);
		Assert.isOfType(rect.size, openfl.geom.Point);

		Assert.equals(100, rect.size.x);
		Assert.equals(100, rect.size.y);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(100, rect.size.x);
		Assert.equals(100, rect.size.y);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.size.x);
		Assert.equals(0, rect.size.y);
	}

	public function test_top()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(0, rect.top);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(-100, rect.top);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.top);
	}

	public function test_topLeft()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.notNull(rect.topLeft);
		Assert.isOfType(rect.topLeft, openfl.geom.Point);

		Assert.equals(0, rect.topLeft.x);
		Assert.equals(0, rect.topLeft.y);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(-100, rect.topLeft.x);
		Assert.equals(-100, rect.topLeft.y);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.topLeft.x);
		Assert.equals(0, rect.topLeft.y);
	}

	public function test_width()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(100, rect.width);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(100, rect.width);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.width);
	}

	public function test_x()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(0, rect.x);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(-100, rect.x);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.x);
	}

	public function test_y()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.equals(0, rect.y);

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.equals(-100, rect.y);

		rect = new Rectangle(0, 0, 0, 0);

		Assert.equals(0, rect.y);
	}

	public function test_new_()
	{
		var rect = new Rectangle();

		Assert.notNull(rect);
		Assert.equals(0, rect.x);
		Assert.equals(0, rect.y);
		Assert.equals(0, rect.width);
		Assert.equals(0, rect.height);

		rect = new Rectangle(100, 100, 100, 100);

		Assert.equals(100, rect.x);
		Assert.equals(100, rect.y);
		Assert.equals(100, rect.width);
		Assert.equals(100, rect.height);
	}

	public function test_clone()
	{
		var rect = new Rectangle(0, 0, 100, 100);
		var clone = rect.clone();

		Assert.notEquals(rect, clone);
		Assert.equals(rect.x, clone.x);
		Assert.equals(rect.y, clone.y);
		Assert.equals(rect.width, clone.width);
		Assert.equals(rect.height, clone.height);
	}

	public function test_contains()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.isTrue(rect.contains(0, 0));
		Assert.isTrue(rect.contains(99, 99));
		Assert.isFalse(rect.contains(100, 100));

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.isTrue(rect.contains(-1, -1));
		Assert.isTrue(rect.contains(-100, -100));
		Assert.isFalse(rect.contains(-101, -101));
	}

	public function test_containsPoint()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.isTrue(rect.containsPoint(new Point(0, 0)));
		Assert.isTrue(rect.containsPoint(new Point(99, 99)));
		Assert.isFalse(rect.containsPoint(new Point(100, 100)));

		rect = new Rectangle(-100, -100, 100, 100);

		Assert.isTrue(rect.containsPoint(new Point(-1, -1)));
		Assert.isTrue(rect.containsPoint(new Point(-100, -100)));
		Assert.isFalse(rect.containsPoint(new Point(-101, -101)));
	}

	public function test_containsRect()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.isTrue(rect.containsRect(new Rectangle(0, 0, 100, 100)));
		Assert.isFalse(rect.containsRect(new Rectangle()));
		Assert.isFalse(rect.containsRect(new Rectangle(0, 0, 1, 0)));
		Assert.isTrue(rect.containsRect(new Rectangle(0, 0, 1, 1)));
		Assert.isTrue(rect.containsRect(new Rectangle(1, 1)));
		Assert.isFalse(rect.containsRect(new Rectangle(-1, 0, 100, 100)));
		Assert.isFalse(rect.containsRect(new Rectangle(0, 0, 100, 101)));

		rect = new Rectangle(-100, -100, 200, 200);

		Assert.isTrue(rect.containsRect(new Rectangle(-100, -100, 200, 200)));
		Assert.isTrue(rect.containsRect(new Rectangle()));
		Assert.isFalse(rect.containsRect(new Rectangle(-100, -100)));
		Assert.isFalse(rect.containsRect(new Rectangle(100, 100)));
		Assert.isTrue(rect.containsRect(new Rectangle(99, 99)));
		Assert.isFalse(rect.containsRect(new Rectangle(-101, -100, 200, 200)));
		Assert.isFalse(rect.containsRect(new Rectangle(-100, -100, 201, 201)));
	}

	public function test_copyFrom()
	{
		var source = new Rectangle(5.0, 6.0, 70.0, 90.0);
		var dest = new Rectangle(1.0, 2.0, 100.0, 101.0);

		source.copyFrom(dest);

		Assert.equals(1.0, source.x);
		Assert.equals(2.0, source.y);
		Assert.equals(100.0, source.width);
		Assert.equals(101.0, source.height);

		// to check if dest reference is not modified
		Assert.equals(1.00, dest.x);
		Assert.equals(2.0, dest.y);
		Assert.equals(100.00, dest.width);
		Assert.equals(101.0, dest.height);
	}

	public function test_equals()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.isTrue(rect.equals(new Rectangle(0, 0, 100, 100)));
		Assert.isTrue(rect.equals(rect.clone()));
		Assert.isFalse(rect.equals(new Rectangle(1, 0, 100, 100)));
		Assert.isFalse(rect.equals(new Rectangle(0, 0, 100, 101)));
	}

	public function test_inflate()
	{
		var rect = new Rectangle(0, 0, 100, 100);
		rect.inflate(1, 0);

		Assert.equals(102, rect.width);
		Assert.equals(100, rect.height);
		Assert.equals(-1, rect.x);
		Assert.equals(0, rect.y);

		rect = new Rectangle(-100, -100, 100, 100);
		rect.inflate(2, 2);

		Assert.equals(104, rect.width);
		Assert.equals(2, rect.right);
		Assert.equals(-102, rect.x);
		Assert.equals(-102, rect.y);

		rect.inflate(-2, -2);

		Assert.equals(100, rect.width);
		Assert.equals(-100, rect.x);
	}

	public function test_inflatePoint()
	{
		var rect = new Rectangle(0, 0, 100, 100);
		rect.inflatePoint(new Point(1, 0));

		Assert.equals(102, rect.width);
		Assert.equals(100, rect.height);
		Assert.equals(-1, rect.x);
		Assert.equals(0, rect.y);

		rect = new Rectangle(-100, -100, 100, 100);
		rect.inflatePoint(new Point(2, 2));

		Assert.equals(104, rect.width);
		Assert.equals(2, rect.right);
		Assert.equals(-102, rect.x);
		Assert.equals(-102, rect.y);

		rect.inflatePoint(new Point(-2, -2));

		Assert.equals(100, rect.width);
		Assert.equals(-100, rect.x);
	}

	public function test_intersection()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.isTrue(rect.intersection(new Rectangle()).equals(new Rectangle()));
		Assert.isTrue(rect.intersection(new Rectangle(50, 50, 100, 100)).equals(new Rectangle(50, 50, 50, 50)));
		Assert.isTrue(rect.intersection(new Rectangle(-50, -50, 100, 100)).equals(new Rectangle(0, 0, 50, 50)));
		Assert.isTrue(rect.intersection(new Rectangle(-100, -100, 100, 100)).equals(new Rectangle()));
	}

	public function test_intersects()
	{
		var rect = new Rectangle(0, 0, 100, 100);

		Assert.isFalse(rect.intersects(new Rectangle()));
		Assert.isTrue(rect.intersects(new Rectangle(50, 50, 100, 100)));
		Assert.isTrue(rect.intersects(new Rectangle(-50, -50, 100, 100)));
		Assert.isFalse(rect.intersects(new Rectangle(-100, -100, 100, 100)));
	}

	public function test_isEmpty()
	{
		Assert.isTrue(new Rectangle().isEmpty());
		Assert.isTrue(new Rectangle(100, 100, -1, -1).isEmpty());
		Assert.isTrue(new Rectangle(0, 0, -1, -1).isEmpty());
		Assert.isTrue(new Rectangle(0, 0, 1, 0).isEmpty());
		Assert.isFalse(new Rectangle(0, 0, 1, 1).isEmpty());
	}

	public function test_offset()
	{
		var rect = new Rectangle();
		rect.offset(-1, -1);

		Assert.isTrue(rect.equals(new Rectangle(-1, -1, 0, 0)));

		rect.offset(1, 1);

		Assert.isTrue(rect.equals(new Rectangle()));

		rect = new Rectangle(0, 0, 100, 100);
		rect.offset(20, 0);

		Assert.isTrue(rect.equals(new Rectangle(20, 0, 100, 100)));
	}

	public function test_offsetPoint()
	{
		var rect = new Rectangle();
		rect.offsetPoint(new Point(-1, -1));

		Assert.isTrue(rect.equals(new Rectangle(-1, -1, 0, 0)));

		rect = new Rectangle(0, 0, 100, 100);
		rect.offsetPoint(new Point(20, 0));

		Assert.isTrue(rect.equals(new Rectangle(20, 0, 100, 100)));
	}

	public function test_setEmpty()
	{
		var rect = new Rectangle(0, 0, 100, 100);
		rect.setEmpty();

		Assert.isTrue(rect.isEmpty());

		rect = new Rectangle(0, 0, 100, 100);
		rect.setEmpty();

		Assert.isTrue(rect.equals(new Rectangle()));
	}

	public function test_setTo()
	{
		var rect = new Rectangle(0.0, 0.0, 100.0, 100.0);
		rect.setTo(5.0, 6.0, 7.0, 8.0);

		Assert.equals(5.0, rect.x);
		Assert.equals(6.0, rect.y);
		Assert.equals(7.0, rect.width);
		Assert.equals(8.0, rect.height);
	}

	public function test_union()
	{
		Assert.isTrue(new Rectangle().union(new Rectangle()).isEmpty());
		Assert.isTrue(new Rectangle().union(new Rectangle(0, 0, 100, 100)).equals(new Rectangle(0, 0, 100, 100)));
		Assert.isTrue(new Rectangle(-100, -100, 100, 100).union(new Rectangle(-20, -20, 100, 100)).equals(new Rectangle(-100, -100, 180, 180)));
		Assert.isTrue(new Rectangle(-100, -100, 10, 10).union(new Rectangle(100, 100, 10, 10)).equals(new Rectangle(-100, -100, 210, 210)));
	}
}
