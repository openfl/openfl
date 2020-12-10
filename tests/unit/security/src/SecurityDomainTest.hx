import openfl.system.SecurityDomain;

class SecurityDomainTest
{
	public static function __init__()
	{
		Mocha.describe("SecurityDomain", function()
		{
			Mocha.it("currentDomain", function()
			{
				// TODO: Confirm functionality

				var exists = SecurityDomain.currentDomain;

				Assert.notEqual(exists, null);
			});
		});
	}
}
