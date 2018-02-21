import Context3DTextureFormat from "openfl/display3D/Context3DTextureFormat";
import * as assert from "assert";


describe ("ES6 | Context3DTextureFormat", function () {
	
	
	it ("test", function () {
		
		switch (+Context3DTextureFormat.BGRA) {
			
			case Context3DTextureFormat.BGRA:
			case Context3DTextureFormat.BGRA_PACKED:
			case Context3DTextureFormat.BGR_PACKED:
			case Context3DTextureFormat.COMPRESSED:
			case Context3DTextureFormat.COMPRESSED_ALPHA:
			case Context3DTextureFormat.RGBA_HALF_FLOAT:
				break;
			
		}
		
	});
	
	
});