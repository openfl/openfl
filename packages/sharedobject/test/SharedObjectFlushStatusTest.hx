import openfl.net.SharedObjectFlushStatus;

class SharedObjectFlushStatusTest
{
	public static function __init__()
	{
		Mocha.describe("SharedObjectFlushStatus", function()
		{
			Mocha.it("test", function()
			{
				switch (SharedObjectFlushStatus.FLUSHED)
				{
					case SharedObjectFlushStatus.FLUSHED, SharedObjectFlushStatus.PENDING:
				}
			});
		});
	}
}
