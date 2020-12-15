package openfl.utils._internal;

#if lime
typedef UInt8Array = lime.utils.UInt8Array;
#elseif js
typedef UInt8Array = js.lib.Uint8Array;
#else
typedef UInt8Array = Dynamic;
#end
