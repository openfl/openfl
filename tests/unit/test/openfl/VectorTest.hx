package openfl;


import massive.munit.Assert;


class VectorTest {
	
	
	@Test public function length () {
		
		var vector = new Vector<Int> (1);
		vector.length = 0;
		
		Assert.areEqual (0, vector.length);
		
		vector.length = 2;
		
		Assert.areEqual (2, vector.length);
		#if (js || neko)
		Assert.areEqual (null, vector[0]);
		#else
		Assert.areEqual (0, vector[0]);
		#end
		
		var vector = new Vector<Float> ();
		vector.length = 2;
		
		#if (js || neko)
		Assert.areEqual (null, vector[0]);
		#else
		Assert.areEqual (0, vector[0]);
		#end
		
		var vector = new Vector<Bool> ();
		vector.length = 2;
		
		#if (js || neko)
		Assert.areEqual (null, vector[0]);
		#else
		Assert.areEqual (false, vector[0]);
		#end
		
		var vector = new Vector<Int> (10);
		
		Assert.areEqual (10, vector.length);
		
		var vector = new Vector<String> ();
		vector.length = 2;
		
		Assert.areEqual (null, vector[0]);
		
		try {
			
			var invalid = vector[3];
			Assert.fail ("");
			
		} catch (e:Dynamic) {}
		
	}
	
	
	@Test public function fixed () {
		
		var vector = new Vector<Int> (0, true);
		
		#if !cpp // for performance, C++ does not match here
		try {
			vector.length = 10;
		} catch (e:Dynamic) {}
		#end
		
		Assert.areEqual (0, vector.length);
		vector.fixed = false;
		vector.length = 10;
		Assert.areEqual (10, vector.length);
		vector.fixed = true;
		
		#if !cpp // for performance, C++ does not match here
		try {
			vector.push (1);
		} catch (e:Dynamic) {}
		#end
		
		Assert.areEqual (10, vector.length);
		
		#if !cpp // for performance, C++ does not match here
		try {
			vector.unshift (100);
		} catch (e:Dynamic) {}
		#end
		
		Assert.areEqual (10, vector.length);
		#if (js || neko)
		Assert.areEqual (null, vector[0]);
		#else
		Assert.areEqual (0, vector[0]);
		#end
		
		var vector2 = new Vector<Int> ();
		vector2.push (1);
		vector = vector.concat (vector2);
		Assert.areEqual (11, vector.length);
		Assert.isFalse (vector.fixed);
		
		vector[9] = 100;
		
		Assert.areEqual (1, vector.pop ());
		Assert.areEqual (10, vector.length);
		Assert.areEqual (100, vector[9]);
		vector.shift ();
		
		Assert.areEqual (9, vector.length);
		#if (js || neko)
		Assert.areEqual (null, vector[0]);
		#else
		Assert.areEqual (0, vector[0]);
		#end
		
		vector.fixed = true;
		var vector = vector.splice (0, 2);
		Assert.isFalse (vector.fixed);
		
		Assert.areEqual (2, vector.length);
		
		vector = new Vector<Int> (10, true);
		Assert.areEqual (10, vector.length);
		var vector2 = vector.slice (0, 2);
		
		Assert.areEqual (10, vector.length);
		
	}
	
	
	@Test public function new_ () {
		
		var vector = new Vector<Int> ();
		
		Assert.areEqual (0, vector.length);
		Assert.isFalse (vector.fixed);
		
		var vector = new Vector<Int> (10, true);
		
		Assert.areEqual (10, vector.length);
		
		#if !cpp // for performance, C++ does not match here
		Assert.isTrue (vector.fixed);
		#end
		
	}
	
	
	@Test public function concat () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		
		var vector2 = new Vector<Int> ();
		vector2.push (1);
		
		vector = vector.concat (vector2);
		
