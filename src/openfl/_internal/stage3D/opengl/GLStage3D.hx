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
			
			// TODO: the commented check below is the result of the assumption that
			// shaderManager.currentShader being null means the we only used Context3D shaders
			// and we don't need to re-enable the Context3D program as it's already active.
			//
			// However this is now not the case, because our new BatchRenderer doesn't use
			// the shader manager as well: it sets shaderManager.currentShader to null and then
			// manually enables its own shader. So the check below becomes invalid.
			//
			// There are a number of more correct approaches to fix this, one of them being
			// to adapt BatchRenderer to use ShaderManager, but it's too intrusive at the moment,
			// so instead we just always enable the Stage3D program.
			
			// if (renderSession.shaderManager.currentShader != null) {
				
				renderSession.shaderManager.setShader (null);
				
				if (stage3D.context3D.__program != null) {
					
					stage3D.context3D.__program.__use ();
					
				}
				
			// }
			
		}
		
		if (GLUtils.debug) {
			
			renderSession.gl.getError ();
			
		}
		
	}
	
	
}