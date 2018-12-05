package openfl.geom;


class RectangleTest { public static function __init__ () { Mocha.describe ("Haxe | Rectangle", function () {
	
	
	Mocha.it ("bottom", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.bottom, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.bottom, 0);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.bottom, 0);
		
	});
	
	
	Mocha.it ("bottomRight", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.notEqual (rect.bottomRight, null);
		Assert.assert (Std.is (rect.bottomRight, openfl.geom.Point));
		
		Assert.equal (rect.bottomRight.x, 100);
		Assert.equal (rect.bottomRight.y, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.bottomRight.x, 0);
		Assert.equal (rect.bottomRight.y, 0);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.bottomRight.x, 0);
		Assert.equal (rect.bottomRight.y, 0);
		
	});
	
	
	Mocha.it ("height", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.height, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.height, 100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.height, 0);
		
	});
	
	
	Mocha.it ("left", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.left, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.left, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.left, 0);
		
	});
	
	
	Mocha.it ("right", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.right, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.right, 0);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.right, 0);
		
	});
	
	
	Mocha.it ("size", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.notEqual (rect.size, null);
		Assert.assert (Std.is (rect.size, openfl.geom.Point));
		
		Assert.equal (rect.size.x, 100);
		Assert.equal (rect.size.y, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.size.x, 100);
		Assert.equal (rect.size.y, 100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.size.x, 0);
		Assert.equal (rect.size.y, 0);
		
	});
	
	
	Mocha.it ("top", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.top, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.top, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.top, 0);
		
	});
	
	
	Mocha.it ("topLeft", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.notEqual (rect.topLeft, null);
		Assert.assert (Std.is (rect.topLeft, openfl.geom.Point));
		
		Assert.equal (rect.topLeft.x, 0);
		Assert.equal (rect.topLeft.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.topLeft.x, -100);
		Assert.equal (rect.topLeft.y, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.topLeft.x, 0);
		Assert.equal (rect.topLeft.y, 0);
		
	});
	
	
	Mocha.it ("width", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.width, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.width, 100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.width, 0);
		
	});
	
	
	Mocha.it ("x", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.x, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.x, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.x, 0);
		
	});
	
	
	Mocha.it ("y", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.equal (rect.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.equal (rect.y, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.equal (rect.y, 0);
		
	});
	
	
	Mocha.it ("new", function () {
		
		var rect = new Rectangle ();
		
		Assert.notEqual (rect, null);
		Assert.equal (rect.x, 0);
		Assert.equal (rect.y, 0);
		Assert.equal (rect.width, 0);
		Assert.equal (rect.height, 0);
		
		rect = new Rectangle (100, 100, 100, 100);
		
		Assert.equal (rect.x, 100);
		Assert.equal (rect.y, 100);
		Assert.equal (rect.width, 100);
		Assert.equal (rect.height, 100);
		
	});
	
	
	Mocha.it ("clone", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		var clone = rect.clone ();
		
		Assert.notEqual (rect, clone);
		Assert.equal (clone.x, rect.x);
		Assert.equal (clone.y, rect.y);
		Assert.equal (clone.width, rect.width);
		Assert.equal (clone.height, rect.height);
		
	});
	
	
	Mocha.it ("contains", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.assert (rect.contains (0, 0));
		Assert.assert (rect.contains (99, 99));
		Assert.assert (!rect.contains (100, 100));
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.assert (rect.contains (-1, -1));
		Assert.assert (rect.contains (-100, -100));
		Assert.assert (!rect.contains (-101, -101));
		
	});
	
	
	Mocha.it ("containsPoint", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.assert (rect.containsPoint (new Point (0, 0)));
		Assert.assert (rect.containsPoint (new Point (99, 99)));
		Assert.assert (!rect.containsPoint (new Point (100, 100)));
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.assert (rect.containsPoint (new Point (-1, -1)));
		Assert.assert (rect.containsPoint (new Point (-100, -100)));
		Assert.assert (!rect.containsPoint (new Point (-101, -101)));
		
	});
	
	
	Mocha.it ("containsRect", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.assert (rect.containsRect (new Rectangle (0, 0, 100, 100)));
		Assert.assert (!rect.containsRect (new Rectangle ()));
		Assert.assert (!rect.containsRect (new Rectangle (0, 0, 1, 0)));
		Assert.assert (rect.containsRect (new Rectangle (0, 0, 1, 1)));
		Assert.assert (rect.containsRect (new Rectangle (1, 1)));
		Assert.assert (!rect.containsRect (new Rectangle (-1, 0, 100, 100)));
		Assert.assert (!rect.containsRect (new Rectangle (0, 0, 100, 101)));
		
		rect = new Rectangle (-100, -100, 200, 200);
		
		Assert.assert (rect.containsRect (new Rectangle (-100, -100, 200, 200)));
		Assert.assert (rect.containsRect (new Rectangle ()));
		Assert.assert (!rect.containsRect (new Rectangle (-100, -100)));
		Assert.assert (!rect.containsRect (new Rectangle (100, 100)));
		Assert.assert (rect.containsRect (new Rectangle (99, 99)));
		Assert.assert (!rect.containsRect (new Rectangle (-101, -100, 200, 200)));
		Assert.assert (!rect.containsRect (new Rectangle (-100, -100, 201, 201)));
		
	});
	
	
	Mocha.it ("copyFrom", function () {
		
		// TODO: Confirm functionality
		
		var rectangle = new Rectangle ();
		var exists = rectangle.copyFrom;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("equals", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.assert (rect.equals (new Rectangle (0, 0, 100, 100)));
		Assert.assert (rect.equals (rect.clone ()));
		Assert.assert (!rect.equals (new Rectangle (1, 0, 100, 100)));
		Assert.assert (!rect.equals (new Rectangle (0, 0, 100, 101)));
		
	});
	
	
	Mocha.it ("inflate", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.inflate (1, 0);
		
		Assert.equal (rect.width, 102);
		Assert.equal (rect.height, 100);
		Assert.equal (rect.x, -1);
		Assert.equal (rect.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		rect.inflate (2, 2);
		
		Assert.equal (rect.width, 104);
		Assert.equal (rect.right, 2);
		Assert.equal (rect.x, -102);
		Assert.equal (rect.y, -102);
		
		rect.inflate (-2, -2);
		
		Assert.equal (rect.width, 100);
		Assert.equal (rect.x, -100);
		
	});
	
	
	Mocha.it ("inflatePoint", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.inflatePoint (new Point (1, 0));
		
		Assert.equal (rect.width, 102);
		Assert.equal (rect.height, 100);
		Assert.equal (rect.x, -1);
		Assert.equal (rect.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		rect.inflatePoint (new Point (2, 2));
		
		Assert.equal (rect.width, 104);
		Assert.equal (rect.right, 2);
		Assert.equal (rect.x, -102);
		Assert.equal (rect.y, -102);
		
		rect.inflatePoint (new Point (-2, -2));
		
		Assert.equal (rect.width, 100);
		Assert.equal (rect.x, -100);
		
	});
	
	
	Mocha.it ("intersection", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.assert (rect.intersection (new Rectangle ()).equals (new Rectangle ()));
		Assert.assert (rect.intersection (new Rectangle (50, 50, 100, 100)).equals (new Rectangle (50, 50, 50, 50)));
		Assert.assert (rect.intersection (new Rectangle (-50, -50, 100, 100)).equals (new Rectangle (0, 0, 50, 50)));
		Assert.assert (rect.intersection (new Rectangle (-100, -100, 100, 100)).equals (new Rectangle ()));
		
	});
	
	
	Mocha.it ("intersects", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.assert (!rect.intersects (new Rectangle ()));
		Assert.assert (rect.intersects (new Rectangle (50, 50, 100, 100)));
		Assert.assert (rect.intersects (new Rectangle (-50, -50, 100, 100)));
		Assert.assert (!rect.intersects (new Rectangle (-100, -100, 100, 100)));
		
	});
	
	
	Mocha.it ("isEmpty", function () {
		
		Assert.assert (new Rectangle ().isEmpty ());
		Assert.assert (new Rectangle (100, 100, -1, -1).isEmpty ());
		Assert.assert (new Rectangle (0, 0, -1, -1).isEmpty ());
		Assert.assert (new Rectangle (0, 0, 1, 0).isEmpty ());
		Assert.assert (!new Rectangle (0, 0, 1, 1).isEmpty ());
		
	});
	
	
	Mocha.it ("offset", function () {
		
		var rect = new Rectangle ();
		rect.offset (-1, -1);
		
		Assert.assert (rect.equals (new Rectangle (-1, -1, 0, 0)));
		
		rect.offset (1, 1);
		
		Assert.assert (rect.equals (new Rectangle ()));
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.offset (20, 0);
		
		Assert.assert (rect.equals (new Rectangle (20, 0, 100, 100)));
		
	});
	
	
	Mocha.it ("offsetPoint", function () {
		
		var rect = new Rectangle ();
		rect.offsetPoint (new Point (-1, -1));
		
		Assert.assert (rect.equals (new Rectangle (-1, -1, 0, 0)));
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.offsetPoint (new Point (20, 0));
		
		Assert.assert (rect.equals (new Rectangle (20, 0, 100, 100)));
		
	});
	
	
	Mocha.it ("setEmpty", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.setEmpty ();
		
		Assert.assert (rect.isEmpty ());
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.setEmpty ();
		
		Assert.assert (rect.equals (new Rectangle ()));
		
	});
	
	
	Mocha.it ("setTo", function () {
		
		// TODO: Confirm functionality
		
		var rectangle = new Rectangle ();
		var exists = rectangle.setTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
	Mocha.it ("union", function () {
		
		Assert.assert (new Rectangle ().union (new Rectangle ()).isEmpty ());
		Assert.assert (new Rectangle ().union (new Rectangle (0, 0, 100, 100)).equals (new Rectangle (0, 0, 100, 100)));
		Assert.assert (new Rectangle (-100, -100, 100, 100).union (new Rectangle (-20, -20, 100, 100)).equals (new Rectangle (-100, -100, 180, 180)));
		Assert.assert (new Rectangle (-100, -100, 10, 10).union (new Rectangle (100, 100, 10, 10)).equals (new Rectangle (-100, -100, 210, 210)));
		
	});
	
	
}); }}