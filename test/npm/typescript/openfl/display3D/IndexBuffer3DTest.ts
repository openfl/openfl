import IndexBuffer3D from "openfl/display3D/IndexBuffer3D";
import Stage3DTest from "./../display/Stage3DTest";
import * as assert from "assert";


describe ("TypeScript | IndexBuffer3D", function () {
	
	
	it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			var exists = indexBuffer.dispose;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			var exists = indexBuffer.uploadFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromTypedArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			indexBuffer.uploadFromTypedArray (null);
			
		}
		
	});
	
	
	it ("uploadFromVector", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var indexBuffer = context3D.createIndexBuffer (1);
			var exists = indexBuffer.uploadFromVector;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});