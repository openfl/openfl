package;

import openfl.events.SecurityErrorEvent;
import utest.Assert;
import utest.Test;

class SecurityErrorEventTest extends Test
{
	public function test_new_()
	{
		// TODO: Confirm functionality

		var securityErrorEvent = new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR);
		Assert.notNull(securityErrorEvent);
	}
}
