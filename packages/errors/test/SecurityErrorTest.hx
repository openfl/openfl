package;

import openfl.errors.SecurityError;

class SecurityErrorTest
{
	public static function __init__()
	{
		Mocha.describe("SecurityError", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var securityError = new SecurityError();
				Assert.notEqual(securityError, null);
			});
		});
	}
}
