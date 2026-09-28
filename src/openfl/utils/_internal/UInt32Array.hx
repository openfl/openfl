package openfl.utils._internal;

#if lime
typedef UInt32Array = lime.utils.UInt32Array;
#elseif js
typedef UInt32Array = js.lib.Uint32Array;
#else
typedef UInt32Array = Dynamic;
#end
