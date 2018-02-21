


import openfl.utils.Dictionary;


describe ("TypeScript | Dictionary", function () {
	
	
	var floatDict: Dictionary<Float, String>;
	
	
	@Before 
	public function setup(): Void {
		floatDict = new Dictionary<Float, String>(true);
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
	}

	@Test 
	public function testExists(): Void  {

		assert.equal(floatDict[1/3], "value_"+Std.string(1/3));
		assert.equal(floatDict[Math.PI], "value_"+Std.string(Math.PI));
		assert.equal(floatDict[9238768.043589345890], "value_" + Std.string(9238768.043589345890));
		assert.equal(floatDict[0], "value_"+Std.string(0));
		assert.equal(floatDict[0.000068435], "value_"+Std.string(0.000068435));
		assert.equal(floatDict[92421432132], "value_"+Std.string(92421432132));
		assert(floatDict.exists(2/3));
		assert(floatDict.exists(1/2));
		assert(floatDict.exists(800000));
		assert(floatDict.exists(39.569540));

	}

	@Test 
	public function testCountKeysAndValues(): Void  {

		var keyNum: Int = 0;
		for (k in floatDict) {
       		keyNum ++;
    	}

		var valNum: Int = 0;
    	for (v in floatDict.each()) {
       		valNum ++;
    	}

    	assert.equal(keyNum, valNum);

	}

	@Test 
	public function testRemove(): Void  {

		floatDict.remove(1/3);
		assert.equal(floatDict[1/3], null);
	}

	@Test 
	public function testRemoveAll(): Void  {
	
		for (k in floatDict) {
       		floatDict.remove(k);
    	}

    	assert(!floatDict.each().hasNext());
	}

	@Test 
	public function testOverwrite(): Void  {
		floatDict[2/3] = "overwritten";

    	assert.equal(floatDict[2/3], "overwritten");
	}

});