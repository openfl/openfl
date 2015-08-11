package openfl.utils;


#if openfl_legacy
#if android
typedef JNI = openfl._legacy.utils.JNI;
#end
#else
typedef JNI = lime.system.JNI;
#end