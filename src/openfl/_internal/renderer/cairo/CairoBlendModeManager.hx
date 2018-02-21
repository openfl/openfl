package openfl._internal.renderer.cairo;


import lime.graphics.cairo.CairoOperator;
import openfl._internal.renderer.AbstractBlendModeManager;
import openfl._internal.renderer.RenderSession;
import openfl.display.BlendMode;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end


class CairoBlendModeManager extends AbstractBlendModeManager {
	
	
	public var currentBlendMode:BlendMode;
	public var renderSession:RenderSession;
	
	
	public function new (renderSession:RenderSession) {
		
		super ();
		
		this.renderSession = renderSession;
		
	}
	
	
	public override function setBlendMode (blendMode:BlendMode):Void {
		
		if (currentBlendMode == blendMode) return;
		
		currentBlendMode = blendMode;
		
		switch (blendMode) {
			
			case ADD:
				
				renderSession.cairo.operator = CairoOperator.ADD;
			
			//case ALPHA:
				
				//TODO;
			
			case DARKEN:
				
				renderSession.cairo.operator = CairoOperator.DARKEN;
			
			case DIFFERENCE:
				
				renderSession.cairo.operator = CairoOperator.DIFFERENCE;
			
			//case ERASE:
				
				//TODO;
			
			case HARDLIGHT:
				
				renderSession.cairo.operator = CairoOperator.HARD_LIGHT;
			
			//case INVERT:
				
				//TODO
			
			case LAYER:
				
				renderSession.cairo.operator = CairoOperator.OVER;
			
			case LIGHTEN:
				
				renderSession.cairo.operator = CairoOperator.LIGHTEN;
			
			case MULTIPLY:
				
				renderSession.cairo.operator = CairoOperator.MULTIPLY;
			
			case OVERLAY:
				
				renderSession.cairo.operator = CairoOperator.OVERLAY;
			
			case SCREEN:
				
				renderSession.cairo.operator = CairoOperator.SCREEN;
			
			//case SHADER:
				
				//TODO
			
			//case SUBTRACT:
				
				//TODO;
			
			default:
				
				renderSession.cairo.operator = CairoOperator.OVER;
			
		}
		
	}
	
	
}