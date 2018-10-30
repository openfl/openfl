import JPEGEncoderOptions from "openfl/display/JPEGEncoderOptions";
import * as assert from "assert";


describe ("TypeScript | JPEGEncoderOptions", function () {
	
	
	it ("quality", function () {
		
		var jpegEncoderOptions = new JPEGEncoderOptions ();
		var exists = jpegEncoderOptions;
		
		assert.notEqual (exists, null);
		assert.equal (jpegEncoderOptions.quality, 80);
		
		var jpegEncoderOptions = new JPEGEncoderOptions (100);
		assert.equal (jpegEncoderOptions.quality, 100);
		
	});
	
	
});