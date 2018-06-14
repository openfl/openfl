import Dictionary from "openfl/utils/Dictionary";
import * as assert from "assert";


describe ("TypeScript | Dictionary", function () {
	
	
	var floatDict = new Dictionary<number, String>(true);
	var keys:Array<number> = [
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
	
	for (var i:number = 0; i < keys.length; i++) {
		var k = keys[i];
		floatDict[k] = "value_"+String(k);
	}
	
	
	it ("testExists", function () {
		
		assert.equal(floatDict[1/3], "value_"+String(1/3));
		assert.equal(floatDict[Math.PI], "value_"+String(Math.PI));
		assert.equal(floatDict[9238768.043589345890], "value_" + String(9238768.043589345890));
		assert.equal(floatDict[0], "value_"+String(0));
		assert.equal(floatDict[0.000068435], "value_"+String(0.000068435));
		assert.equal(floatDict[92421432132], "value_"+String(92421432132));
		assert(floatDict[(2/3)]);
		assert(floatDict[(1/2)]);
		assert(floatDict[(800000)]);
		assert(floatDict[(39.569540)]);
		
	});
	
	
	it ("testCountKeysAndValues", function () {
		
		var keyNum:number = 0;
		for (var k in floatDict) {
			keyNum++;
		}
		
		// var valNum:number = 0;
		// for ()
		
		// var keyNum: Int = 0;
		// for (k in floatDict) {
		// 	keyNum ++;
		// }
		
		// var valNum: Int = 0;
		// for (v in floatDict.each()) {
		// 	valNum ++;
		// }
		
		// assert.equal(keyNum, valNum);
		
	});
	
	
	it ("testRemove", function () {
		
		delete floatDict[(1/3)];
		assert(!floatDict[1/3]);
		
	});
	
	
	it ("testRemoveAll", function () {
		
		for (var k in floatDict) {
			delete floatDict[k];
		}
		
		// assert(!floatDict.each().hasNext());
		
	});
	
	
	it ("testOverwrite", function () {
		
		floatDict[2/3] = "overwritten";
		
		assert.equal(floatDict[2/3], "overwritten");
		
	});
	
	
});