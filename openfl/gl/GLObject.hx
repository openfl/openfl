package openfl.gl;


@:deprecated typedef GLObject = #if (!js || !html5 || display) lime.graphics.opengl.GL.GLObject #else Dynamic #end;