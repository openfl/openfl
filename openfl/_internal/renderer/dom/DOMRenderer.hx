package openfl._internal.renderer.dom;


import lime.graphics.DOMRenderContext;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.canvas.CanvasGraphics;
import openfl._internal.renderer.RenderSession;
import openfl.display.Shape;
import openfl.display.Stage;
import openfl.geom.Matrix;

#if js
import js.html.CSSStyleDeclaration;
import js.Browser;
#end

@:access(openfl.display.Graphics)
@:access(openfl.display.Shape)
@:access(openfl.display.Stage)


class DOMRenderer extends AbstractRenderer {
	
	
	private var element:DOMRenderContext;
	
	
	public function new (width:Int, height:Int, element:DOMRenderContext) {
		
		super (width, height);
		
		this.element = element;
		
		renderSession = new RenderSession ();
		renderSession.element = element;
		renderSession.roundPixels = true;
		
		#if js
		var prefix = untyped __js__ ("(function () {
		  var styles = window.getComputedStyle(document.documentElement, ''),
			pre = (Array.prototype.slice
			  .call(styles)
			  .join('') 
			  .match(/-(moz|webkit|ms)-/) || (styles.OLink === '' && ['', 'o'])
			)[1],
			dom = ('WebKit|Moz|MS|O').match(new RegExp('(' + pre + ')', 'i'))[1];
		  return {
			dom: dom,
			lowercase: pre,
			css: '-' + pre + '-',
			js: pre[0].toUpperCase() + pre.substr(1)
		  };
		})")();
		
		renderSession.vendorPrefix = prefix.lowercase;
		renderSession.transformProperty = (prefix.lowercase == "webkit") ? "-webkit-transform" : "transform";
		renderSession.transformOriginProperty = (prefix.lowercase == "webkit") ? "-webkit-transform-origin" : "transform-origin";
		#end
		
	}
	
	
	public override function render (stage:Stage):Void {
		
		element.style.background = stage.__colorString;
		
		renderSession.z = 1;
		stage.__renderDOM (renderSession);
		
	}
	
	
	public static inline function renderShape (shape:Shape, renderSession:RenderSession):Void {
		
		#if js
		var graphics = shape.__graphics;
		
		if (shape.stage != null && shape.__worldVisible && shape.__renderable && graphics != null) {
			
			if (graphics.__dirty || shape.__worldAlphaChanged || (shape.__canvas == null && graphics.__canvas != null)) {
				
				CanvasGraphics.render (graphics, renderSession);
				
				if (graphics.__canvas != null) {
					
					if (shape.__canvas == null) {
						
						shape.__canvas = cast Browser.document.createElement ("canvas");	
						shape.__canvasContext = shape.__canvas.getContext ("2d");
						shape.__initializeElement (shape.__canvas, renderSession);
						
					}
					
					shape.__canvas.width = graphics.__canvas.width;
					shape.__canvas.height = graphics.__canvas.height;
					
					shape.__canvasContext.globalAlpha = shape.__worldAlpha;
					shape.__canvasContext.drawImage (graphics.__canvas, 0, 0);
					
				} else {
					
					if (shape.__canvas != null) {
						
						renderSession.element.removeChild (shape.__canvas);
						shape.__canvas = null;
						shape.__style = null;
						
					}
					
				}
				
			}
			
			if (shape.__canvas != null) {
				
				if (shape.__worldTransformChanged) {
					
					var transform = new Matrix ();
					transform.translate (graphics.__bounds.x, graphics.__bounds.y);
					transform = transform.mult (shape.__worldTransform);
					
					shape.__style.setProperty (renderSession.transformProperty, transform.to3DString (renderSession.roundPixels), null);
					
				}
				
				shape.__applyStyle (renderSession, false, false, true);
				
			}
				
		} else {
			
			if (shape.__canvas != null) {
				
				renderSession.element.removeChild (shape.__canvas);
				shape.__canvas = null;
				shape.__style = null;
				
			}
			
		}
		#end
		
	}
	
	
}