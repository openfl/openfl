package openfl._internal.stage3D;

import openfl.errors.IllegalOperationError;
import openfl.gl.GL;


class GLUtils {
	
    private static var debug = false;
	
    // Comment the following line if you want the GL Error check in release mode on device
    //[Conditional("DEBUG")]
	
    public static function CheckGLError ():Void {
        if (!debug) return;

        var error = GL.getError ();
		
        if (error != GL.NO_ERROR) {
			
			var errorText = switch (error) {
				case GL.NO_ERROR:
					"GL_NO_ERROR";
				case GL.INVALID_ENUM:
					"GL_INVALID_ENUM";
				case GL.INVALID_OPERATION:
					"GL_INVALID_OPERATION";
				case GL.INVALID_FRAMEBUFFER_OPERATION:
					"GL_INVALID_FRAMEBUFFER_OPERATION";
				case GL.INVALID_VALUE:
					"GL_INVALID_VALUE";
				case GL.OUT_OF_MEMORY:
					"GL_OUT_OF_MEMORY";
				default:
					Std.string (error);
			};
			
            throw new IllegalOperationError("Error calling openGL api. Error: " + errorText + "\n");
			
        }
		
    }
	
}
