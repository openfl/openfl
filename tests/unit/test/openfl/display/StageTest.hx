package openfl.display;


import massive.munit.Assert;
import openfl.Lib;


class StageTest {
	
	
	@Test public function align () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.align;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function allowsFullScreen () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.allowsFullScreen;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function color () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.color;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function displayState () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.displayState;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function focus () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.focus;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function frameRate () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.frameRate;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function quality () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.quality;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function scaleMode () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.scaleMode;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stageFocusRect () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.stageFocusRect;
		
		Assert.isTrue (exists);
		
	}
	
	
	@Test public function stageHeight () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.stageHeight;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function stageWidth () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.stageWidth;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function invalidate () {
		
		// TODO: Confirm functionality
		
		var exists = Lib.current.stage.invalidate;
		
		Assert.isNotNull (exists);
		
	}
	
	
}