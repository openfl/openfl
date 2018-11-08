import * as assert from "assert";
import Clipboard from "openfl/desktop/Clipboard";


describe ("ES6 | Clipboard", function () {
	
	
	it ("formats", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.formats;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("generalClipboard", function () {
		
		// TODO: Confirm functionality
		
		assert.notEqual (Clipboard.generalClipboard, null);
		
	});
	
	
	it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.clear;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("clearData", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.clearData;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("getData", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.getData;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("hasFormat", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.hasFormat;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("formats", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.formats;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setData", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setData;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("setDataHandler", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setDataHandler;
		
		assert.notEqual (exists, null);
		
	});
	
	
});