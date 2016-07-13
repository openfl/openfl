package openfl.media;


import massive.munit.Assert;


class SoundTest {
	
	
	@Test public function bytesLoaded () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.bytesLoaded;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function bytesTotal () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.bytesTotal;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function id3 () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.id3;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function isBuffering () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.isBuffering;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function length () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.length;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function url () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.url;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		Assert.isNotNull (sound);
		
	}
	
	
	@Test public function close () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.close;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function load () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.load;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function loadCompressedDataFromByteArray () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.loadCompressedDataFromByteArray;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function loadPCMFromByteArray () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.loadPCMFromByteArray;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function play () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.play;
		
		Assert.isNotNull (exists);
		
	}
	
	
}