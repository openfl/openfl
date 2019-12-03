package openfl._internal.backend.utils;

#if lime
typedef UInt16Array = lime.utils.UInt16Array;
#elseif js
typedef UInt16Array = js.lib.Uint16Array;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef UInt16Array = Dynamic;
#end
