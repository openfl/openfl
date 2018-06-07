package openfl.utils;


import openfl.utils.Dictionary;


class DictionaryTest { public static function __init__ () { Mocha.describe ("Haxe | Dictionary", function () {
	
	
	var floatDict = new Dictionary<Float, String>(true);
	var keys: Array<Float> = [
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
		1/2,
		92421432132,
		3425.42354,
		1/3,
		9238768.043589345890,
		1/3,
		2/3,
		Math.PI
	];
	
	for (k in keys) {
		floatDict.set(k, "value_"+Std.string(k));
	}
	
	
	Mocha.it ("testExists", function () {
		
		Assert.equal(floatDict[1/3], "value_"+Std.string(1/3));
		Assert.equal(floatDict[Math.PI], "value_"+Std.string(Math.PI));
		Assert.equal(floatDict[9238768.043589345890], "value_" + Std.string(9238768.043589345890));
		Assert.equal(floatDict[0], "value_"+Std.string(0));
		Assert.equal(floatDict[0.000068435], "value_"+Std.string(0.000068435));
		Assert.equal(floatDict[92421432132], "value_"+Std.string(92421432132));
		Assert.assert(floatDict.exists(2/3));
		Assert.assert(floatDict.exists(1/2));
		Assert.assert(floatDict.exists(800000));
		Assert.assert(floatDict.exists(39.569540));
		
	});
	
	
	Mocha.it ("testCountKeysAndValues", function () {
		
		var keyNum: Int = 0;
		for (k in floatDict) {
			keyNum ++;
		}
		
		var valNum: Int = 0;
		for (v in floatDict.each()) {
			valNum ++;
		}
		
		Assert.equal(keyNum, valNum);
		
	});
	
	
	Mocha.it ("testRemove", function () {
		
		floatDict.remove(1/3);
		Assert.equal(floatDict[1/3], null);
		
	});
	
	
	Mocha.it ("testRemoveAll", function () {
		
		for (k in floatDict) {
			floatDict.remove(k);
		}
		
		Assert.assert(!floatDict.each().hasNext());
		
	});
	
	
	Mocha.it ("testOverwrite", function () {
		
		floatDict[2/3] = "overwritten";
		
		Assert.equal(floatDict[2/3], "overwritten");
		
	});
	
	
}); }}