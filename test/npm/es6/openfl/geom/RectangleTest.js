import Point from "openfl/geom/Point";
import Rectangle from "openfl/geom/Rectangle";
import * as assert from "assert";


describe ("ES6 | Rectangle", function () {
	
	
	it ("bottom", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.bottom, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.bottom, 0);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.bottom, 0);
		
	});
	
	
	it ("bottomRight", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.notEqual (rect.bottomRight, null);
		assert (rect.bottomRight instanceof Point);
		
		assert.equal (rect.bottomRight.x, 100);
		assert.equal (rect.bottomRight.y, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.bottomRight.x, 0);
		assert.equal (rect.bottomRight.y, 0);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.bottomRight.x, 0);
		assert.equal (rect.bottomRight.y, 0);
		
	});
	
	
	it ("height", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.height, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.height, 100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.height, 0);
		
	});
	
	
	it ("left", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.left, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.left, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.left, 0);
		
	});
	
	
	it ("right", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.right, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.right, 0);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.right, 0);
		
	});
	
	
	it ("size", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.notEqual (rect.size, null);
		assert (rect.size instanceof Point);
		
		assert.equal (rect.size.x, 100);
		assert.equal (rect.size.y, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.size.x, 100);
		assert.equal (rect.size.y, 100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.size.x, 0);
		assert.equal (rect.size.y, 0);
		
	});
	
	
	it ("top", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.top, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.top, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.top, 0);
		
	});
	
	
	it ("topLeft", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.notEqual (rect.topLeft, null);
		assert (rect.topLeft instanceof Point);
		
		assert.equal (rect.topLeft.x, 0);
		assert.equal (rect.topLeft.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.topLeft.x, -100);
		assert.equal (rect.topLeft.y, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.topLeft.x, 0);
		assert.equal (rect.topLeft.y, 0);
		
	});
	
	
	it ("width", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.width, 100);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.width, 100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.width, 0);
		
	});
	
	
	it ("x", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.x, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.x, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.x, 0);
		
	});
	
	
	it ("y", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert.equal (rect.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert.equal (rect.y, -100);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		assert.equal (rect.y, 0);
		
	});
	
	
	it ("new", function () {
		
		var rect = new Rectangle ();
		
		assert.notEqual (rect, null);
		assert.equal (rect.x, 0);
		assert.equal (rect.y, 0);
		assert.equal (rect.width, 0);
		assert.equal (rect.height, 0);
		
		rect = new Rectangle (100, 100, 100, 100);
		
		assert.equal (rect.x, 100);
		assert.equal (rect.y, 100);
		assert.equal (rect.width, 100);
		assert.equal (rect.height, 100);
		
	});
	
	
	it ("clone", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		var clone = rect.clone ();
		
		assert.notEqual (rect, clone);
		assert.equal (clone.x, rect.x);
		assert.equal (clone.y, rect.y);
		assert.equal (clone.width, rect.width);
		assert.equal (clone.height, rect.height);
		
	});
	
	
	it ("contains", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert (rect.contains (0, 0));
		assert (rect.contains (99, 99));
		assert (!rect.contains (100, 100));
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert (rect.contains (-1, -1));
		assert (rect.contains (-100, -100));
		assert (!rect.contains (-101, -101));
		
	});
	
	
	it ("containsPoint", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert (rect.containsPoint (new Point (0, 0)));
		assert (rect.containsPoint (new Point (99, 99)));
		assert (!rect.containsPoint (new Point (100, 100)));
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		assert (rect.containsPoint (new Point (-1, -1)));
		assert (rect.containsPoint (new Point (-100, -100)));
		assert (!rect.containsPoint (new Point (-101, -101)));
		
	});
	
	
	it ("containsRect", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert (rect.containsRect (new Rectangle (0, 0, 100, 100)));
		assert (!rect.containsRect (new Rectangle ()));
		assert (!rect.containsRect (new Rectangle (0, 0, 1, 0)));
		assert (rect.containsRect (new Rectangle (0, 0, 1, 1)));
		assert (rect.containsRect (new Rectangle (1, 1)));
		assert (!rect.containsRect (new Rectangle (-1, 0, 100, 100)));
		assert (!rect.containsRect (new Rectangle (0, 0, 100, 101)));
		
		rect = new Rectangle (-100, -100, 200, 200);
		
		assert (rect.containsRect (new Rectangle (-100, -100, 200, 200)));
		assert (rect.containsRect (new Rectangle ()));
		assert (!rect.containsRect (new Rectangle (-100, -100)));
		assert (!rect.containsRect (new Rectangle (100, 100)));
		assert (rect.containsRect (new Rectangle (99, 99)));
		assert (!rect.containsRect (new Rectangle (-101, -100, 200, 200)));
		assert (!rect.containsRect (new Rectangle (-100, -100, 201, 201)));
		
	});
	
	
	it ("copyFrom", function () {
		
		// TODO: Confirm functionality
		
		var rectangle = new Rectangle ();
		var exists = rectangle.copyFrom;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("equals", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert (rect.equals (new Rectangle (0, 0, 100, 100)));
		assert (rect.equals (rect.clone ()));
		assert (!rect.equals (new Rectangle (1, 0, 100, 100)));
		assert (!rect.equals (new Rectangle (0, 0, 100, 101)));
		
	});
	
	
	it ("inflate", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.inflate (1, 0);
		
		assert.equal (rect.width, 102);
		assert.equal (rect.height, 100);
		assert.equal (rect.x, -1);
		assert.equal (rect.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		rect.inflate (2, 2);
		
		assert.equal (rect.width, 104);
		assert.equal (rect.right, 2);
		assert.equal (rect.x, -102);
		assert.equal (rect.y, -102);
		
		rect.inflate (-2, -2);
		
		assert.equal (rect.width, 100);
		assert.equal (rect.x, -100);
		
	});
	
	
	it ("inflatePoint", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.inflatePoint (new Point (1, 0));
		
		assert.equal (rect.width, 102);
		assert.equal (rect.height, 100);
		assert.equal (rect.x, -1);
		assert.equal (rect.y, 0);
		
		rect = new Rectangle (-100, -100, 100, 100);
		rect.inflatePoint (new Point (2, 2));
		
		assert.equal (rect.width, 104);
		assert.equal (rect.right, 2);
		assert.equal (rect.x, -102);
		assert.equal (rect.y, -102);
		
		rect.inflatePoint (new Point (-2, -2));
		
		assert.equal (rect.width, 100);
		assert.equal (rect.x, -100);
		
	});
	
	
	it ("intersection", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert (rect.intersection (new Rectangle ()).equals (new Rectangle ()));
		assert (rect.intersection (new Rectangle (50, 50, 100, 100)).equals (new Rectangle (50, 50, 50, 50)));
		assert (rect.intersection (new Rectangle (-50, -50, 100, 100)).equals (new Rectangle (0, 0, 50, 50)));
		assert (rect.intersection (new Rectangle (-100, -100, 100, 100)).equals (new Rectangle ()));
		
	});
	
	
	it ("intersects", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		assert (!rect.intersects (new Rectangle ()));
		assert (rect.intersects (new Rectangle (50, 50, 100, 100)));
		assert (rect.intersects (new Rectangle (-50, -50, 100, 100)));
		assert (!rect.intersects (new Rectangle (-100, -100, 100, 100)));
		
	});
	
	
	it ("isEmpty", function () {
		
		assert (new Rectangle ().isEmpty ());
		assert (new Rectangle (100, 100, -1, -1).isEmpty ());
		assert (new Rectangle (0, 0, -1, -1).isEmpty ());
		assert (new Rectangle (0, 0, 1, 0).isEmpty ());
		assert (!new Rectangle (0, 0, 1, 1).isEmpty ());
		
	});
	
	
	it ("offset", function () {
		
		var rect = new Rectangle ();
		rect.offset (-1, -1);
		
		assert (rect.equals (new Rectangle (-1, -1, 0, 0)));
		
		rect.offset (1, 1);
		
		assert (rect.equals (new Rectangle ()));
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.offset (20, 0);
		
		assert (rect.equals (new Rectangle (20, 0, 100, 100)));
		
	});
	
	
	it ("offsetPoint", function () {
		
		var rect = new Rectangle ();
		rect.offsetPoint (new Point (-1, -1));
		
		assert (rect.equals (new Rectangle (-1, -1, 0, 0)));
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.offsetPoint (new Point (20, 0));
		
		assert (rect.equals (new Rectangle (20, 0, 100, 100)));
		
	});
	
	
	it ("setEmpty", function () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.setEmpty ();
		
		assert (rect.isEmpty ());
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.setEmpty ();
		
		assert (rect.equals (new Rectangle ()));
		
	});
	
	
	it ("setTo", function () {
		
		// TODO: Confirm functionality
		
		var rectangle = new Rectangle ();
		var exists = rectangle.setTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
	it ("union", function () {
		
		assert (new Rectangle ().union (new Rectangle ()).isEmpty ());
		assert (new Rectangle ().union (new Rectangle (0, 0, 100, 100)).equals (new Rectangle (0, 0, 100, 100)));
		assert (new Rectangle (-100, -100, 100, 100).union (new Rectangle (-20, -20, 100, 100)).equals (new Rectangle (-100, -100, 180, 180)));
		assert (new Rectangle (-100, -100, 10, 10).union (new Rectangle (100, 100, 10, 10)).equals (new Rectangle (-100, -100, 210, 210)));
		
	});
	
	
});