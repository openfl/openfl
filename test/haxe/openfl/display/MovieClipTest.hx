package openfl.display;


import openfl.display.MovieClip;


class MovieClipTest { public static function __init__ () { Mocha.describe ("Haxe | MovieClip", function () {
	
	
	Mocha.it ("currentFrame", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentFrame;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("currentFrameLabel", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentFrameLabel;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("currentLabel", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentLabel;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("currentLabels", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentLabels;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("enabled", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.enabled;
		
		Assert.assert (exists);
		
	});
	
	
	Mocha.it ("framesLoaded", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.framesLoaded;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("totalFrames", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.totalFrames;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		
		Assert.notEqual (movieClip, null);
		
	});
	
	
	Mocha.it ("gotoAndPlay", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.gotoAndPlay;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("gotoAndStop", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.gotoAndStop;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("nextFrame", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.nextFrame;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("play", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.play;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("prevFrame", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.prevFrame;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("stop", function () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.stop;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}