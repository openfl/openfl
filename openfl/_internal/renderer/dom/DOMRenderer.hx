package openfl._internal.renderer.dom;


import lime.graphics.DOMRenderContext;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.Stage;

#if js
import js.html.Element;
#end

@:access(openfl.display.DisplayObject)
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
		
		renderSession.renderer = this;
		
	}
	
	
	public static function applyStyle (displayObject:DisplayObject, renderSession:RenderSession, setTransform:Bool, setAlpha:Bool, setClip:Bool):Void {
		
		#if js
		var style = displayObject.__style;
		
		if (setTransform && displayObject.__worldTransformChanged) {
			
			style.setProperty (renderSession.transformProperty, displayObject.__worldTransform.to3DString (renderSession.roundPixels), null);
			
		}
		
		if (displayObject.__worldZ != ++renderSession.z) {
			
			displayObject.__worldZ = renderSession.z;
			style.setProperty ("z-index", Std.string (displayObject.__worldZ), null);
			
		}
		
		if (setAlpha && displayObject.__worldAlphaChanged) {
			
			if (displayObject.__worldAlpha < 1) {
				
				style.setProperty ("opacity", Std.string (displayObject.__worldAlpha), null);
				
			} else {
				
				style.removeProperty ("opacity");
				
			}
			
		}
		
		if (setClip && displayObject.__worldClipChanged) {
			
			if (displayObject.__worldClip == null) {
				
				style.removeProperty ("clip");
				
			} else {
				
				var clip = displayObject.__worldClip.transform (displayObject.__worldTransform.clone ().invert ());
				style.setProperty ("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
				
			}
			
		}
		#end
		
	}
	
	
	#if js
	public static function initializeElement (displayObject:DisplayObject, element:Element, renderSession:RenderSession):Void {
		
		var style = displayObject.__style = element.style;
		
		style.setProperty ("position", "absolute", null);
		style.setProperty ("top", "0", null);
		style.setProperty ("left", "0", null);
		style.setProperty (renderSession.transformOriginProperty, "0 0 0", null);
		
		renderSession.element.appendChild (element);
		
		displayObject.__worldAlphaChanged = true;
		displayObject.__worldClipChanged = true;
		displayObject.__worldTransformChanged = true;
		displayObject.__worldVisibleChanged = true;
		displayObject.__worldZ = -1;
		
	}
	#end
	
	
	public override function render (stage:Stage):Void {
		
		element.style.background = stage.__colorString;
		
		renderSession.z = 1;
		stage.__renderDOM (renderSession);
		
	}
	
	
}