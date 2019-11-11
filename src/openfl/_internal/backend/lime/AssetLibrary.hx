package openfl._internal.backend.lime;

#if lime
typedef AssetLibrary = lime.utils.AssetLibrary;
#else
typedef AssetLibrary = Dynamic;
#end
