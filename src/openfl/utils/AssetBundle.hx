package openfl.utils;

#if lime
typedef AssetBundle = lime.utils.AssetBundle;
#else
class AssetBundle
{
	public function new() {}
}
#end
