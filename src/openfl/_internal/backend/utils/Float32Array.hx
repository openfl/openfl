package openfl._internal.backend.utils;

#if lime
typedef Float32Array = lime.utils.Float32Array;
#elseif js
typedef Float32Array = js.lib.Float32Array;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef Float32Array = Dynamic;
#end
