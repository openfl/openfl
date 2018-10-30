package openfl.display3D.textures;


import massive.munit.Assert;
import openfl.display.Stage3DTest;
import openfl.display3D.textures.Texture;


class TextureTest {
	
	
	@Test public function uploadCompressedTextureFromByteArray () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, BGRA, false);
			var exists = texture.uploadCompressedTextureFromByteArray;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function uploadFromBitmapData () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, BGRA, false);
			var exists = texture.uploadFromBitmapData;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
	@Test public function uploadFromByteArray () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, BGRA, false);
			var exists = texture.uploadFromByteArray;
			
			Assert.isNotNull (exists);
			
		}
		
	}
	
	
}