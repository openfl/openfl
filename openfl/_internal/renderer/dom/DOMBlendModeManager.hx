package openfl._internal.renderer.dom;


import openfl._internal.renderer.AbstractBlendModeManager;
import openfl._internal.renderer.RenderSession;
import openfl.display.BlendMode;


class DOMBlendModeManager extends AbstractBlendModeManager {
	
	
	public var currentBlendMode:BlendMode;
	public var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		super ();
		
		this.renderSession = renderSession;
		
	}
	
	
	public override function setBlendMode (blendMode:BlendMode):Void {
		
		if (currentBlendMode == blendMode) return;
		
		currentBlendMode = blendMode;
		
		if (renderSession.context != null) {
			
			switch (blendMode) {
				
				case ADD:
					
					renderSession.context.globalCompositeOperation = "lighter";
				
				case ALPHA:
					
					renderSession.context.globalCompositeOperation = "destination-in";
				
				case DARKEN:
					
					renderSession.context.globalCompositeOperation = "darken";
				
				case DIFFERENCE:
					
					renderSession.context.globalCompositeOperation = "difference";
				
				case ERASE:
					
					renderSession.context.globalCompositeOperation = "destination-out";
				
				case HARDLIGHT:
					
					renderSession.context.globalCompositeOperation = "hard-light";
				
				//case INVERT:
					
					//renderSession.context.globalCompositeOperation = "";
				
				case LAYER:
					
					renderSession.context.globalCompositeOperation = "source-over";
				
				case LIGHTEN:
					
					renderSession.context.globalCompositeOperation = "lighten";
				
				case MULTIPLY:
					
					renderSession.context.globalCompositeOperation = "multiply";
				
				case OVERLAY:
					
					renderSession.context.globalCompositeOperation = "overlay";
				
				case SCREEN:
					
					renderSession.context.globalCompositeOperation = "screen";
				
				//case SHADER:
					
					//renderSession.context.globalCompositeOperation = "";
				
				//case SUBTRACT:
					
					//renderSession.context.globalCompositeOperation = "";
				
				default:
					
					renderSession.context.globalCompositeOperation = "source-over";
					
			}
			
		}
		
	}
	
	
}
