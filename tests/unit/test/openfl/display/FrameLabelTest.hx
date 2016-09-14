package openfl.display;


import massive.munit.Assert;
import openfl.display.FrameLabel;


class FrameLabelTest {
	
	
	@Test public function frame () {
		
		var frameLabel = new FrameLabel (null, 0);
		Assert.areEqual (0, frameLabel.frame);
		var frameLabel = new FrameLabel (null, 100);
		Assert.areEqual (100, frameLabel.frame);
		
	}
	
	
	@Test public function name () {
		
		var frameLabel = new FrameLabel ("abc", 0);
		Assert.areEqual ("abc", frameLabel.name);
		var frameLabel = new FrameLabel (null, 0);
		Assert.isNull (frameLabel.name);
		
	}
	
	
	@Test public function frameLabel () {
		
		var frameLabel = new FrameLabel (null, 0);
		Assert.isNull (frameLabel.name);
		Assert.areEqual (0, frameLabel.frame);
		
	}
	
	
}