package openfl.display3D;



import openfl.display.Stage3DTest;
import openfl.display3D.Context3D;


class Context3DTest { public static function __init__ () { Mocha.describe ("Haxe | Context3D", function () {
	
	
	Mocha.it ("driverInfo", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.driverInfo;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("enableErrorChecking", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.enableErrorChecking;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("clear", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			#if !neko
			var exists = context3D.clear;
			
			Assert.notEqual (exists, null);
			#end
			
		}
		
	});
	
	
	Mocha.it ("configureBackBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			#if !neko
			var exists = context3D.configureBackBuffer;
			
			Assert.notEqual (exists, null);
			#end
			
		}
		
	});
	
	
	Mocha.it ("createCubeTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createCubeTexture;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("createIndexBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createIndexBuffer;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("createProgram", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createProgram;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("createRectangleTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createRectangleTexture;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("createTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createTexture;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("createVertexBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.createVertexBuffer;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.dispose;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("drawToBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.drawToBitmapData;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("drawTriangles", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.drawTriangles;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("present", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.present;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setBlendFactors", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setBlendFactors;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setColorMask", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setColorMask;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setCulling", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setCulling;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setDepthTest", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setDepthTest;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	Mocha.it ("setProgram", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgram;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setProgramConstantsFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgramConstantsFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	Mocha.it ("setProgramConstantsFromMatrix", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgramConstantsFromMatrix;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setProgramConstantsFromVector", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setProgramConstantsFromVector;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setRenderToBackBuffer", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setRenderToBackBuffer;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setRenderToTexture", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setRenderToTexture;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setSamplerStateAt", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setSamplerStateAt;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setScissorRectangle", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setStencilActions;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setStencilReferenceValue", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setStencilReferenceValue;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setTextureAt", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setTextureAt;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("setVertexBufferAt", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var exists = context3D.setVertexBufferAt;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
}); }}