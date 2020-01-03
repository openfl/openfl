package openfl._internal.backend.lime;

#if lime
typedef Matrix4 = lime.math.Matrix4;
#else
typedef Matrix4 = Dynamic;
#end
