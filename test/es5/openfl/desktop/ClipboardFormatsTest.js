var ClipboardFormats = require ("openfl/desktop/ClipboardFormats").default;
var assert = require ("assert");


describe ("ES5 | ClipboardFormats", function () {
	
	
	it ("test", function () {
		
		switch (ClipboardFormats.HTML_FORMAT) {
			
			case ClipboardFormats.HTML_FORMAT:
			case ClipboardFormats.RICH_TEXT_FORMAT:
			case ClipboardFormats.TEXT_FORMAT:
				break;
			
			default:
				assert.ok(false);
			
		}
		
	});
	
	
});