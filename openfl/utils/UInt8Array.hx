package openfl.utils;


#if (flash || next || js)
typedef UInt8Array = lime.utils.UInt8Array;
#else
typedef UInt8Array = openfl._v2.utils.UInt8Array;
#end