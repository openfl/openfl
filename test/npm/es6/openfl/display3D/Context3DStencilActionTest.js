import Context3DStencilAction from "openfl/display3D/Context3DStencilAction";
import * as assert from "assert";


describe ("ES6 | Context3DStencilAction", function () {
	
	
	it ("test", function () {
		
		switch (""+Context3DStencilAction.DECREMENT_SATURATE) {
			
			case Context3DStencilAction.DECREMENT_SATURATE:
			case Context3DStencilAction.DECREMENT_WRAP:
			case Context3DStencilAction.INCREMENT_SATURATE:
			case Context3DStencilAction.INCREMENT_WRAP:
			case Context3DStencilAction.INVERT:
			case Context3DStencilAction.KEEP:
			case Context3DStencilAction.SET:
			case Context3DStencilAction.ZERO:
				break;
			
		}
		
	});
	
	
});