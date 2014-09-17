package openfl.utils;


#if (flash || next || js || display)
typedef ArrayBuffer = lime.utils.ArrayBuffer;
#else
typedef ArrayBuffer = openfl._v2.utils.ArrayBuffer;
#end