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
			324214321.423421, 3425.42354, 0, 9875.345, 92421432132, 39.569540, 67432.6874, 92421432132, 800000, 0.000068435, 0, 1 / 2, 92421432132,
			3425.42354, 1 / 3, 9238768.043589345890, 1 / 3, 2 / 3, Math.PI

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
}
