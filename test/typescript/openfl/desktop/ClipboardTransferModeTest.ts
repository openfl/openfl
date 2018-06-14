import ClipboardTransferMode from "openfl/desktop/ClipboardTransferMode";
import * as assert from "assert";


describe ("TypeScript | ClipboardTransferMode", function () {
	
	
	it ("test", function () {
		
		switch (""+ClipboardTransferMode.CLONE_ONLY) {
			
			case ClipboardTransferMode.CLONE_ONLY:
			case ClipboardTransferMode.CLONE_PREFERRED:
			case ClipboardTransferMode.ORIGINAL_ONLY:
			case ClipboardTransferMode.ORIGINAL_PREFERRED:
				break;
			
			default:
				assert.ok (false);
			
		}
		
	});
	
	
});