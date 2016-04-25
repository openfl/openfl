package openfl._internal.renderer.cairo;

import lime.graphics.cairo.CairoOperator;
import openfl._internal.renderer.BlendModeManager;
import openfl._internal.renderer.RenderSession;
import openfl.display.BlendMode;


class CairoBlendModeManager implements BlendModeManager {
	
	public var currentBlendMode:BlendMode;
	public var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		this.renderSession = renderSession;
		currentBlendMode = null;
		
	}
	
	
	public function destroy ():Void {
		
	}
	
	
	public function setBlendMode (blendMode:BlendMode, ?force:Bool = false):Bool {
		
		if (blendMode == null) {
			
			blendMode = BlendMode.NORMAL;
			force = true;
			
		}
		
		if (!force && currentBlendMode == blendMode) {
			
			return false;
			
		}
		
		currentBlendMode = blendMode;
		
		switch (blendMode) {
			
			case ADD:
				
				renderSession.cairo.operator = CairoOperator.ADD;
			
			case ALPHA:
			
				//TODO;
				
			case DARKEN:
			
				renderSession.cairo.operator = CairoOperator.DARKEN;
				
			case DIFFERENCE:
			
				renderSession.cairo.operator = CairoOperator.DIFFERENCE;
			
			case ERASE:
			
				//TODO;
				
			case HARDLIGHT:
			
				renderSession.cairo.operator = CairoOperator.HARD_LIGHT;
				
			case INVERT:
			
				//TODO
				
			case LAYER:
			
				renderSession.cairo.operator = CairoOperator.OVER;
				
			case LIGHTEN:
			
				renderSession.cairo.operator = CairoOperator.LIGHTEN;
				
			case MULTIPLY:
			
				renderSession.cairo.operator = CairoOperator.MULTIPLY;
				
			case NORMAL:
			
				renderSession.cairo.operator = CairoOperator.OVER;
				
			case OVERLAY:
			
				renderSession.cairo.operator = CairoOperator.OVERLAY;
				
			case SCREEN:
			
				renderSession.cairo.operator = CairoOperator.SCREEN;
				
			case SHADER:
			
				//TODO
				
			case SUBTRACT:
			
				//TODO;
		}
		
		return true;
		
	}
	
	
}
