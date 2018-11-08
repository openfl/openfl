import BlendMode from "openfl/display/BlendMode";
import * as assert from "assert";


describe ("ES6 | BlendMode", function () {
	
	
	it ("test", function () {
		
		switch (""+BlendMode.SUBTRACT) {
			
			case BlendMode.ADD:
			case BlendMode.ALPHA:
			case BlendMode.DARKEN:
			case BlendMode.DIFFERENCE:
			case BlendMode.ERASE:
			case BlendMode.HARDLIGHT:
			case BlendMode.INVERT:
			case BlendMode.LAYER:
			case BlendMode.LIGHTEN:
			case BlendMode.MULTIPLY:
			case BlendMode.NORMAL:
			case BlendMode.OVERLAY:
			case BlendMode.SCREEN:
			case BlendMode.SUBTRACT:
			case BlendMode.SHADER:
				break;
			
			default:
				assert.ok (false);
			
		}
		
	});
	
	
});