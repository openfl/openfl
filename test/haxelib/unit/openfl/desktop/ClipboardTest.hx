package openfl.desktop;

import massive.munit.Assert;
import openfl.desktop.Clipboard;

class ClipboardTest {

	@Test public function formats() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.areEqual(1, clipboard.formats.length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.TEXT_FORMAT == format;
		}).length);

		clipboard.setData(ClipboardFormats.HTML_FORMAT, 'Test Cliboard Data');

		Assert.areEqual(4, clipboard.formats.length);
		Assert.areEqual(2, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.TEXT_FORMAT == format;
		}).length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.HTML_FORMAT == format;
		}).length);
		Assert.areEqual(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool {
			return ClipboardFormats.RICH_TEXT_FORMAT == format;
		}).length);

	}

	@Test public function generalClipboard() {
		var clipboard = Clipboard.generalClipboard;

		Assert.isNotNull(clipboard);
	}

	@Test public function clear() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Test Data');

		Assert.areEqual('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		clipboard.clear();

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	@Test public function clearData() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Test Data');

		Assert.areEqual('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		// clearing data for any format clears the only one set in Lime Clipboard
		clipboard.clearData(ClipboardFormats.HTML_FORMAT);

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	@Test public function getData() {
		var textFormatData:String = 'Text Format Data';
		var richTextFormatData:String = 'Rich Text Format Data';

		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, textFormatData);

		Assert.areEqual(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		clipboard.setData(ClipboardFormats.RICH_TEXT_FORMAT, richTextFormatData);

		Assert.areNotEqual(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		Assert.areEqual(richTextFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		Assert.areEqual(richTextFormatData, clipboard.getData(ClipboardFormats.RICH_TEXT_FORMAT));

	}

	@Test public function hasFormat() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT));
		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.HTML_FORMAT));

		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Sample Text');

		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT));
		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.HTML_FORMAT));
	}

	@Test public function setData() {
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		Assert.isNull(clipboard.getData(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isNull(clipboard.getData(ClipboardFormats.HTML_FORMAT));

		var dataSet:Bool = clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Sample Text');

		Assert.isTrue(dataSet);
		Assert.areEqual('Sample Text', clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	@Test public function setDataHandler() {

		// TODO: Confirm functionality

		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setDataHandler;

		Assert.isNotNull(exists);

	}

}