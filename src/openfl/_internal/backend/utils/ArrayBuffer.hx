package openfl._internal.backend.utils;

#if lime
typedef ArrayBuffer = lime.utils.ArrayBuffer;
#elseif js
typedef ArrayBuffer = js.lib.ArrayBuffer;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef ArrayBuffer = Dynamic;
#end
