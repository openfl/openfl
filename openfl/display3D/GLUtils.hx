package openfl.display3D;

import openfl.errors.IllegalOperationError;
import openfl.gl.GL;


class GLUtils {

    private static inline var debug = true;

    // Comment the following line if you want the GL Error check in release mode on device
    //[Conditional("DEBUG")]

    public static function CheckGLError():Void
    {
        if (!debug) return;

        var error = GL.getError();
        if (error != GL.NO_ERROR) {
            throw new IllegalOperationError("Error calling openGL api. Error: " + error + "\n");
        }
    }

}
