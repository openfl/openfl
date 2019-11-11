package openfl._internal.backend.lime;

#if lime
typedef RenderContextType = lime.graphics.RenderContextType;
#else
typedef RenderContextType = Dynamic;
#end
