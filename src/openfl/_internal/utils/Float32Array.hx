package openfl._internal.utils;

#if lime
typedef Float32Array = lime.utils.Float32Array;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef Float32Array = Dynamic;
#end
