package;

import openfl.errors.ArgumentError;

class ArgumentErrorTest
{
	public static function __init__()
	{
		Mocha.describe("ArgumentError", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var argumentError = new ArgumentError();
				Assert.notEqual(argumentError, null);
			});
		});
	}
}
