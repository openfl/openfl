package openfl.geom;


import massive.munit.Assert;


class PointTest {
	
	
	@Test public function length () {
		
		Assert.areEqual (10, new Point (0, 10).length);
		Assert.areEqual (10, new Point (10, 0).length);
		Assert.areEqual (20, new Point (-20, 0).length);
		Assert.areEqual (0, new Point ().length);
		
		Assert.areEqual (Math.sqrt (40 * 40 + 40 * 40), new Point (40, 40).length);
		
	}
	
	
	@Test public function x () {
		
		var point = new Point ();
		
		Assert.areEqual (0, point.x);
		
		point.x = 100;
		
		Assert.areEqual (100, point.x);
		
	}
	
	
	@Test public function y () {
		
		var point = new Point ();
		
		Assert.areEqual (0, point.x);
		
		point.x = 100;
		
		Assert.areEqual (100, point.x);
		
	}
	
	
	/*@Test public function new_ () {
		
		
		
	}*/
	
	
	@Test public function add () {
		
		var point = new Point ();
		
		Assert.isTrue (point.add (new Point (20, 20)).equals (new Point (20, 20)));
		
		point = new Point (-20, 0);
		
		Assert.isTrue (point.add (new Point (20, 20)).equals (new Point (0, 20)));
		
		point = new Point ();
		point.add (new Point (20, 100));
		
		Assert.isTrue (point.equals (new Point ()));
		
	}
	
	
	@Test public function clone () {
		
		var point = new Point ();
		
		Assert.areNotSame (point, point.clone ());
		Assert.isTrue (point.equals (point.clone ()));
		
		point = new Point (-20, 100);
		
		Assert.areNotSame (point, point.clone ());
		Assert.isTrue (point.equals (point.clone ()));
		
	}
	
	
	@Test public function copyFrom () {
		
		
		
	}
	
	
	@Test public function equals () {
		
		var point = new Point ();
		
		Assert.isTrue (point.equals (new Point ()));
		
		var point = new Point (-40, 100);
		
		Assert.isTrue (point.equals (new Point (-40, 100)));
		
	}
	
	
	@Test public function normalize () {
		
		var point = new Point ();
		point.normalize (0);
		
		Assert.isTrue (point.equals (new Point ()));
		
		point = new Point ();
		point.normalize (1);
		
		Assert.isTrue (point.equals (new Point ()));
		
		point = new Point (100, 100);
		point.normalize (point.length / 2);
		
		Assert.isTrue (point.equals (new Point (50, 50)));
		
		point = new Point (0, 100);
		point.normalize (1);
		
		Assert.isTrue (point.equals (new Point (0, 1)));
		
	}
	
	
	@Test public function offset () {
		
		var point = new Point ();
		point.offset (10, 100);
		
		Assert.isTrue (point.equals (new Point (10, 100)));
		
		point.offset (-10, 0);
		
		Assert.isTrue (point.equals (new Point (0, 100)));
		
		
	}
	
	
	@Test public function setTo () {
		
		// TODO: Confirm functionality
		
		var point = new Point ();
		var exists = point.setTo;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function subtract () {
		
		var point = new Point ();
		
		Assert.isTrue (point.subtract (new Point (20, 20)).equals (new Point (-20, -20)));
		
		point = new Point (-20, 0);
		
		Assert.isTrue (point.subtract (new Point (20, 20)).equals (new Point (-40, -20)));
		
		point = new Point ();
		point.subtract (new Point (20, 100));
		
		Assert.isTrue (point.equals (new Point ()));
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
	@Test public function distance () {
		
		Assert.areEqual (100, Point.distance (new Point (), new Point (100, 0)));
		Assert.areEqual (120, Point.distance (new Point (0, -20), new Point (0, 100)));
		
		var differenceX = 100 - 20;
		var differenceY = 20 - 10;
		
		var distance = Math.sqrt ((differenceX * differenceX) + (differenceY * differenceY));
		
		Assert.areEqual (distance, Point.distance (new Point (100, 20), new Point (20, 10)));
		
	}
	
	
	@Test public function interpolate () {
		
		Assert.isTrue (Point.interpolate (new Point (), new Point (100, 100), 0.5).equals (new Point (50, 50)));
		Assert.isTrue (Point.interpolate (new Point (), new Point (100, 100), 0.2).equals (new Point (80, 80)));
		
		var point = new Point (-200, 100);
		
		Assert.areEqual (point.length * 0.1, Point.interpolate (point, new Point (), 0.1).length);
		
	}
	
	
	@Test public function polar () {
		
		Assert.isTrue (Point.polar (1, 0).equals (new Point (1, 0)));
		Assert.areEqual (-10, Point.polar (10, -Math.PI).x);
		
	}
	
	
}