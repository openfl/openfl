package openfl._internal.backend.html5;

#if openfl_html5
typedef WebGLRenderingContext = js.html.webgl.RenderingContext;
#else
typedef WebGLRenderingContext = Dynamic;
#end
