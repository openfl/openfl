import ID3Info from "openfl/media/ID3Info";
import Sound from "openfl/media/Sound";
import * as assert from "assert";


describe ("ES6 | ID3Info", function () {
	
	
	it ("album", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.album;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("artist", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.artist;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("comment", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.comment;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("genre", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.genre;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("songName", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.songName;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("track", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.track;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("year", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		var exists = id3Info.year;
		
		assert.equal (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var id3Info = new Sound ().id3;
		assert.notEqual (id3Info, null);
		
	});
	
	
});