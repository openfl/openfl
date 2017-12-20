import TextureBase from "openfl/display3D/textures/TextureBase";
import Context3DTextureFormat from "openfl/display3D/Context3DTextureFormat";
import Stage3DTest from "./../../display/Stage3DTest";
import * as assert from "assert";


describe ("ES6 | TextureBase", function () {
	
	
	it ("dispose", function () {
		
		// TODO: Confirm functionality
		
		var context3D = Stage3DTest.__getContext3D ();
		
		if (context3D != null) {
			
			var texture = context3D.createTexture (1, 1, Context3DTextureFormat.BGRA, false);
			var exists = texture.dispose;
			
			assert.notEqual (exists, null);
			
		}
		
	});
	
	
});