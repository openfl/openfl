package openfl._internal.backend.utils;

#if lime
typedef UInt8Array = lime.utils.UInt8Array;
#elseif js
typedef UInt8Array = js.lib.Uint8Array;
#else
@SuppressWarnings("checkstyle:Dynamic")
typedef UInt8Array = Dynamic;
#end
