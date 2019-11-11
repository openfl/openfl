package openfl._internal.backend.lime;

#if lime
typedef AssetManifest = lime.utils.AssetManifest;
#else
typedef AssetManifest = openfl.utils.AssetManifest;
#end
