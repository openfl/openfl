package openfl._internal.utils;

#if lime
typedef ArrayBufferView = lime.utils.ArrayBufferView;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef ArrayBufferView = Dynamic;
#end
