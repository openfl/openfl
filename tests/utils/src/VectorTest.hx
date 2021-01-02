package;

import openfl.errors.Error;
import openfl.Vector;
import utest.Assert;
import utest.Test;

class VectorTest extends Test
{
	public function test_length()
	{
		var vector = new Vector<Int>(1);
		vector.length = 0;

		Assert.equals(0, vector.length);

		vector.length = 2;

		Assert.equals(2, vector.length);
		Assert.equals(0, vector[0]);

		var vector = new Vector<Float>();
		vector.length = 2;

		Assert.equals(0, vector[0]);

		var vector = new Vector<Bool>();
		vector.length = 2;

		Assert.equals(false, vector[0]);

		var vector = new Vector<Int>(10);

		Assert.equals(10, vector.length);

		var vector = new Vector<String>();
		vector.length = 2;

		Assert.equals(null, vector[0]);

		// try
		// {
		// 	var invalid = vector[3];
		// 	Assert.fail("");
		// }
		// catch (e:Dynamic) {}
	}

	public function test_fixed()
	{
		var vector = new Vector<Int>(0, true);

		#if !cpp // for performance, C++ does not match here
		try
		{
			vector.length = 10;
		}
		catch (e:Dynamic) {}
		#end

		Assert.equals(0, vector.length);
		vector.fixed = false;
		vector.length = 10;
		Assert.equals(10, vector.length);
		vector.fixed = true;

		#if !cpp // for performance, C++ does not match here
		try
		{
			vector.push(1);
		}
		catch (e:Dynamic) {}
		#end

		Assert.equals(10, vector.length);

		#if !cpp // for performance, C++ does not match here
		try
		{
			vector.unshift(100);
		}
		catch (e:Dynamic) {}
		#end

		Assert.equals(10, vector.length);
		Assert.equals(0, vector[0]);

		var vector2 = new Vector<Int>();
		vector2.push(1);
		vector = vector.concat(vector2);
		Assert.equals(11, vector.length);
		Assert.isFalse(vector.fixed);

		vector[9] = 100;

		Assert.equals(1, vector.pop());
		Assert.equals(10, vector.length);
		Assert.equals(100, vector[9]);
		vector.shift();

		Assert.equals(9, vector.length);
		Assert.equals(0, vector[0]);

		vector.fixed = true;
		var vector = vector.splice(0, 2);
		Assert.isFalse(vector.fixed);

		Assert.equals(2, vector.length);

		vector = new Vector<Int>(10, true);
		Assert.equals(10, vector.length);
		var vector2 = vector.slice(0, 2);

		Assert.equals(10, vector.length);
	}

	public function test_new_()
	{
		var vector = new Vector<Int>();

		Assert.equals(0, vector.length);
		Assert.isFalse(vector.fixed);

		var vector = new Vector<Int>(10, true);

		Assert.equals(10, vector.length);

		#if !cpp // for performance, C++ does not match here
		Assert.isTrue(vector.fixed);
		#end
	}

	public function test_concat()
	{
		var vector = new Vector<Int>();
		vector.push(0);

		var vector2 = new Vector<Int>();
		vector2.push(1);

		vector = vector.concat(vector2);

		Assert.equals(2, vector.length);
		Assert.isFalse(vector.fixed);
		Assert.equals(0, vector[0]);
		Assert.equals(1, vector2[0]);
		Assert.equals(1, vector[1]);
	}

	public function test_join()
	{
		var vector = new Vector<Int>();
		vector.push(0);

		Assert.equals("0", vector.join(","));

		vector.push(1);

		Assert.equals("0,1", vector.join(","));
	}

	public function test_pop()
	{
		var vector = new Vector<Int>();
		vector.push(0);
		vector.push(1);

		Assert.equals(1, vector.pop());
		Assert.equals(1, vector.length);
	}

	public function test_push()
	{
		var vector = new Vector<Int>();
		vector.push(1);

		Assert.equals(1, vector.length);
		Assert.equals(1, vector[0]);
	}

	public function test_reverse()
	{
		var vector = new Vector<Int>();
		vector.push(0);
		vector.push(1);
		vector.reverse();

		Assert.equals(1, vector[0]);
		Assert.equals(0, vector[1]);
	}

	public function test_shift()
	{
		var vector = new Vector<Int>();
		vector.push(0);
		vector.push(1);

		Assert.equals(0, vector[0]);
		Assert.equals(0, vector.shift());
		Assert.equals(1, vector.length);
	}

	public function test_unshift()
	{
		var vector = new Vector<Int>();
		vector.push(0);
		vector.push(1);
		vector.unshift(2);

		Assert.equals(2, vector[0]);
		Assert.equals(3, vector.length);
	}

	public function test_slice()
	{
		var vector = new Vector<Int>(10);

		for (i in 0...10)
		{
			vector[i] = i;
		}

		var vector2 = vector.slice();

		for (i in 0...vector.length)
		{
			Assert.equals(vector[i], vector2[i]);
		}

		Assert.notEquals(vector, vector2);

		var vector2 = vector.slice(2);

		Assert.equals(8, vector2.length);
		Assert.equals(2, vector2[0]);
		Assert.equals(10, vector.length);
		Assert.equals(0, vector[0]);

		var vector2 = vector.slice(2, -1);

		Assert.equals(7, vector2.length);
		Assert.equals(2, vector2[0]);
		Assert.equals(10, vector.length);
		Assert.equals(0, vector[0]);

		var vector2 = vector.slice(4, 11);

		Assert.equals(6, vector2.length);

		var vector2 = vector.slice(-2);

		Assert.equals(2, vector2.length);
		Assert.equals(8, vector2[0]);
	}

