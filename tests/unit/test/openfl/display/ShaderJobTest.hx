package openfl.display;


import massive.munit.Assert;
import openfl.display.ShaderJob;


class ShaderJobTest {
	
	
	@Test public function height () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.height;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function progress () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.progress;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function shader () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.shader;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function target () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.target;
		
		Assert.isNull (exists);
		
	}
	
	
	@Test public function width () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.width;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function cancel () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.cancel;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function start () {
		
		// TODO: Confirm functionality
		
		var shaderJob = new ShaderJob ();
		var exists = shaderJob.start;
		
		Assert.isNotNull (exists);
		
	}
	
	
}