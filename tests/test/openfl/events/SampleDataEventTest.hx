package openfl.events;


import massive.munit.Assert;


class SampleDataEventTest {
	
	
	@Test public function data () {
		
		// TODO:  Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.data;
		
		// revisit this, perhaps the event should have a null ByteArray, should be populated when dispatched?
		
		//Assert.isNotNull (exists);
		
	}
	
	
	@Test public function position () {
		
		// TODO: Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		var exists = sampleDataEvent.position;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var sampleDataEvent = new SampleDataEvent (SampleDataEvent.SAMPLE_DATA);
		Assert.isNotNull (sampleDataEvent);
		
	}
	
}