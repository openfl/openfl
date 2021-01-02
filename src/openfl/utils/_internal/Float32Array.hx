package openfl.utils._internal;

#if lime
typedef Float32Array = lime.utils.Float32Array;
#elseif js
typedef Float32Array = js.lib.Float32Array;
#else
typedef Float32Array = Dynamic;
#end
