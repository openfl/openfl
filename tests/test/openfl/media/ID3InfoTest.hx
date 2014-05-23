package openfl.media;


import massive.munit.Assert;


class ID3InfoTest {
	
	
	@Test public function album () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.album;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function artist () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.artist;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function comment () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.comment;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function genre () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.genre;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function songName () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.songName;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function track () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.track;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function year () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.year;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		Assert.isNotNull (id3Info);
		
	}
	
	
}