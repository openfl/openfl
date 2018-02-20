package openfl.display;


import lime.graphics.cairo.Cairo;
import openfl._internal.renderer.opengl.GLRenderer;
import openfl._internal.renderer.RenderSession;
import openfl.events.AbstractRenderEvent;
import openfl.geom.ColorTransform;
import openfl.geom.Matrix;

@:access(openfl.events.Event)
@:access(openfl.geom.ColorTransform)


class AbstractRender extends DisplayObject {
	
	
	private var __renderEvent:AbstractRenderEvent;
	
	
	public function new () {
		
		super ();
		
		__renderEvent = new AbstractRenderEvent (null);
		
	}
	
	
	private override function __enterFrame (deltaTime:Int):Void {
		
		if (__renderable) {
			
			__setRenderDirty ();
			
		}
		
	}
	
	
	private override function __renderCairo (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderCairo (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		
		__renderEvent.type = AbstractRenderEvent.RENDER_CAIRO;
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
		
		__renderEvent.type = AbstractRenderEvent.RENDER_CANVAS;
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
	
	
	private override function __renderGL (renderSession:RenderSession):Void {
		
		if (!__renderable) return;
		
		super.__renderGL (renderSession);
		
		renderSession.blendModeManager.setBlendMode (__worldBlendMode);
		renderSession.maskManager.pushObject (this);
		renderSession.shaderManager.updateShader (null);
		
		__renderEvent.type = AbstractRenderEvent.RENDER_OPENGL;
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