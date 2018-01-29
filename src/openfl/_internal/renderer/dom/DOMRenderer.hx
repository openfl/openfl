package openfl._internal.renderer.dom;


import lime.graphics.DOMRenderContext;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.display.DisplayObject;
import openfl.display.Stage;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

#if (js && html5)
import js.html.Element;
import js.Browser;
#end

@:access(openfl._internal.renderer.canvas.CanvasRenderer)
@:access(openfl.display.DisplayObject)
@:access(openfl.display.Stage)
@:access(openfl.display.Stage3D)
@:access(openfl.geom.Matrix)
@:access(openfl.geom.Rectangle)


class DOMRenderer extends AbstractRenderer {
	
	
	private var element:DOMRenderContext;
	
	
	public function new (stage:Stage, element:DOMRenderContext) {
		
		super (stage);
		
		this.element = element;
		
		renderSession = new RenderSession ();
		renderSession.clearRenderDirty = true;
		renderSession.element = element;
		//renderSession.roundPixels = true;
		
		#if (js && html5)
		DisplayObject.__supportDOM = true;
		
		var config = stage.window.config;
		
		if (config != null && Reflect.hasField (config, "allowHighDPI") && config.allowHighDPI) {
			
			CanvasRenderer.scale = untyped window.devicePixelRatio || 1;
			
		}
		
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
		
		renderSession.maskManager = new DOMMaskManager (renderSession);
		renderSession.blendModeManager = new DOMBlendModeManager (renderSession);
		
		renderSession.renderer = this;
		renderSession.renderType = DOM;
		
	}
	
	
	public static function applyStyle (displayObject:DisplayObject, renderSession:RenderSession, setTransform:Bool, setAlpha:Bool, setClip:Bool):Void {
		
		#if (js && html5)
		var style = displayObject.__style;
		
		if (setTransform && displayObject.__renderTransformChanged) {
			
			style.setProperty (renderSession.transformProperty, displayObject.__renderTransform.to3DString (renderSession.roundPixels), null);
			
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
				
				var clip = displayObject.__worldClip;
				style.setProperty ("clip", "rect(" + clip.y + "px, " + clip.right + "px, " + clip.bottom + "px, " + clip.x + "px)", null);
				
			}
			
		}
		#end
		
	}
	
	
	#if (js && html5)
	public static function initializeElement (displayObject:DisplayObject, element:Element, renderSession:RenderSession):Void {
		
		var style = displayObject.__style = element.style;
		
		style.setProperty ("position", "absolute", null);
		style.setProperty ("top", "0", null);
		style.setProperty ("left", "0", null);
		style.setProperty (renderSession.transformOriginProperty, "0 0 0", null);
		
		renderSession.element.appendChild (element);
		
		displayObject.__worldAlphaChanged = true;
		displayObject.__renderTransformChanged = true;
		displayObject.__worldVisibleChanged = true;
		displayObject.__worldClipChanged = true;
		displayObject.__worldClip = null;
		displayObject.__worldZ = -1;
		
	}
	#end
	
	
	public override function render ():Void {
		
		renderSession.allowSmoothing = (stage.quality != LOW);
		
		if (!stage.__transparent) {
			
			element.style.background = stage.__colorString;
			
		} else {
			
			element.style.background = "none";
			
		}
		
		renderSession.z = 1;
		stage.__renderDOM (renderSession);
		
	}
	
	
	public override function renderStage3D ():Void {
		
		for (stage3D in stage.stage3Ds) {
			
			stage3D.__renderDOM (stage, renderSession);
			
		}
		
	}
	
	
	public static function updateClip (displayObject:DisplayObject, renderSession:RenderSession):Void {
		
		var maskManager:DOMMaskManager = cast renderSession.maskManager;
		maskManager.updateClip (displayObject);
		
	}
	
	
}