		Assert.areEqual (2, vector.length);
		Assert.isFalse (vector.fixed);
		Assert.areEqual (0, vector[0]);
		Assert.areEqual (1, vector2[0]);
		Assert.areEqual (1, vector[1]);
		
	}
	
	
	@Test public function join () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		
		Assert.areEqual ("0", vector.join (","));
		
		vector.push (1);
		
		Assert.areEqual ("0,1", vector.join (","));
		
	}
	
	
	@Test public function pop () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		
		Assert.areEqual (1, vector.pop ());
		Assert.areEqual (1, vector.length);
		
	}
	
	
	@Test public function push () {
		
		var vector = new Vector<Int> ();
		vector.push (1);
		
		Assert.areEqual (1, vector.length);
		Assert.areEqual (1, vector[0]);
		
	}
	
	
	@Test public function reverse () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		vector.reverse ();
		
		Assert.areEqual (1, vector[0]);
		Assert.areEqual (0, vector[1]);
		
	}
	
	
	@Test public function shift () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		
		Assert.areEqual (0, vector[0]);
		Assert.areEqual (0, vector.shift ());
		Assert.areEqual (1, vector.length);
		
	}
	
	
	@Test public function unshift () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		vector.unshift (2);
		
		Assert.areEqual (2, vector[0]);
		Assert.areEqual (3, vector.length);
		
	}
	
	
	@Test public function slice () {
		
		var vector = new Vector<Int> (10);
		
		for (i in 0...10) {
			
			vector[i] = i;
			
		}
		
		var vector2 = vector.slice ();
		
		for (i in 0...vector.length) {
			
			Assert.areEqual (vector[i], vector2[i]);
			
		}
		
		Assert.areNotSame (vector, vector2);
		
		var vector2 = vector.slice (2);
		
		Assert.areEqual (8, vector2.length);
		Assert.areEqual (2, vector2[0]);
		Assert.areEqual (10, vector.length);
		Assert.areEqual (0, vector[0]);
		
		var vector2 = vector.slice (2, -1);
		
		Assert.areEqual (7, vector2.length);
		Assert.areEqual (2, vector2[0]);
		Assert.areEqual (10, vector.length);
		Assert.areEqual (0, vector[0]);
		
		var vector2 = vector.slice (4, 11);
		
		Assert.areEqual (6, vector2.length);
		
		var vector2 = vector.slice (-2);
		
		Assert.areEqual (2, vector2.length);
		Assert.areEqual (8, vector2[0]);
		
	}
	
	
	@Test public function sort () {
		
		var sort = function (a:Int, b:Int):Int {
			
			return a - b;
			
		}
		
		var vector = Vector.ofArray ([ 10, 2, 4, 5, 9, 1, 7, 3, 6, 8 ]);
		vector.sort (sort);
		
		var lastValue = 0;
		
		for (i in 0...vector.length) {
			
			Assert.isTrue (vector[i] >= lastValue);
			lastValue = vector[i];
			
		}
		
	}
	
	
	@Test public function splice () {
		
		var vector = new Vector<Int> (10);
		
		for (i in 0...10) {
			
			vector[i] = i;
			
		}
		
		var vector2 = vector.splice (-1, -1);
		
		Assert.areEqual (0, vector2.length);
		Assert.areEqual (10, vector.length);
		
		var vector2 = vector.splice (-1, 0);
		
		Assert.areEqual (0, vector2.length);
		Assert.areEqual (10, vector.length);
		
		var vector2 = vector.splice (-1, 1);
		
		Assert.areEqual (1, vector2.length);
		Assert.areEqual (9, vector2[0]);
		Assert.areEqual (9, vector.length);
		
		vector2 = vector.splice (2, 3);
		
		Assert.areEqual (3, vector2.length);
		Assert.areEqual (2, vector2[0]);
		Assert.areEqual (6, vector.length);
		
		vector2 = vector.splice (5, 20);
		
		Assert.areEqual (1, vector2.length);
		Assert.areEqual (5, vector.length);
		
	}
	
	
	/*public function toString () {
		
		
		
	}*/
	
	
	@Test public function indexOf () {
		
		var vector = new Vector<Int> (20);
		
		for (i in 0...10) {
			
			vector[i] = vector[i + 10] = i;
			
		}
		
		Assert.areEqual (9, vector.indexOf (9));
		Assert.areEqual (2, vector.indexOf (2));
		
	}
	
	
	@Test public function iterator () {
		
		var vector = new Vector<Int> (10);
		
		for (i in 0...10) {
			
			vector[i] = i;
			
		}
		
		vector.push (10);
		
		var iterations = 0;
		
		for (i in vector) {
			
			Assert.areEqual (iterations, vector[iterations]);
			iterations++;
			
		}
		
		Assert.areEqual (11, iterations);
		
	}
	
	
	@Test public function lastIndexOf () {
		
		var vector = new Vector<Int> (20);
		
		for (i in 0...10) {
			
			vector[i] = vector[i + 10] = i;
			
		}
		
		Assert.areEqual (19, vector.lastIndexOf (9));
		Assert.areEqual (12, vector.lastIndexOf (2));
		
	}
	
	
	@Test public function ofArray () {
		
		var array = new Array<Int> ();
		
		for (i in 0...10) {
			
			array[i] = i;
			
		}
		
		var vector = Vector.ofArray (array);
		
		Assert.areEqual (10, vector.length);
		Assert.areEqual (4, vector[4]);
		
	}
	
	
	@Test public function convert () {
		
		
		
	}
	
	
	@Test public function arrayAccess () {
		
		var vector = new Vector<Int> ();
		
		Assert.areEqual (0, vector.length);
		
		// Flash allows array access to one greater 
		// than the length, if not fixed
		
		vector[0] = 100;
		
		Assert.areEqual (1, vector.length);
		Assert.areEqual (100, vector[0]);
		
	}
	
	
}