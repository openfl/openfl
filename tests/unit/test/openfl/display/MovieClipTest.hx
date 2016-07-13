package openfl.display;


import massive.munit.Assert;
import openfl.display.MovieClip;


class MovieClipTest {
	
	
	@Test public function currentFrame () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentFrame;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function currentFrameLabel () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentFrameLabel;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function currentLabel () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentLabel;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function currentLabels () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.currentLabels;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function enabled () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.enabled;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function framesLoaded () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.framesLoaded;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function totalFrames () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.totalFrames;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		
		Assert.isNotNull (movieClip);
		
	}
	
	
	@Test public function gotoAndPlay () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.gotoAndPlay;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function gotoAndStop () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.gotoAndStop;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function nextFrame () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.nextFrame;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function play () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.play;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function prevFrame () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.prevFrame;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stop () {
		
		// TODO: Confirm functionality
		
		var movieClip = new MovieClip ();
		var exists = movieClip.stop;
		
		Assert.isNotNull (exists);
		
	}
	
	
}