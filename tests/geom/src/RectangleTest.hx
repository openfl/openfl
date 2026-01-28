package;

import openfl.geom.Point;
import openfl.geom.Rectangle;
import utest.Assert;
import utest.Test;

class RectangleTest extends Test
{
	public function test_new_default()
	{
		var rect = new Rectangle();
		Assert.equals(0, rect.x);
		Assert.equals(0, rect.y);
		Assert.equals(0, rect.width);
		Assert.equals(0, rect.height);
	}

	public function test_new_withValues()
	{
		var rect = new Rectangle(1, 2, 3, 4);
		Assert.equals(1, rect.x);
		Assert.equals(2, rect.y);
		Assert.equals(3, rect.width);
		Assert.equals(4, rect.height);
	}

	public function test_bottom()
	{
		var r = new Rectangle(0, 0, 10, 20);
		Assert.equals(20, r.bottom);
	}

	public function test_bottomRight_getter()
	{
		var r = new Rectangle(0, 0, 10, 20);
		Assert.equals(10, r.bottomRight.x);
		Assert.equals(20, r.bottomRight.y);
	}

	public function test_bottomRight_setter()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.bottomRight = new Point(15, 25);
		Assert.equals(15, r.width);
		Assert.equals(25, r.height);
	}

	public function test_left_setter()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.left = 5;
		Assert.equals(5, r.x);
		Assert.equals(5, r.width);
	}

	public function test_right_setter_negative()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.right = -5;
		Assert.equals(-5, r.width);
		Assert.isTrue(r.isEmpty());
	}

	public function test_size_setter()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.size = new Point(5, 6);
		Assert.equals(5, r.width);
		Assert.equals(6, r.height);
	}

	public function test_top_setter_negative()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.top = 25;
		Assert.equals(-5, r.height);
		Assert.isTrue(r.isEmpty());
	}

	public function test_topLeft_setter()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.topLeft = new Point(3, 4);
		Assert.equals(3, r.x);
		Assert.equals(4, r.y);
	}

	public function test_clone()
	{
		var r = new Rectangle(0, 0, 10, 20);
		var c = r.clone();
		Assert.isTrue(r.equals(c));
		c.x = 100;
		Assert.notEquals(r.x, c.x);
	}

	public function test_contains()
	{
		var r = new Rectangle(0, 0, 10, 20);
		Assert.isTrue(r.contains(0, 0));
		Assert.isTrue(r.contains(9.999, 19.999));
		Assert.isFalse(r.contains(10, 20));
		Assert.isFalse(r.contains(10, 0));
		Assert.isFalse(r.contains(0, 20));
	}

	public function test_contains_flipped()
	{
		var r = new Rectangle(0, 0, -10, -20);
		Assert.isFalse(r.contains(-5, -10));
	}

	public function test_containsPoint()
	{
		var r = new Rectangle(0, 0, 10, 20);
		Assert.isTrue(r.containsPoint(new Point(5, 10)));
	}

	public function test_containsRect()
	{
		var r = new Rectangle(0, 0, 10, 10);
		Assert.isTrue(r.containsRect(new Rectangle(2, 2, 5, 5)));
		Assert.isFalse(r.containsRect(new Rectangle(-1, 2, 5, 5)));
	}

	public function test_containsRect_flipped_exact()
	{
		var r = new Rectangle(0, 0, 10, 10);
		var r2 = new Rectangle(10, 10, -10, -10);
		Assert.isFalse(r.containsRect(r2));
	}

	public function test_containsRect_zeroSize_corner()
	{
		var r = new Rectangle(0, 0, 10, 10);
		var r2 = new Rectangle(0, 0, 0, 0);
		Assert.isFalse(r.containsRect(r2));
	}

	public function test_copyFrom()
	{
		var src = new Rectangle(2, 3, 4, 5);
		var dst = new Rectangle(0, 0, 10, 10);
		dst.copyFrom(src);
		Assert.isTrue(dst.equals(src));
	}

	public function test_equals()
	{
		var r = new Rectangle(0, 0, 10, 10);
		Assert.isTrue(r.equals(r.clone()));
		Assert.isFalse(r.equals(new Rectangle(1, 0, 10, 10)));
	}

	public function test_intersection()
	{
		var r1 = new Rectangle(0, 0, 10, 20);
		var r2 = new Rectangle(5, 10, 10, 10);
		var i = r1.intersection(r2);
		Assert.equals(5, i.x);
		Assert.equals(10, i.y);
		Assert.equals(5, i.width);
		Assert.equals(10, i.height);
	}

	public function test_intersection_empty()
	{
		var r1 = new Rectangle(0, 0, 10, 10);
		var r2 = new Rectangle(20, 20, 5, 5);
		Assert.isTrue(r1.intersection(r2).isEmpty());
	}

	public function test_intersects()
	{
		var r = new Rectangle(0, 0, 10, 20);
		Assert.isTrue(r.intersects(new Rectangle(5, 10, 10, 10)));
		Assert.isFalse(r.intersects(new Rectangle(20, 20, 5, 5)));
	}

	public function test_isEmpty()
	{
		Assert.isTrue(new Rectangle().isEmpty());
		Assert.isTrue(new Rectangle(0, 0, -5, -5).isEmpty());
		Assert.isTrue(new Rectangle(0, 0, 0, 10).isEmpty());
		Assert.isFalse(new Rectangle(0, 0, 1, 1).isEmpty());
	}

	public function test_offset()
	{
		var r = new Rectangle(0, 0, 10, 10);
		r.offset(5, 10);
		Assert.equals(5, r.x);
		Assert.equals(10, r.y);
	}

	public function test_offsetPoint()
	{
		var r = new Rectangle(0, 0, 10, 10);
		r.offsetPoint(new Point(3, 4));
		Assert.equals(3, r.x);
		Assert.equals(4, r.y);
	}

	public function test_inflate()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.inflate(2, 3);
		Assert.equals(-2, r.x);
		Assert.equals(-3, r.y);
		Assert.equals(14, r.width);
		Assert.equals(26, r.height);
	}

	public function test_inflatePoint()
	{
		var r = new Rectangle(0, 0, 10, 20);
		r.inflatePoint(new Point(1, 2));
		Assert.equals(-1, r.x);
		Assert.equals(-2, r.y);
		Assert.equals(12, r.width);
		Assert.equals(24, r.height);
	}

	public function test_setEmpty()
	{
		var r = new Rectangle(1, 2, 3, 4);
		r.setEmpty();
		Assert.isTrue(r.isEmpty());
	}

	public function test_setTo()
	{
		var r = new Rectangle();
		r.setTo(1, 2, 3, 4);
		Assert.equals(1, r.x);
		Assert.equals(2, r.y);
		Assert.equals(3, r.width);
		Assert.equals(4, r.height);
	}

	public function test_toString()
	{
		var r = new Rectangle(1, 2, 3, 4);
		Assert.equals("(x=1, y=2, w=3, h=4)", r.toString());
	}

	public function test_union()
	{
		var r1 = new Rectangle(0, 0, 10, 20);
		var r2 = new Rectangle(5, 15, 10, 10);
		var u = r1.union(r2);
		Assert.equals(15, u.width);
		Assert.equals(25, u.height);
	}

	public function test_union_flipped()
	{
		var r1 = new Rectangle(0, 0, 10, 20);
		var r2 = new Rectangle(15, 20, -10, -10);
		var u = r1.union(r2);
		Assert.equals(10, u.width);
		Assert.equals(20, u.height);
	}

	public function test_setter_ordering()
	{
		var r = new Rectangle(0, 0, 10, 10);
		r.right = 5;
		r.left = 2;
		Assert.equals(2, r.x);
		Assert.equals(3, r.width);

		r = new Rectangle(0, 0, 10, 10);
		r.left = 2;
		r.right = 5;
		Assert.equals(2, r.x);
		Assert.equals(3, r.width);
	}
}
