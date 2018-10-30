package openfl.media;


class SoundTest { public static function __init__ () { Mocha.describe ("Haxe | Sound", function () {
	
	
	Mocha.it ("bytesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.bytesLoaded;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("bytesTotal", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.bytesTotal;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("id3", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.id3;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("isBuffering", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.isBuffering;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("length", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.length;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("url", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.url;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		Assert.notEqual (sound, null);
		
	});
	
	
	Mocha.it ("close", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.close;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("load", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.load;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("loadCompressedDataFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.loadCompressedDataFromByteArray;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("loadPCMFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.loadPCMFromByteArray;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("play", function () {
		
		// TODO: Confirm functionality
		
		var sound = new Sound ();
		var exists = sound.play;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}