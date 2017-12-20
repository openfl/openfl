package openfl.display3D;


import openfl.display.Stage3DTest;
import openfl.display3D.IndexBuffer3D;


class IndexBuffer3DTest { public static function __init__ () { Mocha.describe ("Haxe | IndexBuffer3D", function () {
	
	
	Mocha.it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			var exists = indexBuffer.dispose;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			var exists = indexBuffer.uploadFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromTypedArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			indexBuffer.uploadFromTypedArray (null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromVector", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			var exists = indexBuffer.uploadFromVector;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
}); }}