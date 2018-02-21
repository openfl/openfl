package openfl.display3D;


import massive.munit.Assert;
import openfl.display.Stage3DTest;
import openfl.display3D.Program3D;


class Program3DTest {
	
	
	@Test public function dispose () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var program = context3D.createProgram ();
			var exists = program.dispose;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function upload () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var program = context3D.createProgram ();
			var exists = program.upload;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
}