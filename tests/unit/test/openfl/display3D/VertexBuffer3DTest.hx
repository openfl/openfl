package openfl.display3D;


import massive.munit.Assert;
import openfl.display.Stage3DTest;
import openfl.display3D.VertexBuffer3D;


class VertexBuffer3DTest {
	
	
	@Test public function dispose () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.dispose;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function uploadFromByteArray () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.uploadFromByteArray;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function uploadFromTypedArray () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			vertexBuffer.uploadFromTypedArray (null);
			
		}
		
	}
	
	
	@Test public function uploadFromVector () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.uploadFromVector;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
}