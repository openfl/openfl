package openfl.geom;


import massive.munit.Assert;


class RectangleTest {
	
	
	@Test public function bottom () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (100, rect.bottom);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (0, rect.bottom);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.bottom);
		
	}
	
	
	@Test public function bottomRight () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isNotNull (rect.bottomRight);
		Assert.isType (rect.bottomRight, openfl.geom.Point);
		
		Assert.areEqual (100, rect.bottomRight.x);
		Assert.areEqual (100, rect.bottomRight.y);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (0, rect.bottomRight.x);
		Assert.areEqual (0, rect.bottomRight.y);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.bottomRight.x);
		Assert.areEqual (0, rect.bottomRight.y);
		
	}
	
	
	@Test public function height () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (100, rect.height);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (100, rect.height);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.height);
		
	}
	
	
	@Test public function left () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (0, rect.left);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (-100, rect.left);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.left);
		
	}
	
	
	@Test public function right () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (100, rect.right);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (0, rect.right);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.right);
		
	}
	
	
	@Test public function size () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isNotNull (rect.size);
		Assert.isType (rect.size, openfl.geom.Point);
		
		Assert.areEqual (100, rect.size.x);
		Assert.areEqual (100, rect.size.y);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (100, rect.size.x);
		Assert.areEqual (100, rect.size.y);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.size.x);
		Assert.areEqual (0, rect.size.y);
		
	}
	
	
	@Test public function top () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (0, rect.top);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (-100, rect.top);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.top);
		
	}
	
	
	@Test public function topLeft () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isNotNull (rect.topLeft);
		Assert.isType (rect.topLeft, openfl.geom.Point);
		
		Assert.areEqual (0, rect.topLeft.x);
		Assert.areEqual (0, rect.topLeft.y);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (-100, rect.topLeft.x);
		Assert.areEqual (-100, rect.topLeft.y);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.topLeft.x);
		Assert.areEqual (0, rect.topLeft.y);
		
	}
	
	
	@Test public function width () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (100, rect.width);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (100, rect.width);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.width);
		
	}
	
	
	@Test public function x () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (0, rect.x);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (-100, rect.x);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.x);
		
	}
	
	
	@Test public function y () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.areEqual (0, rect.y);
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.areEqual (-100, rect.y);
		
		rect = new Rectangle (0, 0, 0, 0);
		
		Assert.areEqual (0, rect.y);
		
	}
	
	
	@Test public function new_ () {
		
		var rect = new Rectangle ();
		
		Assert.isNotNull (rect);
		Assert.areEqual (0, rect.x);
		Assert.areEqual (0, rect.y);
		Assert.areEqual (0, rect.width);
		Assert.areEqual (0, rect.height);
		
		rect = new Rectangle (100, 100, 100, 100);
		
		Assert.areEqual (100, rect.x);
		Assert.areEqual (100, rect.y);
		Assert.areEqual (100, rect.width);
		Assert.areEqual (100, rect.height);
		
	}
	
	
	@Test public function clone () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		var clone = rect.clone ();
		
		Assert.areNotSame (rect, clone);
		Assert.areEqual (rect.x, clone.x);
		Assert.areEqual (rect.y, clone.y);
		Assert.areEqual (rect.width, clone.width);
		Assert.areEqual (rect.height, clone.height);
		
	}
	
	
	@Test public function contains () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isTrue (rect.contains (0, 0));
		Assert.isTrue (rect.contains (99, 99));
		Assert.isFalse (rect.contains (100, 100));
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.isTrue (rect.contains (-1, -1));
		Assert.isTrue (rect.contains (-100, -100));
		Assert.isFalse (rect.contains (-101, -101));
		
	}
	
	
	#if lime_legacy @Ignore #end @Test public function containsPoint () {
		
		// This function works on the older native code, but sometimes causes
		// a race condition when run on the Travis CI servers
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isTrue (rect.containsPoint (new Point (0, 0)));
		Assert.isTrue (rect.containsPoint (new Point (99, 99)));
		Assert.isFalse (rect.containsPoint (new Point (100, 100)));
		
		rect = new Rectangle (-100, -100, 100, 100);
		
		Assert.isTrue (rect.containsPoint (new Point (-1, -1)));
		Assert.isTrue (rect.containsPoint (new Point (-100, -100)));
		Assert.isFalse (rect.containsPoint (new Point (-101, -101)));
		
	}
	
	
	@Test public function containsRect () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isTrue (rect.containsRect (new Rectangle (0, 0, 100, 100)));
		Assert.isFalse (rect.containsRect (new Rectangle ()));
		Assert.isFalse (rect.containsRect (new Rectangle (0, 0, 1, 0)));
		Assert.isTrue (rect.containsRect (new Rectangle (0, 0, 1, 1)));
		Assert.isTrue (rect.containsRect (new Rectangle (1, 1)));
		Assert.isFalse (rect.containsRect (new Rectangle (-1, 0, 100, 100)));
		Assert.isFalse (rect.containsRect (new Rectangle (0, 0, 100, 101)));
		
		rect = new Rectangle (-100, -100, 200, 200);
		
		Assert.isTrue (rect.containsRect (new Rectangle (-100, -100, 200, 200)));
		Assert.isTrue (rect.containsRect (new Rectangle ()));
		Assert.isFalse (rect.containsRect (new Rectangle (-100, -100)));
		Assert.isFalse (rect.containsRect (new Rectangle (100, 100)));
		Assert.isTrue (rect.containsRect (new Rectangle (99, 99)));
		Assert.isFalse (rect.containsRect (new Rectangle (-101, -100, 200, 200)));
		Assert.isFalse (rect.containsRect (new Rectangle (-100, -100, 201, 201)));
		
	}
	
	
	@Test public function copyFrom () {
		
		// TODO: Confirm functionality
		
		var rectangle = new Rectangle ();
		var exists = rectangle.copyFrom;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function equals () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isTrue (rect.equals (new Rectangle (0, 0, 100, 100)));
		Assert.isTrue (rect.equals (rect.clone ()));
		Assert.isFalse (rect.equals (new Rectangle (1, 0, 100, 100)));
		Assert.isFalse (rect.equals (new Rectangle (0, 0, 100, 101)));
		
	}
	
	
	@Test public function inflate () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.inflate (1, 0);
		
		Assert.areEqual (102, rect.width);
		Assert.areEqual (100, rect.height);
		Assert.areEqual (-1, rect.x);
		Assert.areEqual (0, rect.y);
		
		rect = new Rectangle (-100, -100, 100, 100);
		rect.inflate (2, 2);
		
		Assert.areEqual (104, rect.width);
		Assert.areEqual (2, rect.right);
		Assert.areEqual (-102, rect.x);
		Assert.areEqual (-102, rect.y);
		
		rect.inflate (-2, -2);
		
		Assert.areEqual (100, rect.width);
		Assert.areEqual (-100, rect.x);
		
	}
	
	
	@Test public function inflatePoint () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.inflatePoint (new Point (1, 0));
		
		Assert.areEqual (102, rect.width);
		Assert.areEqual (100, rect.height);
		Assert.areEqual (-1, rect.x);
		Assert.areEqual (0, rect.y);
		
		rect = new Rectangle (-100, -100, 100, 100);
		rect.inflatePoint (new Point (2, 2));
		
		Assert.areEqual (104, rect.width);
		Assert.areEqual (2, rect.right);
		Assert.areEqual (-102, rect.x);
		Assert.areEqual (-102, rect.y);
		
		rect.inflatePoint (new Point (-2, -2));
		
		Assert.areEqual (100, rect.width);
		Assert.areEqual (-100, rect.x);
		
	}
	
	
	@Test public function intersection () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isTrue (rect.intersection (new Rectangle ()).equals (new Rectangle ()));
		Assert.isTrue (rect.intersection (new Rectangle (50, 50, 100, 100)).equals (new Rectangle (50, 50, 50, 50)));
		Assert.isTrue (rect.intersection (new Rectangle (-50, -50, 100, 100)).equals (new Rectangle (0, 0, 50, 50)));
		Assert.isTrue (rect.intersection (new Rectangle (-100, -100, 100, 100)).equals (new Rectangle ()));
		
	}
	
	
	@Test public function intersects () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		
		Assert.isFalse (rect.intersects (new Rectangle ()));
		Assert.isTrue (rect.intersects (new Rectangle (50, 50, 100, 100)));
		Assert.isTrue (rect.intersects (new Rectangle (-50, -50, 100, 100)));
		Assert.isFalse (rect.intersects (new Rectangle (-100, -100, 100, 100)));
		
	}
	
	
	@Test public function isEmpty () {
		
		Assert.isTrue (new Rectangle ().isEmpty ());
		Assert.isTrue (new Rectangle (100, 100, -1, -1).isEmpty ());
		Assert.isTrue (new Rectangle (0, 0, -1, -1).isEmpty ());
		Assert.isTrue (new Rectangle (0, 0, 1, 0).isEmpty ());
		Assert.isFalse (new Rectangle (0, 0, 1, 1).isEmpty ());
		
	}
	
	
	@Test public function offset () {
		
		var rect = new Rectangle ();
		rect.offset (-1, -1);
		
		Assert.isTrue (rect.equals (new Rectangle (-1, -1, 0, 0)));
		
		rect.offset (1, 1);
		
		Assert.isTrue (rect.equals (new Rectangle ()));
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.offset (20, 0);
		
		Assert.isTrue (rect.equals (new Rectangle (20, 0, 100, 100)));
		
	}
	
	
	@Test public function offsetPoint () {
		
		var rect = new Rectangle ();
		rect.offsetPoint (new Point (-1, -1));
		
		Assert.isTrue (rect.equals (new Rectangle (-1, -1, 0, 0)));
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.offsetPoint (new Point (20, 0));
		
		Assert.isTrue (rect.equals (new Rectangle (20, 0, 100, 100)));
		
	}
	
	
	@Test public function setEmpty () {
		
		var rect = new Rectangle (0, 0, 100, 100);
		rect.setEmpty ();
		
		Assert.isTrue (rect.isEmpty ());
		
		rect = new Rectangle (0, 0, 100, 100);
		rect.setEmpty ();
		
		Assert.isTrue (rect.equals (new Rectangle ()));
		
	}
	
	
	@Test public function setTo () {
		
		// TODO: Confirm functionality
		
		var rectangle = new Rectangle ();
		var exists = rectangle.setTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
	@Test public function union () {
		
		Assert.isTrue (new Rectangle ().union (new Rectangle ()).isEmpty ());
		Assert.isTrue (new Rectangle ().union (new Rectangle (0, 0, 100, 100)).equals (new Rectangle (0, 0, 100, 100)));
		Assert.isTrue (new Rectangle (-100, -100, 100, 100).union (new Rectangle (-20, -20, 100, 100)).equals (new Rectangle (-100, -100, 180, 180)));
		Assert.isTrue (new Rectangle (-100, -100, 10, 10).union (new Rectangle (100, 100, 10, 10)).equals (new Rectangle (-100, -100, 210, 210)));
		
	}
	
	
}