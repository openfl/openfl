import RectangleTexture from "openfl/display3D/textures/RectangleTexture";
import Context3DTextureFormat from "openfl/display3D/Context3DTextureFormat";
import Stage3DTest from "./../../display/Stage3DTest";
import * as assert from "assert";


describe ("TypeScript | RectangleTexture", function () {
	
	
	it ("uploadFromBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var rectangleTexture = context3D.createRectangleTexture (1, 1, Context3DTextureFormat.BGRA, false);
			var exists = rectangleTexture.uploadFromBitmapData;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var rectangleTexture = context3D.createRectangleTexture (1, 1, Context3DTextureFormat.BGRA, false);
			var exists = rectangleTexture.uploadFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});