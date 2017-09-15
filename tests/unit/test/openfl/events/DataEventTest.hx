package openfl.events;


import massive.munit.Assert;


class DataEventTest {
	
	
	@Test public function data () {
		
		// TODO: Confirm functionality
		
		var dataEvent = new DataEvent (DataEvent.DATA);
		var exists = dataEvent.data;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var dataEvent = new DataEvent (DataEvent.DATA);
		
		Assert.isNotNull (dataEvent);
		
	}
	
	
}