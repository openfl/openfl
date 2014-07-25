package openfl._internal.renderer.canvas;


import lime.graphics.CanvasRenderContext;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.Shape;
import openfl.display.Stage;

@:access(openfl.display.Graphics)
@:access(openfl.display.Shape)
@:access(openfl.display.Stage)


class CanvasRenderer extends AbstractRenderer {
	
	
	private var context:CanvasRenderContext;
	
	
	public function new (width:Int, height:Int, context:CanvasRenderContext) {
		
		super (width, height);
		
		this.context = context;
		
		renderSession = new RenderSession ();
		renderSession.context = context;
		renderSession.roundPixels = true;
		
	}
	
	
	public override function render (stage:Stage):Void {
		
		context.setTransform (1, 0, 0, 1, 0, 0);
		context.globalAlpha = 1;
		
		if (!stage.__transparent && stage.__clearBeforeRender) {
			
			context.fillStyle = stage.__colorString;
			context.fillRect (0, 0, stage.stageWidth, stage.stageHeight);
			
		} else if (stage.__transparent && stage.__clearBeforeRender) {
			
			context.clearRect (0, 0, stage.stageWidth, stage.stageHeight);
			
		}
		
		stage.__renderCanvas (renderSession);
		
	}
	
	
	public static inline function renderShape (shape:Shape, renderSession:RenderSession):Void {
		
		#if js
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CanvasGraphics.render (graphics, renderSession);
			
			if (graphics.__canvas != null) {
				
				var context = renderSession.context;
				var scrollRect = shape.scrollRect;
				
				context.globalAlpha = shape.__worldAlpha;
				var transform = shape.__worldTransform;
				
				if (renderSession.roundPixels) {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, Std.int (transform.tx), Std.int (transform.ty));
					
				} else {
					
					context.setTransform (transform.a, transform.b, transform.c, transform.d, transform.tx, transform.ty);
					
				}
				
				if (scrollRect == null) {
					
					context.drawImage (graphics.__canvas, graphics.__bounds.x, graphics.__bounds.y);
					
				} else {
					
					context.drawImage (graphics.__canvas, scrollRect.x - graphics.__bounds.x, scrollRect.y - graphics.__bounds.y, scrollRect.width, scrollRect.height, graphics.__bounds.x + scrollRect.x, graphics.__bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
					
				}
				
			}
			
		}
		#end
		
	}
	
	
}