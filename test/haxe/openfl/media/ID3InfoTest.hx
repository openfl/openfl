package openfl.media;


class ID3InfoTest { public static function __init__ () { Mocha.describe ("Haxe | ID3Info", function () {
	
	
	Mocha.it ("album", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.album;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("artist", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.artist;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("comment", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.comment;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("genre", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.genre;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("songName", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.songName;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("track", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.track;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("year", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.year;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		Assert.notEqual (id3Info, null);
		
	});
	
	
}); }}