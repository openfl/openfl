package openfl.events;


import massive.munit.Assert;


class NetStatusEventTest {
	
	
	@Test public function info () {
		
		// TODO: Confirm functionality
		
		var netStatusEvent = new NetStatusEvent (NetStatusEvent.NET_STATUS);
		var exists = netStatusEvent.info;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var netStatusEvent = new NetStatusEvent (NetStatusEvent.NET_STATUS);
		
		Assert.isNotNull (netStatusEvent);
		
	}
	
	
}