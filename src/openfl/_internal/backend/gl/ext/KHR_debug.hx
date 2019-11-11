package openfl._internal.backend.gl.ext;

#if lime
typedef KHR_debug = lime.graphics.opengl.ext.KHR_debug;
#else
typedef KHR_debug = Dynamic;
#end
