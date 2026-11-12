package;

import openfl.utils.Dictionary;
import utest.Assert;
import utest.Test;

class DictionaryTest extends Test
{
	var floatDict:Dictionary<Float, String>;

	public function setup():Void
	{
		floatDict = new Dictionary<Float, String>(true);
		var keys:Array<Float> = [
			324214321.423421,
			3425.42354,
			0,
			9875.345,
			92421432132,
			39.569540,
			67432.6874,
			92421432132,
			800000,
			0.000068435,
			0,
			1 / 2,
			92421432132,
			3425.42354,
			1 / 3,
			9238768.043589345890,
			1 / 3,
			2 / 3,
			Math.PI

		];

		for (k in keys)
		{
			floatDict.set(k, "value_" + Std.string(k));
		}
	}

	public function testExists():Void
	{
		Assert.equals(floatDict[1 / 3], "value_" + Std.string(1 / 3));
		Assert.equals(floatDict[Math.PI], "value_" + Std.string(Math.PI));
		Assert.equals(floatDict[9238768.043589345890], "value_" + Std.string(9238768.043589345890));
		Assert.equals(floatDict[0], "value_" + Std.string(0));
		Assert.equals(floatDict[0.000068435], "value_" + Std.string(0.000068435));
		Assert.equals(floatDict[92421432132], "value_" + Std.string(92421432132));
		Assert.isTrue(floatDict.exists(2 / 3));
		Assert.isTrue(floatDict.exists(1 / 2));
		Assert.isTrue(floatDict.exists(800000));
		Assert.isTrue(floatDict.exists(39.569540));
	}

	public function testCountKeysAndValues():Void
	{
		var keyNum:Int = 0;
		for (k in floatDict)
		{
			keyNum++;
		}

		var valNum:Int = 0;
		for (v in floatDict.each())
		{
			valNum++;
		}

		Assert.equals(keyNum, valNum);
	}

	public function testRemove():Void
	{
		floatDict.remove(1 / 3);
		Assert.isNull(floatDict[1 / 3]);
	}

	public function testRemoveAll():Void
	{
		for (k in floatDict)
		{
			floatDict.remove(k);
		}

		Assert.isFalse(floatDict.each().hasNext());
	}

	public function testOverwrite():Void
	{
		floatDict[2 / 3] = "overwritten";

		Assert.equals(floatDict[2 / 3], "overwritten");
	}

	public function testIteration():Void
	{
		// TODO: Test more key types

		var dic:Dictionary<String, String> = new Dictionary<String, String>();

		for (i in 0...3)
		{
			dic["key" + i] = "value" + i;
		}

		for (i in 0...3)
		{
			Assert.equals("value" + i, dic["key" + i]);
		}

		for (str in dic)
		{
			Assert.notNull(str);
			Assert.isTrue(StringTools.startsWith(str, "key"));
		}

		for (str in dic.each())
		{
			Assert.notNull(str);
			Assert.isTrue(StringTools.startsWith(str, "value"));
		}
	}

	public function testWeakKeysOfAnyType():Void
	{
		var dict = new Dictionary<DictionaryTestAnyKey, String>(true);
		var object = new DictionaryTestKey();
		var other = new DictionaryTestKey();
		dict[object] = "object";
		dict[other] = "other";

		Assert.equals("object", dict[object]);
		Assert.equals("other", dict[other]);
		Assert.isTrue(dict.exists(object));
		Assert.isFalse(dict.exists(new DictionaryTestKey()));
		Assert.equals(2, count(dict.iterator()));
		Assert.equals(2, count(dict.each()));

		dict[object] = "overwritten";
		Assert.equals("overwritten", dict[object]);
		Assert.equals(2, count(dict.iterator()));

		Assert.isTrue(dict.remove(other));
		Assert.isFalse(dict.remove(other));
		Assert.isFalse(dict.exists(other));
		Assert.equals(1, count(dict.iterator()));
		Assert.equals("overwritten", dict.each().next());
	}

