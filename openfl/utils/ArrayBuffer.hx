package openfl.utils;


#if (flash || openfl_next || js || display)
typedef ArrayBuffer = lime.utils.ArrayBuffer;
#else
typedef ArrayBuffer = openfl._v2.utils.ArrayBuffer;
#end