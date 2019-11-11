package openfl._internal.backend.lime;

#if lime
typedef BytePointer = lime.utils.BytePointer;
#else
typedef BytePointer = Dynamic;
#end
