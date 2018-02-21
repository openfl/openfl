package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.Stage;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl.display.Graphics)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:allow(openfl.display.Stage)


class CairoRenderer extends AbstractRenderer {
	
	
	private var cairo:Cairo;
	
	
	public function new (stage:Stage, cairo:Cairo) {
		
		super (stage);
		
		#if lime_cairo
		this.cairo = cairo;
		
		renderSession = new RenderSession ();
		renderSession.clearRenderDirty = true;
		renderSession.cairo = cairo;
		//renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.renderType = CAIRO;
		renderSession.maskManager = new CairoMaskManager (renderSession);
		renderSession.blendModeManager = new CairoBlendModeManager (renderSession);
		#end
		
	}
	
	
	public override function clear ():Void {
		
		if (cairo == null) return;
		
		cairo.identityMatrix ();
		
		if (stage.__clearBeforeRender) {
			
			cairo.setSourceRGB (stage.__colorSplit[0], stage.__colorSplit[1], stage.__colorSplit[2]);
			cairo.paint ();
			
		}
		
	}
	
	
	public override function render ():Void {
		
		if (cairo == null) return;
		
		renderSession.allowSmoothing = (stage.quality != LOW);
		
		stage.__renderCairo (renderSession);
		
	}
	
	
	public override function renderStage3D ():Void {
		
		if (cairo == null) return;
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderCairo (stage, renderSession);
			
		}
		
	}
	
	
}