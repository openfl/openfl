package openfl.display;


import massive.munit.Assert;
import openfl.display.Stage3D;
import openfl.display3D.Context3D;


class Stage3DTest {
	
	
	@Test public function context3D () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.context3D;
		
		#if flash
		Assert.isNull (exists);
		#end
		
	}
	
	
	@Test public function visible () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.visible;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function x () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.x;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function y () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.y;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function new_ () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function requestContext3D () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3D;
		
		Assert.isNotNull (exists);
		
	}
	
	
	@Test public function requestContext3DMatchingProfiles  () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3DMatchingProfiles;
		
		Assert.isNotNull (exists);
		
	}
	
	
	public static function __getContext3D ():Context3D {
		
		// TODO: Create the context in advance?
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		
		// This is not currently stable
		return null;
		
		if (stage3D != null) {
			
			if (stage3D.context3D == null) {
				
				// munit template does not have the correct wmode for Stage3D
				
				#if !flash
				
				stage3D.addEventListener ("context3DCreate", function (_) {});
				stage3D.requestContext3D ();
				
				#end
				
			}
			
			return stage3D.context3D;
			
		}
		
		return null;
		
	}
	
	
}