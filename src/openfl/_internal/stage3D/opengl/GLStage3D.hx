package openfl._internal.stage3D.opengl;


import openfl._internal.stage3D.GLUtils;
import openfl.display.OpenGLRenderer;
import openfl.display.Stage3D;

#if !openfl_debug
@:fileXml('tags="haxe,release"')
@:noDebug
#end

@:access(openfl._internal.stage3D.GLUtils)
@:access(openfl.display3D.Context3D)
@:access(openfl.display3D.Program3D)
@:access(openfl.display.DisplayObjectRenderer)
@:access(openfl.display.OpenGLRenderer)


class GLStage3D {
	
	
	public static inline function render (stage3D:Stage3D, renderer:OpenGLRenderer):Void {
		
		if (stage3D.context3D != null) {
			
			renderer.__setBlendMode (null);
			
			if (renderer.__currentShader != null) {
				
				renderer.setShader (null);
				
				if (stage3D.context3D.__program != null) {
					
					stage3D.context3D.__program.__use ();
					
				}
				
			}
			
		}
		
		if (GLUtils.debug) {
			
			renderer.gl.getError ();
			
		}
		
	}
	
	
}