package openfl._internal.utils;

#if lime
typedef UInt8Array = lime.utils.UInt8Array;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef UInt8Array = Dynamic;
#end
