package openfl._internal.backend.lime;

#if lime
typedef Endian = lime.system.Endian;
#else
typedef Endian = Dynamic;
#end
