package openfl.geom;


class PointTest { public static function __init__ () { Mocha.describe ("Haxe | Point", function () {
	
	
	Mocha.it ("length", function () {
		
		Assert.equal (new Point (0, 10).length, 10);
		Assert.equal (new Point (10, 0).length, 10);
		Assert.equal (new Point (-20, 0).length, 20);
		Assert.equal (new Point ().length, 0);
		
		Assert.equal (new Point (40, 40).length, Math.sqrt (40 * 40 + 40 * 40));
		
	});
	
	
	Mocha.it ("x", function () {
		
		var point = new Point ();
		
		Assert.equal (point.x, 0);
		
		point.x = 100;
		
		Assert.equal (point.x, 100);
		
	});
	
	
	Mocha.it ("y", function () {
		
		var point = new Point ();
		
		Assert.equal (point.x, 0);
		
		point.x = 100;
		
		Assert.equal (point.x, 100);
		
	});
	
	
	/*Mocha.it ("new", function () {
		
		
		
	}*/
	
	
	Mocha.it ("add", function () {
		
		var point = new Point ();
		
		Assert.assert (point.add (new Point (20, 20)).equals (new Point (20, 20)));
		
		point = new Point (-20, 0);
		
		Assert.assert (point.add (new Point (20, 20)).equals (new Point (0, 20)));
		
		point = new Point ();
		point.add (new Point (20, 100));
		
		Assert.assert (point.equals (new Point ()));
		
	});
	
	
	Mocha.it ("clone", function () {
		
		var point = new Point ();
		
		Assert.notEqual (point, point.clone ());
		Assert.assert (point.equals (point.clone ()));
		
		point = new Point (-20, 100);
		
		Assert.notEqual (point, point.clone ());
		Assert.assert (point.equals (point.clone ()));
		
	});
	
	
	Mocha.it ("copyFrom", function () {
		
		
		
	});
	
	
	Mocha.it ("equals", function () {
		
		var point = new Point ();
		
		Assert.assert (point.equals (new Point ()));
		
		var point = new Point (-40, 100);
		
		Assert.assert (point.equals (new Point (-40, 100)));
		
	});
	
	
	Mocha.it ("normalize", function () {
		
		var point = new Point ();
		point.normalize (0);
		
		Assert.assert (point.equals (new Point ()));
		
		point = new Point ();
		point.normalize (1);
		
		Assert.assert (point.equals (new Point ()));
		
		point = new Point (100, 100);
		point.normalize (point.length / 2);
		
		Assert.assert (point.equals (new Point (50, 50)));
		
		point = new Point (0, 100);
		point.normalize (1);
		
		Assert.assert (point.equals (new Point (0, 1)));
		
	});
	
	
	Mocha.it ("offset", function () {
		
		var point = new Point ();
		point.offset (10, 100);
		
		Assert.assert (point.equals (new Point (10, 100)));
		
		point.offset (-10, 0);
		
		Assert.assert (point.equals (new Point (0, 100)));
		
		
	});
	
	
	Mocha.it ("setTo", function () {
		
		// TODO: Confirm functionality
		
		var point = new Point ();
		var exists = point.setTo;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("subtract", function () {
		
		var point = new Point ();
		
		Assert.assert (point.subtract (new Point (20, 20)).equals (new Point (-20, -20)));
		
		point = new Point (-20, 0);
		
		Assert.assert (point.subtract (new Point (20, 20)).equals (new Point (-40, -20)));
		
		point = new Point ();
		point.subtract (new Point (20, 100));
		
		Assert.assert (point.equals (new Point ()));
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
	Mocha.it ("distance", function () {
		
		Assert.equal (Point.distance (new Point (), new Point (100, 0)), 100);
		Assert.equal (Point.distance (new Point (0, -20), new Point (0, 100)), 120);
		
		var differenceX = 100 - 20;
		var differenceY = 20 - 10;
		
		var distance = Math.sqrt ((differenceX * differenceX) + (differenceY * differenceY));
		
		Assert.equal (Point.distance (new Point (100, 20), new Point (20, 10)), distance);
		
	});
	
	
	Mocha.it ("interpolate", function () {
		
		Assert.assert (Point.interpolate (new Point (), new Point (100, 100), 0.5).equals (new Point (50, 50)));
		Assert.assert (Point.interpolate (new Point (), new Point (100, 100), 0.2).equals (new Point (80, 80)));
		
		var point = new Point (-200, 100);
		
		Assert.equal (Point.interpolate (point, new Point (), 0.1).length, point.length * 0.1);
		
	});
	
	
	Mocha.it ("polar", function () {
		
		Assert.assert (Point.polar (1, 0).equals (new Point (1, 0)));
		Assert.equal (Point.polar (10, -Math.PI).x, -10);
		
	});
	
	
}); }}