package;

import openfl.errors.EOFError;

class EOFErrorTest
{
	public static function __init__()
	{
		Mocha.describe("EOFError", function()
		{
			Mocha.it("test", function()
			{
				// TODO: Confirm functionality

				var eofError = new EOFError();
				Assert.notEqual(eofError, null);
			});
		});
	}
}
