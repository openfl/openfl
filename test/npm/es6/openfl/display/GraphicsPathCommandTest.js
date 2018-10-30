import GraphicsPathCommand from "openfl/display/GraphicsPathCommand";
import * as assert from "assert";


describe ("ES6 | GraphicsPathCommand", function () {
	
	
	it ("test", function () {
		
		switch (+GraphicsPathCommand.NO_OP) {
			
			case GraphicsPathCommand.NO_OP:
			case GraphicsPathCommand.MOVE_TO:
			case GraphicsPathCommand.LINE_TO:
			case GraphicsPathCommand.CURVE_TO:
			case GraphicsPathCommand.WIDE_MOVE_TO:
			case GraphicsPathCommand.WIDE_LINE_TO:
			/*case GraphicsPathCommand.CUBIC_CURVE_TO:*/
				break;
			
			default:
			
		}
		
	});
	
	
});