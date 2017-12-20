package openfl._internal.stage3D.opengl;


import openfl._internal.renderer.RenderSession;
import openfl._internal.stage3D.GLUtils;
import openfl.display.Stage3D;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.GLUtils)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)


class GLStage3D {
	
	
	public static inline function render (stage3D:Stage3D, renderSession:RenderSession):Void {
		
		if (stage3D.context3D != null) {
			
			renderSession.blendModeManager.setBlendMode (null);
			
			if (renderSession.shaderManager.currentShader != null) {
				
				renderSession.shaderManager.setShader (null);
				
				if (stage3D.context3D.__program != null) {
					
					stage3D.context3D.__program.__use ();
					
				}
				
			}
			
		}
		
		if (GLUtils.debug) {
			
			renderSession.gl.getError ();
			
		}
		
	}
	
	
}