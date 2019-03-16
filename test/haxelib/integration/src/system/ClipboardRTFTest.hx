package system;

import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.utils.ByteArray;

class ClipboardRTFTest
{
	// Security sandbox rules for Flash Player require `Clipboard.getData` to occur
	// only within a "paste" event from the user
	#if (flash && !air)
	@Ignore
	#end
	@AsyncTest public function getData()
	{
		// TODO: Inline RTF bytes?

		#if integration
		var handler = Async.handler(this, function(richTextFormatData)
		{
			var textFormatData = 'Text Format Data';
			var clipboard = Clipboard.generalClipboard;

			clipboard.setData(ClipboardFormats.TEXT_FORMAT, textFormatData);

			Assert.areEqual(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));

			clipboard.setData(ClipboardFormats.RICH_TEXT_FORMAT, richTextFormatData);

			#if !flash
			Assert.areNotEqual(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));
			// Assert.areEqual (richTextFormatData, clipboard.getData (ClipboardFormats.TEXT_FORMAT));
			#end

			// TODO
			// Assert.areEqual (richTextFormatData, clipboard.getData (ClipboardFormats.RICH_TEXT_FORMAT));
		});

		ByteArray.loadFromFile("hello.rtf").onComplete(handler);
		#end
	}
}
