import openfl.events.SecurityErrorEvent;

class SecurityErrorEventTest
{
	public static function __init__()
	{
		Mocha.describe("SecurityErrorEvent", function()
		{
			Mocha.it("new", function()
			{
				// TODO: Confirm functionality

				var securityErrorEvent = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
				Assert.notEqual(securityErrorEvent, null);
			});
		});
	}
}
