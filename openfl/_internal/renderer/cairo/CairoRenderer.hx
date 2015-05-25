package openfl._internal.renderer.cairo;


import lime.graphics.cairo.Cairo;
import lime.graphics.cairo.CairoSurface;
import lime.math.Matrix3;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.Graphics;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.text.TextField;

@:access(openfl.geom.Matrix)
@:access(openfl.display.Stage)
@:allow(openfl.display.Stage)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Graphics)


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
	
	public static function renderTextField (textField:TextField, renderSession:RenderSession):Void {
				
		#if lime_cairo
		
		if (!textField.__renderable || textField.__worldAlpha <= 0) return;
		
		var bounds = textField.getBounds( null );
				
		CairoTextField.render (textField, renderSession );
		
		if (textField.__graphics.__cairo != null) {
			
			if (textField.__mask != null) {
				renderSession.maskManager.pushMask (textField.__mask);
			}
			
			var cairo : Cairo = renderSession.cairo;
			var scrollRect = textField.scrollRect;
			var transform = textField.__worldTransform;
			
			cairo.identityMatrix();
			
			if (renderSession.roundPixels) {
				
				var matrix = transform.__toMatrix3 ();
				matrix.tx = Math.round (matrix.tx);
				matrix.ty = Math.round (matrix.ty);
				cairo.matrix = matrix;
				
			} else {
				
				cairo.matrix = transform.__toMatrix3();
			}			

			cairo.scale( 1 / textField.scaleX, 1 / textField.scaleY );
			
			cairo.setSourceSurface (textField.__graphics.__cairo.target, 0, 0 );
			
			if (scrollRect != null) {
				
				cairo.pushGroup ();
				cairo.newPath ();
				cairo.rectangle (bounds.x + scrollRect.x, bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
				cairo.fill ();
				cairo.popGroupToSource ();
				
			}
			
			cairo.paintWithAlpha (textField.__worldAlpha);
			
			if (textField.__mask != null) {
				
				renderSession.maskManager.popMask ();
				
			}
			
		}
	
		#end
	}
	
	public static function renderDisplayObject( shape:DisplayObject, renderSession:RenderSession): Void {

		#if lime_cairo
		if (!shape.__renderable || shape.__worldAlpha <= 0) return;
		
		var graphics = shape.__graphics;
		
		if (graphics != null) {
			
			CairoGraphics.render ( shape, renderSession );
			
			if (graphics.__cairo != null) {
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.pushMask (shape.__mask);
					
				}
				
				var cairo = renderSession.cairo;
				var scrollRect = shape.scrollRect;
				
				//context.globalAlpha = shape.__worldAlpha;
				var transform = shape.__worldTransform;
				
				if (renderSession.roundPixels) {
					
					var matrix = transform.__toMatrix3 ();
					matrix.tx = Math.round (matrix.tx);
					matrix.ty = Math.round (matrix.ty);
					cairo.matrix = matrix;
					
				} else {
					
					cairo.matrix = transform.__toMatrix3 ();
					
				}
				
				cairo.scale( 1 / shape.scaleX, 1 / shape.scaleY );
				
				cairo.setSourceSurface (graphics.__cairo.target, graphics.__bounds.x, graphics.__bounds.y);
				
				if (scrollRect != null) {
					
					cairo.pushGroup ();
					cairo.newPath ();
					cairo.rectangle (graphics.__bounds.x + scrollRect.x, graphics.__bounds.y + scrollRect.y, scrollRect.width, scrollRect.height);
					cairo.fill ();
					cairo.popGroupToSource ();
					
				}
				
				cairo.paintWithAlpha (shape.__worldAlpha);
				
				if (shape.__mask != null) {
					
					renderSession.maskManager.popMask ();
					
				}
				
			}
			
		}
		#end
	}
	
	
}