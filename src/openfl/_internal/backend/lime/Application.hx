package openfl._internal.backend.lime;

#if lime
typedef Application = lime.app.Application;
#else
typedef Application = Dynamic;
#end
