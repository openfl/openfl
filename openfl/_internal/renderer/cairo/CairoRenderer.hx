package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:allow(openfl.display.Stage)


class CairoRenderer extends AbstractRenderer {
	
	
	private var cairo:Cairo;
	
	
	public function new (width:Int, height:Int, cairo:Cairo) {
		
		super (width, height);
		
		this.cairo = cairo;
		
		renderSession = new RenderSession ();
		renderSession.cairo = cairo;
		renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.maskManager = new CairoMaskManager (renderSession);
		
	}
	
	
	public override function render (stage:Stage):Void {
		
		cairo.identityMatrix ();
		
		if (stage.__clearBeforeRender) {
			
			cairo.setSourceRGB (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2]);
			cairo.paint ();
			
		}
		
		stage.__renderCairo (renderSession);
		
	}
	
	
}