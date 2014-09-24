package openfl.utils;


#if (flash || openfl_next || js || display)
typedef Int16Array = lime.utils.Int16Array;
#else
typedef Int16Array = openfl._v2.utils.Int16Array;
#end