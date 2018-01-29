package openfl.display;


import openfl.display.Stage3D;
import openfl.display3D.Context3D;


class Stage3DTest { public static function __init__ () { Mocha.describe ("Haxe | Stage3D", function () {
	
	/*
	Mocha.it ("context3D", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.context3D;
		
		#if flash
		Assert.equal (exists, null);
		#end
		
	});
	
	
	Mocha.it ("visible", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.visible;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("x", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.x;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("y", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.y;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("new", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("requestContext3D", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3D;
		
		Assert.notEqual (exists, null);
		
	});
	
	
	Mocha.it ("requestContext3DMatchingProfiles ", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3DMatchingProfiles;
		
		Assert.notEqual (exists, null);
		
	});
	*/
	
}); }
	
	
	public static function __getContext3D ():Context3D {
		
		// TODO: Create the context in advance?
		
		//var stage3D = Lib.current.stage.stage3Ds[0];
		
		// This is not currently stable
		return null;
		
		// if (stage3D != null) {
			
		// 	if (stage3D.context3D == null) {
				
		// 		// munit template does not have the correct wmode for Stage3D
				
		// 		#if !flash
				
		// 		stage3D.addEventListener ("context3DCreate", function (_) {});
		// 		stage3D.requestContext3D ();
				
		// 		#end
				
		// 	}
			
		// 	return stage3D.context3D;
			
		// }
		
		// return null;
		
	}
	
	
}