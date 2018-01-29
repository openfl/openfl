import Context3DTextureFilter from "openfl/display3D/Context3DTextureFilter";
import * as assert from "assert";


describe ("TypeScript | Context3DTextureFilter", function () {
	
	
	it ("test", function () {
		
		switch (+Context3DTextureFilter.ANISOTROPIC16X) {
			
			case Context3DTextureFilter.ANISOTROPIC16X:
			case Context3DTextureFilter.ANISOTROPIC2X:
			case Context3DTextureFilter.ANISOTROPIC4X:
			case Context3DTextureFilter.ANISOTROPIC8X:
			case Context3DTextureFilter.LINEAR:
			case Context3DTextureFilter.NEAREST:
				break;
			
		}
		
	});
	
	
});