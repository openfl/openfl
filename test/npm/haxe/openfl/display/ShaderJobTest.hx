package openfl.display;


import openfl.display.ShaderJob;


class ShaderJobTest { public static function __init__ () { Mocha.describe ("Haxe | ShaderJob", function () {
	
	
	Mocha.it ("height", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.height;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("progress", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.progress;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("shader", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.shader;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("target", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.target;
		
		Assert.equal (exists, null);
		
	});
	
	
	Mocha.it ("width", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.width;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("cancel", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.cancel;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("start", function () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.start;
		
		Assert.notEqual (exists, null);
		
	});
	
	
}); }}