import VertexBuffer3D from "openfl/display3D/VertexBuffer3D";
import Stage3DTest from "./../display/Stage3DTest";
import * as assert from "assert";


describe ("TypeScript | VertexBuffer3D", function () {
	
	
	it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.dispose;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.uploadFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromTypedArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			vertexBuffer.uploadFromTypedArray (null);
			
		}
		
	});
	
	
	it ("uploadFromVector", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var vertexBuffer = context3D.createVertexBuffer (1, 1);
			var exists = vertexBuffer.uploadFromVector;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});