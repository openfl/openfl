package openfl.display;


import lime.graphics.cairo.Cairo;
import lime.graphics.opengl.GL;
import lime.graphics.GLRenderContext;
import openfl._internal.renderer.canvas.CanvasRenderer;
import openfl._internal.renderer.dom.DOMRenderer;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.AbstractRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.events.RenderEvent;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

#if (js && html5)
import js.html.webgl.RenderingContext;
import js.html.CanvasElement;
import js.Browser;
#end

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(lime._backend.html5.HTML5GLRenderContext)
@:access(lime._backend.native.NativeGLRenderContext)
@:access(lime.graphics.opengl.GL)
@:access(openfl._internal.renderer.AbstractRenderer)
@:access(openfl._internal.renderer.RenderSession)
@:access(openfl.events.Event)
@:access(openfl.geom.ColorTransform)


class AbstractView extends DisplayObject {
	
	
	private var __addedToDOM:Bool;
	private var __domRenderer:AbstractRenderer;
	private var __renderEvent:RenderEvent;
	
	
	public function new () {
		
		super ();
		
		__renderEvent = new RenderEvent (null);
		
	}
	
	
	public function invalidate ():Void {
		
		__setRenderDirty ();
		
	}
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderCairo (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		
		__renderEvent.type = RenderEvent.RENDER_CAIRO;
		__renderEvent.allowSmoothing = renderSession.allowSmoothing;
		__renderEvent.cairo = renderSession.cairo;
		__renderEvent.renderTransform.copyFrom (__renderTransform);
		__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
		__renderEvent.worldTransform.copyFrom (__worldTransform);
		__renderEvent.__renderSession = renderSession;
		
		dispatchEvent (__renderEvent);
		
		renderSession.maskManager.popObject (this);
		__renderEvent.cairo = null;
		
	}
	
	
	private override function __renderCanvas (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderCanvas (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		
		__renderEvent.type = RenderEvent.RENDER_CANVAS;
		__renderEvent.allowSmoothing = renderSession.allowSmoothing;
		__renderEvent.context = renderSession.context;
		__renderEvent.renderTransform.copyFrom (__renderTransform);
		__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
		__renderEvent.worldTransform.copyFrom (__worldTransform);
		__renderEvent.__renderSession = renderSession;
		
		dispatchEvent (__renderEvent);
		
		renderSession.maskManager.popObject (this);
		__renderEvent.context = null;
		
	}
	
	
	private override function __renderDOM (renderSession:RenderSession):Void {
		
		#if (js && html5)
		if (stage != null && __worldVisible && __renderable && __renderDirty) {
			
			if (__canvas == null) {
				
				__canvas = cast Browser.document.createElement ("canvas");
				__canvas.width = stage.stageWidth;
				__canvas.height = stage.stageHeight;
				
				var window = stage.window;
				
				var options = {
					
					alpha: true,
					antialias: false,
					depth: Reflect.hasField (window.config, "depthBuffer") ? window.config.depthBuffer : true,
					premultipliedAlpha: true,
					stencil: Reflect.hasField (window.config, "stencilBuffer") ? window.config.stencilBuffer : false,
					preserveDrawingBuffer: false
					
				};
				
				var glContextType = [ "webgl2", "webgl", "experimental-webgl" ];
				
				var webgl:RenderingContext = null;
				
				for (name in glContextType) {
					
					webgl = cast __canvas.getContext (name, options);
					if (webgl != null) break;
					
				}
				
				if (webgl != null) {
					
					var gl = new GLRenderContext (cast webgl);
					
					if (GL.context == null) {
						
						GL.context = gl;
						
					}
					
					__domRenderer = new GLRenderer (stage, gl);
					
				} else {
					
					__context = __canvas.getContext ("2d");
					__domRenderer = new CanvasRenderer (stage, __context);
					
				}
				
			} else if (__canvas.width != stage.stageWidth || __canvas.height != stage.stageHeight) {
				
				__canvas.width = stage.stageWidth;
				__canvas.height = stage.stageHeight;
				
			}
			
			if (!__addedToDOM) {
				
				renderSession.element.appendChild (__canvas);
				__addedToDOM = true;
				
				DOMRenderer.initializeElement (this, __canvas, renderSession);
				
			}
			
			DOMRenderer.applyStyle (this, renderSession, false, true, true);
			
			if (__context != null) {
				
				__domRenderer.renderSession.blendModeManager.setBlendMode (NORMAL);
				
				__context.setTransform (1, 0, 0, 1, 0, 0);
				__context.globalAlpha = 1;
				__context.clearRect (0, 0, stage.stageWidth * stage.window.scale, stage.stageHeight * stage.window.scale);
				
				__renderCanvas (__domRenderer.renderSession);
				
			} else {
				
				var gl = __domRenderer.renderSession.gl;
				gl.clearColor (0, 0, 0, 0);
				gl.clear (gl.COLOR_BUFFER_BIT);
				
				__renderGL (__domRenderer.renderSession);
				
			}
			
		} else if (__addedToDOM) {
			
			renderSession.element.removeChild (__canvas);
			__addedToDOM = false;
			
		}
		#end
		
	}
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderGL (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		renderSession.shaderManager.setShader (null);
		
		__renderEvent.type = RenderEvent.RENDER_OPENGL;
		__renderEvent.allowSmoothing = renderSession.allowSmoothing;
		__renderEvent.gl = renderSession.gl;
		__renderEvent.renderTransform.copyFrom (__renderTransform);
		__renderEvent.worldColorTransform.__copyFrom (__worldColorTransform);
		__renderEvent.worldTransform.copyFrom (__worldTransform);
		__renderEvent.__renderSession = renderSession;
		
		dispatchEvent (__renderEvent);
		
		renderSession.maskManager.popObject (this);
		__renderEvent.gl = null;
		
	}
	
	
}