	public function test_sort()
	{
		var sort = function(a:Int, b:Int):Int
		{
			return a - b;
		}

		var vector = Vector.ofArray([10, 2, 4, 5, 9, 1, 7, 3, 6, 8]);
		vector.sort(sort);

		var lastValue = 0;

		for (i in 0...vector.length)
		{
			Assert.isTrue(vector[i] >= lastValue);
			lastValue = vector[i];
		}
	}

	public function test_splice()
	{
		var vector = new Vector<Int>(10);

		for (i in 0...10)
		{
			vector[i] = i;
		}

		var vector2 = vector.splice(-1, -1);

		Assert.equals(0, vector2.length);
		Assert.equals(10, vector.length);

		var vector2 = vector.splice(-1, 0);

		Assert.equals(0, vector2.length);
		Assert.equals(10, vector.length);

		var vector2 = vector.splice(-1, 1);

		Assert.equals(1, vector2.length);
		Assert.equals(9, vector2[0]);
		Assert.equals(9, vector.length);

		vector2 = vector.splice(2, 3);

		Assert.equals(3, vector2.length);
		Assert.equals(2, vector2[0]);
		Assert.equals(6, vector.length);

		vector2 = vector.splice(5, 20);

		Assert.equals(1, vector2.length);
		Assert.equals(5, vector.length);
	}

	/*public function toString () {



	}*/
	public function test_indexOf()
	{
		var vector = new Vector<Int>(20);

		for (i in 0...10)
		{
			vector[i] = vector[i + 10] = i;
		}

		Assert.equals(9, vector.indexOf(9));
		Assert.equals(2, vector.indexOf(2));
		Assert.equals(2, vector.indexOf(2, 1));
	}

	public function test_iterator()
	{
		var vector = new Vector<Int>(10);

		for (i in 0...10)
		{
			vector[i] = i;
		}

		vector.push(10);

		var iterations = 0;

		for (i in vector)
		{
			Assert.equals(iterations, vector[iterations]);
			iterations++;
		}

		Assert.equals(11, iterations);
	}

	public function test_lastIndexOf()
	{
		var vector = new Vector<Int>(20);

		for (i in 0...10)
		{
			vector[i] = vector[i + 10] = i;
		}

		Assert.equals(19, vector.lastIndexOf(9));
		Assert.equals(12, vector.lastIndexOf(2));
		Assert.equals(12, vector.lastIndexOf(2, 20));
	}

	public function test_ofArray()
	{
		var array = new Array<Int>();

		for (i in 0...10)
		{
			array[i] = i;
		}

		var vector = Vector.ofArray(array);

		Assert.equals(10, vector.length);
		Assert.equals(4, vector[4]);
	}

	@Ignored
	public function test_convert() {}

	public function test_arrayAccess()
	{
		var vector = new Vector<Int>();

		Assert.equals(0, vector.length);

		// Flash allows array access to one greater
		// than the length, if not fixed

		vector[0] = 100;

		Assert.equals(1, vector.length);
		Assert.equals(100, vector[0]);
	}

	#if (!html5 && !flash)
	@Ignored
	#end
	public function test_intVectorStringify()
	{
		// Testing if we have the same stringify behavior in JS and flash
		var expected:String = "[1,2]";
		var stringyfied:String = null;
		var vector:Vector<Int> = new Vector<Int>();

		vector.push(1);
		vector.push(2);
		stringyfied = haxe.Json.stringify(vector);
		Assert.equals(expected, stringyfied);
	}

	#if (!html5 && !flash)
	@Ignored
	#end
	public function test_boolVectorStringify()
	{
		// Testing if we have the same stringify behavior in JS and flash
		var expected:String = "[false,true]";
		var stringyfied:String = null;
		var vector:Vector<Bool> = new Vector<Bool>();

		vector.push(false);
		vector.push(true);
		stringyfied = haxe.Json.stringify(vector);
		Assert.equals(expected, stringyfied);
	}

	#if (!html5 && !flash)
	@Ignored
	#end
	public function test_floatVectorStringify()
	{
		// Testing if we have the same stringify behavior in JS and flash
		var expected:String = "[1.1,2.2]";
		var stringyfied:String = null;
		var vector:Vector<Float> = new Vector<Float>();

		vector.push(1.1);
		vector.push(2.2);
		stringyfied = haxe.Json.stringify(vector);
		Assert.equals(expected, stringyfied);
	}

	#if (!html5 && !flash)
	@Ignored
	#end
	public function test_objectVectorStringify()
	{
		// Testing if we have the same stringify behavior in JS and flash
		var expected:String = null;
		var stringyfied:String = null;
		var obj:Error = new Error("Message", 1);
		var strObj:String = haxe.Json.stringify(obj);
		var vector:Vector<Error> = new Vector<Error>();

		vector.push(obj);
		stringyfied = haxe.Json.stringify(vector);
		expected = "[" + strObj + "]";
		Assert.equals(expected, stringyfied);
		// Testing stringify inside object
		var obj:Dynamic = {id: 5, errors: vector};
		stringyfied = haxe.Json.stringify(obj);
		// Testing if stringify inside object is still the same as outside
		Assert.isTrue(stringyfied.indexOf(expected) != -1);
		// Check lengh and __array aren't stringified
		Assert.equals(stringyfied.indexOf("length"), -1);
		Assert.equals(stringyfied.indexOf("__array"), -1);
	}
}
