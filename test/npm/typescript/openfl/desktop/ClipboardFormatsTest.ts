import ClipboardFormats from "openfl/desktop/ClipboardFormats";
import * as assert from "assert";


describe ("TypeScript | ClipboardFormats", function () {
	
	
	it ("test", function () {
		
		switch (""+ClipboardFormats.HTML_FORMAT) {
			
			case ClipboardFormats.HTML_FORMAT:
			case ClipboardFormats.RICH_TEXT_FORMAT:
			case ClipboardFormats.TEXT_FORMAT:
				break;
			
			default:
				assert.ok (false);
			
		}
		
	});
	
	
});