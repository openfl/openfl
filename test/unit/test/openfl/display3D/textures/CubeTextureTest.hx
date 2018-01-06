package openfl.display3D.textures;


import massive.munit.Assert;
import openfl.display.Stage3DTest;
import openfl.display3D.textures.CubeTexture;


class CubeTextureTest {
	
	
	@Test public function uploadCompressedTextureFromByteArray () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, BGRA, false);
			var exists = cubeTexture.uploadCompressedTextureFromByteArray;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function uploadFromBitmapData () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, BGRA, false);
			var exists = cubeTexture.uploadFromBitmapData;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function uploadFromByteArray () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, BGRA, false);
			var exists = cubeTexture.uploadFromByteArray;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
}