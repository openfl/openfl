package;

import openfl.errors.IOError;

class IOErrorTest
{
	public static function __init__()
	{
		Mocha.describe("IOError", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var ioError = new IOError();
				Assert.notEqual(ioError, null);
			});
		});
	}
}
