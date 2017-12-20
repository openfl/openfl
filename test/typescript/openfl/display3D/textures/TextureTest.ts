import Texture from "openfl/display3D/textures/Texture";
import Context3DTextureFormat from "openfl/display3D/Context3DTextureFormat";
import Stage3DTest from "./../../display/Stage3DTest";
import * as assert from "assert";


describe ("TypeScript | Texture", function () {
	
	
	it ("uploadCompressedTextureFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, Context3DTextureFormat.BGRA, false);
			var exists = texture.uploadCompressedTextureFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, Context3DTextureFormat.BGRA, false);
			var exists = texture.uploadFromBitmapData;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, Context3DTextureFormat.BGRA, false);
			var exists = texture.uploadFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});