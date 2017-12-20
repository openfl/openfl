import PNGEncoderOptions from "openfl/display/PNGEncoderOptions";
import * as assert from "assert";


describe ("TypeScript | PNGEncoderOptions", function () {
	
	
	it ("fastCompression", function () {
		
		var pngEncoderOptions = new PNGEncoderOptions ();
		var exists = pngEncoderOptions;
		
		assert.notEqual (exists, null);
		assert (!pngEncoderOptions.fastCompression);
		
		var pngEncoderOptions = new PNGEncoderOptions (true);
		assert (pngEncoderOptions.fastCompression);
		
	});
	
	
});