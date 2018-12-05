import Stage3D from "openfl/display/Stage3D";
import Context3D from "openfl/display3D/Context3D";
import * as assert from "assert";


describe ("TypeScript | Stage3D", function () {
	
	/*
	it ("context3D", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.context3D;
		
		#if flash
		assert.equal (exists, null);
		#end
		
	});
	
	
	it ("visible", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.visible;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("x", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.x;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("y", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.y;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("new", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("requestContext3D", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3D;
		
		assert.notEqual (exists, null);
		
	});
	
	
	it ("requestContext3DMatchingProfiles ", function () {
		
		// TODO: Confirm functionality
		
		var stage3D = Lib.current.stage.stage3Ds[0];
		var exists = stage3D.requestContext3DMatchingProfiles;
		
		assert.notEqual (exists, null);
		
	});
	*/
	
});


export class Stage3DTest {
	
	
	static __getContext3D ():Context3D {
		
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


export default Stage3DTest;