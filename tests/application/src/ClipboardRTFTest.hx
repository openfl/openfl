package;

import openfl.desktop.Clipboard;
import openfl.desktop.ClipboardFormats;
import openfl.utils.ByteArray;
import utest.Assert;
import utest.Async;
import utest.Test;
#if air
import flash.filesystem.File;
#end

// TODO: Requires a running Application to work
class ClipboardRTFTest extends Test
{
	// Security sandbox rules for Flash Player require `Clipboard.getData` to occur
	// only within a "paste" event from the user
	#if (flash && !air)
	@Ignored
	#end
	#if (flash && !haxe4)
	// ByteArray type coercion fails with Haxe 3.4.7
	@Ignored
	#end
	@:timeout(1000)
	public function test_getData(async:Async)
	{
		ByteArray.loadFromFile("hello.rtf").onComplete(function(richTextFormatData)
		{
			var textFormatData = 'Text Format Data';
			var clipboard = Clipboard.generalClipboard;

			clipboard.setData(ClipboardFormats.TEXT_FORMAT, textFormatData);

			Assert.equals(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));

			clipboard.setData(ClipboardFormats.RICH_TEXT_FORMAT, richTextFormatData);

			#if !flash
			Assert.notEquals(textFormatData, clipboard.getData(ClipboardFormats.TEXT_FORMAT));
			// Assert.areEqual (richTextFormatData, clipboard.getData (ClipboardFormats.TEXT_FORMAT));
			#end

			// TODO
			// Assert.areEqual (richTextFormatData, clipboard.getData (ClipboardFormats.RICH_TEXT_FORMAT));
			async.done();
		}).onError(function(result)
		{
				Assert.fail(result);
				async.done();
		});
	}
}
