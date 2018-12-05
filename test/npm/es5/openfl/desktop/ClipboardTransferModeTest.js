var ClipboardTransferMode = require("openfl/desktop/ClipboardTransferMode").default;
var assert = require("assert");

describe("ES5 | ClipboardTransferMode", function () {
	
	it("test", function () {
		switch (ClipboardTransferMode.CLONE_ONLY) {
			case ClipboardTransferMode.CLONE_ONLY:
			case ClipboardTransferMode.CLONE_PREFERRED:
			case ClipboardTransferMode.ORIGINAL_ONLY:
			case ClipboardTransferMode.ORIGINAL_PREFERRED:
				break;
			default:
				assert.ok(false);
		}
	});
	
});