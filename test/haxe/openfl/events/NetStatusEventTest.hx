package openfl.events;


class NetStatusEventTest { public static function __init__ () { Mocha.describe ("Haxe | NetStatusEvent", function () {
	
	
	Mocha.it ("info", function () {
		
		// TODO: Confirm functionality
		
		var netStatusEvent = new NetStatusEvent (NetStatusEvent.NET_STATUS);
		var exists = netStatusEvent.info;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var netStatusEvent = new NetStatusEvent (NetStatusEvent.NET_STATUS);
		
		Assert.notEqual (netStatusEvent, null);
		
	});
	
	
}); }}