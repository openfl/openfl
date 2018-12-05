


import openfl.errors.Error;


describe ("TypeScript | Vector", function () {
	
	
	it ("length", function () {
		
		var vector = new Vector<Int> (1);
		vector.length = 0;
		
		assert.equal (vector.length, 0);
		
		vector.length = 2;
		
		assert.equal (vector.length, 2);
		assert.equal (vector[0], 0);
		
		var vector = new Vector<Float> ();
		vector.length = 2;
		
		assert.equal (vector[0], 0);
		
		var vector = new Vector<Bool> ();
		vector.length = 2;
		
		assert.equal (vector[0], false);
		
		var vector = new Vector<Int> (10);
		
		assert.equal (vector.length, 10);
		
		var vector = new Vector<String> ();
		vector.length = 2;
		
		assert.equal (vector[0], null);
		
		try {
			
			var invalid = vector[3];
			assert.ok (false);
			
		} catch (e:Dynamic) {}
		
	});
	
	
	it ("fixed", function () {
		
		var vector = new Vector<Int> (0, true);
		
		#if !cpp // for performance, C++ does not match here
		try {
			vector.length = 10;
		} catch (e:Dynamic) {}
		#end
		
		assert.equal (vector.length, 0);
		vector.fixed = false;
		vector.length = 10;
		assert.equal (vector.length, 10);
		vector.fixed = true;
		
		#if !cpp // for performance, C++ does not match here
		try {
			vector.push (1);
		} catch (e:Dynamic) {}
		#end
		
		assert.equal (10, vector.length);
		
		#if !cpp // for performance, C++ does not match here
		try {
			vector.unshift (100);
		} catch (e:Dynamic) {}
		#end
		
		assert.equal (vector.length, 10);
		assert.equal (vector[0], 0);
		
		var vector2 = new Vector<Int> ();
		vector2.push (1);
		vector = vector.concat (vector2);
		assert.equal (vector.length, 11);
		assert (!vector.fixed);
		
		vector[9] = 100;
		
		assert.equal (vector.pop (), 1);
		assert.equal (vector.length, 10);
		assert.equal (vector[9], 100);
		vector.shift ();
		
		assert.equal (vector.length, 9);
		assert.equal (vector[0], 0);
		
		vector.fixed = true;
		var vector = vector.splice (0, 2);
		assert (!vector.fixed);
		
		assert.equal (vector.length, 2);
		
		vector = new Vector<Int> (10, true);
		assert.equal (vector.length, 10);
		var vector2 = vector.slice (0, 2);
		
		assert.equal (vector.length, 10);
		
	});
	
	
	it ("new", function () {
		
		var vector = new Vector<Int> ();
		
		assert.equal (vector.length, 0);
		assert (!vector.fixed);
		
		var vector = new Vector<Int> (10, true);
		
		assert.equal (vector.length, 10);
		
		#if !cpp // for performance, C++ does not match here
		assert (vector.fixed);
		#end
		
	});
	
	
	it ("concat", function () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		
		var vector2 = new Vector<Int> ();
		vector2.push (1);
		
		vector = vector.concat (vector2);
		
		assert.equal (vector.length, 2);
		assert (!vector.fixed);
		assert.equal (vector[0], 0);
		assert.equal (vector2[0], 1);
		assert.equal (vector[1], 1);
		
	});
	
	
	it ("join", function () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		
		assert.equal (vector.join (","), "0");
		
		vector.push (1);
		
		assert.equal (vector.join (","), "0,1");
		
	});
	
	
	it ("pop", function () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		
		assert.equal (vector.pop (), 1);
		assert.equal (vector.length, 1);
		
	});
	
	
	it ("push", function () {
		
		var vector = new Vector<Int> ();
		vector.push (1);
		
		assert.equal (vector.length, 1);
		assert.equal (vector[0], 1);
		
	});
	
	
	it ("reverse", function () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		vector.reverse ();
		
		assert.equal (vector[0], 1);
		assert.equal (vector[1], 0);
		
	});
	
	
	it ("shift", function () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		
		assert.equal (vector[0], 0);
		assert.equal (vector.shift (), 0);
		assert.equal (vector.length, 1);
		
	});
	
	
	it ("unshift", function () {
		
		var vector = new Vector<Int> ();
		vector.push (0);
		vector.push (1);
		vector.unshift (2);
		
		assert.equal (vector[0], 2);
		assert.equal (vector.length, 3);
		
	});
	
	
	it ("slice", function () {
		
		var vector = new Vector<Int> (10);
		
		for (i in 0...10) {
			
			vector[i] = i;
			
		}
		
		var vector2 = vector.slice ();
		
		for (i in 0...vector.length) {
			
			assert.equal (vector2[i], vector[i]);
			
		}
		
		assert.notEqual (vector, vector2);
		
		var vector2 = vector.slice (2);
		
		assert.equal (vector2.length, 8);
		assert.equal (vector2[0], 2);
		assert.equal (vector.length, 10);
		assert.equal (vector[0], 0);
		
		var vector2 = vector.slice (2, -1);
		
		assert.equal (vector2.length, 7);
		assert.equal (vector2[0], 2);
		assert.equal (vector.length, 10);
		assert.equal (vector[0], 0);
		
		var vector2 = vector.slice (4, 11);
		
		assert.equal (vector2.length, 6);
		
		var vector2 = vector.slice (-2);
		
		assert.equal (vector2.length, 2);
		assert.equal (vector2[0], 8);
		
	});
	
	
	it ("sort", function () {
		
		var sort = function (a:Int, b:Int):Int {
			
			return a - b;
			
		}
		
		var vector = Vector.ofArray ([ 10, 2, 4, 5, 9, 1, 7, 3, 6, 8 ]);
		vector.sort (sort);
		
		var lastValue = 0;
		
		for (i in 0...vector.length) {
			
			assert (vector[i] >= lastValue);
			lastValue = vector[i];
			
		}
		
	});
	
	
	it ("splice", function () {
		
		var vector = new Vector<Int> (10);
		
		for (i in 0...10) {
			
			vector[i] = i;
			
		}
		
		var vector2 = vector.splice (-1, -1);
		
		assert.equal (vector2.length, 0);
		assert.equal (vector.length, 10);
		
		var vector2 = vector.splice (-1, 0);
		
		assert.equal (vector2.length, 0);
		assert.equal (vector.length, 10);
		
		var vector2 = vector.splice (-1, 1);
		
		assert.equal (vector2.length, 1);
		assert.equal (vector2[0], 9);
		assert.equal (vector.length, 9);
		
		vector2 = vector.splice (2, 3);
		
		assert.equal (vector2.length, 3);
		assert.equal (vector2[0], 2);
		assert.equal (vector.length, 6);
		
		vector2 = vector.splice (5, 20);
		
		assert.equal (vector2.length, 1);
		assert.equal (vector.length, 5);
		
	});
	
	
	/*public function toString", function () {
		
		
		
	}*/
	
	
	it ("indexOf", function () {
		
		var vector = new Vector<Int> (20);
		
		for (i in 0...10) {
			
			vector[i] = vector[i + 10] = i;
			
		}
		
		assert.equal (vector.indexOf (9), 9);
		assert.equal (vector.indexOf (2), 2);
		
	});
	
	
	it ("iterator", function () {
		
		var vector = new Vector<Int> (10);
		
		for (i in 0...10) {
			
			vector[i] = i;
			
		}
		
		vector.push (10);
		
		var iterations = 0;
		
		for (i in vector) {
			
			assert.equal (vector[iterations], iterations);
			iterations++;
			
		}
		
		assert.equal (iterations, 11);
		
	});
	
	
	it ("lastIndexOf", function () {
		
		var vector = new Vector<Int> (20);
		
		for (i in 0...10) {
			
			vector[i] = vector[i + 10] = i;
			
		}
		
		assert.equal (vector.lastIndexOf (9), 19);
		assert.equal (vector.lastIndexOf (2), 12);
		
	});
	
	
	it ("ofArray", function () {
		
		var array = new Array<Int> ();
		
		for (i in 0...10) {
			
			array[i] = i;
			
		}
		
		var vector = Vector.ofArray (array);
		
		assert.equal (vector.length, 10);
		assert.equal (vector[4], 4);
		
	});
	
	
	it ("convert", function () {
		
		
		
	});
	
	
	it ("arrayAccess", function () {
		
		var vector = new Vector<Int> ();
		
		assert.equal (vector.length, 0);
		
		// Flash allows array access to one greater 
		// than the length, if not fixed
		
		vector[0] = 100;
		
		assert.equal (vector.length, 1);
		assert.equal (vector[0], 100);
		
	});
	
	
	#if (!html5 && !flash) @Ignore #end it ("intVectorStringify", function () {
		// Testing if we have the same stringify behavior in JS and flash
		var expected: String = "[1,2]";
		var stringyfied: String = null;
		var vector: Vector<Int> = new Vector<Int> ();
		
		vector.push(1);
		vector.push(2);
		
		stringyfied = haxe.Json.stringify(vector);
		
		assert.equal (stringyfied, expected);
	});
	
	
	#if (!html5 && !flash) @Ignore #end it ("boolVectorStringify", function () {
		// Testing if we have the same stringify behavior in JS and flash
		var expected: String = "[false,true]";
		var stringyfied: String = null;
		var vector: Vector<Bool> = new Vector<Bool> ();
		
		vector.push(false);
		vector.push(true);
		
		stringyfied = haxe.Json.stringify(vector);
		
		assert.equal (stringyfied, expected);
	});
	
	
	#if (!html5 && !flash) @Ignore #end it ("floatVectorStringify", function () {
		// Testing if we have the same stringify behavior in JS and flash
		var expected: String = "[1.1,2.2]";
		var stringyfied: String = null;
		var vector: Vector<Float> = new Vector<Float> ();
		
		vector.push(1.1);
		vector.push(2.2);
		
		stringyfied = haxe.Json.stringify(vector);
		
		assert.equal (stringyfied, expected);
	});
	
	
	#if (!html5 && !flash) @Ignore #end it ("objectVectorStringify", function () {
		// Testing if we have the same stringify behavior in JS and flash
		var expected: String = null;
		var stringyfied: String = null;
		var obj: Error = new Error("Message", 1);
		var strObj: String = haxe.Json.stringify(obj);
		var vector: Vector<Error> = new Vector<Error> ();
		
		vector.push(obj);
		
		stringyfied = haxe.Json.stringify(vector);
		expected = "[" + strObj + "]";
		
		assert.equal (stringyfied, expected);
		
		// Testing stringify inside object
		var obj: Dynamic = {id: 5, errors: vector};
		
		stringyfied = haxe.Json.stringify(obj);
		
		// Testing if stringify inside object is still the same as outside
		assert (stringyfied.indexOf(expected) != -1);
		
		// Check lengh and __array aren't stringified
		assert.equal(stringyfied.indexOf("length"), -1);
		assert.equal(stringyfied.indexOf("__array"), -1);
	});
	
	
});