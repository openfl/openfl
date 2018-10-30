package openfl.desktop;


import openfl.desktop.Clipboard;


class ClipboardTest { public static function __init__ () { Mocha.describe ("Haxe | Clipboard", function () {
	
	
	Mocha.it ("formats", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.formats;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("generalClipboard", function () {
		
		// TODO: Confirm functionality
		
		Assert.notEqual (Clipboard.generalClipboard, null);
		
	});
	
	
	Mocha.it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.clear;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("clearData", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.clearData;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("getData", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.getData;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("hasFormat", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.hasFormat;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("formats", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.formats;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setData", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setData;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("setDataHandler", function () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setDataHandler;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}