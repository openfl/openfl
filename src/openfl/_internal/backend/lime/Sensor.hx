package openfl._internal.backend.lime;

#if lime
typedef Sensor = lime.system.Sensor;
#else
typedef Sensor = Dynamic;
#end
