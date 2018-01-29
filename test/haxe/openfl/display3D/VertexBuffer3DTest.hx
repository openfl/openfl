package openfl.display3D;


import openfl.display.Stage3DTest;
import openfl.display3D.VertexBuffer3D;


class VertexBuffer3DTest { public static function __init__ () { Mocha.describe ("Haxe | VertexBuffer3D", function () {
	
	
	Mocha.it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.dispose;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.uploadFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromTypedArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			vertexBuffer.uploadFromTypedArray (null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromVector", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.uploadFromVector;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
}); }}