package openfl._internal.backend.lime;

#if lime
typedef HTTPRequestHeader = lime.net.HTTPRequestHeader;
#else
typedef HTTPRequestHeader = Dynamic;
#end
