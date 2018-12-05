package openfl.display;


import openfl.display.FrameLabel;


class FrameLabelTest { public static function __init__ () { Mocha.describe ("Haxe | FrameLabel", function () {
	
	
	Mocha.it ("frame", function () {
		
		var frameLabel = new FrameLabel (null, 0);
		Assert.equal (frameLabel.frame, 0);
		var frameLabel = new FrameLabel (null, 100);
		Assert.equal (frameLabel.frame, 100);
		
	});
	
	
	Mocha.it ("name", function () {
		
		var frameLabel = new FrameLabel ("abc", 0);
		Assert.equal (frameLabel.name, "abc");
		var frameLabel = new FrameLabel (null, 0);
		Assert.equal (frameLabel.name, null);
		
	});
	
	
	Mocha.it ("frameLabel", function () {
		
		var frameLabel = new FrameLabel (null, 0);
		Assert.equal (frameLabel.name, null);
		Assert.equal (frameLabel.frame, 0);
		
	});
	
	
}); }}