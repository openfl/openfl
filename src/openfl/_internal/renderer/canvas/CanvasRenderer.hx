package openfl._internal.renderer.canvas;


import lime.graphics.CanvasRenderContext;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Stage;
import openfl.geom.Matrix;

#if (js && html5)
import js.Browser;
#end

@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)


class CanvasRenderer extends AbstractRenderer {
	
	
	public static var scale (default, null):Float = 1;
	
	private var context:CanvasRenderContext;
	private var displayMatrix:Matrix;
	private var tempMatrix:Matrix;
	
	
	public function new (stage:Stage, context:CanvasRenderContext) {
		
		super (stage);
		
		this.context = context;
		
		renderSession = new RenderSession ();
		renderSession.clearRenderDirty = true;
		renderSession.context = context;
		//renderSession.roundPixels = true;
		renderSession.renderer = this;
		renderSession.renderType = CANVAS;
		#if !neko
		renderSession.blendModeManager = new CanvasBlendModeManager (renderSession);
		renderSession.maskManager = new CanvasMaskManager (renderSession);
		#end
		
		tempMatrix = new Matrix ();
		
		if (stage != null) {
			
			#if (js && html5)
			var config = stage.window.config;
			
			if (config != null && Reflect.hasField (config, "allowHighDPI") && config.allowHighDPI) {
				
				scale = untyped window.devicePixelRatio || 1;
				
			}
			#end
			
			setDisplayMatrix (stage.__displayMatrix);
			
		} else {
			
			setDisplayMatrix (new Matrix ());
			
		}
		
	}
	
	
	public override function clear ():Void {
		
		renderSession.blendModeManager.setBlendMode (NORMAL);
		
		context.setTransform (1, 0, 0, 1, 0, 0);
		context.globalAlpha = 1;
		
		if (!stage.__transparent && stage.__clearBeforeRender) {
			
			context.fillStyle = stage.__colorString;
			context.fillRect (0, 0, stage.stageWidth * stage.window.scale, stage.stageHeight * stage.window.scale);
			
		} else if (stage.__transparent && stage.__clearBeforeRender) {
			
			context.clearRect (0, 0, stage.stageWidth * stage.window.scale, stage.stageHeight * stage.window.scale);
			
		}
		
	}
	
	
	public override function render ():Void {
		
		renderSession.allowSmoothing = (stage.quality != LOW);
		
		stage.__renderCanvas (renderSession);
		
	}
	
	
	public override function renderStage3D ():Void {
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderCanvas (stage, renderSession);
			
		}
		
	}
	
	
	public override function resize (width:Int, height:Int):Void {
		
		super.resize (width, height);
		
		if (stage != null) {
			
			setDisplayMatrix (stage.__displayMatrix);
			
		}
		
	}
	
	
	public function setDisplayMatrix (matrix:Matrix):Void {
		
		displayMatrix = matrix;
		
	}
	
	
	public function setTransform (context:CanvasRenderContext, transform:Matrix):Void {
		
		if (this.context == context) {
			
			tempMatrix.copyFrom (transform);
			tempMatrix.concat (displayMatrix);
			transform = tempMatrix;
			
		}
		
		if (renderSession.roundPixels) {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
			
		} else {
			
			context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
			
		}
		
	}
	
	
}