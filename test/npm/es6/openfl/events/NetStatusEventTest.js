import NetStatusEvent from "openfl/events/NetStatusEvent";
import * as assert from "assert";


describe ("ES6 | NetStatusEvent", function () {
	
	
	it ("info", function () {
		
		// TODO: Confirm functionality
		
		var netStatusEvent = new NetStatusEvent (NetStatusEvent.NET_STATUS);
		var exists = netStatusEvent.info;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var netStatusEvent = new NetStatusEvent (NetStatusEvent.NET_STATUS);
		
		assert.notEqual (netStatusEvent, null);
		
	});
	
	
});