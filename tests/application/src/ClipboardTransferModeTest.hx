package;

import openfl.desktop.ClipboardTransferMode;
import utest.Assert;
import utest.Test;

class ClipboardTransferModeTest extends Test
{
	public function test_test()
	{
		switch (ClipboardTransferMode.CLONE_ONLY)
		{
			case ClipboardTransferMode.CLONE_ONLY, ClipboardTransferMode.CLONE_PREFERRED, ClipboardTransferMode.ORIGINAL_ONLY,
				ClipboardTransferMode.ORIGINAL_PREFERRED:
				Assert.isTrue(true);
		}
	}
}
