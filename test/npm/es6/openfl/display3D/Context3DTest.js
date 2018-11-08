import Context3D from "openfl/display3D/Context3D";
import Stage3DTest from "./../display/Stage3DTest";
import * as assert from "assert";


describe ("ES6 | Context3D", function () {
	
	
	it ("driverInfo", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.driverInfo;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("enableErrorChecking", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.enableErrorChecking;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			// #if !neko
			var exists = context3D.clear;
			
			assert.notEqual (exists, null);
			// #end
			
		}
		
	});
	
	
	it ("configureBackBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			// #if !neko
			var exists = context3D.configureBackBuffer;
			
			assert.notEqual (exists, null);
			// #end
			
		}
		
	});
	
	
	it ("createCubeTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createCubeTexture;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("createIndexBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createIndexBuffer;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("createProgram", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createProgram;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("createRectangleTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createRectangleTexture;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("createTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createTexture;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("createVertexBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createVertexBuffer;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.dispose;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("drawToBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.drawToBitmapData;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("drawTriangles", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.drawTriangles;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("present", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.present;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setBlendFactors", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setBlendFactors;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setColorMask", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setColorMask;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setCulling", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setCulling;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setDepthTest", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setDepthTest;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	it ("setProgram", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgram;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setProgramConstantsFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgramConstantsFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	it ("setProgramConstantsFromMatrix", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgramConstantsFromMatrix;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setProgramConstantsFromVector", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgramConstantsFromVector;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setRenderToBackBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setRenderToBackBuffer;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setRenderToTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setRenderToTexture;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setSamplerStateAt", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setSamplerStateAt;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setScissorRectangle", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setStencilActions;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setStencilReferenceValue", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setStencilReferenceValue;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setTextureAt", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setTextureAt;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("setVertexBufferAt", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setVertexBufferAt;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});