import CubeTexture from "openfl/display3D/textures/CubeTexture";
import Context3DTextureFormat from "openfl/display3D/Context3DTextureFormat";
import Stage3DTest from "./../../display/Stage3DTest";
import * as assert from "assert";


describe ("TypeScript | CubeTexture", function () {
	
	
	it ("uploadCompressedTextureFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, Context3DTextureFormat.BGRA, false);
			var exists = cubeTexture.uploadCompressedTextureFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromBitmapData", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, Context3DTextureFormat.BGRA, false);
			var exists = cubeTexture.uploadFromBitmapData;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
	it ("uploadFromByteArray", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var cubeTexture = context3D.createCubeTexture (1, Context3DTextureFormat.BGRA, false);
			var exists = cubeTexture.uploadFromByteArray;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});