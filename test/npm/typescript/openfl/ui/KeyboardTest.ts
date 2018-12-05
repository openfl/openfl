import Keyboard from "openfl/ui/Keyboard";
import * as assert from "assert";


describe ("TypeScript | Keyboard", function () {
	
	
	it ("test", function () {
		
		var exists = Keyboard.A;
		
		assert.notEqual (exists, null);
		
	});
	
	
});