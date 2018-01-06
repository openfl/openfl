import Endian from "openfl/utils/Endian";
import * as assert from "assert";


describe ("ES6 | Endian", function () {
	
	
	it ("test", function () {
		
		switch (+Endian.BIG_ENDIAN) {
			
			case Endian.BIG_ENDIAN:
			case Endian.LITTLE_ENDIAN:
				break;
			
		}
		
	});
	
	
});