package openfl._internal.renderer.opengl;


import lime.graphics.GLRenderContext;
import openfl._internal.renderer.AbstractFilterManager;
import openfl.display.DisplayObject;

@:access(openfl._internal.renderer.opengl.GLRenderer)
@:access(openfl.display.DisplayObject)
@:access(openfl.filters.BitmapFilter)
@:keep


class GLFilterManager extends AbstractFilterManager {
	
	
	private var gl:GLRenderContext;
	
	
	public function new (renderSession:RenderSession) {
		
		super (renderSession);
		
		this.gl = renderSession.gl;
		
	}
	
	
	public override function pushObject (object:DisplayObject):Void {
		
		var shader;
		
		if (object.__filters != null && object.__filters.length > 0) {
			
			shader = object.__filters[0].__initShader (renderSession);
			
		} else {
			
			shader = renderSession.shaderManager.defaultShader;
			
		}
		
		renderSession.shaderManager.setShader (shader);
		
	}
	
	
	public override function popObject (object:DisplayObject):Void {
		
		
		
	}
	
	
}