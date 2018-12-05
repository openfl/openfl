package openfl.display3D.textures;


import openfl.display.Stage3DTest;
import openfl.display3D.textures.Texture;


class TextureTest { public static function __init__ () { Mocha.describe ("Haxe | Texture", function () {
	
	
	Mocha.it ("uploadCompressedTextureFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, BGRA, false);
			var exists = texture.uploadCompressedTextureFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, BGRA, false);
			var exists = texture.uploadFromBitmapData;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, BGRA, false);
			var exists = texture.uploadFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
}); }}