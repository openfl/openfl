package openfl._internal.backend.utils;

#if lime
typedef ArrayBufferView = lime.utils.ArrayBufferView;
#elseif js
typedef ArrayBufferView = js.lib.ArrayBufferView;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef ArrayBufferView = Dynamic;
#end
