package;

import openfl.errors.IllegalOperationError;

class IllegalOperationErrorTest
{
	public static function __init__()
	{
		Mocha.describe("IllegalOperationError", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var illegalOperationError = new IllegalOperationError();
				Assert.notEqual(illegalOperationError, null);
			});
		});
	}
}
