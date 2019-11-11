package openfl._internal.backend.lime;

#if lime
typedef AudioBuffer = lime.media.AudioBuffer;
#else
typedef AudioBuffer = Dynamic;
#end
