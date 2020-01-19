package openfl._internal.bindings.gl;

#if lime
typedef GL = lime.graphics.opengl.GL;
#elseif openfl_html5
typedef GL = js.html.webgl.RenderingContext;
#else
typedef GL = Dynamic;
#end
