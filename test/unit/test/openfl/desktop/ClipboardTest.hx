package openfl.desktop;


import massive.munit.Assert;
import openfl.desktop.Clipboard;


class ClipboardTest {
	
	
	@Test public function formats () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.formats;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function generalClipboard () {
		
		// TODO: Confirm functionality
		
		Assert.isNotNull (Clipboard.generalClipboard);
		
	}
	
	
	@Test public function clear () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.clear;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function clearData () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.clearData;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function getData () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.getData;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function hasFormat () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.hasFormat;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setData () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setData;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function setDataHandler () {
		
		// TODO: Confirm functionality
		
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setDataHandler;
		
		Assert.isNotNull (exists);
		
	}
	
	
}