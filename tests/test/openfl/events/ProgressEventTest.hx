package openfl.events;


import massive.munit.Assert;


class ProgressEventTest {
	
	
	@Test public function bytesLoaded () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesLoaded;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function bytesTotal () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		var exists = progressEvent.bytesTotal;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var progressEvent = new ProgressEvent (ProgressEvent.PROGRESS);
		Assert.isNotNull (progressEvent);
		
	}
	
	
}