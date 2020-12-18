package;

import openfl.events.NetStatusEvent;
import utest.Assert;
import utest.Test;

class NetStatusEventTest extends Test
{
	public function test_info()
	{
		// TODO: Confirm functionality

		var netStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS);
		var exists = netStatusEvent.info;

		Assert.isNull(exists);
	}

	public function test_new_()
	{
		// TODO: Confirm functionality

		var netStatusEvent = new NetStatusEvent(NetStatusEvent.NET_STATUS);

		Assert.notNull(netStatusEvent);
	}
}
