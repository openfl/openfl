package openfl._internal.backend.lime;

#if lime
typedef HTTPRequestMethod = lime.net.HTTPRequestMethod;
#else
typedef HTTPRequestMethod = Dynamic;
#end
