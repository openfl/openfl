package openfl._internal.backend.lime;

#if lime
typedef DataPointer = lime.utils.DataPointer;
#else
typedef DataPointer = Dynamic;
#end
