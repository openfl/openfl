package openfl.display3D.textures;


import openfl.display.Stage3DTest;
import openfl.display3D.textures.CubeTexture;


class CubeTextureTest { public static function __init__ () { Mocha.describe ("Haxe | CubeTexture", function () {
	
	
	Mocha.it ("uploadCompressedTextureFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, BGRA, false);
			var exists = cubeTexture.uploadCompressedTextureFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, BGRA, false);
			var exists = cubeTexture.uploadFromBitmapData;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, BGRA, false);
			var exists = cubeTexture.uploadFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
}); }}