package openfl._internal.backend.lime;

#if lime
typedef DOMRenderContext = lime.graphics.DOMRenderContext;
#else
typedef DOMRenderContext = Dynamic;
#end
