package;

import openfl.net.SharedObjectFlushStatus;
import utest.Assert;
import utest.Test;

class SharedObjectFlushStatusTest extends Test
{
	public function test_test()
	{
		switch (SharedObjectFlushStatus.FLUSHED)
		{
			case SharedObjectFlushStatus.FLUSHED, SharedObjectFlushStatus.PENDING:
				Assert.isTrue(true);
		}
	}
}
