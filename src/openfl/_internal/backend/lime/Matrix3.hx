package openfl._internal.backend.lime;

#if lime
typedef Matrix3 = lime.math.Matrix3;
#else
typedef Matrix3 = Dynamic;
#end
