package openfl.display3D.textures;


import openfl.display.Stage3DTest;
import openfl.display3D.textures.RectangleTexture;


class RectangleTextureTest { public static function __init__ () { Mocha.describe ("Haxe | RectangleTexture", function () {
	
	
	Mocha.it ("uploadFromBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var rectangleTexture = context3D.createRectangleTexture (1, 1, BGRA, false);
			var exists = rectangleTexture.uploadFromBitmapData;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
	Mocha.it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var rectangleTexture = context3D.createRectangleTexture (1, 1, BGRA, false);
			var exists = rectangleTexture.uploadFromByteArray;
			
			Assert.notEqual (exists, null);
			
		}
		
	});
	
	
}); }}