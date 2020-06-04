package;

import openfl.errors.TypeError;

class TypeErrorTest
{
	public static function __init__()
	{
		Mocha.describe("Haxe | TypeError", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var typeError = new TypeError();
				Assert.notEqual(typeError, null);
			});
		});
	}
}
