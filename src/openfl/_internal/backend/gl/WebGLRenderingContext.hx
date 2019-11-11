package openfl._internal.backend.gl;

#if lime
typedef WebGLRenderingContext = lime.graphics.WebGLRenderContext;
#elseif openfl_html5
typedef WebGLRenderingContext = js.html.webgl.RenderingContext;
#else
typedef WebGLRenderingContext = Dynamic;
#end
