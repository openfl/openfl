package openfl._internal.backend.lime;

#if lime
typedef AudioSource = lime.media.AudioSource;
#else
typedef AudioSource = Dynamic;
#end
