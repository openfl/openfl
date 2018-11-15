package openfl.desktop;

import massive.munit.Assert;
import openfl.desktop.Clipboard;
import openfl.utils.ByteArray;

@:file("../assets/hello.rtf") class HelloRTF extends ByteArrayData {}

class ClipboardTest {
	
	// Security sandbox rules for Flash Player require `Clipboard.getData` to occur
	// only within a "paste" event from the user
	
	#if (flash && !air) @Ignore #end @Test public function formats() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();
		
		Assert.areEqual(0, clipboard.formats.length);

		clipboard.setData(ClipboardFormats.HTML_FORMAT, 'Test Clipboard Data');

		#if flash
		Assert.areEqual(1, clipboard.formats.length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.HTML_FORMAT == format;
		}).length);
		#else
		Assert.areEqual(3, clipboard.formats.length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.TEXT_FORMAT == format;
		}).length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.HTML_FORMAT == format;
		}).length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.RICH_TEXT_FORMAT == format;
		}).length);
		#end

	}

	#if (flash && !air) @Ignore #end @Test public function generalClipboard() {
		var clipboard = Clipboard.generalClipboard;

		Assert.isNotNull(clipboard);
	}

	#if (flash && !air) @Ignore #end @Test public function clear() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Test Data');

		Assert.areEqual('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		clipboard.clear();

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	#if (flash && !air) @Ignore #end @Test public function clearData() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Test Data');
		
		Assert.areEqual('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		// clearing data for any format clears the only one set in Lime Clipboard
		clipboard.clearData(ClipboardFormats.HTML_FORMAT);

		#if flash
		Assert.isNull(clipboard.getData(ClipboardFormats.HTML_FORMAT));
		Assert.areEqual('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		clipboard.clearData(ClipboardFormats.TEXT_FORMAT);
		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		#else
		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		#end
	}

	#if (flash && !air) @Ignore #end @Test public function getData() {
		var textFormatData:String = 'Text Format Data';
		var richTextFormatData = new HelloRTF ();

		var clipboard = Clipboard.generalClipboard;

		clipboard.setData(ClipboardFormats.TEXT_FORMAT, textFormatData);

		Assert.areEqual(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		clipboard.setData(ClipboardFormats.RICH_TEXT_FORMAT, richTextFormatData);

		#if !flash
		Assert.areNotEqual(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		// Assert.areEqual(richTextFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		#end
		
		// TODO
		// Assert.areEqual(richTextFormatData, clipboard.getData(ClipboardFormats.RICH_TEXT_FORMAT));
	}

	#if (flash && !air) @Ignore #end @Test public function hasFormat() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT));
		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.HTML_FORMAT));

		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Sample Text');

		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT));
		
		#if !flash
		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.HTML_FORMAT));
		#end
	}

	#if (flash && !air) @Ignore #end @Test public function setData() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		Assert.isNull(clipboard.getData(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isNull(clipboard.getData(ClipboardFormats.HTML_FORMAT));

		var dataSet:Bool = clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Sample Text');

		Assert.isTrue(dataSet);
		Assert.areEqual('Sample Text', clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	#if (flash && !air) @Ignore #end @Test public function setDataHandler() {

		// TODO: Confirm functionality

		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setDataHandler;

		Assert.isNotNull(exists);

	}

}