	#if cpp
	public function testWeakKeysOfFunctionsAndValues():Void
	{
		var dict = new Dictionary<DictionaryTestAnyKey, String>(true);
		var object = new DictionaryTestKey();
		var listener = function():Void {};
		var number:DictionaryTestAnyKey = 1.5;
		dict[object] = "object";
		dict[listener] = "function";
		dict[number] = "number";
		dict[true] = "boolean";
		dict[5] = "integer";

		Assert.equals("object", dict[object]);
		Assert.equals("function", dict[listener]);
		Assert.equals("number", dict[number]);
		Assert.equals("boolean", dict[true]);
		Assert.equals("integer", dict[5]);
		Assert.equals(5, count(dict.iterator()));
		Assert.equals(5, count(dict.each()));

		dict[listener] = "overwritten";
		Assert.equals("overwritten", dict[listener]);
		Assert.equals(5, count(dict.iterator()));

		Assert.isTrue(dict.remove(listener));
		Assert.isFalse(dict.remove(listener));
		Assert.isFalse(dict.exists(listener));
		Assert.isTrue(dict.remove(object));
		Assert.equals(3, count(dict.iterator()));
	}

	public function testWeakKeysAreCollected():Void
	{
		var weak = new Dictionary<DictionaryTestAnyKey, Int>(true);
		var typed = new Dictionary<DictionaryTestKey, Int>(true);
		var strong = new Dictionary<DictionaryTestAnyKey, Int>();
		var kept = new DictionaryTestKey();
		weak[kept] = -1;
		typed[kept] = -1;
		fill(weak, typed, strong);
		// A second frame, over the stack slots where fill() left its last keys
		fill(new Dictionary<DictionaryTestAnyKey, Int>(), new Dictionary<DictionaryTestKey, Int>(), new Dictionary<DictionaryTestAnyKey, Int>());

		cpp.vm.Gc.run(true);

		Assert.isTrue(count(weak.iterator()) < 100);
		Assert.isTrue(count(typed.iterator()) < 100);
		Assert.equals(200, count(strong.iterator()));
		Assert.equals(-1, weak[kept]);
		Assert.equals(-1, typed[kept]);
	}

	// A function or a value is another object each time it is passed as a key, one nothing else holds
	public function testWeakKeysKeepFunctionsAndValues():Void
	{
		var weak = new Dictionary<DictionaryTestAnyKey, Int>(true);
		fillWithFunctionsAndValues(weak);
		fillWithFunctionsAndValues(new Dictionary<DictionaryTestAnyKey, Int>());

		cpp.vm.Gc.run(true);

		// 100 of each: method closures, anonymous functions, integers, floats and strings
		Assert.equals(500, count(weak.iterator()));
	}

	@:noinline private function fillWithFunctionsAndValues(weak:Dictionary<DictionaryTestAnyKey, Int>):Void
	{
		for (i in 0...100)
		{
			weak[new DictionaryTestKey().method] = i;
			weak[function():Int return i] = i;
			weak[1000000 + i] = i;
			weak[i + 0.5] = i;
			weak["key" + i] = i;
		}
	}

	@:noinline private function fill(weak:Dictionary<DictionaryTestAnyKey, Int>, typed:Dictionary<DictionaryTestKey, Int>,
			strong:Dictionary<DictionaryTestAnyKey, Int>):Void
	{
		for (i in 0...200)
		{
			weak[new DictionaryTestKey()] = i;
			typed[new DictionaryTestKey()] = i;
			strong[new DictionaryTestKey()] = i;
		}
	}
	#end

	private function count<T>(iterator:Iterator<T>):Int
	{
		var count = 0;
		for (item in iterator)
			count++;
		return count;
	}
}

private class DictionaryTestKey
{
	public function new() {}

	public function method():Void {}
}

// A key of any type, as an ActionScript Dictionary takes
private abstract DictionaryTestAnyKey(Dynamic) from Dynamic {}
