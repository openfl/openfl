package openfl._internal.backend.harfbuzz;

#if lime
typedef HBBufferClusterLevel = lime.text.harfbuzz.HBBufferClusterLevel;
#else
typedef HBBufferClusterLevel = Dynamic;
#end
