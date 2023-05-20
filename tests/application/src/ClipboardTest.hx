package;

import openfl.desktop.ClipboardFormats;
import openfl.desktop.Clipboard;
import utest.Assert;
import utest.Test;

class ClipboardTest extends Test
{
	// Security sandbox rules for Flash Player require `Clipboard.getData` to occur
	// only within a "paste" event from the user
	#if (flash && !air)
	@Ignored
	#end
	public function test_clear()
	{
		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Test Data');

		Assert.equals('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		clipboard.clear();

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	#if flash
	@Ignored
	#end
	public function test_clearData()
	{
		var clipboard = Clipboard.generalClipboard;
		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Test Data');

		Assert.equals('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		// clearing data for any format clears the only one set in Lime Clipboard
		clipboard.clearData(ClipboardFormats.HTML_FORMAT);

		#if (flash || !integration)
		Assert.isNull(clipboard.getData(ClipboardFormats.HTML_FORMAT));
		Assert.equals('Test Data', clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		// for some reason, calling clearData crashes on AIR
		clipboard.clearData(ClipboardFormats.TEXT_FORMAT);
		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		#else
		// TODO
		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		#end
	}

	#if (flash && !air)
	@Ignored
	#end
	public function test_getData()
	{
		var textFormatData = 'Text Format Data';
		var clipboard = Clipboard.generalClipboard;

		clipboard.setData(ClipboardFormats.TEXT_FORMAT, textFormatData);

		Assert.equals(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));

		// RTF data is tested in integration, requires external asset
	}

	#if (flash && !air)
	@Ignored
	#end
	public function test_hasFormat()
	{
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT));
		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isFalse(clipboard.hasFormat(ClipboardFormats.HTML_FORMAT));

		clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Sample Text');

		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.TEXT_FORMAT));

		#if (!flash && integration)
		// TODO
		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isTrue(clipboard.hasFormat(ClipboardFormats.HTML_FORMAT));
		#end
	}

	#if (flash && !air)
	@Ignored
	#end
	public function test_setData()
	{
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.isNull(clipboard.getData(ClipboardFormats.TEXT_FORMAT));
		Assert.isNull(clipboard.getData(ClipboardFormats.RICH_TEXT_FORMAT));
		Assert.isNull(clipboard.getData(ClipboardFormats.HTML_FORMAT));

		var dataSet = clipboard.setData(ClipboardFormats.TEXT_FORMAT, 'Sample Text');

		Assert.isTrue(dataSet);
		Assert.equals('Sample Text', clipboard.getData(ClipboardFormats.TEXT_FORMAT));
	}

	#if (flash && !air)
	@Ignored
	#end
	public function test_setDataHandler()
	{
		// TODO: Confirm functionality

		#if !openfl_strict
		var clipboard = Clipboard.generalClipboard;
		var exists = clipboard.setDataHandler;

		Assert.notNull(exists);
		#end
	}

	// Properties
	#if (flash && !air)
	@Ignored
	#end
	public function test_formats()
	{
		var clipboard = Clipboard.generalClipboard;
		clipboard.clear();

		Assert.equals(0, clipboard.formats.length);

		clipboard.setData(ClipboardFormats.HTML_FORMAT, 'Test Clipboard Data');

		#if (flash || !integration)
		Assert.equals(1, clipboard.formats.length);
		Assert.equals(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool
		{
			return ClipboardFormats.HTML_FORMAT == format;
		}).length);
		#else
		// TODO
		Assert.equals(3, clipboard.formats.length);
		Assert.equals(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool
		{
			return ClipboardFormats.TEXT_FORMAT == format;
		}).length);
		Assert.equals(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool
		{
			return ClipboardFormats.HTML_FORMAT == format;
		}).length);
		Assert.equals(1, clipboard.formats.filter(function(format:ClipboardFormats):Bool
		{
			return ClipboardFormats.RICH_TEXT_FORMAT == format;
		}).length);
		#end
	}

	#if (flash && !air)
	@Ignored
	#end
	public function test_generalClipboard()
	{
		Assert.notNull(Clipboard.generalClipboard);
	}
}
