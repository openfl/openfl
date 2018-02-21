import Context3DVertexBufferFormat from "openfl/display3D/Context3DVertexBufferFormat";
import * as assert from "assert";


describe ("ES6 | Context3DVertexBuffer", function () {
	
	
	it ("test", function () {
		
		switch (+Context3DVertexBufferFormat.BYTES_4) {
			
			case Context3DVertexBufferFormat.BYTES_4:
			case Context3DVertexBufferFormat.FLOAT_1:
			case Context3DVertexBufferFormat.FLOAT_2:
			case Context3DVertexBufferFormat.FLOAT_3:
			case Context3DVertexBufferFormat.FLOAT_4:
				break;
			
		}
		
	});
	
	
});