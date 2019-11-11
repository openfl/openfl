package openfl._internal.backend.lime;

#if lime
typedef IModule = lime.app.IModule;
#else
typedef IModule = Dynamic;
#end
