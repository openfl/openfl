import Point from "openfl/geom/Point";
import * as assert from "assert";


describe ("ES6 | Point", function () {
	
	
	it ("length", function () {
		
		assert.equal (new Point (0, 10).length, 10);
		assert.equal (new Point (10, 0).length, 10);
		assert.equal (new Point (-20, 0).length, 20);
		assert.equal (new Point ().length, 0);
		
		assert.equal (new Point (40, 40).length, Math.sqrt (40 * 40 + 40 * 40));
		
	});
	
	
	it ("x", function () {
		
		var point = new Point ();
		
		assert.equal (point.x, 0);
		
		point.x = 100;
		
		assert.equal (point.x, 100);
		
	});
	
	
	it ("y", function () {
		
		var point = new Point ();
		
		assert.equal (point.x, 0);
		
		point.x = 100;
		
		assert.equal (point.x, 100);
		
	});
	
	
	/*it ("new", function () {
		
		
		
	}*/
	
	
	it ("add", function () {
		
		var point = new Point ();
		
		assert (point.add (new Point (20, 20)).equals (new Point (20, 20)));
		
		point = new Point (-20, 0);
		
		assert (point.add (new Point (20, 20)).equals (new Point (0, 20)));
		
		point = new Point ();
		point.add (new Point (20, 100));
		
		assert (point.equals (new Point ()));
		
	});
	
	
	it ("clone", function () {
		
		var point = new Point ();
		
		assert.notEqual (point, point.clone ());
		assert (point.equals (point.clone ()));
		
		point = new Point (-20, 100);
		
		assert.notEqual (point, point.clone ());
		assert (point.equals (point.clone ()));
		
	});
	
	
	it ("copyFrom", function () {
		
		
		
	});
	
	
	it ("equals", function () {
		
		var point = new Point ();
		
		assert (point.equals (new Point ()));
		
		var point = new Point (-40, 100);
		
		assert (point.equals (new Point (-40, 100)));
		
	});
	
	
	it ("normalize", function () {
		
		var point = new Point ();
		point.normalize (0);
		
		assert (point.equals (new Point ()));
		
		point = new Point ();
		point.normalize (1);
		
		assert (point.equals (new Point ()));
		
		point = new Point (100, 100);
		point.normalize (point.length / 2);
		
		assert (point.equals (new Point (50, 50)));
		
		point = new Point (0, 100);
		point.normalize (1);
		
		assert (point.equals (new Point (0, 1)));
		
	});
	
	
	it ("offset", function () {
		
		var point = new Point ();
		point.offset (10, 100);
		
		assert (point.equals (new Point (10, 100)));
		
		point.offset (-10, 0);
		
		assert (point.equals (new Point (0, 100)));
		
		
	});
	
	
	it ("setTo", function () {
		
		// TODO: Confirm functionality
		
		var point = new Point ();
		var exists = point.setTo;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("subtract", function () {
		
		var point = new Point ();
		
		assert (point.subtract (new Point (20, 20)).equals (new Point (-20, -20)));
		
		point = new Point (-20, 0);
		
		assert (point.subtract (new Point (20, 20)).equals (new Point (-40, -20)));
		
		point = new Point ();
		point.subtract (new Point (20, 100));
		
		assert (point.equals (new Point ()));
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
	it ("distance", function () {
		
		assert.equal (Point.distance (new Point (), new Point (100, 0)), 100);
		assert.equal (Point.distance (new Point (0, -20), new Point (0, 100)), 120);
		
		var differenceX = 100 - 20;
		var differenceY = 20 - 10;
		
		var distance = Math.sqrt ((differenceX * differenceX) + (differenceY * differenceY));
		
		assert.equal (Point.distance (new Point (100, 20), new Point (20, 10)), distance);
		
	});
	
	
	it ("interpolate", function () {
		
		assert (Point.interpolate (new Point (), new Point (100, 100), 0.5).equals (new Point (50, 50)));
		assert (Point.interpolate (new Point (), new Point (100, 100), 0.2).equals (new Point (80, 80)));
		
		var point = new Point (-200, 100);
		
		assert.equal (Point.interpolate (point, new Point (), 0.1).length, point.length * 0.1);
		
	});
	
	
	it ("polar", function () {
		
		assert (Point.polar (1, 0).equals (new Point (1, 0)));
		assert.equal (Point.polar (10, -Math.PI).x, -10);
		
	});
	
	
});