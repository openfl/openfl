package;

import openfl.errors.RangeError;

class RangeErrorTest
{
	public static function __init__()
	{
		Mocha.describe("RangeError", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var rangeError = new RangeError();
				Assert.notEqual(rangeError, null);
			});
		});
	}
}
